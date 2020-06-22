Import-Module -Name "../SimplePSLogger/SimplePSLogger.psd1"


$MyLogger = New-SimplePSLogger -Name "vanilla-script"


$MyLogger.Log("warning", "warn")
$MyLogger.Log("skdufh", "unsupported level")
$MyLogger.Log("critical", "critical")
$MyLogger.Log("verbose", "verbose")
$MyLogger.Log("information", "information")
$MyLogger.Log("debug", "deubg")
$MyLogger.Log("error", "error")


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
    "k5" = "dsfjlijoiefoiuowfwuoewf"
    "kg" = $obj
    "kh" = @{
        "k3.k1" = "''ef\ferthew\gkuhweg/qwrqw"
        "k3.k2" = @{
            "ewkfh" = "srkguhdg"
        }
    }
    "df" = "dsfjlijoiefoiuowfwuoewf"
    "j2" = $obj
    "l3" = @{
        "k3.k1" = "''ef\ferthew\gkuhweg/qwrqw"
        "k3.k2" = @{
            "ewkfh" = "srkguhdg"
        }
        "kh"    = @{
            "k3.k1" = "''ef\ferthew\gkuhweg/qwrqw"
            "k3.k2" = @{
                "ewkfh" = "srkguhdg"
            }
        }
    }
}

$MyLogger.Log($objectLog)

$MyLogger.Dispose()

