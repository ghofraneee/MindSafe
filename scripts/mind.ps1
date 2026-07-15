# MindSafe dev helper — run from project root:
#   .\scripts\mind.ps1 doctor
#   .\scripts\mind.ps1 analyze
#   .\scripts\mind.ps1 run chrome
#   .\scripts\mind.ps1 build web

param(
    [Parameter(Position = 0)]
    [ValidateSet('doctor', 'analyze', 'test', 'pub-get', 'build-runner', 'run', 'build', 'clean', 'help')]
    [string]$Command = 'help',

    [Parameter(Position = 1, ValueFromRemainingArguments = $true)]
    [string[]]$Args
)

$ErrorActionPreference = 'Stop'
. "$PSScriptRoot\MindSafe.Env.ps1"

$projectRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
Push-Location $projectRoot
try {
    switch ($Command) {
        'doctor' { flutter doctor -v }
        'analyze' { dart analyze lib test }
        'test' { flutter test @Args }
        'pub-get' { flutter pub get }
        'build-runner' {
            dart run build_runner build --delete-conflicting-outputs @Args
        }
        'run' {
            if ($Args.Count -eq 0) { $Args = @('chrome') }
            flutter run @Args
        }
        'build' {
            if ($Args.Count -eq 0) { $Args = @('web') }
            flutter build @Args
        }
        'clean' { flutter clean }
        default {
            Write-Host @'
MindSafe dev commands (.\scripts\mind.ps1 <command>):

  doctor        flutter doctor -v
  analyze       dart analyze lib test
  test          flutter test
  pub-get       flutter pub get
  build-runner  regenerate Freezed / JSON
  run [device]  flutter run (default: chrome)
  build [target] flutter build (default: web)
  clean         flutter clean
'@
        }
    }
} finally {
    Pop-Location
}
