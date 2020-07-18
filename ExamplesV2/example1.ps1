
begin { 
    Import-Module -Name "../SimplePSLogger/SimplePSLogger.psd1"
    New-SimplePSLogger -Name "example-1"
}
process {
    try {

        Write-Log "warn" "warning"
        #Write-Log "unsupported level" "unsupported" not supported in v2
        Write-Log "critical" "critical"
        Write-Log "verbose" "verbose"
        Write-Log "information" "information"
        Write-Log "debug" "debug"
        Write-Log "error" "error"

        $objectLog = @{
            "k1" = "dsfjlijoiefoiuowfwuoewf"
            "k2" = "sekfejo09dj9"
            "k3" = @{
                "k3.k1" = "''ef\ferthew\gkuhweg/qwrqw"
                "k3.k2" = @{
                    "ewkfh" = "srkguh"
                }
            }
        }

        Write-Log $objectLog
        Write-Log "Script executed successfully" "information"
    }
    catch {
        Clear-Buffer -All
        Remove-SimplePSLogger -All
        throw
    }
}
end { 
    Clear-Buffer -All
    Remove-SimplePSLogger -All
}
