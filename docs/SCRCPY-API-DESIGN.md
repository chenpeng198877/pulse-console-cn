# scrcpy API 草案

以下是目标 API 契约，不代表这些接口已经在运行版本中实现。

## Capability
- GET /api/scrcpy/capabilities
- 返回：scrcpy 是否安装、版本、支持的输出/网关能力、最大允许会话数、当前活动数和拒绝原因。

## Sessions
- POST /api/scrcpy/sessions  body: { "serial": "...", "profile": "interactive|thumbnail" }
- GET /api/scrcpy/sessions
- GET /api/scrcpy/sessions/{session_id}
- DELETE /api/scrcpy/sessions/{session_id}

启动接口应该快速返回 session_id 和 queued/starting 状态；启动失败写入 error 字段，不要让浏览器无限等待。服务端须校验设备已登记且在线、同设备没有活动会话，并执行全局并发限制。

## Profiles
- interactive：单台设备交互，默认中等分辨率和帧率，可配置但必须限制范围。
- thumbnail：低分辨率、低帧率，用于巡检；仅允许少量并发，建议采用轮巡而不是全量常驻。

## Session state
- queued, starting, running, stopping, stopped, failed
- 字段：session_id、serial、profile、created_at、started_at、last_activity_at、exit_code、error

## 错误
- 400 参数无效
- 401 未登录/未授权
- 404 设备或会话不存在
- 409 同设备已有会话或并发额度已满
- 503 scrcpy/媒体网关不可用

## 重要实现说明
视频传输不能仅靠一个“启动 scrcpy 进程”接口就宣称完成。必须确认所用 scrcpy 版本支持的输出方式，并完成浏览器端接收、渲染、输入控制、认证、断线重连和清理的端到端验证。