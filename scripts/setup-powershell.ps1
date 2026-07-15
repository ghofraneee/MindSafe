# One-time setup: UTF-8 console + Flutter PATH in your PowerShell profile.
# Run: powershell -ExecutionPolicy Bypass -File .\scripts\setup-powershell.ps1

$ErrorActionPreference = 'Stop'

$profilePath = $PROFILE
$profileDir = Split-Path $profilePath -Parent
$envScript = Join-Path $PSScriptRoot 'MindSafe.Env.ps1'
$markerStart = '# >>> MindSafe dev env >>>'
$markerEnd = '# <<< MindSafe dev env <<<'

if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

$block = @"
$markerStart
if (Test-Path '$envScript') {
    . '$envScript'
}
$markerEnd
"@

$existing = ''
if (Test-Path $profilePath) {
    $existing = Get-Content -Path $profilePath -Raw -ErrorAction SilentlyContinue
    if ($null -eq $existing) { $existing = '' }
}

if ($existing -match [regex]::Escape($markerStart)) {
    $pattern = "(?s)$([regex]::Escape($markerStart)).*?$([regex]::Escape($markerEnd))"
    $updated = [regex]::Replace($existing, $pattern, $block.TrimEnd())
} else {
    $updated = if ($existing.Trim().Length -gt 0) { "$existing`r`n`r`n$block" } else { $block }
}

Set-Content -Path $profilePath -Value $updated.TrimEnd() -Encoding UTF8

Write-Host 'PowerShell profile updated:' -ForegroundColor Green
Write-Host "  $profilePath"
Write-Host ''
Write-Host 'Applied:' -ForegroundColor Cyan
Write-Host '  - UTF-8 console encoding'
Write-Host '  - Flutter SDK: C:\src\flutter\bin (preferred)'
Write-Host '  - mind-analyze alias (dart analyze lib test)'
Write-Host ''
Write-Host 'Restart the terminal (or run: . $PROFILE) for changes to take effect.' -ForegroundColor Yellow
