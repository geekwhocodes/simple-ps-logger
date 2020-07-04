
$TempArchiveDir = Join-Path $([system.io.path]::GetTempPath()) -ChildPath "SimplePSLoggerArchive"

if ($(Test-Path -Path $TempArchiveDir)) {
    Remove-Item -Path $TempArchiveDir -Recurse -Force
}

Start-Sleep -Seconds 1

if (-Not $TempArchiveDir -or $null -eq $TempArchiveDir) {
    throw "Error while creating temp achive dir"
}

Write-Information "Creating stagged archive at $TempArchiveDir" -InformationAction Continue
Copy-Item -Path "$pwd\SimplePSLogger" -Destination $TempArchiveDir -Recurse -Force
Write-Information "Creating stagged archive at $TempArchiveDir" -InformationAction Continue

$FilesToWrite = Get-ChildItem -Path $TempArchiveDir -Recurse -ErrorAction Stop | Where-Object { $_.Extension -in ".psd1", ".psm1", ".ps1" } | Select-Object -ExpandProperty FullName

#Remove existing signature
$FilesToWrite | ForEach-Object {
    Try {
        $Content = Get-Content -Path $_ -ErrorAction Stop
        Remove-Item -Path $_ -Force
        Start-Sleep -Seconds 1
        New-Item -Path $_ -ItemType File
        $StringBuilder = New-Object -TypeName System.Text.StringBuilder -ErrorAction Stop
        
        foreach ($Line in $Content) {
            if ($Line -match '^# SIG # Begin signature block|^<!-- SIG # Begin signature block -->') {
                Break
            }
            else {
                $null = $StringBuilder.AppendLine($Line)
            }
        }
        Set-Content -Path $_ -Value $StringBuilder.ToString().TrimEnd()
    }
    Catch {
        Write-Error -Message $_.Exception.Message
    }
}

return $TempArchiveDir
