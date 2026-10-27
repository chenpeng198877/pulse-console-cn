# Pulse Console CN（中文界面 + Docker）

这是基于上游 [smw006007/pulse-console](https://github.com/smw006007/pulse-console) 制作的个人分支，目标是方便在 Linux / iStoreOS Docker 环境部署，并增加简体中文界面层。保留原项目的 ADB 设备管理逻辑；中文层只翻译界面文本，不修改 API 字段和设备命令。

> **重要安全提示：** 该控制台能通过 ADB 重启、操作和管理手机，权限非常高。请仅管理自己拥有的设备；必须设置长随机 token，只在可信内网/VPN 中使用，切勿将控制台或 ws-scrcpy 直接暴露到公网。

## 功能

- 基于上游 Python 服务与静态网页。
- 增加简体中文界面翻译层（部分动态或未收录的文字仍可能显示英文）。
- Dockerfile + Docker Compose，适合 x86-64 Linux / iStoreOS Docker。
- ADB 无线调试；容器必须能够通过网络访问手机的无线调试端口。
- 配置与运行数据不应提交到 Git。

## 在 iStoreOS / Linux 上部署

先安装 Docker 与 Docker Compose 插件，然后执行：

```sh
git clone https://github.com/chenpeng198877/pulse-console-cn.git
cd pulse-console-cn
cp devices.example.json devices.json
```

编辑 `devices.json`，至少修改：

- `token`：替换成足够长、随机且独有的密码。
- `bind`：容器内保持 `0.0.0.0`，这样 Docker 端口映射才能访问。
- 检查 `port`（默认 8787），以及需要的 Acurast / Guardian 配置。

生成随机 token 的一种方式：

```sh
openssl rand -hex 32
```

将输出填入 `devices.json` 的 `token` 字段，然后启动：

```sh
mkdir -p data/apk-cache data/guardian-apks
touch data/metrics.db data/device_state.json data/discovery_baseline.json data/screensaver.json data/heartbeat_checks.json
docker compose up -d --build
docker compose logs -f
```

浏览器访问 `http://<iStoreOS的局域网地址>:8787`。例如，路由器地址是 `192.168.100.1` 时，访问 `http://192.168.100.1:8787`。

停止服务：

```sh
docker compose down
```

更新代码后：

```sh
git pull
docker compose up -d --build
```

## ADB 与手机连接

1. 手机开启开发者选项中的“无线调试”。
2. 首次通过配对 IP:端口和配对码完成配对。
3. 确保容器网络可访问手机的无线调试地址；不同 Wi-Fi/VLAN 的隔离、防火墙可能阻断连接。
4. 若页面显示 `Discovery failed / bad token`，请确认设备配置中的 token、手机无线调试状态以及容器网络可达性。

此 Compose 配置面向无线 ADB；**没有自动映射 USB 设备**。如果要走 USB，需要额外配置宿主机设备节点、权限与容器运行参数。

## 数据与安全

- `devices.json` 是本机私有配置，已在 `.gitignore` 中排除，不能提交。
- 请不要在公网端口转发中开放 8787。
- ws-scrcpy 服务本身可能没有认证；若启用，应单独用防火墙限制在可信网络。
- 使用 Guardian / Processor 更新功能前，先核对包名、签名证书与目标版本；不要在正在执行任务的设备上盲目升级。
- 本分支尚未在真实手机集群和 iStoreOS 环境完成端到端测试。构建成功不代表所有 ADB、Guardian 或实时画面功能均已验证。

## 上游与许可

- 上游项目：[smw006007/pulse-console](https://github.com/smw006007/pulse-console)
- 本分支保留上游许可证文件。请在再发布时遵守原许可证要求。
