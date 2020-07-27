---
external help file: SimplePSLogger-help.xml
id: remove-simplepslogger
Module Name: SimplePSLogger
online version:
schema: 2.0.0
title: Remove-SimplePSLogger
---

## SYNOPSIS
Remove or close existing logger instance

## SYNTAX

```
Remove-SimplePSLogger [[-Name] <String>] [-All] [<CommonParameters>]
```

## DESCRIPTION
You need to remove logger before exiting from your script.
This removes logger so that you can register and use new logger in the same session.

## EXAMPLES

### EXAMPLE 1
```
Remove-SimplePSLogger -All
Remove-SimplePSLogger -Name "my-logger"
```

## PARAMETERS

### -Name
{{ Fill Name Description }}

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
!
It is recommended to remove all loggers before exiting from your script.

## RELATED LINKS
