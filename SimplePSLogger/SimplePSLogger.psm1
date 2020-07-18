
class SimplePSLogger : System.IDisposable {
    
    # Create with providers
    SimplePSLogger([string]$Name, [LoggingProvider[]]$LoggingProviders) {
        $this.Name = $Name
        $this.AddLoggingProviders($LoggingProviders)
        Write-Information "Logging providers registered - $($this.LoggingProviders.Count)" -InformationAction Continue
        Write-Information "$([Environment]::NewLine)----------------- SimpleLogger instance initialized with name '$Name' ---------------------- $([Environment]::NewLine)" -InformationAction Continue
    }

    <#------------------------------- Members Variables ----------------------------------#>
    hidden [string] $Name = $null
    hidden [System.Collections.ArrayList] $LoggingProviders = [System.Collections.ArrayList]@()
    hidden [string] $DefaultLogLevel = "information"
    hidden [hashtable] $LogLevels = [ordered]@{"verbose" = 0; "debug" = 1; "information" = 2; "warning" = 3; "error" = 4; "critical" = 5; "none" = 6 }
    <#------------------------------- Members Variables ----------------------------------#>
    
    hidden static [object] CreateLogger($Name, [LoggingProvider[]]$LoggingProviders) {
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
        if (-Not $this.LogLevels[$level]) {
            Write-Information "Log level '$level' not supported, defaulting to '$this.DefaultLogLevel'" -InformationAction Continue
            $level = $this.DefaultLogLevel
        }
        return $level
    }

    <#  This method checks configured loglevel(for provider) against 
        user provided loglevel in .Log() method
    #>
    hidden [Boolean] ShouldLog($ConfugeredLevel, $Level) {
        # provided level should be greater or equal to configured value.
        return $this.LogLevels[$ConfugeredLevel] -le $this.LogLevels[$Level]
    }

    hidden [void] AddLoggingProviders([LoggingProvider[]]$loggers) {
        foreach ($logger in $loggers) {
            if ($logger.GetType() -ne [LoggingProvider]) {
                throw [InvalidCastException]::new()
            }
            $this.LoggingProviders.Add($logger)
        }
    }

    # TODO : need more information.
    [void] Dispose() {
        Write-Warning "$($this.Name) SimplePSLogger disposed" -WarningAction Continue
    }

    <#------------------------------- /Internals ---------------------------------------#>

    
    <#------------------------------- Public methods ---------------------------------------#>
    [void] Log(
        [string]$Level, 
        [object]$Message
    ) {
        if (-Not $Level) {
            $Level = $this.DefaultLogLevel
        }
        $Level = $this.GetLogLevel($Level)

        if (-Not $($Message.GetType() -eq 'String')) {
            $Message = $Message | ConvertTo-Json -Compress -Depth 100 
        }

        if ($this.LoggingProviders.Count -le 0) {
            Write-Information "Zero logging providers registered." -InformationAction Continue
        }

        foreach ($logger in $this.LoggingProviders) {
            Write-Verbose "Writing using logger - $($logger.Name)"
            if (-Not $logger.Config) {
                try {
                    if ($this.ShouldLog($this.DefaultLogLevel, $Level) -and $logger.Config["Enabled"]) {
                        Invoke-Command $logger.Function -ArgumentList $this.Name, $Level, $Message -ErrorAction Continue   
                    }
                }
                catch {
                    Write-Warning "---------------------- Attention : error occurred while writing log------------------" -WarningAction Continue
                    Write-Warning "$_" -WarningAction Continue
                    Write-Warning "---------------------- /Attention ------------------" -WarningAction Continue
                }
                finally {
                    # TODo : need help
                }
            }
            else {
                try {
                    $UserProvidedLogLevel = if (-Not $logger.Config["LogLevel"]) { $this.DefaultLogLevel }else { $logger.Config["LogLevel"] }
                    if ($this.ShouldLog($UserProvidedLogLevel, $Level) -and $logger.Config["Enabled"]) {
                        Invoke-Command $logger.Function -ArgumentList ($this.Name), $Level, $Message, ($logger.Config) -ErrorAction Continue
                    }
                }
                catch {
                    Write-Warning "---------------------- Attention : error occurred while writing log------------------" -WarningAction Continue
                    Write-Warning "$_" -WarningAction Continue
                    Write-Warning "---------------------- /Attention ------------------" -WarningAction Continue
                }
                finally {
                    #TODO : need help
                }
            }
        }
    }


