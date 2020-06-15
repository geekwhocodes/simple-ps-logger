#
# Module manifest for module 'SimplePSLogger.psm1'
# Generated by: Ganesh Raskar
# Generated on: 11-June-2020
#

@{
    # Script module or binary module file associated with this manifest.
    RootModule        = 'SimplePSLogger.psm1'
    
    # Version of the module. Use this to track when the module was updated.

    ModuleVersion     = '0.0.5'
    
    # ID used to uniquely identify this module''
    GUID              = '4d2e4e26-9ca9-4691-9045-0797a5afa249'

    Author            = 'Ganesh Raskar'
    Copyright         = '2019 Ganesh Raskar. All rights reserved.'
    Description       = 'Simple logging module for PowerShell, It is build for simplicity and usability.'
    PowerShellVersion = '5.1.1'

    FunctionsToExport = @(
        'New-SimplePSLogger'
    )
    RequiredModules   = @(
    )

    NestedModules     = @(
        'SimplePSLogger.Console\SimplePSLogger.Console.psm1',
        'SimplePSLogger.File\SimplePSLogger.File.psm1'
    )
		
    PrivateData       = @{
        PSData = @{
            Prerelease = 'alpha'
            Tags       = @('powershell', 'pscore', 'logger', 'logging', 'log', 'audit', 'governance', 'file logger', 'file', 'azure', 'linux', 'ubuntu', 'debian')
            LicenseUri = 'https://github.com/geekwhocodes/simple-ps-logger/blob/master/LICENSE'
            ProjectUri = 'https://github.com/geekwhocodes/simple-ps-logger'            
        }
    }
    
    HelpInfoURI       = 'https://github.com/geekwhocodes/simple-ps-logger/blob/master/readme.md'

    

    # HelpInfo URI of this module
    # HelpInfoURI = ''
}
