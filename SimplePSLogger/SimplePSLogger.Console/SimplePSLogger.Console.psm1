<#
.SYNOPSIS
    Colored Console logging provider for SimplePSLogger logger 
    This provider writes colored messages to the console by using powershell's default Write-* functions
.DESCRIPTION
    TODO: add more details
    More details

.PARAMETER Name
    SimplePSLogger action execution id which is used to identify executing action
.PARAMETER Level
    Log level : allowed values are - "verbose", "debug", "information", "warning", "error", "critical", "none"
    TODO : add more infor for each level
.PARAMETER Message
    Log message : 
        String - plain text string
        OtherTypes - json serialized string
.EXAMPLE
    TODO : Add examples

.NOTES
    Author: Ganesh Raskar
    
#>
function New-Console-Logger {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Name of the SimplePSLogger instance")]
        [string]
        $Name,
        [Parameter(Mandatory = $false, HelpMessage = "Log level, default value is information")]
        [string]
        $Level,
        [Parameter(Mandatory = $true, HelpMessage = "Log message")]
        [object]
        $Message
    )
    $Message = ' ' * 2 + $Message
    $logMessage = "[$((Get-Date).ToUniversalTime().ToString("yyyy/MM/dd HH:mm:ss:ffff tt"))] [$Name] [$($Level)]: $($Message) `r"

    $VerbosePreference = "Continue"
    $DebugPreference = "Continue"
    $InformationPreference = "Continue"

    switch -Exact ($Level) {
        'verbose' { Write-Verbose $logMessage; break }
        'debug' { Write-Debug $logMessage; break }
        'information' { Write-Information $logMessage; break }
        'error' { Write-Error $logMessage; break }
        'warning' { Write-Warning $logMessage; break }
        'critical' { Write-Error $logMessage; break }
        Default {
            Write-Information $logMessage
        }
    }
}

Export-ModuleMember -Function New-Console-Logger