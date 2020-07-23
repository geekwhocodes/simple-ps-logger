---
external help file: SimplePSLogger-help.xml
id: get-simplepslogger
Module Name: SimplePSLogger
online version:
schema: 2.0.0
title: Get-SimplePSLogger
---

## SYNOPSIS
Retrieve registred logger instance by name or list all of them

## SYNTAX

```
Get-SimplePSLogger [[-Name] <String>] [-List] [<CommonParameters>]
```

## DESCRIPTION
Retrieve registred logger instance by name or list all of them

## EXAMPLES

### EXAMPLE 1
```
Get-SimplePSLogger -All
```

### EXAMPLE 2
```
Get-SimplePSLogger -Name "my-logger"
```

## PARAMETERS

### -Name
Name of the logger instance .PARAMETER

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -List
List all logger instances .PARAMETER

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

### Returns Object[] of all logger instances
### Returns [SimplePSLogger]
## NOTES

## RELATED LINKS
