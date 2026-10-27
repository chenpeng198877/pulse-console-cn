#!/bin/sh
# Pulse Console CN installer for Linux, macOS and WSL.
set -eu
REPO_URL="https://github.com/chenpeng198877/pulse-console-cn.git"
if [ -n "${PULSE_INSTALL_DIR:-}" ]; then
  INSTALL_DIR="$PULSE_INSTALL_DIR"
elif [ "$(uname -s 2>/dev/null || echo unknown)" = "Darwin" ]; then
  INSTALL_DIR="$HOME/pulse-console-cn"
else
  INSTALL_DIR="${HOME:-/root}/pulse-console-cn"
fi
PORT="${PULSE_PORT:-8787}"
fail() { echo "错误：$*" >&2; exit 1; }

echo "== Pulse Console CN 一键部署（Linux / macOS / WSL） =="
command -v docker >/dev/null 2>&1 || fail "未找到 Docker。请先安装并启动 Docker Engine 或 Docker Desktop。"
docker compose version >/dev/null 2>&1 || fail "未找到 Docker Compose v2（docker compose）。请先安装 Compose 插件。"
command -v git >/dev/null 2>&1 || fail "未找到 Git。请先安装 Git。"

mkdir -p "$(dirname "$INSTALL_DIR")"
if [ -d "$INSTALL_DIR/.git" ]; then
  echo "发现已有 Git 项目：$INSTALL_DIR"
  cd "$INSTALL_DIR"
  if git diff --quiet && git diff --cached --quiet; then
    git pull --ff-only || echo "警告：更新失败，继续尝试使用现有代码。"
  else
    echo "检测到本地代码修改，为避免覆盖，跳过 git pull。"
  fi
elif [ -e "$INSTALL_DIR" ]; then
  fail "目录已存在但不是 Git 仓库：$INSTALL_DIR。请备份后移走该目录，或设置 PULSE_INSTALL_DIR。"
else
  git clone "$REPO_URL" "$INSTALL_DIR" || fail "克隆失败，请检查网络和 GitHub 访问。"
  cd "$INSTALL_DIR"
fi

[ -f devices.example.json ] || fail "缺少 devices.example.json，项目文件可能不完整。"
if [ ! -f devices.json ]; then cp devices.example.json devices.json; fi
if grep -q 'CHANGE-ME-TO-A-LONG-RANDOM-SECRET' devices.json; then
  if command -v openssl >/dev/null 2>&1; then TOKEN="$(openssl rand -hex 32)"
  else TOKEN="$(od -An -N32 -tx1 /dev/urandom | tr -d ' \n')"; fi
  sed "s/CHANGE-ME-TO-A-LONG-RANDOM-SECRET/$TOKEN/g" devices.json > devices.json.tmp
  mv devices.json.tmp devices.json
fi

export PULSE_PORT="$PORT"
export TZ="${TZ:-Asia/Shanghai}"
mkdir -p data/apk-cache data/guardian-apks
touch data/metrics.db data/device_state.json data/discovery_baseline.json data/screensaver.json data/heartbeat_checks.json

echo "正在构建并启动服务……"
docker compose up -d --build
echo
docker compose ps
echo
echo "已提交启动命令。访问地址：http://<本机或服务器IP>:$PORT"
echo "安装目录：$INSTALL_DIR"
echo "配置文件：$INSTALL_DIR/devices.json"
echo "查看日志：cd '$INSTALL_DIR' && docker compose logs --tail=100"
echo "停止服务：cd '$INSTALL_DIR' && docker compose down"
echo "Windows 原生 PowerShell 请使用 install.ps1。"
echo "请勿将控制台端口或未受保护的 scrcpy 服务暴露到公网。"
