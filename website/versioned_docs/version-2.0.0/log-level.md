---
id: log-level
title: LogLevel
keywords:
  - logger
  - logging
  - loglevel
  - SimplePSLogger
description: SimplePSLogger loglevel
---

This page describes which log levels are supported and when to use which log level.

### Supported Log Levels

| id  | Level       | Description                                                                                                              |
| --- | ----------- | ------------------------------------------------------------------------------------------------------------------------ |
| 0   | verbose     | This log level contains detailed message(including sensitive information) and it is not recommended to use in production |
| 1   | debug       | This is for development and debugging                                                                                    |
| 2   | information | This is widely used to track your script's or application's execution flow                                               |
| 3   | warning     | This is used to log abnormal or unexpected events                                                                        |
| 4   | error       | To log exceptions which cannot be handled by user code                                                                   |
| 5   | critical    | Indicates application/script failure and needs immediate attention                                                       |



:::info
If you modify [PowerShell Preference Variables](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-7) then above information will be less valid
:::

### LogLevel Precedence

LogLevel precedence helps you to configure which messages you want to log. 
Example - 
If you configure **```LogLevel```** property as **information** for Console provider then Console provider will ignore all the messages which has **id** value less than information log level's id. In above table information has id 2 so, "verbose" and "debug" log messages will get ignored. 


