Import-Module -Name "../../SimplePSLogger/SimplePSLogger.psd1"

$SimplePSLoggerConfig = @{
    Name      = "config-example"
    Providers = @{
        File = @{
            LiteralFilePath = "G:\Git\simple-ps-logger\Examples\V2\cleared-logs.log"
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
New-SimplePSLogger -Name "vanilla-script-2" -Configuration $SimplePSLoggerConfig


Get-Process | Select-Object -Property @{
    label      = 'Message';
    expression = { ("PID - " + $_.Id + " Proc Name - " + $_.ProcessName).ToString() };
} 
#, @{
#     label      = 'Level';
#     expression = { "error" };
# }
| Write-Log


#$ef | Write-Log


Clear-Buffer -All
