---
id: quick-start
title: Quick Start
description: Getting started with SimplePSLogger
keywords:
    - simple-ps-logger
    - powershell core
    - powershell logging
    - pscore
    - SimplePSLogger
    - geekwhocodes
---

Setup logger into your script under less than a minute 🚀

### Installation

#### PowerShell Gallery

```powershell
# Install from PS Gallery 
Install-Module -Name SimplePSLogger -Scope CurrentUser
```
#### Import from Directory

```powershell
Import-Module -Name drive:path\SimplePSLogger -Verbose
```
Read more about importing module here [Import Module](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/import-module?view=powershell-7)

### Usage

#### Create Logger Instance

```powershell
<#
    .PARAMETER Name 
    This can be used to identify for which purpose you are using this logger instance.
    example - if you are performing task1
    Simple logger will generate log message like this :
    2020/06/12 15:48:31:2518 PM task1 information Log from task1

    task1 is unique name you used while creating the instance. This will helpful to analyze your logs later. 
#>

$MyLogger = New-SimplePSLogger -Name "Unique Name"

# information log
$MyLogger.Log('information', 'log message')

# default log level
$MyLogger.Log("message") # In this case, SimplePSLogger will automatically use default(information) loglevel

$Object = @{User = @{Name= "geekwhocodes", LastLogin = "2020/06/12 15:48:31:2518 PM" } }
# Log PowerShell object, SimplePSLogger will automatically serialize this object
$MyLogger.Log('warning', $Object)

```
