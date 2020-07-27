# PSScriptAnalyzerSettings.psd1
@{
    Severity     = @('Error', 'Warning')
    ExcludeRules = @('PSAvoidTrailingWhitespace',
        'PSUseShouldProcessForStateChangingFunctions')
}