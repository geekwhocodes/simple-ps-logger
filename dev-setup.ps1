Write-Output "Adding SimplePSLogger path to PSModulePath"
#Check If Path is already there
$SimplePSLoggerPath = Get-Location
$CurrentPaths = $env:Psmodulepath.Split([IO.Path]::PathSeparator)
if ($CurrentPaths.Contains($SimplePSLoggerPath.Path.ToString())) {
    Write-Output "SimplePSLogger path is already present in PowerShell module path. Yay!"
    return
}

$SimplePSLoggerEnvPath = "$\env:PSModulePath += '$([IO.Path]::PathSeparator)$($SimplePSLoggerPath.Path)'"

$SimplePSLoggerPathcommandContent = "$([Environment]::NewLine)#Added by https://github.com/geekwhocodes/simple-ps-logger for local development $([Environment]::NewLine)"
$SimplePSLoggerPathcommandContent += $($SimplePSLoggerEnvPath.Replace('$\', '$'))

if (Test-Path $PROFILE.CurrentUserAllHosts) {
    Write-Output "User(for all hosts) powershell profile found, adding SimplePSLogger path.r`
    Read more about powershell profie here https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7"
}
else {
    Write-Output "User(for all hosts) powershell profile not found, creating powershell profile for current user(for all hosts).r`
    Read more about powershell profie here https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7"
    New-Item -Type File -Force $PROFILE.CurrentUserAllHosts
}

Add-Content $PROFILE.CurrentUserAllHosts $SimplePSLoggerPathcommandContent

Write-Output "Added SimplePSLogger path to PSModulePath for local development."