    [void] Log(
        [object]$Message
    ) {
        # Default loglevel
        $Level = $this.DefaultLogLevel
        $this.Log($Level, $Message)
    }

    <#
        .SYNOPSIS
        Register your custom logging provider
        .DESCRIPTION
            Use this method of [SimplePSLogger] to register your custom logging provider. 
            Make sure that your custom logging script/module/function is available before registering.
            
        .PARAMETER Name
            Name of your logging provider
        .PARAMETER ProviderFunctionName
            Powershell function name of your provider

        .PARAMETER Configuration
            Configuratoin object needed for your logging provider
            Example configuration object :
            $config = @{
                Enabled  = $true
                LogLevel = "information"
                Authkey  = "key"
            }
        
        .EXAMPLE
            $myLogger = New-SimplePSLogger -Name "mylogger"
            $myLogger.RegisterProvider("myAwesomeProvider", "New-MyAwesomeProvider-Logger", $config)
        .NOTES
            Make sure that "New-MyAwesomeProvider-Logger" function and it's dependencies are imported/initialized before registering your provider
    #>
    [void] RegisterProvider($Name, $ProviderFunctionName, $Configuration) {
        try {
            Write-Information "$([Environment]::NewLine)----------------- SimpleLogger - Registering Custom Provider ---------------------- $([Environment]::NewLine)" -InformationAction Continue 
            if (-Not $Name) {
                throw "Provider name is required"
            }
            if (-Not $ProviderFunctionName) {
                throw "Provider function name is required"
            }
            Get-Command -Name $ProviderFunctionName -ErrorAction Stop
            $ProviderFunctionCode = [scriptblock]::Create($(Get-Command -Name $ProviderFunctionName).Definition)
            $ProviderLogger = [LoggingProvider]::Create($Name, $ProviderFunctionCode, $Configuration)
            $this.AddLoggingProviders($ProviderLogger)
            Write-Information "$([Environment]::NewLine)----------------- SimpleLogger - Registering Custom Provider ---------------------- $([Environment]::NewLine)" -InformationAction Continue
        }
        catch [System.Management.Automation.CommandNotFoundException] {
            throw "Provider module/function is recognized as name of cmdlet, please make sure that your provider is available"
        }
        catch {
            throw $_.Exception.Message
        }
    } 

    <#
        Processes remaining logs 
    #>
    [void] Flush() {
        foreach ($logger in $this.LoggingProviders) {
            if ($logger.Config -and $logger.Config["Flush"]) {
                "Clearing $($logger.Name)'s buffered logs"
                Write-Information "Clearing $($logger.Name)'s buffered logs" -InformationAction Continue
                try {
                    Invoke-Command $logger.Function -ArgumentList ($this.Name), "information", "flush logs", $logger.Config, $true -ErrorAction Continue
                }
                catch {
                    Write-Warning "---------------------- Attention : error occurred while flushing logs of $($logger.Name) ------------------" -WarningAction Continue
                    Write-Warning "$_" -WarningAction Continue
                    Write-Warning "---------------------- /Attention ------------------" -WarningAction Continue
                }
                finally {
                    #TODO : need help
                }
            }
            
        }
    }
    <#------------------------------- /Public methods : everything is public tho :P ---------------------------------------#>
}


class LoggingProvider {

    hidden LoggingProvider($name, $function, $config) {
        Write-Information "Registering '$name' provider" -InformationAction Continue
        if (-Not $name) {
            throw "Logging provider name is required"
        }
        if (-Not $function) {
            throw "Logging provider function is required"
        }
        #TODO : validate function type
        if ($($function.GetType()) -ne [scriptblock]) {
            throw "Logging provider's function should be ScriptBlock"
        }
        if (-Not $config) {
            Write-Information "Configurations not provided for '$name' provider or it does not need any configurations." -InformationAction Continue
        }
        $this.Config = $config
        $this.Name = $name
        $this.Function = $function
        Write-Information "Registered '$name' provider" -InformationAction Continue
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
   Create new SimplePSLogger instance
.DESCRIPTION
    You can create multiple loggers for one action but we recommend creating one single logger for your action
    SimplePSLogger logger automatically registers x loggers.
    Custom logging provider support will be added soon.
    
.PARAMETER Name
    SimplePSLogger name which is used to identify current logger instnace
    Examples : your script name, unique task name etc. 
    It will help you to analyze logs

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
        $Configuration,
        # Set Default 
        [Parameter(Mandatory = $false)]
        [switch]
        $SetDefault
    )

