---
external help file: SimplePSLogger-help.xml
id: register-loggingprovider
Module Name: SimplePSLogger
online version:
schema: 2.0.0
title: Register-LoggingProvider
---

## SYNOPSIS
Register your custom logging provider.
Read more here https://spsl.geekwhocodes.me/docs/custom-provider-registration

## SYNTAX

```
Register-LoggingProvider [-Name] <String> [-FunctionName] <String> [-Configuration] <Object>
 [<CommonParameters>]
```

## DESCRIPTION
Register your custom logging provider.
Read more here https://spsl.geekwhocodes.me/docs/custom-provider-registration

## EXAMPLES

### EXAMPLE 1
```
Register-LoggingProvider -Name "AwesomeLogger" -FunctionName "FunctionName" -Configuration @{
        Enabled  = $true
        LogLevel = "information"
        Authkey  = "key"
    }
```

## PARAMETERS

### -Name
Name for your custom logging provider name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FunctionName
Function name which implements SimplePSLogger custom provider interface.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Configuration
Configurations required for your logging provider

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Make sure Function/Module is imported before registering your provider

## RELATED LINKS
