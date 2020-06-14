Write-Warning "Adding SimplePSLogger path to PSModulePath"

$SimplePSLoggerPath = Join-Path -Path $(Get-Location) -ChildPath "SimplePSLogger"
$SimplePSLoggerEnvPath = "$\env:PSModulePath += ';$SimplePSLoggerPath'"

$SimplePSLoggerPathcommandContent = "`r#Added by https://github.com/geekwhocodes/simple-ps-logger for local development `r"
$SimplePSLoggerPathcommandContent += $($SimplePSLoggerEnvPath.Replace('$\', '$'))

if (Test-Path $PROFILE.CurrentUserAllHosts) {
    Write-Warning "User(for all hosts) powershell profile found, adding SimplePSLogger path.r`
    Read more about powershell profie here https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7"
}
else {
    Write-Warning "User(for all hosts) powershell profile not found, creating powershell profile for current user(for all hosts).r`
    Read more about powershell profie here https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7"
    New-Item -Type File -Force $PROFILE.CurrentUserAllHosts
}

Add-Content $PROFILE.CurrentUserAllHosts $SimplePSLoggerPathcommandContent


Write-Warning "Added SimplePSLogger path to PSModulePath for local development."