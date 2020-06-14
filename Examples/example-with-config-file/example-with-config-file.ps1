Import-Module -Name "../../SimplePSLogger/SimplePSLogger.psd1"

# In memory conguration
$SimplePSLoggerConfig = @{
    Name      = "config-example"
    Providers = @{
        File = @{
            LiteralFilePath = "G:\Git\simple-ps-logger\Examples\example-with-config-file\example-with-config.log"
        }
    }
}

$MyLogger = New-SimplePSLogger -Name "with-config-script" -Configuration $SimplePSLoggerConfig

$MyLogger.Log("warning", "warn")
$MyLogger.Log("skdufh", "unsupported level")
$MyLogger.Log("critical", "critical")
$MyLogger.Log("verbose", "verbose")
$MyLogger.Log("information", "information")
$MyLogger.Log("debug", "deubg")
$MyLogger.Log("error", "error")

$MyLogger.Log("warning", "warn")
$MyLogger.Log("skdufh", "unsupported level")
$MyLogger.Log("critical", "critical")
$MyLogger.Log("verbose", "verbose")
$MyLogger.Log("information", "information")
$MyLogger.Log("debug", "deubg")
$MyLogger.Log("error", "error")

$MyLogger.Log("kdfjoiopfkdopkopk")

$MyLogger.Dispose()

