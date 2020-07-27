---
external help file: SimplePSLogger-help.xml
id: write-simplelog
Module Name: SimplePSLogger
online version:
schema: 2.0.0
title: Write-SimpleLog
---

## SYNOPSIS
Write log messages

## SYNTAX

```
Write-SimpleLog [-Message] <Object> [[-Level] <String>] [<CommonParameters>]
```

## DESCRIPTION
Write log messages

## EXAMPLES

### EXAMPLE 1
```
Write-Log "info message"
Write-Log "warn messahe" "warning"
Write-Log "error message" "error"
```

## PARAMETERS

### -Message
Log message

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Level
LogLevel

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
!
Default log level is 'information'

## RELATED LINKS
