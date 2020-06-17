---
title : Supported LogLevel
description : This page explains which loglevel are supported and when to use them. 
tags: "powershell logging", "loglevel", "logging"
---

# Supported LogLevel


| Id  | Level       | Description                                                                                                              |
| --- | ----------- | ------------------------------------------------------------------------------------------------------------------------ |
| 0   | verbose     | This log level contains detailed message(including sensitive information) and it is not recommended to use in production |
| 1   | debug       | This is for development and debugging                                                                                    |
| 2   | information | This is widely used to track your script's or application's execution flow                                               |
| 3   | warning     | This is used to log abnormal or unexpected events                                                                        |
| 4   | error       | To log exceptions which cannot be handled by user code                                                                   |
| 5   | critical    | Indicates application/script failure and needs immediate attention                                                       |


#### You can configure loglevel for each [Provider](providers) 

<!-- This is using gitbook specific hint syntax -->
{% hint style="warning" %}
If you modify [PowerShell Preference Variables](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-7) then above information will be less valid
{% endhint %}

