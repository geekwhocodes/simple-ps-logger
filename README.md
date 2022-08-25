<a style="text-decoration:none" href="https://www.powershellgallery.com/packages/SimplePSLogger" target="_blank" rel="noopener noreferrer">
    <h3 align="center">Simple PowerShell Logging Module</h3>
</a>
<p align="center">
  <a style="text-decoration:none" href="https://www.powershellgallery.com/packages/SimplePSLogger" target="_blank" rel="noopener noreferrer">
    <img src="./logo.svg" width="250x" alt="Simple PowerShell Logging Module logo" />
  </a>
</p>

<p align="center">
  <a style="text-decoration:none" href="https://dev.azure.com/geekwhocodes/simple-ps-logger">
    <img src="https://img.shields.io/azure-devops/build/geekwhocodes/simple-ps-logger/12/master?style=flat-square" alt="Build Status" />
  </a>
  <a style="text-decoration:none" href="https://dev.azure.com/geekwhocodes/simple-ps-logger/_test/analytics?definitionId=12&contextType=build">
    <img src="https://img.shields.io/azure-devops/tests/geekwhocodes/simple-ps-logger/12?style=flat-square" alt="Tests" />
  </a>
  <a style="text-decoration:none" href="https://www.codefactor.io/repository/github/geekwhocodes/simple-ps-logger">
    <img src="https://img.shields.io/codefactor/grade/github/geekwhocodes/simple-ps-logger?style=flat-square" alt="Code Quality" />
  </a>
  
  <img src="https://img.shields.io/github/last-commit/geekwhocodes/simple-ps-logger/master?style=flat-square" alt="last commit">
  <img src="https://img.shields.io/github/license/geekwhocodes/simple-ps-logger?style=flat-square" alt="license">
</p>

---

