---
title: Simple PowerShell Logger
description: "Simple logging module made with love"
---

# Simple PowerShell Logger Module 
>Supports `n` number of custom providers
---




# Modules

Below is a table contains our modules including built in provider modules.

| Description                                   | Module Name              | PowerShell Gallery Link |
| --------------------------------------------- | ------------------------ | ----------------------- |
| SimplePSLogger                                | `SimplePSLogger`         | Not available yet       |
| [SimplePSLogger.Console](#Build-in-Providers) | `SimplePSLogger.Console` | Not available yet       |
| [SimplePSLogger.File](#Build-in-Providers)    | `SimplePSLogger.File`    | Not available yet       |

## Installation

### PowerShell Gallery

Coming soon...

### Import from Directory

```powershell
Import-Module -Name drive:path\SimplePSLogger -Verbose
```
Read more about importing module here [Import Module](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/import-module?view=powershell-7)

## Usage

### Create Logger Instance

To create new logger instance in your script [New-SimplePSLogger] cmdlet:

```powershell
<#
    .PARAMETER Name 
    This can be used to identify for which purpose you are using this logger instance.
    example - if you are performing task1
    Simple logger will generate log message like this :
    [2020/06/12 15:48:31:2518 PM] [task1] [information]:   "Log from task1"

    here task1 is unique name you used while creating the instance. This will helpful to analyze your logs later. 
    However, you can write your log message in your way by creating custom logging provider. SimplePSLogger will provide :
    Name, Level and Message paramters to your custom logging provider and the you can use them to create your log message.
#>

$MyLogger = New-SimplePSLogger -Name "Unique Name"

<# To log your log message 
    *Log Message type conversion*:
        String - plain text string
        OtherTypes - json serialized string
#>
$MyLogger.Log('level', 'log message')

$MyLogger.Dispose()

```

### Supported Log Levels 
| Level       | Description              |
| ----------- | ------------------------ |
| verbose     | for verbose messages     |
| debug       | for debug messages       |
| information | for information messages |
| warning     | for warning messages     |
| error       | for error messages       |
| critical    | for critical messages    |

### Build in Providers
| Provider           | Description                                                                                                                                         | Docs |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------- | ---- |
| Console            | Simply outputs logs to console                                                                                                                      | Link |
| File               | Outputs logs to file(at this point file path is not configurable but it's on our roadmap ) logFile path is $env:Temp/SimplePSLoggerInstanceName.log | Link |
| Azure LogAnalytics | Coming soon                                                                                                                                         | Link |
| Azure AppInsights  | Cooming soon                                                                                                                                        | Link |
| Rolling Log File   | On the Roadmap                                                                                                                                      | LInk |


## Reporting Issues and Feedback

### Issues

If you find any bugs when using this module, Please an issue on github


### Feedback

If there is a feature you would like to see  in SimplePSLogger file an issue on github page. 


