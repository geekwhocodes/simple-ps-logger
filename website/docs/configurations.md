---
title: Configurations
id: configurations
description: SimplePSLogger configutation
keywords:
  - logging
  - SimplePSLogger 
---

Configure it your way 🤘

SimplePSLogger support's multiple [**Logging Providers**](providers.md) and each provider has it's own configuration properties which you can configure. This gives provider writers an ability to create more powerful and robust providers. You can find configurable properties for each provider on provider's page under **```Configuration```** section. 


### Sample Configuration Object

```powershell
$SimplePSLoggerConfig = @{
    Name      = "Your-Logger-Name" # You can configure this name using -Name parameter too
    Providers = @{
        Console = @{
            Enabled  = $true
            LogLevel = "verbose"
        }
        File    = @{
            LiteralFilePath = "literal\path\file.log"
            LogLevel        = "information"
            Enabled         = $true
        }
    }
}
```

You can configure logger name in your configuration object using **Name** property.
Configuration object has **```Providers```** section which contains provider specific configurations. 
Example - in above example we have configured Console and File logging providers respectively. 

:::tip
Each provider has default **Enabled** and **LogLevel** properties. You can configure them as per your needs.
:::


The name of configuration section follows naming convention: if logging provider's name is **```SimplePSLogger.XYZ```** then you use **```XYZ```** name in configuration object. In above example, we used **```File```** name to configure **```SimplePSLogger.File```** provider. You can find more information on how to configure specific provider under it's own page under [Providers](providers.md) or Custome Providers documentation.

### Log Message Format

SimplePSLogger use following log message format -
UTC-Timestamp[space]logger-name[space]loglevel[space]Log message
:::info
UTC Timestamp format : yyyy/MM/dd HH:mm:ss:ffff tt
:::
![sample-logs-image](/img/providers/simplepslogger.console.png)



:::note
*Each provider can have their own log message format*
:::
