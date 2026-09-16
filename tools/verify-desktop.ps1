param(
    [string]$PublishDir = (Join-Path $PSScriptRoot '..\work\desktop-publish')
)

$ErrorActionPreference = 'Stop'
$PublishDir = [System.IO.Path]::GetFullPath($PublishDir)
$exe = Join-Path $PublishDir 'TotalFreeConvert.exe'
$index = Join-Path $PublishDir 'wwwroot\index.html'

if (-not (Test-Path -LiteralPath $exe -PathType Leaf)) {
    throw "Desktop executable not found: $exe"
}
if (-not (Test-Path -LiteralPath $index -PathType Leaf)) {
    throw "Bundled website not found: $index"
}

Write-Host "Running desktop smoke test..."
$process = Start-Process -FilePath $exe -ArgumentList '--smoke-test' -Wait -PassThru
if ($process.ExitCode -ne 0) {
    throw "Desktop smoke test failed with exit code $($process.ExitCode)."
}

Write-Host "Desktop smoke test passed."
