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

$MyLogger = New-SimplePSLogger -Name "ps-play"
$MyLogger.RegisterProvider("AwesomeLogger", "ExtProvider", $SimplePSLoggerConfig.Providers["AwesomeLogger"])
$MyLogger.Log("test")



$MyLogger = New-SimplePSLogger -Name "action0" -Configuration $SimplePSLoggerConfig
$MyLogger.RegisterProvider("AwesomeLogger", "ExtProvider", $SimplePSLoggerConfig.Providers["AwesomeLogger"])
$MyLogger.Log("test 2")