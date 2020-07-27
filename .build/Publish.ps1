[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, HelpMessage = "PowerShell Gallery Api key")]
    [ValidateNotNull()]
    [string]
    $NuGetApiKey,
    [Parameter(Mandatory = $true, HelpMessage = "Archive Path")]
    [ValidateNotNull()]
    [string]
    $ArchivePath
)
Begin {
    Write-Output "Publishing module to PowerShell Gallery"
    $OutMessage = $null
}
Process {
    try {
        #TODO: code sign
        Publish-Module -Path $ArchivePath -NuGetApiKey $NuGetApiKey`
        -ProjectUri "https://github.com/geekwhocodes/simple-ps-logger"`
            -Tags "powershell, powershellcore, logging, logger, simplelogging, simplelogger,  pscore, log"`
            -LicenseUri "https://github.com/geekwhocodes/simple-ps-logger/blob/master/LICENSE"`
            -ErrorAction Continue
 
        Write-Output "Module published successfully."
    }
    catch {
        $OutMessage = "Error ocurred while publishing module - $($_.Exception.Message)"
    }
    finally {
        Write-Output "$OutMessage"
    }
}
End {

}