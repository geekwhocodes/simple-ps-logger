# TODO : reduce constructor overloads and CreateLogger overloads
class SimplePSLogger : System.IDisposable {
    
    # Create with providers
    SimplePSLogger([string]$Name, [object[]]$LoggingProviders) {
        Write-Information "SimpleLogger instance initialized with name $Name"
        $this.Name = $Name
        $this.AddLoggingProviders($LoggingProviders)
    }

    # Create with provider
    SimplePSLogger([string]$Name, [object]$LoggingProvider) {
        Write-Information "SimpleLogger instance initialized with name $Name"
        $this.Name = $Name
        $this.AddLoggingProvider($LoggingProvider)
    }
    

    <#------------------------------- Members Variables ----------------------------------#>
    hidden [string] $Name = $null
    hidden [System.Collections.ArrayList] $LoggingProviders = [System.Collections.ArrayList]@()
    <#------------------------------- Members Variables ----------------------------------#>
    
    hidden static [object] CreateLogger($Name, [object[]]$LoggingProviders) {
        if (-Not $Name) {
            throw "Cannot create logger without action id"
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
            Write-Warning "Log level '$level' not supported, defaulting to 'information'"
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
            Write-Warning "Zero logging providers registered."
        }

        foreach ($logger in $this.LoggingProviders) {
            Invoke-Command $logger -ArgumentList $this.Name, $Level, $Message
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
            Write-Warning "Zero logging providers registered."
        }

        foreach ($logger in $this.LoggingProviders) {
            Invoke-Command $logger -ArgumentList $this.Name, $Level, $Message
        }
    }
    <#------------------------------- /Public methods : everythong is public tho :P ---------------------------------------#>
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
        $Name
    )

    if (-Not $Name) {
        $Name = [SimplePSLogger]::GenerateLoggerName()
        Write-Information "SimplePSLogger name not provided, initializing instance with auto generated name : $Name"
    }

    # Register SimplePSLogger internal loggers
    # TODO : are there any alternatoives to this?
    $ConsoleLogger = ${function:New-Console-Logger}
    $FileLogger = ${function:New-File-Logger}
    $Loggers = @($ConsoleLogger, $FileLogger)

    return [SimplePSLogger]::CreateLogger($Name, $Loggers)
}