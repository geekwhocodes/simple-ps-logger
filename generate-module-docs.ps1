Begin {
    Import-Module -Name ".\SimplePSLogger\SimplePSLogger.psd1" -Force
    Import-Module -Name ".\.build\third-party\platyPS\platyPS.psd1" -Force
    $ModuleName = "SimplePSLogger"
    $OutPath = "$pwd\website\docs\commands"
}
Process {
    if (Test-Path -Path $OutPath) {
        Write-Information "Module docs directory is already created"    
    }
    else {
        New-Item -Path $OutPath -ItemType Directory
        Write-Information "Create Module docs directory at $OutPath" -InformationAction Continue
    }
    try {
        New-MarkdownHelp -Module $ModuleName -OutputFolder $OutPath -Force    
    }
    catch {
        throw
    }
}