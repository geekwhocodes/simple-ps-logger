
begin { 
    Import-Module -Name "../SimplePSLogger/SimplePSLogger.psd1"
    $MyLooger = New-SimplePSLogger -Name "example-1"
}
process {
    try {

        $MyLooger.Log("warning", "warn")
        $MyLooger.Log("unsupported", "unsupported level")
        $MyLooger.Log("critical", "critical")
        $MyLooger.Log("verbose", "verbose")
        $MyLooger.Log("information", "information")
        $MyLooger.Log("debug", "deubg")
        $MyLooger.Log("error", "error")

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

        $MyLooger.Log($objectLog)
        $MyLooger.Log("information", "Script executed successfully")
    }
    catch {
        $MyLooger.Dispose()
        throw
    }
}
end { $MyLooger.Dispose() }
