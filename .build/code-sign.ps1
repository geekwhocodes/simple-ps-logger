[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, HelpMessage = "Build artifact path")]
    [string]
    $ArchivePath,
    [Parameter(Mandatory = $true, HelpMessage = "Signing cert thumbprint")]
    [string]
    $Thumbprint
)

if (-Not $ArchivePath) {
    throw "Archive path is not valid"
}

#TODO : generate from base64 & pass
$cert = Get-ChildItem Cert:\CurrentUser\My | Where-Object Thumbprint -EQ $Thumbprint

if ($null -eq $cert) {
    throw "Certificate wit provided thumbprint not found in user cert store"
}

if (@($cert).Length -gt 1) {
    throw "Multiple certificates found with provided thumbprint"
}

$FilesToSign = Get-ChildItem -Path $ArchivePath -Recurse -ErrorAction Stop | Where-Object { $_.Extension -in ".psd1", ".psm1", ".ps1" } | Select-Object -ExpandProperty FullName

$IncorrectSignature = Get-AuthenticodeSignature -FilePath $FilesToSign | Where-Object { -Not @("Valid", "NotSigned").Contains(($_.Status.ToString())) }
if ($IncorrectSignature) {
    throw "There are files which are signed with another certificate. $([Environment]::NewLine) Review these files $($IncorrectSignature | Out-String) $([Environment]::NewLine)"
}

$FilesToSign = $FilesToSign | Where-Object { "NotSigned" -eq (Get-AuthenticodeSignature -FilePath $_ ).Status }

if (-not @($FilesToSign)) {
    return "All files are already signed. yay!"
}

$FilesToSign | ForEach-Object {
    $Signed = Set-AuthenticodeSignature $_ -Certificate $cert -TimestampServer 'http://timestamp.digicert.com' -ErrorAction Stop
    $Signed | Out-String | Write-Output
    if ($Signed.Status -ne "Valid") {
        Write-Error "Failed to sign $($Signed.Path) file" -ErrorAction Continue
    }
}
