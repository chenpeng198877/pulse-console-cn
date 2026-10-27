# Pulse Console CN 跨平台管理工具（Windows PowerShell 5.1+ / PowerShell 7）
$ErrorActionPreference = "Stop"
$RepoUrl = "https://github.com/chenpeng198877/pulse-console-cn.git"
$AppDir = if ($env:PULSE_INSTALL_DIR) { $env:PULSE_INSTALL_DIR } else { Join-Path $HOME "pulse-console-cn" }
$Port = if ($env:PULSE_PORT) { $env:PULSE_PORT } else { "8787" }

function Pause-Menu { Read-Host "按回车返回菜单" | Out-Null }
function Confirm-Action([string]$Message) {
  $answer = Read-Host "$Message [y/N]"
  return $answer -eq "y" -or $answer -eq "Y"
}
function Test-Project { return (Test-Path (Join-Path $AppDir ".git")) -and (Test-Path (Join-Path $AppDir "docker-compose.yml")) }
function Test-Docker {
  if (-not (Get-Command docker -ErrorAction SilentlyContinue)) { throw "未安装 Docker。请先安装 Docker Desktop 或 Linux Docker Engine。" }
  docker compose version *> $null
  if ($LASTEXITCODE -ne 0) { throw "需要 Docker Compose v2。请更新 Docker Desktop 或安装 Compose 插件。" }
  docker info *> $null
  if ($LASTEXITCODE -ne 0) { throw "Docker 服务未运行。请启动 Docker Desktop / Docker Engine 后重试。" }
}
function Backup-Data {
  if (-not (Test-Path $AppDir)) { return }
  $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
  $dest = Join-Path $AppDir "backups/$stamp"
  New-Item -ItemType Directory -Force -Path $dest | Out-Null
  foreach ($name in @("devices.json", ".env")) {
    $src = Join-Path $AppDir $name
    if (Test-Path $src) { Copy-Item $src $dest -Force }
  }
  $data = Join-Path $AppDir "data"
  if (Test-Path $data) { Copy-Item $data $dest -Recurse -Force }
  Write-Host "备份完成：$dest" -ForegroundColor Green
}
function Ensure-Project {
  if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw "未安装 Git。请先安装 Git for Windows。" }
  if (Test-Project) { return }
  if (Test-Path $AppDir) { throw "目录已存在但不是本项目：$AppDir。请备份后移走，或设置 PULSE_INSTALL_DIR。" }
  New-Item -ItemType Directory -Force -Path (Split-Path $AppDir -Parent) | Out-Null
  git clone $RepoUrl $AppDir
  if ($LASTEXITCODE -ne 0) { throw "下载失败，请检查网络/GitHub 访问。" }
}
function Prepare-Config {
  Set-Location $AppDir
  if (-not (Test-Path "devices.example.json")) { throw "缺少 devices.example.json，项目文件不完整。" }
  if (-not (Test-Path "devices.json")) { Copy-Item "devices.example.json" "devices.json" }
  $cfg = Get-Content "devices.json" -Raw
  if ($cfg.Contains("CHANGE-ME-TO-A-LONG-RANDOM-SECRET")) {
    $token = -join ((1..64) | ForEach-Object { "0123456789abcdef"[(Get-Random -Maximum 16)] })
    $cfg.Replace("CHANGE-ME-TO-A-LONG-RANDOM-SECRET", $token) | Set-Content "devices.json" -Encoding utf8
  }
  foreach ($d in @("data/apk-cache", "data/guardian-apks")) { New-Item -ItemType Directory -Force -Path $d | Out-Null }
  foreach ($f in @("data/metrics.db", "data/device_state.json", "data/discovery_baseline.json", "data/screensaver.json", "data/heartbeat_checks.json")) {
    if (-not (Test-Path $f)) { New-Item -ItemType File -Force -Path $f | Out-Null }
  }
}
function Deploy {
  Test-Docker
  Ensure-Project
  Set-Location $AppDir
  $dirty = git status --porcelain
  if ($LASTEXITCODE -ne 0) { throw "无法读取 Git 状态。" }
  if ($dirty) { throw "检测到本地文件修改，为避免覆盖已停止。请先备份并处理修改。" }
  Write-Host "正在检查 GitHub 更新……"
  git fetch origin
  if ($LASTEXITCODE -ne 0) { throw "连接 GitHub 失败，未执行更新。" }
  git merge --ff-only '@{u}'
  if ($LASTEXITCODE -ne 0) { throw "无法快进更新，请运行 git status -sb 检查。" }
  Prepare-Config
  Backup-Data
  $env:PULSE_PORT = $Port
  if (-not $env:TZ) { $env:TZ = "Asia/Shanghai" }
  Write-Host "正在构建并启动，请等待 Docker 完成……"
  docker compose up -d --build
  if ($LASTEXITCODE -ne 0) { throw "构建或启动失败；请使用菜单查看日志。" }
  docker compose ps
  Write-Host "安装/更新完成。访问：http://127.0.0.1:$Port" -ForegroundColor Green
}
function Show-Status {
  Test-Docker
  if (-not (Test-Project)) { Write-Host "尚未安装：$AppDir"; return }
  Set-Location $AppDir
  Write-Host "--- 容器状态 ---"
  docker compose ps
  Write-Host "--- 最近日志 ---"
  docker compose logs --tail=40
  Write-Host "访问地址：http://127.0.0.1:$Port"
}
function Show-Logs {
  Test-Docker
  if (-not (Test-Project)) { throw "尚未安装：$AppDir" }
  Set-Location $AppDir
  Write-Host "实时日志；按 Ctrl+C 返回菜单"
  docker compose logs -f --tail=100
}
function Service-Action([string]$Action) {
  Test-Docker
  if (-not (Test-Project)) { throw "尚未安装：$AppDir" }
  Set-Location $AppDir
  if ($Action -eq "start") { docker compose up -d }
  elseif ($Action -eq "stop") { docker compose down }
  elseif ($Action -eq "restart") { docker compose restart }
}
function Uninstall-Service {
  Test-Docker
  if (-not (Test-Project)) { Write-Host "尚未安装：$AppDir"; return }
  if (-not (Confirm-Action "停止并卸载服务（保留配置和数据）？")) { return }
  Set-Location $AppDir
  Backup-Data
  docker compose down
  Write-Host "服务已停止并卸载；文件保留在 $AppDir" -ForegroundColor Green
}
function Remove-All {
  Test-Docker
  if (-not (Test-Project)) { Write-Host "尚未安装：$AppDir"; return }
  Write-Host "将删除容器及整个项目目录，包括配置、设备数据和备份。" -ForegroundColor Yellow
  if (-not (Confirm-Action "确定永久删除 $AppDir？")) { return }
  Set-Location $AppDir
  docker compose down
  Set-Location $HOME
  Remove-Item -LiteralPath $AppDir -Recurse -Force
  Write-Host "项目目录已删除。" -ForegroundColor Green
}
while ($true) {
  Clear-Host
  Write-Host "===================================="
  Write-Host "     Pulse Console CN 管理工具"
  Write-Host "===================================="
  Write-Host "系统：Windows PowerShell | 目录：$AppDir | 端口：$Port"
  Write-Host ""
  Write-Host "1) 安装 / 更新并启动"
  Write-Host "2) 查看状态和日志"
  Write-Host "3) 查看实时日志"
  Write-Host "4) 启动服务"
  Write-Host "5) 停止服务"
  Write-Host "6) 重启服务"
  Write-Host "7) 备份配置和数据"
  Write-Host "8) 卸载服务（保留数据）"
  Write-Host "9) 完全删除项目（危险）"
  Write-Host "0) 退出"
  $choice = Read-Host "请选择 [0-9]"
  try {
    switch ($choice) {
      "1" { Deploy }
      "2" { Show-Status }
      "3" { Show-Logs }
      "4" { Service-Action "start" }
      "5" { Service-Action "stop" }
      "6" { Service-Action "restart" }
      "7" { if (Test-Project) { Backup-Data } else { Write-Host "尚未安装项目。" } }
      "8" { Uninstall-Service }
      "9" { Remove-All }
      "0" { return }
      default { Write-Host "请输入菜单中的数字。" -ForegroundColor Yellow }
    }
  } catch {
    Write-Host "操作失败：$($_.Exception.Message)" -ForegroundColor Red
  }
  Pause-Menu
}
