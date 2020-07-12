---
title: Custom Provider Registration
id: custom-provider-registration
description: "Registering SimplePSLogger Custom Logging Provider"
keywords:
    - simple-ps-logger
    - powershell core
    - powershell logging
    - pscore
    - SimplePSLogger
    - geekwhocodes
---

We assume that you have successfully create custom logging provider by following [writing custom provider](writing-custom-provider.md). Let's register it so that you can use it.

### Steps 
- Import SimplePSLogger module
- Import your custom logging provider module
- Create SimplePSLogger instance
- Register your provider using .Register method


### Registration

```powershell {30}
# 1. Import SimplePSLogger module
Import-Module -Name SimplePSLogger
# 2. Import your custom logging provider module
Import-Module -Name CustomeLoggingProvider
# Create SimplePSLogger configuration 
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

# 3. Create SimplePSLogger instance
$MyLogger = New-SimplePSLogger -Name "ps-play"

# 4. Register your provider using .Register method. MAKE SURE function named "ExtProvider" is imported
$MyLogger.RegisterProvider("AwesomeLogger", "ExtProvider", $SimplePSLoggerConfig.Providers["AwesomeLogger"])


$MyLogger.Log("test")
```

### Registration Paramters

1. Customer Logging Provider Name
2. Exported function name which implements [SimplePSLogger Provider Interface](writing-custom-provider.md#SimplePSLogger-Provider-Interface)
3. Configuration object required/defined by custom provider


<br/>

If you are facing problems, tweet me at [@_ganesh_raskar](https://twitter.com/_ganesh_raskar)