<#
    This example works with version 2.x
#>

begin { 
    Import-Module -Name "../SimplePSLogger/SimplePSLogger.psd1"
    New-SimplePSLogger -Name "example-1"
}
process {
    try {

        Write-SimpleLog "warn" "warning"
        #Write-SimpleLog "unsupported level" "unsupported" not supported in v2
        Write-SimpleLog "critical" "critical"
        Write-SimpleLog "verbose" "verbose"
        Write-SimpleLog "information" "information"
        Write-SimpleLog "debug" "debug"
        Write-SimpleLog "error" "error"

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

        Write-SimpleLog $objectLog
        Write-SimpleLog "Script executed successfully" "information"
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
