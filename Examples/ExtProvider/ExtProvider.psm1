function ExtProvider {
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
    $InformationPreference = "Continue"
    $logMessage = "$((Get-Date).ToUniversalTime().ToString("yyyy/MM/dd HH:mm:ss:ffff tt")) $Name $($Level): $($Message.Trim())"

    Write-Information "------------------ Log from Custom provider --------------------------"
    Write-Information "$logMessage"
    Write-Information "------------------ Log from Custom provider --------------------------"

    # Do whatever you want to do with message params. Cheers!
}

Export-ModuleMember -Function ExtProvider