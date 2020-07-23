<#
    Source - https://docs.microsoft.com/en-us/azure/azure-monitor/platform/data-collector-api#powershell-sample
#>
Function Build-Signature ($customerId, $sharedKey, $date, $contentLength, $method, $contentType, $resource) {
    $xHeaders = "x-ms-date:" + $date
    $stringToHash = $method + "`n" + $contentLength + "`n" + $contentType + "`n" + $xHeaders + "`n" + $resource

    $bytesToHash = [Text.Encoding]::UTF8.GetBytes($stringToHash)
    $keyBytes = [Convert]::FromBase64String($sharedKey)

    $sha256 = New-Object System.Security.Cryptography.HMACSHA256
    $sha256.Key = $keyBytes
    $calculatedHash = $sha256.ComputeHash($bytesToHash)
    $encodedHash = [Convert]::ToBase64String($calculatedHash)
    $authorization = 'SharedKey {0}:{1}' -f $customerId, $encodedHash
    return $authorization
}

<#
    
#>
Function Send-LogAnalyticsData($customerId, $sharedKey, $body, $logType) {
    $method = "POST"
    $contentType = "application/json"
    $resource = "/api/logs"
    $rfc1123date = [DateTime]::UtcNow.ToString("r")
    $contentLength = $body.Length
    $signature = Build-Signature `
        -customerId $customerId `
        -sharedKey $sharedKey `
        -date $rfc1123date `
        -contentLength $contentLength `
        -method $method `
        -contentType $contentType `
        -resource $resource
    
    if (-Not  $logType) {
        $logType = "SimplePSLogger"
    }
    $headers = @{
        "Authorization" = $signature;
        "Log-Type"      = $logType;
        "x-ms-date"     = $rfc1123date;
    }
    $endpoint = "https://" + $customerId + ".ods.opinsights.azure.com" + $resource + "?api-version=2016-04-01"
    try {
        $params = @{
            "ContentType" = "application/json"
            "Header"      = $headers
            "Body"        = $body
            "Method"      = "POST"
            "URI"         = $endpoint
        }

        # TODO : add status code check and resiliency
        $null = Invoke-RestMethod @params
    }
    catch {
        throw
    }
}

<#
.SYNOPSIS
    AzLogAnalytics logging provider for SimplePSLogger logger 
    This provider send log to Azure Log Analytics https://dev.loganalytics.io/documentation/Overview
    Use - https://docs.microsoft.com/en-us/azure/azure-monitor/platform/data-collector-api
    https://docs.microsoft.com/en-us/azure/azure-monitor/platform/metrics-store-custom-rest-api
    Limits - https://docs.microsoft.com/en-us/azure/azure-monitor/platform/data-collector-api#data-limits
.DESCRIPTION
    TODO: add more details
    More details


.PARAMETER Name
    SimplePSLogger action execution id which is used to identify executing action
.PARAMETER Level
    Log level : allowed values are - "verbose", "debug", "information", "warning", "error", "critical", "none"
    TODO : add more infor for each level
.PARAMETER Message
    Log message : 
        String - plain text string
        OtherTypes - json serialized string

.PARAMETER Config
    Required configuration provided by user

.EXAMPLE
    TODO : Add examples

.NOTES
    Author: Ganesh Raskar
    
#>
Function New-AzLogAnalytics-Logger {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Name of the SimplePSLogger instance")]
        [string]
        $Name,
        [Parameter(Mandatory = $false, HelpMessage = "Log level, default value is information")]
        [string]
        $Level,
        [Parameter(Mandatory = $true, HelpMessage = "Log message")]
        [string]
        $Message,
        [Parameter(Mandatory = $false, HelpMessage = "Configuration object")]
        [object]
        $Config,
        # Flush logs to make sure all logs gets logged
        [Parameter(Mandatory = $false)]
        [Switch]
        $Flush
    )

    # TODO : SimpleLogger will pass on current provider name(my name :P)
    #$CurrentProviderName = "AzLogAnalytics"
    #$bufferedFile = Join-Path $([system.io.path]::GetTempPath()) -ChildPath "$Name.$CurrentProviderName.log"

    # TODO : refactor?
    if (-Not $Config) {
        Write-Warning "Configuration not provided for 'AzLogAnalytics' provider"
    }
    if (-Not $Config['WorkspaceId']) {
        Write-Warning "Azure Log Analytics WorkspaceId not provided for 'AzLogAnalytics' provider"
    }

    if (-Not $Config['WorkspaceKey']) {
        Write-Warning "Azure Log Analytics WorkspaceKey(secret) not provided for 'AzLogAnalytics' provider"
    }
    if (-Not $Config['LogType']) {
        $Config['LogType'] = "SimplePSLogger"
    }
    if (-Not $Config["BufferSize"]) {
        $Config["BufferSize"] = 20
    }

    $logMessage = "$((Get-Date).ToUniversalTime().ToString("yyyy/MM/ddHH:mm:ss:fffftt"))`t$Name`t$($Level)`t$($Message.Trim())"

    $bufferFileName = Join-Path $([system.io.path]::GetTempPath()) -ChildPath "$Name-az-loganalytics.log"
    
    if (-Not $(Test-Path -Path $bufferFileName)) {
        New-Item $bufferFileName -ItemType file
    }

    $currentBufferSize = Get-Content $bufferFileName | Measure-Object –Line
    $LogsToFlush = New-Object Collections.Generic.List[Object]

    if ($currentBufferSize.Lines -ge $Config["BufferSize"] -or $Flush) {
        # in case,  someone modify file and added line
        if (-Not $Flush) {
            Add-Content -Path $bufferFileName -Value $logMessage
        }

        $content = Get-Content -Path $bufferFileName

        foreach ($line in $content) {
            # Help : do we need to replace `t with 'space char'? What if message contains `t char?
            $log = $line.Split("`t")
            if ($log.Count -gt 4 -or $log.Count -lt 4) {
                Write-Information "Malformed log entry found. Logging entire content as log message"
                $lineItem = New-Object -TypeName psobject
                $lineItem | Add-Member -MemberType NoteProperty -Name Timestamp -Value $((Get-Date).ToUniversalTime().ToString("yyyy/MM/dd HH:mm:ss:ffff tt"))
                $lineItem | Add-Member -MemberType NoteProperty -Name LoggerName -Value $Name
                $lineItem | Add-Member -MemberType NoteProperty -Name Level -Value "information"
                $lineItem | Add-Member -MemberType NoteProperty -Name Message -Value $line
                $LogsToFlush.Add($lineItem)
            }
            else {
                $lineItem = New-Object -TypeName psobject
                $lineItem | Add-Member -MemberType NoteProperty -Name Timestamp -Value $log[0].Trim()
                $lineItem | Add-Member -MemberType NoteProperty -Name LoggerName -Value $log[1].Trim()
                $lineItem | Add-Member -MemberType NoteProperty -Name Level -Value $log[2].Trim()
                $lineItem | Add-Member -MemberType NoteProperty -Name Message -Value $log[3]
                $LogsToFlush.Add($lineItem)
            }
        }
        $payLoad = $LogsToFlush | ConvertTo-Json -Depth 20 -Compress -AsArray
        #Flush to LAWS
        try {
            Send-LogAnalyticsData -customerId $Config['WorkspaceId'] -sharedKey $Config['WorkspaceKey'] -body $payLoad -logType $Config['LogType']    
            Remove-Item -Path $bufferFileName -Force
        }
        catch {
            throw
        }
        finally {
            # TODO : retains logs and try agian
        }
    }
    else {
        Add-Content -Path $bufferFileName -Value $logMessage
    }
}

# TODO : is there any way to ignore other functions export?
Export-ModuleMember -Function New-AzLogAnalytics-Logger, Send-LogAnalyticsData, Build-Signature

