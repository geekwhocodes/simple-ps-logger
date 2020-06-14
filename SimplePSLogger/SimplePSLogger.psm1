
class SimplePSLogger : System.IDisposable {
    
    # Create with providers
    SimplePSLogger([string]$Name, [System.Collections.ArrayList]$LoggingProviders) {
        $this.Name = $Name
        $this.AddLoggingProviders($LoggingProviders)
        Write-Information "`n----------------- SimpleLogger instance initialized with name '$Name' ---------------------- `n"
    }

    <#------------------------------- Members Variables ----------------------------------#>
    hidden [string] $Name = $null
    hidden [System.Collections.ArrayList] $LoggingProviders = [System.Collections.ArrayList]@()
    <#------------------------------- Members Variables ----------------------------------#>
    
    hidden static [object] CreateLogger($Name, [System.Collections.ArrayList]$LoggingProviders) {
        if (-Not $Name) {
            throw "Cannot create logger without 'name'"
        }
        return [SimplePSLogger]::new($Name, $LoggingProviders)
    }

    hidden static [string] GenerateLoggerName() {
        # https://devblogs.microsoft.com/scripting/powertip-create-a-new-guid-by-using-powershell/
        return [Guid]::NewGuid().ToString()
    }

    hidden [string] GetTimestamp() {
        return (Get-Date).ToUniversalTime().ToString("yyyy/MM/dd HH:mm:ss:ffff tt")
    }

    hidden [string] GetLogLevel($level) {
        # TODO : optimize it later
        $c = ("verbose", "debug", "information", "warning", "error", "critical", "none").Contains($level)
        if (-Not $c) {
            Write-Information "Log level '$level' not supported, defaulting to 'information'"
            $level = 'information'
        }
        return $level
    }

    hidden [void] AddLoggingProviders([object[]]$loggers) {
        foreach ($logger in $loggers) {
            $this.LoggingProviders.Add($logger)
        }
    }

    # TODO : need more information.
    [void] Dispose() {
        Write-Warning "$($this.Name) SimplePSLogger disposed"
    }

    <#------------------------------- /Internals ---------------------------------------#>

    
    <#------------------------------- Public methods ---------------------------------------#>
    [void] Log(
        [string]$Level, 
        [object]$Message
    ) {
        $Level = $this.GetLogLevel($Level)

        if (-Not $($Message.GetType() -eq 'String')) {
            $Message = $Message | ConvertTo-Json -Compress -Depth 100 
        }

        if ($this.LoggingProviders.Count -le 0) {
            Write-Information "Zero logging providers registered."
        }

        foreach ($logger in $this.LoggingProviders) {
            Write-Information "Writing using logger - $($logger.Name)"
            if (-Not $logger.Config) {
                Invoke-Command $logger.Function -ArgumentList $this.Name, $Level, $Message
            }
            else {
                Invoke-Command $logger.Function -ArgumentList ($this.Name), $Level, $Message, ($logger.Config)
            }
        }
    }

    [void] Log(
        [object]$Message
    ) {
        $Level = "information"

        if (-Not $($Message.GetType() -eq 'String')) {
            $Message = $Message | ConvertTo-Json -Compress -Depth 100 
        }

        if ($this.LoggingProviders.Count -le 0) {
            Write-Information "Zero logging providers registered."
        }

        foreach ($logger in $this.LoggingProviders) {
            Write-Information "Writing using logger - $($logger.Name)"
            if (-Not $logger.Config) {
                Invoke-Command $logger.Function -ArgumentList ($this.Name), $Level, $Message
            }
            else {
                Invoke-Command $logger.Function -ArgumentList $this.Name, $Level, $Message, ($logger.Config)
            }
        }
    }
    <#------------------------------- /Public methods : everythong is public tho :P ---------------------------------------#>
}

class LoggingProvider {

    hidden LoggingProvider($name, $function, $config) {
        Write-Information "Registering '$name' provider"
        if (-Not $name) {
            throw "Logging provider name is required"
        }
        if (-Not $function) {
            throw "logging provider function is required"
        }
        if (-Not $config) {
            Write-Information "Configurations not provided for '$name' provider or it does not need any configurations."
        }
        $this.Config = $config
        $this.Name = $name
        $this.Function = $function
        Write-Information "Registered '$name' provider"
    }

    hidden static [LoggingProvider] Create($name, $function, $config) {
        return [LoggingProvider]::new($name, $function, $config)
    }

    [string] $Name
    [object] $Function
    [object] $Config
}

<#
.SYNOPSIS
    Use to create new SimplePSLogger instance
    
.DESCRIPTION
    You can create multiple loggers for one action but we recommend creating one single logger for your action
    SimplePSLogger logger automatically registers x loggers.
    Custom logging provider support will be added soon.
    
.PARAMETER Name
    SimplePSLogger name which is used to identify current logger instnace
    Examples : your script name, unique task name etc. 
    It will help you to analyze logs
    TODO: Add more details

.PARAMETER Configuration
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

.EXAMPLE
    TODO : Add examples
    $myLogger = New-SimplePSLogger -Name "action-1234"
    $myLogger.Log('level', 'log message')
    $myLogger.Dispose()

.NOTES
#>
function New-SimplePSLogger {
    param (
        [Parameter(Mandatory = $false, HelpMessage = "Unique/Identifiable name for your logger instance")]
        [string]
        $Name,
        [Parameter(Mandatory = $false, HelpMessage = "Config object")]
        [object]
        <#TODO : Add support to read form file path, 
            First class support for object seems resonable because user can add secrets by without storing those in config file
        #>
        $Configuration
    )

    try {
        $InformationPreference = "Continue"

        if (-Not $Name) {
            if (-Not $Config["Name"]) {
                Write-Information "SimplePSLogger name not provided, initializing instance with auto generated name : '$Name'"
                $Name = [SimplePSLogger]::GenerateLoggerName()
            }
            $Name = $Config["Name"]
        }

        Write-Information "----------------- Initializing SimpleLogger instance with name '$Name' ----------------------`n"

        if (-Not $Configuration) {
            Write-Warning "Configuration path not provided, all providers will get configured without configurations(Not recommended)"
            $Configuration = @{
                Providers = @{
                    
                }
            }
        }
        $NestedProviders = $((Get-Module SimplePSLogger).NestedModules)
        if ($NestedProviders.Count -le 0) {
            Write-Error "Zero logging provider registred, there is no use of SimplePSLogger with logging providers. Exiting..."
        }
        $Loggers = [System.Collections.ArrayList]@()
        foreach ($provider in $NestedProviders) {
            $ProviderSectionName = $($provider.Name -replace "SimplePSLogger.", "")
            $ProviderSectionConfig = $Configuration.Providers[$ProviderSectionName]
            $ProviderFunctionName = "New-$ProviderSectionName-Logger"
            if (-Not $($provider.ExportedCommands.Keys.Contains($ProviderFunctionName))) {
                Write-Information "$($provider.Name) does not have module member exposed in 'New-YuorLoogerName-Logger' format"
            }
            else {
                $ProviderFunctionCode = [scriptblock]::Create($(Get-Command $ProviderFunctionName).Definition)
                $ProviderLogger = [LoggingProvider]::Create($ProviderSectionName, $ProviderFunctionCode, $ProviderSectionConfig)
                # .Add method retuns int32 in pipeline
                $added = $Loggers.Add($ProviderLogger)
            }
        }
        return [SimplePSLogger]::CreateLogger($Name, $Loggers)
    }
    catch {
        throw
    }
}

Export-ModuleMember -Function New-SimplePSLogger -Alias New-SPSL