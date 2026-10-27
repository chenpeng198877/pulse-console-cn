#!/bin/sh
set -eu

REPO_URL="https://github.com/chenpeng198877/pulse-console-cn.git"
INSTALL_DIR="${PULSE_INSTALL_DIR:-/mnt/nvme0n1-4/docker/pulse-console-cn}"
PORT="${PULSE_PORT:-8787}"

echo "== Pulse Console 中文版：iStoreOS 一键部署 =="

if ! command -v docker >/dev/null 2>&1; then
  echo "错误：未检测到 Docker，请先在 iStoreOS 安装并启动 Docker。"
  exit 1
fi
if ! docker compose version >/dev/null 2>&1; then
  echo "错误：未检测到 docker compose 插件。请先安装 Docker Compose。"
  exit 1
fi

mkdir -p "$(dirname "$INSTALL_DIR")"
if [ -d "$INSTALL_DIR/.git" ]; then
  echo "发现已有项目目录：$INSTALL_DIR"
  cd "$INSTALL_DIR"
  if ! git diff --quiet 2>/dev/null; then
    echo "提示：检测到本地修改，跳过自动 git pull，以免覆盖修改。"
  else
    git pull --ff-only || echo "提示：拉取更新失败，将继续使用本地文件。"
  fi
elif [ -e "$INSTALL_DIR" ]; then
  echo "错误：$INSTALL_DIR 已存在但不是 Git 仓库。为避免覆盖文件，停止部署。"
  exit 1
else
  if ! command -v git >/dev/null 2>&1; then
    echo "错误：未检测到 git，请先安装 git。"
    exit 1
  fi
  git clone "$REPO_URL" "$INSTALL_DIR"
  cd "$INSTALL_DIR"
fi

if [ ! -f devices.json ]; then
  cp devices.example.json devices.json
fi

# 仅替换示例 Token；已有自定义 Token 不会被覆盖。
if grep -q 'CHANGE-ME-TO-A-LONG-RANDOM-SECRET' devices.json; then
  if command -v openssl >/dev/null 2>&1; then
    TOKEN="$(openssl rand -hex 32)"
  else
    TOKEN="$(od -An -N32 -tx1 /dev/urandom | tr -d ' \n')"
  fi
  sed "s/CHANGE-ME-TO-A-LONG-RANDOM-SECRET/$TOKEN/g" devices.json > devices.json.tmp
  mv devices.json.tmp devices.json
fi

# 将端口写入本次 Compose 环境，不修改项目文件。
export PULSE_PORT="$PORT"
export TZ="${TZ:-Asia/Shanghai}"

mkdir -p data/apk-cache data/guardian-apks
touch data/metrics.db data/device_state.json data/discovery_baseline.json data/screensaver.json data/heartbeat_checks.json

echo "正在构建并启动容器……"
docker compose up -d --build

echo
docker compose ps
echo
echo "部署命令已执行。请在浏览器打开： http://<iStoreOS局域网IP>:$PORT"
echo "配置文件：$INSTALL_DIR/devices.json"
echo "数据目录：$INSTALL_DIR/data"
echo
echo "当前配置 Token（请妥善保管，不要发给他人）："
sed -n 's/.*"token"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' devices.json
echo
echo "查看日志：cd '$INSTALL_DIR' && docker compose logs --tail=100"
echo "注意：容器启动不等于手机已连接；无线 ADB 需在设备配置中设置可达的地址/端口。USB 直连需要额外配置设备映射。"
