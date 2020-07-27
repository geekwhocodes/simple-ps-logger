---
external help file: SimplePSLogger-help.xml
id: set-simplepslogger
Module Name: SimplePSLogger
online version:
schema: 2.0.0
title: Set-SimplePSLogger
---

## SYNOPSIS
Set DEFAULT LOGGER

## SYNTAX

```
Set-SimplePSLogger [-Name] <String> [<CommonParameters>]
```

## DESCRIPTION
If you have mutiple logger instances, you can set default logger of your choice before logging messages.

## EXAMPLES

### EXAMPLE 1
```
Set-SimplePSLogger -Name "my-logger"
```

## PARAMETERS

### -Name
{{ Fill Name Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
You can use one(DEFAULT LOGGER) at a time.

## RELATED LINKS
