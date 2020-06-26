Import-Module -Name "../SimplePSLogger/SimplePSLogger.psd1"

# In memory conguration
$SimplePSLoggerConfig = @{
    Name      = "az-analytics-example-buffered"
    Providers = @{
        File           = @{
            LiteralFilePath = "G:\Git\simple-ps-logger\Examples\example-with-config-file\example-with-config.log"
            LogLevel        = "information"
            Enabled         = $false
        }
        AzLogAnalytics = @{
            Enabled    = $true
            LogLevel   = "verbose"
            #WorkspaceId  = "****************" # Fetch from your secure store. example - KeyVault
            #WorkspaceKey = "****************" # Fetch from your secure store. example - KeyVault
            LogType    = "GWCPSLogger" # https://docs.microsoft.com/en-us/azure/azure-monitor/platform/data-collector-api#record-type-and-properties
            BufferSize = 50
            Flush      = $true
        }
    }
}

$objectLog = @{
    "k1" = "dsfjlijoiefoiuowfwuoewf"
    "k2" = $obj
    "k3" = @{
        "k3.k1" = "efferthewgku hweqwrq  w"
        "k3.k2" = @{
            "ewkfh" = "srkguhdg"
        }
    }
}

$errMsg = "Something went srong while executing action"

$MyLogger = New-SimplePSLogger -Configuration $SimplePSLoggerConfig


1..5 | ForEach-Object {
    $MyLogger = New-SimplePSLogger -Name "action-$_" -Configuration $SimplePSLoggerConfig
    1..57 | ForEach-Object {
        if ($_ % 2 -eq 0) {
            $MyLogger.Log($objectLog)
        }
        else {
            $MyLogger.log("error", $errMsg)
        }    
    }
    $MyLogger.Flush() 
}