    try {
        if (-Not $Name) {
            if ($null -ne $Configuration) {
                if (-Not $Configuration["Name"]) {
                    Write-Information "SimplePSLogger name not provided, initializing instance with auto generated name : '$Name'" -InformationAction Continue
                    $Name = [SimplePSLogger]::GenerateLoggerName()
                }
                $Name = $Configuration["Name"]
            }
            else {
                $Name = [guid]::NewGuid()
            }
        }

        Write-Information "----------------- Initializing SimpleLogger instance with name '$Name' ----------------------`n" -InformationAction Continue

        <#  NOTE : We can merge User provided with default configurations but 
            merging deep hastables is complicated and expensive. 
        #>
        if (-Not $Configuration) {
            #TODO : Create and read default config file. 
            Write-Warning "Configuration not provided, all providers will get configured without configurations(Not recommended)" -WarningAction Continue
            $Configuration = @{
                Providers = @{
                    Console = @{
                        Enabled  = $true
                        LogLevel = "information"
                    }
                }
            }
        }
        else {
            # TODO : will it be helpful if we enable Console provider forcefully?
            if ($Configuration.Providers["Console"]) {
                $Configuration.Providers.Console["Enabled"] = $true
            }
            else {
                $Configuration.Providers["Console"] = @{
                    Enabled = $true
                }
            }
        }
        $NestedProviders = $((Get-Module SimplePSLogger).NestedModules)
        if ($NestedProviders.Count -le 0) {
            Write-Error "Zero logging provider registred, there is no use of SimplePSLogger with logging providers." -ErrorAction Continue
        }
        $Loggers = [System.Collections.ArrayList]@()
        foreach ($provider in $NestedProviders) {
            $ProviderSectionName = $($provider.Name -replace "SimplePSLogger.", "")
            $ProviderSectionConfig = $Configuration.Providers[$ProviderSectionName]

            # IsEnabled?
            if ($ProviderSectionConfig -and $ProviderSectionConfig["Enabled"]) {
                $ProviderFunctionName = "New-$ProviderSectionName-Logger"
                if (-Not $($provider.ExportedCommands.Keys.Contains($ProviderFunctionName))) {
                    Write-Information "$($provider.Name) does not have module member exposed in 'New-YuorLoogerName-Logger' format" -InformationAction Continue
                }
                else {
                    $ProviderFunctionCode = [scriptblock]::Create($(Get-Command $ProviderFunctionName).Definition)
                    $ProviderLogger = [LoggingProvider]::Create($ProviderSectionName, $ProviderFunctionCode, $ProviderSectionConfig)
                    # .Add method retuns int32 in pipeline
                    $null = $Loggers.Add($ProviderLogger)
                }
            }            
        }
        $logger = [SimplePSLogger]::CreateLogger($Name, $Loggers)
        Set-SimplePSLoggerContext -Logger $logger -Default:$SetDefault -ErrorAction Continue
    }
    catch {
        throw
    }
}

<#
.SYNOPSIS
    It sets SimplePSLogger Context
.DESCRIPTION
    SimplePSLogger context contains all instances intialized by the user along with the DEFAULT_LOGGER
.EXAMPLE
    
.INPUTS
    
.OUTPUTS
    
.NOTES
    Used internally
#>
Function Set-SimplePSLoggerContext {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [SimplePSLogger]
        $Logger,
        [Parameter(Mandatory = $false)]
        [switch]
        $Default
    )

    if (-Not $script:SimplePSLoggerContext -or $script:SimplePSLoggerContext.Count -le 0) {
        $script:SimplePSLoggerContext = @{
            DEFAULT_LOGGER = $null
            Instances      = @{}
        }
    }
    if (-Not $script:SimplePSLoggerContext.DEFAULT_LOGGER) {
        Add-SimplePSLogger $Logger -SetDefault -Force
    }
    if ($Default) {
        Add-SimplePSLogger $Logger -SetDefault
    }
    else {
        <# NOTE : If user creates new logger with exiting name then
            the -Force parameter replaces existing logger with the new logger instance
         #>
        Add-SimplePSLogger $Logger -Force
    }
}

<#
.SYNOPSIS
    Add logger instance to SimplePSLogger context
.DESCRIPTION
    Add logger instance to SimplePSLogger context

.PARAMETER Logger
    SimplePSLogger instance
