---
title : SimplePSLogger
description: Simple PowerShell Logging module, built for simplicity and usability.
tags: "powershell", "logging", "logger", "pscore", "linux", "file-logging", "azure-log-analytics"
---

# Simple PowerShell Logger
![](https://img.shields.io/github/last-commit/geekwhocodes/simple-ps-logger/dev?style=flat-square) [![Docs][DocsImg]][DocsUrl]
![](https://img.shields.io/github/license/geekwhocodes/simple-ps-logger?style=flat-square)


> Supports `n` number of custom providers
---

# Modules

Below is a table contains our modules including built in provider modules.

| Description                                   | Module Name              | PowerShell Gallery Link                                   | Downloads                                                                                  |
| --------------------------------------------- | ------------------------ | --------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| SimplePSLogger                                | `SimplePSLogger`         | [![SimplePSLogger][SimplePSLoggerImg]][SimplePSLoggerUrl] | ![Downloads](https://img.shields.io/powershellgallery/dt/SimplePSLogger?style=flat-square) |
| [SimplePSLogger.Console](#Build-in-Providers) | `SimplePSLogger.Console` | Sub module                                                |
| [SimplePSLogger.File](#Build-in-Providers)    | `SimplePSLogger.File`    | Sub module                                                |

## Installation

### PowerShell Gallery

```powershell
# Install pre-release version 
Install-Module -Name SimplePSLogger -AllowPrerelease

```

### Import from Directory

```powershell
Import-Module -Name drive:path\SimplePSLogger -Verbose
```
Read more about importing module here [Import Module](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/import-module?view=powershell-7)


## Docs 

[SimplePSLogger Documentation](https://spsl.geekwhocodes.me/)


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
| Azure AppInsights  | Coming soon                                                                                                                                         | Link |
| Rolling Log File   | On the Roadmap                                                                                                                                      | LInk |


## Reporting Issues and Feedback

### Issues

If you find any bugs when using this module, Please an issue on github


### Feedback

If there is a feature you would like to see  in SimplePSLogger file an issue on github page. 





[SimplePSLoggerImg]:  https://img.shields.io/powershellgallery/v/SimplePSLogger?include_prereleases&label=SimplePSLogger&style=flat-square
[SimplePSLoggerUrl]:  https://www.powershellgallery.com/packages/SimplePSLogger

[DocsImg]: https://img.shields.io/github/deployments/geekwhocodes/Simple-PS-Logger/github-pages?label=docs&style=flat-square
[DocsUrl]: https://spsl.geekwhocodes.me/
