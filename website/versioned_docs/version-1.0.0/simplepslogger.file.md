---
id: simplepslogger.file
title: File Logging Provider
description: SimplePSLogger file logging provider
keywords:
  - file logging
  - logging
  - SimplePSLogger 
sidebar_label: "File Logging Provider"
---

This logging provider save logs to static file. This provider doesn't need any configurations, However you can configure it using **```SimplePSLogger```** configuration object to override defaults.

:::tip
Default file path : /Temp/logger-name.log <br/>
get default file path by running this command - ```[system.io.path]::GetTempPath()```
:::

### Configuration

Use **```File```** name to configure this provider's supported properties. 

You can configure two properties - 

| Name            | Type                     | Description                                                                                                             | Default Value                                         |
| --------------- | ------------------------ | ----------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------- |
| Enabled         | Boolean                  | Tells SimplePSLogger whether to enable this provider or not.                                                            | false                                                 |
| LogLevel        | [LogLevel](log-level.md) | It tell this provider to which messages to log. Read more about [loglevel precedence](log-level.md#loglevel-precedence) | information                                           |
| LiteralFilePath | string                   | Literal file path                                                                                                       | ```[system.io.path]::GetTempPath()/logger-name.log``` |

:::caution
LiteralFilePath value will be used as typed
:::

### Sample Configuration

```powershell
$SimplePSLoggerConfig = @{
    Name      = "with-config-script"
    Providers = @{
        File           = @{
            LiteralFilePath = "G:\Git\simple-ps-logger\Examples\example-with-config-file\example-with-config.log"
            LogLevel        = "information"
            Enabled         = $true # You can disable this logging provider by setting this value to '$false'
        }
        ... other provider config ...
    }
}
```
### Sample Logs

![file logs sample](/img/providers/simplepslogger.file.png)