- [Introduction](#introduction)
    - [Features](#features)
- [Modules](#modules)
  - [Installation](#installation)
    - [PowerShell Gallery](#powershell-gallery)
    - [Import from Directory](#import-from-directory)
- [Usage](#usage)
        - [Example 1](#example-1)
        - [Example 2](#example-2)
- [Built in Providers](#built-in-providers)
- [Supported Log Levels](#supported-log-levels)
  - [Reporting Issues and Feedback](#reporting-issues-and-feedback)
    - [Issues](#issues)
    - [Feedback](#feedback)


# Introduction

> **SimplePSLogger provides an easy yet powerful way to save or display your logs.**
- Docs - [SimplePSLogger Documentation](https://spsl.geekwhocodes.me/)
- Task Board - [Board](https://github.com/geekwhocodes/simple-ps-logger/projects/3)
- [V2 Docs](https://next-simplepslogger.onrender.com/docs/next/)
### Features
- Built with 💜 and PowerShell Core
  - Easy to use
  - Cross platform
- Simple Configuration 👌
- Pluggable
  - Bring your own logging provider
  - Open source your logging provider to share with your fellow PowerShellers, because sharing is caring 
- Built in Providers 🔥
  - Start logging within a minute 
- Lightning fast ⚡️ 
  
---

# Modules

Below is a table contains our modules including built in provider modules.

| Description                                          | Module Name                     | PowerShell Gallery Link                                   | Downloads                                                                                  |
| ---------------------------------------------------- | ------------------------------- | --------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| SimplePSLogger                                       | `SimplePSLogger`                | [![SimplePSLogger][SimplePSLoggerImg]][SimplePSLoggerUrl] | ![Downloads](https://img.shields.io/powershellgallery/dt/SimplePSLogger?style=flat-square) |
| [SimplePSLogger.Console](#Built-in-Providers)        | `SimplePSLogger.Console`        | Sub module                                                |
| [SimplePSLogger.File](#Built-in-Providers)           | `SimplePSLogger.File`           | Sub module                                                |
| [SimplePSLogger.AzLogAnalytics](#Built-in-Providers) | `SimplePSLogger.AzLogAnalytics` | Sub module                                                |

## Installation

### PowerShell Gallery

```powershell
# Install pre-release version 
Install-Module -Name SimplePSLogger -Confirm

```

### Import from Directory

```powershell
Import-Module -Name drive:path\SimplePSLogger -Verbose
```
Read more about importing module here [Import Module](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/import-module?view=powershell-7)


<hr/>

# Usage

##### Example 1
Create new logger instance using ```New-SimplePSLogger``` cmdlet:

```powershell 
<#
    .PARAMETER Name 
    This can be used to identify for which purpose you are using this logger instance.
    example - if you are performing task1
    Simple logger will generate log message like this :
    2020/06/12 15:48:31:2518 PM task1 information Log from task1

    task1 is unique name you used while creating the instance. This will helpful to analyze your logs later. 
#>

New-SimplePSLogger -Name "MyLogger"

# information log
Write-SimpleLog "Log message" "information"

# default log level
Write-SimpleLog "message" # In this case, SimplePSLogger will automatically use default(information) loglevel

$Object = @{User = @{Name= "geekwhocodes", LastLogin = "2020/06/12 15:48:31:2518 PM" } }
# Log PowerShell object, SimplePSLogger will automatically serialize this object
Write-SimpleLog $Object "warning"

# Note - DON'T forget to flush and remove logger instance/instances

# Flush bufferred logs 
Clear-Buffer -Name "MyLogger"
# Remove all logger instances
Remove-SimplePSLogger -Name "MyLogger"

```

##### Example 2
Create new logger instance using ```New-SimplePSLogger``` cmdlet: <br/>
Read more about [configuration](https://spsl.geekwhocodes.me/docs/configurations)

```powershell 
<#
    .PARAMETER Name 
    This can be used to identify for which purpose you are using this logger instance.
    example - if you are performing task1
    Simple logger will generate log message like this :
    2020/06/12 15:48:31:2518 PM task1 information Log from task1
    task1 is unique name you used while creating the instance. This will helpful to analyze your logs later. 

    .PARAMETER Configuration
    Configuration to use for logger instance.
#>

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

New-SimplePSLogger -Name "MyLogger" -Configuration $SimplePSLoggerConfig

# information log
Write-SimpleLog "Log message" "information"

# default log level
Write-SimpleLog "message" # In this case, SimplePSLogger will automatically use default(information) loglevel

$Object = @{User = @{Name= "geekwhocodes", LastLogin = "2020/06/12 15:48:31:2518 PM" } }
# Log PowerShell object, SimplePSLogger will automatically serialize this object
Write-SimpleLog $Object "warning"

# Note - DON'T forget to flush and remove logger instance/instances

# Flush bufferred logs 
Clear-Buffer -Name "MyLogger"
# Remove all logger instances
Remove-SimplePSLogger -Name "MyLogger"

```


---

# Built in Providers

| Provider                                                                                            | Description                                | Docs                                                                                            |
| --------------------------------------------------------------------------------------------------- | ------------------------------------------ | ----------------------------------------------------------------------------------------------- |
| Console                                                                                             | Outputs logs to console                    | [Console Provider](https://spsl.geekwhocodes.me/docs/simplepslogger.console)               |
| File                                                                                                | Writes logs to static file                 | [File Provider](https://spsl.geekwhocodes.me/docs/simplepslogger.file)                     |
| [AzLogAnalytics](https://docs.microsoft.com/en-us/azure/azure-monitor/log-query/get-started-portal) | Send logs to Azure Log Analytics Workspace | [AzLogAnalytics Provider](https://spsl.geekwhocodes.me/docs/simplepslogger.azloganalytics) |
| Rolling File                                                                                        | Writes logs to file                        | [To do](https://github.com/geekwhocodes/simple-ps-logger/projects/3#card-40824479)              |

---

# Supported Log Levels 
| Level       | Description              |
| ----------- | ------------------------ |
| verbose     | for verbose messages     |
| debug       | for debug messages       |
| information | for information messages |
| warning     | for warning messages     |
| error       | for error messages       |
| critical    | for critical messages    |

--- 

## Reporting Issues and Feedback

### Issues

If you find any bugs when using this module, Please an [issue on github](https://github.com/geekwhocodes/simple-ps-logger/issues)


### Feedback

If there is a feature you would like to see  in SimplePSLogger file an [issue on github](https://github.com/geekwhocodes/simple-ps-logger/issues)

# Show your love
Give a ⭐ if you find this project helpful!


[SimplePSLoggerImg]:  https://img.shields.io/powershellgallery/v/SimplePSLogger?include_prereleases&label=SimplePSLogger&style=flat-square
[SimplePSLoggerUrl]:  https://www.powershellgallery.com/packages/SimplePSLogger

[DocsImg]: https://img.shields.io/github/deployments/geekwhocodes/Simple-PS-Logger/github-pages?label=docs&style=flat-square
[DocsUrl]: https://spsl.geekwhocodes.me/

[AzBuildImg]: https://img.shields.io/azure-devops/build/geekwhocodes/simple-ps-logger/12/master?style=flat-square
[AzBuildUrl]: https://dev.azure.com/geekwhocodes/simple-ps-logger

[AzTestsImg]: https://img.shields.io/azure-devops/tests/geekwhocodes/simple-ps-logger/12?style=flat-square
[AzTestsUrl]: https://dev.azure.com/geekwhocodes/simple-ps-logger/_test/analytics?definitionId=12&contextType=build

[CodeFactImg]: https://img.shields.io/codefactor/grade/github/geekwhocodes/simple-ps-logger?style=flat-square
[CodeFactUrl]: https://www.codefactor.io/repository/github/geekwhocodes/simple-ps-logger
