param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("task8","task9_master","task9_slave","task10","task11")]
    [string]$Task
)
$ErrorActionPreference = "Stop"
$repo = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$project = "C:\Users\young\Documents\ece2_474"
$map = @{
    task8       = "task8_spi_scope\ece2_474_routine.c"
    task9_master= "task9_mcu_to_mcu\master\ece2_474_routine.c"
    task9_slave = "task9_mcu_to_mcu\slave\ece2_474_routine.c"
    task10      = "task10_mcu_to_fpga\ece2_474_routine.c"
    task11      = "task11_fpga_to_mcu\ece2_474_routine.c"
}
$src = Join-Path (Join-Path $repo "stm32") $map[$Task]
$dst = Join-Path $project "Core\Src\ece2_474_routine.c"
$backup = Join-Path $project ("lab7_backup\" + (Get-Date -Format "yyyyMMdd-HHmmss") + "_before_" + $Task)
New-Item -ItemType Directory -Force -Path $backup | Out-Null
Copy-Item -LiteralPath $dst -Destination (Join-Path $backup "ece2_474_routine.c")
Copy-Item -LiteralPath $src -Destination $dst -Force
$ninja = "C:\Users\young\AppData\Local\stm32cube\bundles\ninja\1.13.2+st.1\bin\ninja.exe"
if (-not (Test-Path -LiteralPath $ninja)) { throw "STM32Cube Ninja not found: $ninja" }
& $ninja -C (Join-Path $project "build\Debug") -t clean
if ($LASTEXITCODE -ne 0) { throw "ARM clean failed: exit $LASTEXITCODE" }
& $ninja -C (Join-Path $project "build\Debug")
if ($LASTEXITCODE -ne 0) { throw "ARM build failed: exit $LASTEXITCODE" }
Write-Host "ACTIVE $Task; backup=$backup"

