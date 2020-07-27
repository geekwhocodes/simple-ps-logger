<#
    This example works with version 2.x
#>

Import-Module -Name "../SimplePSLogger/SimplePSLogger.psd1"

$SimplePSLoggerConfig = @{
    Name      = "config-example"
    Providers = @{
        File = @{
            LiteralFilePath = "G:\Git\simple-ps-logger\ExamplesV2\cleared-logs.log"
            LogLevel        = "verbose"
            Enabled         = $true
            Flush           = $true
        }
    }
}
1..1 | ForEach-Object {
    New-SimplePSLogger -Name "vanilla-script" -Configuration $SimplePSLoggerConfig
}
#New-SimplePSLogger -Name "vanilla-script"
$rt = New-SimplePSLogger -Name "vanilla-script-2" -Configuration $SimplePSLoggerConfig

Set-SimplePSLogger -Name "vanilla-script"
# Get-Process | Select-Object -Property @{
#     label      = 'Message';
#     expression = { ("PID - " + $_.Id + " Proc Name - " + $_.ProcessName).ToString() };
# } 
# | Write-SimpleLog


Write-SimpleLog "sdfkh"


Clear-Buffer -All
Remove-SimplePSLogger -All
