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
        [string]
        $Message
    )
    
    $logMessage = "$((Get-Date).ToUniversalTime().ToString("yyyy/MM/dd HH:mm:ss:fff tt")) $Name $($Level): $($Message.Trim())"

    $InformationPreference = "Continue"

    <# I don't like prepended WARNING, IFORMATION etc by powershell
    # Reference - https://devblogs.microsoft.com/scripting/weekend-scripter-customize-powershell-title-and-prompt/
    # TODO : refactor 
    #>
    switch -Exact ($Level) {
        'verbose' {
            $prevColor = $host.ui.RawUI.ForegroundColor
            $host.ui.RawUI.ForegroundColor = "White"
            Write-Information "$logMessage" -InformationAction Continue
            $host.ui.RawUI.ForegroundColor = $prevColor
            break
        }
        'debug' { 
            $prevColor = $host.ui.RawUI.ForegroundColor
            $host.ui.RawUI.ForegroundColor = "White"
            Write-Information "$logMessage" -InformationAction Continue
            $host.ui.RawUI.ForegroundColor = $prevColor
            break
        }
        'information' { 
            $prevColor = $host.ui.RawUI.ForegroundColor
            $host.ui.RawUI.ForegroundColor = "Cyan"
            Write-Information "$logMessage" -InformationAction Continue
            $host.ui.RawUI.ForegroundColor = $prevColor
            break
        }
        'error' { 
            $prevColor = $host.ui.RawUI.ForegroundColor
            $host.ui.RawUI.ForegroundColor = "Red"
            Write-Information "$logMessage" -InformationAction Continue
            $host.ui.RawUI.ForegroundColor = $prevColor
            break
        }
        'warning' { 
            $prevColor = $host.ui.RawUI.ForegroundColor
            $host.ui.RawUI.ForegroundColor = "Yellow"
            Write-Information "$logMessage" -InformationAction Continue
            $host.ui.RawUI.ForegroundColor = $prevColor
            break
        }
        'critical' { 
            $prevColor = $host.ui.RawUI.ForegroundColor
            $host.ui.RawUI.ForegroundColor = "DarkRed"
            Write-Information "$logMessage" -InformationAction Continue
            $host.ui.RawUI.ForegroundColor = $prevColor
            break
        }
        Default {
            $prevColor = $host.ui.RawUI.ForegroundColor
            $host.ui.RawUI.ForegroundColor = "Cyan"
            Write-Information "$logMessage" -InformationAction Continue
            $host.ui.RawUI.ForegroundColor = $prevColor
        }
    }
}

Export-ModuleMember -Function New-Console-Logger