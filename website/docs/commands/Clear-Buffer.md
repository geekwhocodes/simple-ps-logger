---
external help file: SimplePSLogger-help.xml
id: clear-buffer
Module Name: SimplePSLogger
online version:
schema: 2.0.0
title: Clear-Buffer
---

## SYNOPSIS
Flush buffered logs

## SYNTAX

```
Clear-Buffer [[-Name] <String>] [-All] [<CommonParameters>]
```

## DESCRIPTION
It's always better to batch your tasks and execute them as one task, it improves performance.
To avoid missing logs.
flush them before exiting your script or flow.

## EXAMPLES

### EXAMPLE 1
```
Clear-Buffer # This flushes buffered logs of DEFAULT LOGGER
Clear-Buffer -Name "my-looger" # This flushes logs of provided logger instance
Clear-Buffer -All # This flushes all buffered logs of all logger instances
```

## PARAMETERS

### -Name
Logger name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -All
{{ Fill All Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Always clear call this command at the end of your script, usually in finally block

## RELATED LINKS
