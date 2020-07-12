---
title: Writing Custom Logging Provider
id: writing-custom-provider
description: "Writing SimplePSLogger Custom Logging Provider"
keywords:
    - simple-ps-logger
    - powershell core
    - powershell logging
    - pscore
    - SimplePSLogger
    - geekwhocodes
---

So you want to write custom logging provider? 

### Let's begin

This is an example of custom provider -

```powershell
function AwesomeLoggingProvider {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Name of the SimplePSLogger instance")]
        [string]
        $Name,
        [Parameter(Mandatory = $false, HelpMessage = "Log level, default value is information")]
        [string]
        $Level,
        [Parameter(Mandatory = $true, HelpMessage = "Log message")]
        [string]
        $Message, 
        [Parameter(Mandatory = $false, HelpMessage = "Configuration object")]
        [object]
        $Config,
        # Flush logs to make sure all logs gets logged
        [Parameter(Mandatory = $false)]
        [Switch]
        $Flush
    )
    $InformationPreference = "Continue"
    $logMessage = "$((Get-Date).ToUniversalTime().ToString("yyyy/MM/dd HH:mm:ss:ffff tt")) $Name $($Level): $($Message.Trim())"

    Write-Information "------------------ Log from Custom provider --------------------------" -InformationAction Continue
    Write-Information "$logMessage" -InformationAction Continue
    Write-Information "------------------ Log from Custom provider --------------------------" -InformationAction Continue

    # Do whatever you want to do with message params. Cheers!
}

Export-ModuleMember -Function AwesomeLoggingProvider
```

In order to write custom logging provider, you need to create powershell module with a ***function*** which implements SimplePSLogger Provider interface implemented in above example. 

:::note
You will have export all functions from your custom logger. On line 31 in above example we have exported one function module member AwesomeLoggingProvider if you have other functions defined in there, please export them so that those are available in SimplePSLogger instance.
:::

### SimplePSLogger Provider Interface

| Parameter Name | Description                                                                                                                                                                                                                                                                    |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Name           | Name of the logger provided by end user while creating logging instance                                                                                                                                                                                                        |
| Level          | [LogLevel](log-level.md) supplied by an end user for a single log message                                                                                                                                                                                                      |
| Message        | Actual value of log message provided by an end user                                                                                                                                                                                                                            |
| Config         | Configuration required by your logging provider. It's good to have default values wherever possible. Define clear and self explanatory names for configuration keys. example - [AzLogAnalytics Configuration](simplepslogger.azloganalytics.md#sample-configuration)           |
| Flush          | This is an optional paramter. Use this if your logging provider buffers logs before saving/sending/displaying them. [SimplePSLogger.AzLogAnalytics](simplepslogger.azloganalytics.md) provider does support buffering, please take look at it's implementation to get an idea. |

:::note
Custom logging provider configuration should have two mandatory properties/keys <br/>
**Enabled - boolean flag** <br/>
**LogLevel - [LogLevel](log-level.md)**
:::

:::tip
Example custom logging provider - https://github.com/geekwhocodes/simple-ps-logger/blob/master/Examples/ExtProvider/ExtProvider.psm1
:::

After writing custom provider, you will need to register it. SimplePSLogger provides a simple way to register it, see here.


If you are facing problems, tweet me at [@_ganesh_raskar](https://twitter.com/_ganesh_raskar)
