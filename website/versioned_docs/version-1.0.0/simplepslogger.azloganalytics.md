---
id: simplepslogger.azloganalytics
title: Azure Log Analytics Logging Provider
description: SimplePSLogger Azure Log Analytics logging provider
keywords:
  - console logging
  - azure log analytics
  - logging
  - SimplePSLogger
sidebar_label: "Azure Log Analytics Logging Provider"
---

This logging provider sends log messages to [Azure Log Analytics](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/design-logs-deployment) workspace. Azure log analytics is great place to store and visualize logs. This provider uses [HTTP Data Collector API](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/data-collector-api) to send custom logs to configured workspace. 

### Configuration

Use **```AzLogAnalytics```** name to configure this provider's supported properties. 

You can configure two properties - 

| Name         | Type                     | Description                                                                                                                                                                                                   | Default Value  |
| ------------ | ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- |
| Enabled      | Boolean                  | Tells SimplePSLogger whether to enable this provider or not.                                                                                                                                                  | false          |
| LogLevel     | [LogLevel](log-level.md) | It tell this provider to which messages to log. Read more about [loglevel precedence](log-level.md#loglevel-precedence)                                                                                       | information    |
| WorkspaceId  | string                   | Azure Log Analytics Workspace Id                                                                                                                                                                              | $null          |
| WorkspaceKey | string                   | Azure Log Analytics Workspace Key                                                                                                                                                                             | $null          |
| LogType      | string                   | [Azure Log Analytics Custom log type](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/data-sources-custom-logs) (You don't need to create it beforehand, this provider create it automatically) | SimplePSLogger |
| BufferSize   | int                      | Buffer size before sending logs to analytics workspace                                                                                                                                                        | 20             |
| Flush        | Boolean                  | Tells logging provider to flush logs after calling ```.Flush``` method                                                                                                                                        | $null          |

:::danger Caution
Use Flush method to flush your log messages at the end of the script otherwise those log messages will be lost. 
:::

### How to flush logs 

```powershell {6}
$MyLogger = New-SimplePSLogger -Name "Unique Name"
$MyLogger.Log('information', 'log message')
$MyLogger.Log("message") # In this case, SimplePSLogger will automatically use default(information) loglevel
$Object = @{User = @{Name= "geekwhocodes", LastLogin = "2020/06/12 15:48:31:2518 PM" } }
$MyLogger.Log('warning', $Object)
$MyLogger.Flush()
```


### Log Format 
This provider sends log messages to Azure log analytics in this format

| Field      | Value                                                         |
| ---------- | ------------------------------------------------------------- |
| TimeStamp  | Current timestamp in ```yyyy/MM/dd HH:mm:ss:ffff tt``` format |
| LoggerName | Current configured logger name                                |
| Level      | [LogLevel](log-level.md)                                      |
| Message    | Actual log message                                            |

### Sample Configuration

```powershell
$SimplePSLoggerConfig = @{
    Name      = "az-analytics-example"
    Providers = @{
        ... other providers config...
        AzLogAnalytics = @{
            Enabled  = $true
            LogLevel = "verbose"
            #WorkspaceId  = "****************" # Fetch from your secure store. example - KeyVault
            #WorkspaceKey = "****************" # Fetch from your secure store. example - KeyVault
            LogType  = "GWCPSLogger" # https://docs.microsoft.com/en-us/azure/azure-monitor/platform/data-collector-api#record-type-and-properties
        }
    }
}
```

### Sample Logs
![azloganalytics-logs-sample](/img/providers/simplepslogger.azloganalytics.png)