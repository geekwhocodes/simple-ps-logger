<#
.SYNOPSIS
    File logging provider for SimplePSLogger logger 
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

.PARAMETER Config
    Required configuration provided by user

.EXAMPLE
    TODO : Add examples

.NOTES
    Author: Ganesh Raskar
    
#>
function New-File-Logger {
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

    $Message = ' ' * 2 + $Message

    $logMessage = "[$((Get-Date).ToUniversalTime().ToString("yyyy/MM/dd HH:mm:ss:ffff tt"))] [$Name] [$($Level)]: $($Message)"
    
    <#  
        TODO : Robust error handling and config validation
    #>
    if (-Not $Config) {
        $filePath = Join-Path $([system.io.path]::GetTempPath()) -ChildPath "$Name.log"
        Write-Warning "File provider does not have LiteralfilePath configured, switching to auto generated file here $filepath"
    }
    else {
        $filePath = $($Config["LiteralFilePath"])
    }
    
    Add-Content $filePath $logMessage -Encoding 'UTF8'
}

Export-ModuleMember -Function New-File-Logger