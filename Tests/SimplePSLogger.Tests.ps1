using Module SimplePSLogger
Get-Module SimplePSLogger | Remove-Module -Force
Import-Module -Name $pwd\SimplePSLogger\SimplePSLogger.psd1 -Force
Import-Module -Name $pwd\Tests\ExternalLoggingProvider\ExternalLoggingProvider.psm1

Describe "New-SimplePSLogger" {

    Context "When we create simple ps logger instance using New-SimplePSLogger, " {
        
              
    }   
}

Describe "SimplePSLogger Class" {
    Context "CreateLogger Static Method" {
        It "When we don't pass name, it should throw" {
            try {
                [SimplePSLogger]::CreateLogger($null, @())
            }
            catch {
                $PSItem.Exception | Should -Not -Be $null
                $PSItem.Exception.Message | Should -BeExactly "Cannot create logger without 'name'"
            }
        }

        It "Gives incorrect logging provider type, it throws PSInvalidCastException" {
            try {
                [SimplePSLogger]::CreateLogger("SPSL", @(@{}))
            }
            catch {
                $PSItem.Exception | Should -Not -Be $null
                $PSItem.FullyQualifiedErrorId | Should -BeExactly "MethodArgumentConversionInvalidCastArgument"
            }
        }

        It "When we give name, it should not be null" {
            $LoggerInstance = [SimplePSLogger]::CreateLogger("loggerName", @())
            $LoggerInstance | Should -Not -Be $null
        }

        It "gives name '<Name>', it returns '<Expected>'" -TestCases @(
            @{Name = 'MySPSL'; Expected = 'MySPSL' }
            @{Name = 'MyPowerShellLogger'; Expected = 'MyPowerShellLogger' }) 
        {
            param ($Name, $Expected)
            
            $LoggerInstance = [SimplePSLogger]::CreateLogger($Name)
            $LoggerInstance.Name | Should -Be $Expected
        }
    }
    Context "Internal memebers and methods" {
        It "Gives '<Name>', it returns '<Expected>'" -TestCases @(
            @{Name = "SPSL"; Expected = "SPSL" }
        ) {
            param($Name, $Expected)

            $LoggerInstance = [SimplePSLogger]::new($Name, @())
            $LoggerInstance.Name | Should -Be $Expected
        }

        It "Gives '<Providers> providers count', it returns '<Expected>' providers count" -TestCases @(
            @{Providers = @(); Expected = @() }
        ) {
            param($Providers, $Expected)

            $LoggerInstance = [SimplePSLogger]::new("SPSl", $Providers)
            $LoggerInstance.LoggingProviders.Count | Should -Be $($Expected.Length)
        }
    }
    Context "Custome Provider Registration" {
        It "When we don't pass provider name, it should throw" {
            try {
                $LoggerInstance = [SimplePSLogger]::CreateLogger("Test-Provider", @())
                $LoggerInstance.RegisterProvider($null, "Write-MockLog", @{})
            }
            catch {
                $PSItem.Exception | Should -Not -Be $null
                $PSItem.Exception.Message | Should -BeExactly "Provider name is required"
            }
        }

        It "When we don't pass provider function name, it should throw" {
            try {
                $LoggerInstance = [SimplePSLogger]::CreateLogger("Test-Provider", @())
                $LoggerInstance.RegisterProvider("AwesomeProvider", $null, @{})
            }
            catch {
                $PSItem.Exception | Should -Not -Be $null
                $PSItem.Exception.Message | Should -BeExactly "Provider function name is required"
            }
        }

        It "When we don't pass correct provider function name, it should throw" {
            try {
                $LoggerInstance = [SimplePSLogger]::CreateLogger("Test-Provider", @())
                $LoggerInstance.RegisterProvider("AwesomeProvider", "ABCD", @{})
            }
            catch {
                $PSItem.Exception | Should -Not -Be $null
                $PSItem.Exception.Message | Should -BeExactly "Provider module/function is recognized as name of cmdlet, please make sure that your provider is available"
            }
        }

        It "When we pass correct provider , it should not throw" {
            #Mock -ModuleName ExternalLoggingProvider AwesomeLoggingProvider { Write-Information "Log" -InformationAction Continue }
            try {
                $LoggerInstance = [SimplePSLogger]::CreateLogger("Test-Provider", @())
                $LoggerInstance.RegisterProvider("AwesomeProvider", "AwesomeLoggingProvider", @{})
            }
            catch {
                $PSItem.Exception | Should -Not -Be $null
                $PSItem.Exception.Message | Should -BeExactly "Provider module/function is recognized as name of cmdlet, please make sure that your provider is available"
            }
        }
        
    }
}


Describe "LoggingProvider Class: Create" {

    It "When we don't pass name, throws 'Logging provider name is required'" {
        try {
            $funcBlock = [scriptblock]::Create( { Write-Output "Hi.." })
            [LoggingProvider]::Create($null, $funcBlock , @{})
        }
        catch {
            $PSItem.Exception | Should -Not -Be $null
            $PSItem.Exception.Message | Should -BeExactly "Logging provider name is required"
        }
    }

    It "When we don't pass function block, throws 'Logging provider function is required'" {
        try {
            [LoggingProvider]::Create("Console", $null, @{})
        }
        catch {
            $PSItem.Exception | Should -Not -Be $null
            $PSItem.Exception.Message | Should -BeExactly "Logging provider function is required"
        }
    }

    It "When we provide incorrect function block, throws 'Logging provider's function should be ScriptBlock'" {
        try {
            [LoggingProvider]::Create("Console", @{}, @{})
        }
        catch {
            $PSItem.Exception | Should -Not -Be $null
            $PSItem.Exception.Message | Should -BeExactly "Logging provider's function should be ScriptBlock"
        }
    }

    It "Gives name '<Name>', it returns '<Expected>'" -TestCases @(
        @{Name = 'MySPSL'; Expected = 'MySPSL' }) 
    {
        param ($Name, $Expected)
        
        $funcBlock = [scriptblock]::Create( { Write-Output "Hi.." })
        $LoggingProviderInstance = [LoggingProvider]::Create($Name, $funcBlock, @{})
        $LoggingProviderInstance.Name | Should -Be $Expected
    }
    
}