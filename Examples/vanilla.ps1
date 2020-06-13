Import-Module -Name "../SimplePSLogger/SimplePSLogger.psd1"


$MyLooger = New-SimplePSLogger -Name "vanilla-script"


$MyLooger.Log("warning", "warn")
$MyLooger.Log("skdufh", "unsupported level")
$MyLooger.Log("critical", "critical")
$MyLooger.Log("verbose", "verbose")
$MyLooger.Log("information", "information")
$MyLooger.Log("debug", "deubg")
$MyLooger.Log("error", "error")


$obj = @{
    "nest1" = "sfkuh"
}
$objectLog = @{
    "k1" = "dsfjlijoiefoiuowfwuoewf"
    "k2" = $obj
    "k3" = @{
        "k3.k1" = "''ef\ferthew\gkuhweg/qwrqw"
        "k3.k2" = @{
            "ewkfh" = "srkguhdg"
        }
    }
}

$MyLooger.Log($objectLog)

$MyLooger.Dispose()

