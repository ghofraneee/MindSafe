# MindSafe dev environment — UTF-8 console + Flutter SDK on PATH.
# Dot-source from your profile or project scripts: . "$PSScriptRoot\MindSafe.Env.ps1"

$ErrorActionPreference = 'Continue'

# UTF-8 input/output (fixes garbled paths like USER£ in PowerShell 5.1)
try {
    chcp 65001 | Out-Null
    [Console]::InputEncoding = [System.Text.UTF8Encoding]::new($false)
    [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
    $OutputEncoding = [System.Text.UTF8Encoding]::new($false)
} catch {
    # Non-fatal on hosts that restrict console encoding changes
}

# Prefer the working Flutter SDK (3.44+). Drop other flutter\bin entries first.
$flutterBin = 'C:\src\flutter\bin'
if (Test-Path (Join-Path $flutterBin 'flutter.bat')) {
    $pathParts = $env:PATH -split ';' | Where-Object {
        $_ -and ($_ -notmatch '(?i)\\flutter\\bin$')
    }
    $env:PATH = ($flutterBin + ';' + ($pathParts -join ';')).TrimEnd(';')
}

# Reliable analyze (flutter analyze can crash the LSP on some setups)
function Invoke-MindSafeAnalyze {
    param(
        [string[]]$Paths = @('lib', 'test')
    )
    Push-Location $PSScriptRoot\..
    try {
        dart analyze @Paths
    } finally {
        Pop-Location
    }
}

Set-Alias -Name mind-analyze -Value Invoke-MindSafeAnalyze -Scope Global -Force
