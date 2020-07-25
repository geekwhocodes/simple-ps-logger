<#
    This example works with version 2.x
#>

Import-Module -Name "../SimplePSLogger/SimplePSLogger.psd1"

# In memory conguration
$SimplePSLoggerConfig = @{
    Name      = "az-analytics-example-buffered"
    Providers = @{
        File           = @{
            LiteralFilePath = "G:\Git\simple-ps-logger\ExamplesV2\example-with-config.log"
            LogLevel        = "information"
            Enabled         = $true
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

New-SimplePSLogger -Configuration $SimplePSLoggerConfig

New-SimplePSLogger -Name "az-logger-2" -Configuration $SimplePSLoggerConfig


1..5 | ForEach-Object {
    $loggerName = "action-$_"
    New-SimplePSLogger -Name $loggerName -Configuration $SimplePSLoggerConfig
    1..2 | ForEach-Object {
        if ($_ % 2 -eq 0) {
            Set-SimplePSLogger -Name $loggerName
            Write-Log $objectLog
        }
        else {
            Set-SimplePSLogger -Name "az-logger-2"
            Write-Log $errMsg "error"
        }    
    }
    Clear-Buffer -Name $loggerName
}

Remove-SimplePSLogger -All

