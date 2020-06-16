Import-Module -Name "../SimplePSLogger/SimplePSLogger.psd1"

# In memory conguration
$SimplePSLoggerConfig = @{
    Name      = "az-analytics-example"
    Providers = @{
        File           = @{
            LiteralFilePath = "G:\Git\simple-ps-logger\Examples\example-with-config-file\example-with-config.log"
            LogLevel        = "information"
            Enabled         = $false
        }
        AzLogAnalytics = @{
            Enabled  = $true
            LogLevel = "verbose"
            #WorkspaceId  = "****************" # Fetch from your secure store. example - KeyVault
            #WorkspaceKey = "****************" # Fetch from your secure store. example - KeyVault
            LogType  = "GWCPSLogger" # https://docs.microsoft.com/en-us/azure/azure-monitor/platform/data-collector-api#record-type-and-properties
        }
    }
}

$MyLogger = New-SimplePSLogger -Configuration $SimplePSLoggerConfig

$MyLogger.Log("fiest log test")

$objectLog = @{
    "k1" = "dsfjlijoiefoiuowfwuoewf"
    "k2" = $obj
    "k3" = @{
        "k3.k1" = "''ef\ferthew\gkuhweg/qwrqw"
        "k3.k2" = @{
            "ewkfh" = "srkguhdg"
        }
    }
}

$MyLogger.Log($objectLog)

$MyLogger.Dispose()


