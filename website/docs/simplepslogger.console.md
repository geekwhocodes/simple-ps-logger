---
id: simplepslogger.console
title: Console Logging Provider
sidebar_label: Console Logging Provider
description: SimplePSLogger console logging provider
keywords:
  - console logging
  - logging
  - SimplePSLogger
---

This is one of the simplest logging provider, this provider log messages to console. This provider doesn't need any configurations, However you can configure it using **```SimplePSLogger```** configuration object to override defaults.

### Configuration
Use **Console** name to configure this provider's supported properties. 

You can configure two properties -

| Name     | Type                     | Description                                                                                                             | Default Value |
| -------- | ------------------------ | ----------------------------------------------------------------------------------------------------------------------- | ------------- |
| Enabled  | Boolean                  | Tells SimplePSLogger whether to enable this provider or not                                                             | false         |
| LogLevel | [LogLevel](log-level.md) | It tell this provider to which messages to log. Read more about [loglevel precedence](log-level.md#loglevel-precedence) | information   |

<br /><br />

![sample-logs-image](/img/providers/simplepslogger.console-xl.png)