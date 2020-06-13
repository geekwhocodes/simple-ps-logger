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
        $Message
    )
    $Message = ' ' * 2 + $Message

    $Message = $Message #| ConvertTo-Json -Compress -Depth 100

    $logMessage = "[$((Get-Date).ToUniversalTime().ToString("yyyy/MM/dd HH:mm:ss:ffff tt"))] [$Name] [$($Level)]: $($Message)"
    
    <#  
        TODO : make it configurable(get it wile registering it)
    #>
    $filePath = Join-Path $env:Temp -ChildPath "$Name.log"
    Add-Content $filePath $logMessage -Encoding 'UTF8'
}

Export-ModuleMember -Function New-File-Logger