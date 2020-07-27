---
external help file: SimplePSLogger-help.xml
id: new-simplepslogger
Module Name: SimplePSLogger
online version:
schema: 2.0.0
title: New-SimplePSLogger
---

## SYNOPSIS
Create new SimplePSLogger instance

## SYNTAX

```
New-SimplePSLogger [[-Name] <String>] [[-Configuration] <Object>] [-SetDefault] [<CommonParameters>]
```

## DESCRIPTION
You can create multiple loggers for one action but we recommend creating one single logger for your action
SimplePSLogger logger automatically registers x loggers.
Custom logging provider support will be added soon.

## EXAMPLES

### EXAMPLE 1
```
New-SimplePSLogger -Name "action-1234"
```

### EXAMPLE 2
```
New-SimplePSLogger -Configuration $SimplePSLoggerConfig
```

## PARAMETERS

### -Name
SimplePSLogger name which is used to identify current logger instnace
Examples : your script name, unique task name etc. 
It will help you to analyze logs

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

### -Configuration
SimplePSLogger configuratoin object, this will contain configurations for supported/reistred providers
Configuration for each provider should be defined by creating new section/key with it's name

Example configuration object :
$SimplePSLoggerConfig = @{
Name      = "config-example"
Providers = @{
    File = @{
        LiteralFilePath = "G:\Git\simple-ps-logger\Examples\example-with-config-file\example-with-config.log"
    }
    }
}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SetDefault
Set Default

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

## RELATED LINKS
