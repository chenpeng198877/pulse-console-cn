#!/usr/bin/env bash
# Pulse Console CN cross-platform manager for macOS/Linux/WSL
set -Eeuo pipefail
REPO_URL="https://github.com/chenpeng198877/pulse-console-cn.git"
APP_DIR="${PULSE_INSTALL_DIR:-$HOME/pulse-console-cn}"
PORT="${PULSE_PORT:-8787}"
green(){ printf '\033[32m%s\033[0m\n' "$*"; }
yellow(){ printf '\033[33m%s\033[0m\n' "$*"; }
red(){ printf '\033[31m%s\033[0m\n' "$*" >&2; }
pause(){ printf '\n按回车返回菜单...'; read -r _ || true; }
confirm(){ local a; printf '%s [y/N]: ' "$1"; read -r a || true; [[ "${a:-}" == y || "${a:-}" == Y ]]; }
is_project(){ [[ -d "$APP_DIR/.git" && -f "$APP_DIR/docker-compose.yml" ]]; }
check_docker(){
  command -v docker >/dev/null 2>&1 || { red "未安装 Docker。请先安装 Docker Desktop（macOS/Windows）或 Docker Engine（Linux）。"; return 1; }
  docker compose version >/dev/null 2>&1 || { red "需要 Docker Compose v2：请更新 Docker Desktop 或安装 Compose 插件。"; return 1; }
  docker info >/dev/null 2>&1 || { red "Docker 服务未运行。请启动 Docker Desktop / Docker Engine 后重试。"; return 1; }
}
backup_data(){
  [[ -d "$APP_DIR" ]] || return 0
  local stamp dest
  stamp="$(date '+%Y%m%d-%H%M%S')"; dest="$APP_DIR/backups/$stamp"; mkdir -p "$dest"
  for f in devices.json .env; do [[ ! -f "$APP_DIR/$f" ]] || cp -p "$APP_DIR/$f" "$dest/"; done
  [[ ! -d "$APP_DIR/data" ]] || cp -R "$APP_DIR/data" "$dest/"
  green "备份完成：$dest"
}
ensure_project(){
  command -v git >/dev/null 2>&1 || { red "未安装 Git。请先安装 Git。"; return 1; }
  if is_project; then return 0; fi
  if [[ -e "$APP_DIR" ]]; then red "目录已存在但不是本项目：$APP_DIR"; return 1; fi
  mkdir -p "$(dirname "$APP_DIR")"
  git clone "$REPO_URL" "$APP_DIR" || { red "下载失败，请检查网络/GitHub 访问。"; return 1; }
}
prepare_config(){
  cd "$APP_DIR"
  [[ -f devices.example.json ]] || { red "缺少 devices.example.json，项目文件不完整。"; return 1; }
  [[ -f devices.json ]] || cp devices.example.json devices.json
  if grep -q 'CHANGE-ME-TO-A-LONG-RANDOM-SECRET' devices.json; then
    local token
    if command -v openssl >/dev/null 2>&1; then token="$(openssl rand -hex 32)"
    else token="$(od -An -N32 -tx1 /dev/urandom | tr -d ' \n')"; fi
    sed "s/CHANGE-ME-TO-A-LONG-RANDOM-SECRET/$token/g" devices.json > devices.json.tmp
    mv devices.json.tmp devices.json
  fi
  mkdir -p data/apk-cache data/guardian-apks
  touch data/metrics.db data/device_state.json data/discovery_baseline.json data/screensaver.json data/heartbeat_checks.json
}
deploy(){
  check_docker || return 1
  ensure_project || return 1
  cd "$APP_DIR"
  if [[ -d .git ]]; then
    if ! git diff --quiet || ! git diff --cached --quiet; then
      red "检测到本地代码修改，为避免覆盖已停止。请先备份并处理修改。"; return 1
    fi
    printf '正在检查远程更新……\n'
    git fetch origin || { red "连接 GitHub 失败，未执行更新。"; return 1; }
    git merge --ff-only '@{u}' || { red "无法快进更新，请检查 git status -sb。"; return 1; }
  fi
  prepare_config || return 1
  backup_data
  export PULSE_PORT="$PORT" TZ="${TZ:-Asia/Shanghai}"
  printf '正在构建并启动，请等待 Docker 完成……\n'
  docker compose up -d --build
  docker compose ps
  green "安装/更新完成。访问：http://127.0.0.1:$PORT"
}
status(){
  check_docker || return 1
  is_project || { yellow "尚未安装：$APP_DIR"; return 0; }
  cd "$APP_DIR"; printf '\n--- 容器状态 ---\n'; docker compose ps
  printf '\n--- 最近日志 ---\n'; docker compose logs --tail=40 || true
  printf '\n访问地址：http://127.0.0.1:$PORT\n'
}
logs(){ check_docker || return 1; is_project || { yellow "尚未安装：$APP_DIR"; return 1; }; cd "$APP_DIR"; echo "实时日志；按 Ctrl+C 返回菜单"; docker compose logs -f --tail=100; }
service_action(){ check_docker || return 1; is_project || { yellow "尚未安装：$APP_DIR"; return 1; }; cd "$APP_DIR"; docker compose "$1"; }
uninstall(){
  check_docker || return 1; is_project || { yellow "尚未安装：$APP_DIR"; return 1; }
  confirm "停止并卸载服务（保留配置和数据）？" || return 0
  cd "$APP_DIR"; backup_data; docker compose down; green "服务已停止并卸载；文件保留在 $APP_DIR"
}
remove_all(){
  check_docker || return 1; is_project || { yellow "尚未安装：$APP_DIR"; return 1; }
  yellow "将删除容器及整个项目目录，包括配置、设备数据和备份。"
  confirm "确定永久删除 $APP_DIR？" || return 0
  cd "$APP_DIR"; docker compose down; cd "$HOME"; rm -rf -- "$APP_DIR"; green "项目目录已删除。"
}
while true; do
  printf '\n====================================\nPulse Console CN 跨平台管理工具\n====================================\n'
  printf '系统：%s | 目录：%s | 端口：%s\n\n' "$(uname -s)" "$APP_DIR" "$PORT"
  printf '1) 安装 / 更新并启动\n2) 查看状态和日志\n3) 查看实时日志\n4) 启动服务\n5) 停止服务\n6) 重启服务\n7) 备份配置和数据\n8) 卸载服务（保留数据）\n9) 完全删除项目（危险）\n0) 退出\n\n请选择 [0-9]: '
  read -r choice || exit 0
  case "$choice" in
    1) deploy ;;
    2) status ;;
    3) logs ;;
    4) service_action up -d ;;
    5) service_action down ;;
    6) service_action restart ;;
    7) is_project && backup_data || { red "尚未安装项目。"; } ;;
    8) uninstall ;;
    9) remove_all ;;
    0) exit 0 ;;
    *) yellow "请输入菜单中的数字。" ;;
  esac
  pause
done
