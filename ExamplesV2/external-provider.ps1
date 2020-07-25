<#
    This example works with version 2.x
#>

Import-Module -Name "../SimplePSLogger/SimplePSLogger.psd1"
Import-Module -Name "./ExtProvider/ExtProvider.psm1"
Set-StrictMode -Version 3.0

# In memory conguration
$SimplePSLoggerConfig = @{
    Name      = "config-example"
    Providers = @{
        Console       = @{
            LogLevel = "verbose"
            Enabled  = $false
        }
        File          = @{
            LiteralFilePath = "G:\Git\simple-ps-logger\Examples\example-with-config-file\example-with-config.log"
            LogLevel        = "information"
            Enabled         = $false
        }
        AwesomeLogger = @{
            Enabled  = $true
            LogLevel = "information"
            Authkey  = "key"
        }
    }
}

New-SimplePSLogger -Name "ps-play"
Register-LoggingProvider -Name "AwesomeLogger" -FunctionName "ExtProvider" -Configuration $SimplePSLoggerConfig.Providers["AwesomeLogger"]

Write-SimpleLog "sgl" "warning"

Clear-Buffer -All
Remove-SimplePSLogger -All
