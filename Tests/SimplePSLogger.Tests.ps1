using Module SimplePSLogger
Get-Module SimplePSLogger | Remove-Module -Force
Import-Module -Name $pwd\SimplePSLogger\SimplePSLogger.psd1 -Force

Describe "New-SimplePSLogger" {

    Context "When we create simple ps logger instance using New-SimplePSLogger, " {
        
        It "should not be null" {
            $LoggerInstance = New-SimplePSLogger -Name $Name
            $LoggerInstance | Should -Not -Be $null
        }

        It "creates logger with auto generated name" {
            $LoggerInstance = New-SimplePSLogger -ErrorAction Continue
            $LoggerInstance | Should -Not -Be $null
            $LoggerInstance.Name | Should -Not -Be $null
        }

        It "gives name '<Name>', it returns '<Expected>'" -TestCases @(
            @{Name = 'MySPSL'; Expected = 'MySPSL' }
            @{Name = 'MyPowerShellLogger'; Expected = 'MyPowerShellLogger' }) 
        {
            param ($Name, $Expected)
            
            $LoggerInstance = New-SimplePSLogger -Name $Name
            $LoggerInstance.Name | Should -Be $Expected
        }

        It "returns SimplePSLogger type" {
            $LoggerInstance = New-SimplePSLogger -Name "MyLogger"
            $LoggerInstance.GetType() | Should -Be "SimplePSLogger"
        }

        It "has DefaultLogLevel 'information'" {
            $LoggerInstance = New-SimplePSLogger -Name "MyLogger"
            $LoggerInstance.DefaultLogLevel | Should -Be "information"
        }

        It "should have supported loglevels" {
            $LoggerInstance = New-SimplePSLogger -Name "MyLogger"
            [hashtable]$LogLevels = @{"verbose" = 0; "debug" = 1; "information" = 2; "warning" = 3; "error" = 4; "critical" = 5; "none" = 6 }
            $LoggerInstance.Loglevels | Should -BeLikeExactly $LogLevels
        }
        
        It "should have at-least one logging provider registered" {
            $LoggerInstance = New-SimplePSLogger -Name "MyLogger"
            $LoggerInstance.LoggingProviders.Count | Should -BeGreaterThan 0
        }        
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