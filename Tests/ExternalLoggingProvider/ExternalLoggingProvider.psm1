function AwesomeLoggingProvider {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Name of the SimplePSLogger instance")]
        [string]
        $Name,
        [Parameter(Mandatory = $false, HelpMessage = "Log level, default value is information")]
        [string]
        $Level,
        [Parameter(Mandatory = $true, HelpMessage = "Log message")]
        [string]
        $Message, 
        [Parameter(Mandatory = $false, HelpMessage = "Configuration object")]
        [object]
        $Config
    )

    $null = $Config

    $InformationPreference = "Continue"
    $logMessage = "$((Get-Date).ToUniversalTime().ToString("yyyy/MM/dd HH:mm:ss:ffff tt")) $Name $($Level): $($Message.Trim())"

    Write-Information "------------------ Log from Custom provider --------------------------" -InformationAction Continue
    Write-Information "$logMessage" -InformationAction Continue
    Write-Information "------------------ Log from Custom provider --------------------------" -InformationAction Continue

    # Do whatever you want to do with message params. Cheers!
}

Export-ModuleMember -Function AwesomeLoggingProvider