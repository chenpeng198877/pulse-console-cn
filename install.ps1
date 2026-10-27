# Pulse Console CN installer for Windows PowerShell 5.1+ / PowerShell 7.
$ErrorActionPreference = "Stop"
$RepoUrl = "https://github.com/chenpeng198877/pulse-console-cn.git"
$InstallDir = if ($env:PULSE_INSTALL_DIR) { $env:PULSE_INSTALL_DIR } else { Join-Path $HOME "pulse-console-cn" }
$Port = if ($env:PULSE_PORT) { $env:PULSE_PORT } else { "8787" }

Write-Host "== Pulse Console CN 一键部署（Windows PowerShell） ==" -ForegroundColor Cyan
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) { throw "未找到 Docker。请先安装并启动 Docker Desktop。" }
docker compose version
if ($LASTEXITCODE -ne 0) { throw "未检测到 Docker Compose v2，请更新 Docker Desktop。" }
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw "未找到 Git for Windows，请先安装 Git。" }

$Parent = Split-Path -Parent $InstallDir
New-Item -ItemType Directory -Force -Path $Parent | Out-Null
if (Test-Path (Join-Path $InstallDir ".git")) {
  Set-Location $InstallDir
  $Changes = git status --porcelain
  if ($LASTEXITCODE -ne 0) { throw "无法检查 Git 状态。" }
  if (-not $Changes) {
    git pull --ff-only
    if ($LASTEXITCODE -ne 0) { Write-Warning "拉取更新失败，将继续尝试使用本地代码。" }
  } else {
    Write-Warning "检测到本地修改，跳过 git pull 以免覆盖。"
  }
} elseif (Test-Path $InstallDir) {
  throw "安装目录已存在但不是 Git 仓库：$InstallDir。请备份后移走该目录，或设置 PULSE_INSTALL_DIR。"
} else {
  git clone $RepoUrl $InstallDir
  if ($LASTEXITCODE -ne 0) { throw "克隆失败，请检查网络和 GitHub 访问。" }
  Set-Location $InstallDir
}
Set-Location $InstallDir
if (-not (Test-Path "devices.example.json")) { throw "缺少 devices.example.json，项目文件可能不完整。" }

if (-not (Test-Path "devices.json")) {
  Copy-Item "devices.example.json" "devices.json"
}
$Config = Get-Content "devices.json" -Raw
if ($Config.Contains("CHANGE-ME-TO-A-LONG-RANDOM-SECRET")) {
  $Bytes = New-Object byte[] 32
  $Rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
  $Rng.GetBytes($Bytes)
  $Token = ([System.BitConverter]::ToString($Bytes)).Replace("-", "").ToLowerInvariant()
  $Rng.Dispose()
  $Config = $Config.Replace("CHANGE-ME-TO-A-LONG-RANDOM-SECRET", $Token)
  $Utf8NoBom = New-Object System.Text.UTF8Encoding -ArgumentList $false
  [System.IO.File]::WriteAllText((Join-Path (Get-Location) "devices.json"), $Config, $Utf8NoBom)
}

$env:PULSE_PORT = "$Port"
if (-not $env:TZ) { $env:TZ = "Asia/Shanghai" }
New-Item -ItemType Directory -Force -Path "data/apk-cache", "data/guardian-apks" | Out-Null
@("data/metrics.db","data/device_state.json","data/discovery_baseline.json","data/screensaver.json","data/heartbeat_checks.json") | ForEach-Object {
  if (-not (Test-Path $_)) { New-Item -ItemType File -Path $_ | Out-Null }
}

Write-Host "正在构建并启动服务……" -ForegroundColor Cyan
docker compose up -d --build
if ($LASTEXITCODE -ne 0) { throw "构建或启动失败。运行 docker compose logs --tail=100 查看日志。" }
docker compose ps
Write-Host ""
Write-Host "部署命令已执行。访问：http://<本机或服务器IP>:$Port"
Write-Host "安装目录：$InstallDir"
Write-Host "查看日志：docker compose logs --tail=100"
Write-Host "停止服务：docker compose down"
Write-Host "请勿将控制台端口或未受保护的 scrcpy 服务暴露到公网。" -ForegroundColor Yellow