.PARAMETER SetDefault
    Sets default logger if provided
.PARAMETER Force
    If logger instance with the same name is already exists it flag replaces it.
.EXAMPLE
    
.INPUTS
    
.OUTPUTS
    
.NOTES
    Used internally
#>
function Add-SimplePSLogger {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [SimplePSLogger]
        $Logger,
        [Parameter(Mandatory = $false)]
        [switch]
        $SetDefault,
        [Parameter(Mandatory = $false)]
        [switch]
        $Force
    )
    if ($Force) {
        $script:SimplePSLoggerContext.Instances.Remove($Logger.Name)
        $script:SimplePSLoggerContext.Instances.Add($Logger.Name, $Logger)
    }
    else {
        if ($null -ne $(Get-SimplePSLogger -Name $Logger.Name)) {
            Write-Error "Logger witn name $($Logger.Name) already exists. You cannot create logger with same name." -ErrorAction Continue
        }
        $script:SimplePSLoggerContext.Instances.Add($Logger.Name, $Logger)
    }

    if ($SetDefault) {
        $script:SimplePSLoggerContext.DEFAULT_LOGGER = $Logger
    }
}

<#
.SYNOPSIS
    Retrieve registred logger instance by name or list all of them
.DESCRIPTION
    Retrive registred logger instance by name or list all of them
.EXAMPLE
    To retrieve all instances
    Get-SimplePSLogger -All
    To retrieve instance by name
    Get-SimplePSLogger -Name "my-logger"
.INPUTS
    
.OUTPUTS
    1. Returns Object[] if list 
    2. Returns SimplePSLogger instance or $null
.NOTES
    
#>
function Get-SimplePSLogger {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]
        $Name,
        [Parameter(Mandatory = $false)]
        [switch]
        $List
    )
    
    if ($List) {
        return $script:SimplePSLoggerContext.Instances.Values
    }
    if (-Not $script:SimplePSLoggerContext -or $null -eq $script:SimplePSLoggerContext) {
        return $null
    }
    else {
        return $script:SimplePSLoggerContext.Instances[$Name]
    }
}

<#
.SYNOPSIS
    Set DEFAULT LOGGER 
.DESCRIPTION
    If you have mutiple logger instances, you can set default logger of your choice before logging messages.
.EXAMPLE
    Set-SimplePSLogger -Name "my-logger"
.INPUTS
    
.OUTPUTS
    
.NOTES
    You can use one(DEFAULT LOGGER) at a time.
#>
function Set-SimplePSLogger {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName)]
        [string]
        $Name
    )

    if (-Not $script:SimplePSLoggerContext.Instances[$Name]) {
        throw "Logger instance not found with name $Name"
    }
    $script:SimplePSLoggerContext.DEFAULT_LOGGER = $script:SimplePSLoggerContext.Instances[$Name]
    Write-Verbose "Set default logger as $($script:SimplePSLoggerContext.DEFAULT_LOGGER.Name)"
}

<#
.SYNOPSIS
    Remove or close existing logger instance
.DESCRIPTION
    You need to remove logger before exiting from your script.
    This removes logger so that you can register and use new logger in the same session.
.EXAMPLE
    Remove-SimplePSLogger -All
    Remove-SimplePSLogger -Name "my-logger"
.INPUTS
    
.OUTPUTS
    
.NOTES
    ! It is recommended to remove all loggers before exiting from your script.
#>
function Remove-SimplePSLogger {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [string]
        $Name,
        [Parameter(Mandatory = $false)]
        [switch]
        $All
    )
    process {
        if ($All) {
            $script:SimplePSLoggerContext = @{}
            return
        }
        else {
            if ($null -ne $(Get-SimplePSLogger -Name $Name)) {
                Write-Information "Removing Logger $Name" -InformationAction Continue
                $script:SimplePSLoggerContext.Instances.Remove($Name)
                if ($script:SimplePSLoggerContext.DEFAULT_LOGGER.Name -eq $Name) {
                    $script:SimplePSLoggerContext.DEFAULT_LOGGER = $null    
                }
            }
        }
    }
}

<#
.SYNOPSIS
    Write log messages
.DESCRIPTION
    Write log messages
.EXAMPLE
    Write-Log "info message"
    Write-Log "warn messahe" "warning"
    Write-Log "error message" "error"
.INPUTS
    
.OUTPUTS
    
.NOTES
    ! Default log level is 'information'
