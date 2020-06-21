[CmdletBinding()]
param (
    [Parameter(Mandatory = $false, HelpMessage = "Build artifact path")]
    [string]
    $ArchivePath,
    [Parameter(Mandatory = $true, HelpMessage = "Signing cert thumbprint")]
    [string]
    $Thumbprint = ""
)

if (-Not $ArchivePath) {
    Write-Output "Archive path is not valid"
    $ArchivePath = "$pwd\SimplePSLogger"
}


$cert = Get-ChildItem Cert:\CurrentUser\My |
Where-Object Thumbprint -EQ $Thumbprint

if ($null -eq $cert) {
    throw "Certificate wit provided thumbprint not found in user cert store"
}

if (@($cert).Length -gt 1) {
    throw "Multiple certificates found with provided thumbprint"
}

$FilesToSign = Get-ChildItem -Recurse -ErrorAction SilentlyContinue $ArchivePath | Where-Object 
{ $_.Extension -in ".psd1", ".psm1", ".ps1" } | Select-Object -ExpandProperty FullName

$IncorrectSignature = Get-AuthenticodeSignature -FilePath $FilesToSign | Where-Object { @("Valid", "NotSigned", "UnknownError").Contains($_.Status.ToString()) }
if ($IncorrectSignature) {
    throw "Tere are files which are signed with another certificate. $([Environment]::NewLine) Review these files $($IncorrectSignature | Out-String) $([Environment]::NewLine)"
}

$FilesToSign = $FilesToSign | Where-Object { "NotSigned" -eq (Get-AuthenticodeSignature -FilePath $_ ).Status }

if (-not @($FilesToSign)) {
    return "All files are already signed. yay!"
}

$results = $FilesToSign | ForEach-Object {
    $Signed = Set-AuthenticodeSignature $_ -Certificate $cert -TimestampServer 'http://timestamp.comodoca.com/authenticode' -ErrorAction Stop
    $Signed | Out-String | Write-Output
    $Signed
}

$failed = $results | Where-Object { $_.Status -ne "Valid" }

if ($failed) {
    throw "Failed to sign -  $($failed.Path -join $())"
}