#>
function Write-Log {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Log message", ValueFromPipelineByPropertyName)]
        [object]
        $Message,
        [Parameter(Mandatory = $false, HelpMessage = "LogLevel", ValueFromPipelineByPropertyName)]
        [ValidateSet("verbose", "debug", "information", "warning", "error", "critical")]
        [string]
        $Level
    )
    process {
        if (-Not $script:SimplePSLoggerContext.DEFAULT_LOGGER) {
            Write-Warning "Default Logger not found, using latest available logger"
            $loggers = Get-SimplePSLogger -All
            if ($loggers.Count -gt 0) {
                $NextDefaultLogger = $loggers.Keys[0]
                $script:SimplePSLoggerContext.DEFAULT_LOGGER = $script:SimplePSLoggerContext.Instances[$NextDefaultLogger]
            }
            else {
                Write-Error "Loggers not available. You might have removed logger, Please create new logger using New-SimplePSLogger cmdlt." -ErrorAction Continue
                return
            }
        }
        $Logger = $script:SimplePSLoggerContext.DEFAULT_LOGGER
        $Logger.Log($Level, $Message)
    }
}

<#
.SYNOPSIS
    Flush buffered logs
.DESCRIPTION
    It's always better to batch your tasks and execute them as one task, it improves performance.
    To avoid missing logs. flush them before exiting your script or flow.
.EXAMPLE
    Clear-Buffer # This flushes buffered logs of DEFAULT LOGGER
    Clear-Buffer -Name "my-looger" # This flushes logs of provided logger instance
    Clear-Buffer -All # This flushes all buffered logs of all logger instances
.INPUTS
    
.OUTPUTS
    
.NOTES
    Always clear call this command at the end of your script, usually in finally block
#>
function Clear-Buffer {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, HelpMessage = "Logger name", ValueFromPipelineByPropertyName)]
        [string]
        $Name,
        [Parameter(Mandatory = $false)]
        [switch]
        $All
    )

    if (-Not $Name -and -Not $All) {
        $logger = $script:SimplePSLoggerContext.DEFAULT_LOGGER
        if ($logger) {
            $logger.Flush()
        }
        return
    }

    if ($All) {
        foreach ($logger In $script:SimplePSLoggerContext.Instances.Values) {
            if ($logger) {
                $logger.Flush()
            }
        }
        return
    }
    if ($Name) {
        $logger = Get-SimplePSLogger -Name $Name
        if (-Not $logger) {
            $logger.Flush()
        }
        return
    }
}

<#
.SYNOPSIS
    Register your custom logging provider. Read more here https://spsl.geekwhocodes.me/docs/custom-provider-registration
.DESCRIPTION
    Register your custom logging provider. Read more here https://spsl.geekwhocodes.me/docs/custom-provider-registration
.EXAMPLE
    Register-LoggingProvider -Name "AwesomeLogger" -FunctionName "FunctionName" -Configuration @{
            Enabled  = $true
            LogLevel = "information"
            Authkey  = "key"
        }
.INPUTS
    
.OUTPUTS
    
.NOTES
    Make sure Function/Module is imported before registering your provider 
#>
function Register-LoggingProvider {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Name for your custom logging provider name")]
        [ValidateNotNull()]
        [string]
        $Name, 
        [Parameter(Mandatory = $true, HelpMessage = "Function name which implements SimplePSLogger custom provider interface.")]
        [ValidateNotNull()]
        [string]
        $FunctionName,
        [Parameter(Mandatory = $true, HelpMessage = "Configurations required for your logging provider")]
        [ValidateNotNull()]
        [object]
        $Configuration
    )

    if (-Not $script:SimplePSLoggerContext) {
        Write-Error "SmplePSLogger is not created. Create logger using New-SimplePSLogger before registering custom provider" -ErrorAction Continue
        return
    }
    if (-Not $script:SimplePSLoggerContext.DEFAULT_LOGGER) {
        Write-Error "DEFAULT LOGGER is not set, Please set default logger using Set-SimplePSLogger cmdlt" -ErrorAction Continue
        return 
    }
    $script:SimplePSLoggerContext.DEFAULT_LOGGER.RegisterProvider($Name, $FunctionName, $Configuration)
}

Export-ModuleMember -Function New-SimplePSLogger, Get-SimplePSLogger, Set-SimplePSLogger, Remove-SimplePSLogger, Register-LoggingProvider, Write-Log, Clear-Buffer