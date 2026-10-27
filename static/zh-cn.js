/* Pulse Console CN: Chinese UI translation + password login gate. API keys and payloads remain unchanged. */
(() => {
  document.documentElement.lang = "zh-CN";
  const dict = {
    "Wireless ADB device management and remote control.":"通过无线 ADB 管理设备并进行远程控制。",
    "Connection to the fleet control plane was lost.":"与设备集群控制服务的连接已断开。",
    "Search devices and run fleet commands":"搜索设备并执行集群命令",
    "Auto-refresh every 4 seconds":"每 4 秒自动刷新",
    "Reduce interface motion":"减少界面动画",
    "Update all outdated":"更新所有过期设备",
    "Update selected":"更新所选设备",
    "Phones waiting to pair":"等待配对的手机",
    "Operational distribution":"设备运行分布",
    "Release and installation management":"版本发布与安装管理",
    "Select a signed Guardian build from the configured repository.":"从已配置的仓库中选择经过签名验证的 Guardian 版本。",
    "Read installed Guardian versions from every online device.":"读取所有在线设备上安装的 Guardian 版本。",
    "Install the verified APK in backend-controlled waves.":"通过后台分批安装已验证的 APK。",
    "Apply permissions, WD recovery, and fleet-mode protection.":"应用权限、无线调试恢复和集群模式保护。",
    "Onboard phones, manage reversible debloat, inspect readiness drift, or enable the legacy Keep-Lite fallback.":"添加手机、管理可恢复的精简操作、检查就绪状态，或启用旧版 Keep-Lite 备用机制。",
    "Wireless debugging":"无线调试",
    "Pair device with pairing code":"使用配对码配对设备",
    "Enable Wireless debugging, pair each phone once, then discover via mDNS or import the configured device list.":"请先在手机上启用无线调试并完成一次配对，然后通过 mDNS 发现设备或导入设备列表。",
    "The console will retry automatically.":"控制台将自动重试。",
    "The backend returned no per-device results.":"后台未返回逐台设备的执行结果。",
    "No Guardian arm telemetry has been reported yet.":"尚未收到 Guardian 运行状态遥测数据。",
    "Guardian OTA is not configured. Add the repository and read-only token in devices.json.":"尚未配置 Guardian 在线更新。请在 devices.json 中填写仓库和只读令牌。",
    "Package inventory unavailable.":"无法获取应用包清单。",
    "Nothing to show yet.":"暂无可显示的内容。",
    "No devices in this fleet":"当前集群中没有设备",
    "No devices match this view":"没有符合当前视图条件的设备",
    "Try removing a filter or use a broader fleet query.":"请尝试移除筛选条件，或扩大集群查询范围。",
    "Could not load settings":"无法加载设置",
    "Enter the fleet token in the header first — server settings are token-gated.":"请先在页面顶部输入集群令牌；服务器设置需要令牌验证。",
    "Token rejected":"令牌验证失败",
    "Checking release state…":"正在检查版本状态…",
    "Search devices and run fleet commands":"搜索设备并执行集群命令",
    "Assign selected devices to a named group":"将所选设备分配到指定分组",
    "How cells are arranged. Position is stable within a group, so a device keeps its place between refreshes.":"设置设备方块的排列方式。同一分组内的位置保持稳定，刷新后设备不会随意换位。",
    "Green screen on every reachable phone for 15 min, silent. Whatever stays dark is not on the console.":"让所有可连接的手机显示绿色屏幕 15 分钟，不发出声音。没有亮起的手机可能未被控制台识别。",
    "Black screen with a bouncing green dot while Lite is foreground. Locate still works on top.":"Lite 位于前台时显示黑屏和移动的绿点；定位标记仍可显示在上层。",
    "Download the signed, SHA-256 + cert-verified APK for the selected release — for hand-testing on phones outside this console":"下载所选版本的 APK；文件已通过 SHA-256 和签名证书校验，可用于控制台外的手动测试。",
    "Assign selected":"分配所选设备",
    "Ungroup selected":"取消所选设备分组",
    "Clear all groups":"清空所有分组",
    "Group name, e.g. rack-a":"分组名称，例如 rack-a",
    "Select devices in the table (or shift-click them on the map), then assign them to a named group. Groups are stored in this browser and drive the map's layout when \"Custom groups\" is the grouping mode.":"在表格中选择设备（或在地图上按住 Shift 点击），然后将它们分配到指定分组。分组保存在当前浏览器中；地图选择“自定义分组”模式时会按此排列。",
    "No devices selected.":"未选择设备。",
    "Scanning for pairing-mode phones…":"正在扫描处于配对模式的手机…",
    "None detected. On the phone, leave “Pair device with pairing code” open and refresh.":"未发现设备。请在手机上保持“使用配对码配对设备”页面打开，然后重新扫描。",
    "Select a device":"选择设备",
    "Select devices":"选择设备",
    "Device details":"设备详情",
    "Close device details":"关闭设备详情",
    "Enlarged screenshot":"放大截图",
    "Screenshot from":"设备截图：",
    "No output":"无输出",
    "Retry now":"立即重试",
    "Refresh fleet":"刷新设备",
    "Skip to device fleet":"跳转到设备列表",
    "Application navigation":"应用导航",
    "Overview":"总览",
    "Fleet":"设备集群",
    "Activity":"活动记录",
    "Guardian":"Guardian 守护程序",
    "Operations":"运维操作",
    "Discovery":"设备发现",
    "Heartbeats":"心跳检测",
    "Versions":"版本检查",
    "Analytics":"数据分析",
    "Onboard":"添加设备",
    "Import":"导入",
    "Control plane":"控制服务",
    "Connecting":"连接中",
    "Fleet Operations":"集群运维",
    "Fleet Console":"设备集群控制台",
    "Last refresh":"上次刷新",
    "Discover":"发现设备",
    "Roster":"设备清单",
    "Mark all":"全部标记",
    "Commands":"命令面板",
    "Keyboard shortcuts":"键盘快捷键",
    "Console options":"控制台选项",
    "Fleet settings":"集群设置",
    "Fleet access token":"集群访问令牌",
    "Required for actions":"执行操作需要令牌",
    "Fleet status":"集群状态",
    "Processor update":"处理器更新",
    "Check now":"立即检查",
    "FLEET MAP":"设备分布图",
    "Group":"分组",
    "Subnet":"子网",
    "Phone model":"手机型号",
    "Alias":"别名",
    "Custom groups":"自定义分组",
    "None":"无",
    "Groups…":"分组管理…",
    "Heatmap metric":"热力图指标",
    "Health":"健康状态",
    "Acurast Network":"Acurast 网络",
    "LITE OTA":"Lite 在线更新",
    "Refresh scan":"刷新扫描",
    "Pair":"配对",
    "Cancel":"取消",
    "Save changes":"保存更改",
    "Save":"保存",
    "Close":"关闭",
    "Search":"搜索",
    "Settings":"设置",
    "Open server settings":"打开服务器设置",
    "Options":"选项",
    "Device":"设备",
    "Status":"状态",
    "Model":"型号",
    "Battery":"电池",
    "Temperature":"温度",
    "Temp":"温度",
    "Online":"在线",
    "Offline":"离线",
    "Connected":"已连接",
    "Disconnected":"未连接",
    "Unknown":"未知",
    "Actions":"操作",
    "Reboot":"重启",
    "Screenshot":"截图",
    "Live":"实时画面",
    "Onboard phone":"添加手机",
    "Pair device":"配对设备",
    "Host":"主机地址",
    "Pairing code":"配对码",
    "Token":"令牌",
    "Apply":"应用",
    "Enable":"启用",
    "Disable":"禁用",
    "Update Guardian":"更新 Guardian",
    "No devices selected":"未选择设备",
    "Select all":"全选",
    "Deselect all":"取消全选",
    "Filter":"筛选",
    "All":"全部",
    "Loading…":"加载中…",
    "Connected devices":"已连接设备",
    "Missing":"未连接",
    "Maintenance":"维护模式",
    "Resume":"恢复",
    "Pause":"暂停",
    "Mark online":"标记在线",
    "Import devices":"导入设备",
    "Export":"导出",
    "Copy":"复制",
    "Copied":"已复制",
    "Error":"错误",
    "Success":"成功",
    "Warning":"警告",
    "Last seen":"最后在线",
    "Version":"版本",
    "Heartbeat":"心跳",
    "Running":"运行中",
    "Idle":"空闲",
    "Busy":"忙碌",
    "Stalled":"已停滞",
    "Processor":"处理器",
    "Guardian version":"Guardian 版本",
    "Device roster":"设备清单",
    "Command palette":"命令面板",
    "Unavailable":"不可用",
    "Waiting for control plane":"等待控制服务响应",
    "Fleet state unavailable":"集群状态不可用",
    "Retry":"重试",
    "Clear filters":"清除筛选",
    "Open operations table":"打开运维表格",
    "Open operations table":"打开运维表格",
    "Current":"当前版本",
    "Outdated":"版本过期",
    "Eligible":"符合条件",
    "Verification":"校验状态",
    "Passed":"已通过",
    "Pending":"等待中",
    "Installing":"安装中",
    "Completed":"已完成",
    "succeeded":"成功",
    "failed":"失败",
    "Reporting":"正在上报",
    "Fully armed":"已完整启用",
    "Degraded":"状态异常",
    "Average temp":"平均温度",
    "Hottest":"最高温度",
    "Throttling":"温控降频",
    "DEVICE INVENTORY":"设备清单",
    "Operations fleet":"设备运维集群",
    "devices":"台设备",
    "Device view":"设备视图",
    "Activity & alerts":"活动与告警",
    "LIVE OPERATIONS":"实时运维",
    "Alerts":"告警",
    "Actions":"操作",
    "Release":"版本",
    "Select release":"选择版本",
    "Refresh releases":"刷新版本列表",
    "Download APK":"下载 APK",
    "Scan fleet":"扫描集群",
    "Scan Guardian":"扫描 Guardian",
    "Deploy safely":"安全部署",
    "Install selected":"安装所选设备",
    "Install all online":"安装所有在线设备",
    "Grant and arm":"授权并启用",
    "Provision selected":"配置所选设备",
    "Provision all online":"配置所有在线设备",
    "FLEET UTILITIES":"集群工具",
    "Onboard phones":"添加手机",
    "Readiness details":"就绪状态详情",
    "Keep Lite":"保持 Lite 运行",
    "Screensaver":"屏幕保护",
    "Clear marks":"清除标记",
    "Reset FG losses":"重置前台丢失计数",
    "Debloat":"精简应用",
    "Refresh":"刷新",
    "Refresh fleet":"刷新设备",
    "Overview":"总览",
    "Device details":"设备详情",
    "Alias":"别名",
    "IP address":"IP 地址",
    "Serial":"序列号",
    "CPU":"CPU",
    "Memory":"内存",
    "Storage":"存储空间",
    "Charging":"正在充电",
    "Not charging":"未充电",
    "Healthy":"健康",
    "Warning":"警告",
    "Critical":"严重",
    "Temperature":"温度",
    "Battery level":"电量",
    "Battery health":"电池健康度",
    "Foreground":"前台",
    "Background":"后台",
    "Heartbeat age":"心跳间隔",
    "Last heartbeat":"最近心跳",
    "No results":"没有结果",
    "Nothing matches that. Try a device name, an IP, or a command.":"没有匹配项。请尝试输入设备名称、IP 地址或命令。",
    "Select a device, an IP, or a command.":"选择设备、IP 地址或命令。",
    "No devices match":"没有匹配的设备",
    "Clear all":"全部清除",
    "Clear":"清除",
    "Done":"完成",
    "Back":"返回",
    "Next":"下一步",
    "Previous":"上一步",
    "Confirm":"确认",
    "Run":"运行",
    "Stop":"停止",
    "Start":"启动",
    "Refresh now":"立即刷新",
    "Select":"选择",
    "Selected":"已选择",
    "selected":"已选择",
    "device":"设备",
    "devices":"台设备",
    "group":"分组",
    "groups":"个分组",
    "Unknown device":"未知设备",
    "Pairing-mode device":"配对模式设备",
    "No data":"暂无数据",
    "Unavailable":"不可用",
    "Not configured":"尚未配置",
    "Enabled":"已启用",
    "Disabled":"已禁用",
    "On":"开",
    "Off":"关",
    "latest (newest)":"最新版本",
    "pre-release":"预发布版",
    "Save":"保存",
    "Save changes":"保存更改",
    "Clear all groups":"清空所有分组",
    "Map group":"地图分组",
    "Custom group":"自定义分组",
    "Cancel":"取消",
    "Import list":"导入列表",
    "Discover devices":"发现设备",
    "No devices selected.":"未选择设备。",
    "Loading":"加载中",
    "Error loading":"加载失败",
    "Open command palette":"打开命令面板",
    "Console options — what to show, refresh rate, density":"控制台选项——显示内容、刷新频率和密度",
    "Collapse sidebar":"折叠侧边栏",
    "Close Guardian panel":"关闭 Guardian 面板",
    "Close":"关闭",
    "Assign selected devices to a named group":"将所选设备分配到指定分组",
    "Server settings":"服务器设置",
    "Save settings":"保存设置",
    "Save changes":"保存更改",
    "Package inventory unavailable.":"无法获取应用包清单。",
    "No output":"无输出",
    "NOMINAL":"正常",
    "ALSO":"其他",
    "All":"全部",
    "Alerts":"告警",
    "Actions":"操作",
    "Set password":"设置密码",
    "Password":"密码",
    "Log in":"登录",
    "Enter password":"请输入密码",
    "Incorrect password. Try again.":"密码错误，请重试。",
    "Login service unavailable. Check the server logs.":"登录服务不可用，请检查服务器日志。",
    "Your session has expired. Please log in again.":"登录会话已过期，请重新登录。",
    "Enter the console password to continue.":"请输入控制台密码以继续。",
    "Default password: 123456. Change it in devices.json before exposing this service to other networks.":"默认密码：123456。向其他网络开放前，请先在 devices.json 中修改密码。"
  };

  const keys = Object.keys(dict).sort((a, b) => b.length - a.length);
  const translate = value => {
    if (!value) return value;
    let out = value;
    for (const key of keys) {
      const escaped = key.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
      const isWord = /^[A-Za-z0-9]+$/.test(key);
      const re = isWord
        ? new RegExp("(^|[^A-Za-z0-9])(" + escaped + ")(?=$|[^A-Za-z0-9])", "g")
        : new RegExp(escaped, "g");
      out = out.replace(re, isWord ? (match, prefix) => prefix + dict[key] : dict[key]);
    }
    return out;
  };

  const translateElement = el => {
    if (!el || el.nodeType !== 1) return;
    const walker = document.createTreeWalker(el, NodeFilter.SHOW_TEXT);
    const nodes = [];
    while (walker.nextNode()) nodes.push(walker.currentNode);
    for (const node of nodes) {
      if (node.parentElement && /^(SCRIPT|STYLE|TEXTAREA|CODE|PRE)$/i.test(node.parentElement.tagName)) continue;
      const before = node.nodeValue;
      const after = translate(before);
      if (after !== before) node.nodeValue = after;
    }
    for (const attr of ["title", "aria-label", "placeholder", "alt"]) {
      const before = el.getAttribute(attr);
      if (before) {
        const after = translate(before);
        if (after !== before) el.setAttribute(attr, after);
      }
    }
  };

  const installLogin = async () => {
    let authenticated = false;
    try {
      const response = await fetch("/api/session", { cache: "no-store", credentials: "same-origin" });
      authenticated = response.ok;
    } catch (_) {}
    if (authenticated) {
      document.body.classList.add("console-authenticated");
      return;
    }
    const style = document.createElement("style");
    style.textContent = `
      body:not(.console-authenticated) .app-shell { visibility: hidden !important; }
      #pulseLoginOverlay { position: fixed; inset: 0; z-index: 2147483000; display: grid; place-items: center; padding: 24px; background: #080d15; color: #eef4ff; font-family: system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif; }
      #pulseLoginCard { width: min(100%, 390px); box-sizing: border-box; padding: 30px; border: 1px solid #263448; border-radius: 18px; background: #101a28; box-shadow: 0 24px 80px #0008; }
      #pulseLoginCard h1 { margin: 0 0 8px; font-size: 25px; }
      #pulseLoginCard p { color: #aab8ca; line-height: 1.6; }
      #pulseLoginCard label { display:block; margin:20px 0 8px; font-size:14px; }
      #pulseLoginCard input { box-sizing:border-box; width:100%; padding:12px 14px; border:1px solid #394b62; border-radius:9px; background:#0b111b; color:#fff; font-size:16px; }
      #pulseLoginCard button { width:100%; margin-top:16px; padding:12px; border:0; border-radius:9px; background:#c8f135; color:#17210a; font-size:15px; font-weight:700; cursor:pointer; }
      #pulseLoginError { min-height:20px; color:#ff9c9c !important; font-size:13px; }
      #pulseLoginHint { font-size:12px; color:#8393a8 !important; }
    `;
    document.head.appendChild(style);
    const overlay = document.createElement("div");
    overlay.id = "pulseLoginOverlay";
    overlay.innerHTML = '<form id="pulseLoginCard"><h1>Pulse Console</h1><p>请输入控制台密码以继续。</p><label for="pulseLoginPassword">访问密码</label><input id="pulseLoginPassword" type="password" autocomplete="current-password" placeholder="请输入密码" required autofocus><button type="submit">登录</button><p id="pulseLoginError" role="alert"></p><p id="pulseLoginHint">默认密码：123456。向其他网络开放前，请先在 devices.json 中修改密码。</p></form>';
    document.body.appendChild(overlay);
    translateElement(overlay);
    const input = document.getElementById("pulseLoginPassword");
    input.focus();
    document.getElementById("pulseLoginCard").addEventListener("submit", async event => {
      event.preventDefault();
      const button = event.currentTarget.querySelector("button");
      const error = document.getElementById("pulseLoginError");
      button.disabled = true;
      button.textContent = "正在登录…";
      error.textContent = "";
      try {
        const response = await fetch("/api/login", {
          method: "POST",
          credentials: "same-origin",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ password: input.value })
        });
        const result = await response.json();
        if (!response.ok || !result.ok) throw new Error(response.status === 401 ? "密码错误，请重试。" : "登录服务不可用，请检查服务器日志。");
        // Verify that the browser accepted the session cookie before reloading the app.
        // Otherwise the page can loop between the login gate and unauthenticated API calls.
        const sessionResponse = await fetch("/api/session", { cache: "no-store", credentials: "same-origin" });
        if (!sessionResponse.ok) throw new Error("登录已提交，但会话未建立。请检查浏览器是否允许本站 Cookie，然后重试。");
        document.body.classList.add("console-authenticated");
        location.reload();
      } catch (e) {
        error.textContent = e.message || "登录失败，请重试。";
        input.select();
      } finally {
        button.disabled = false;
        button.textContent = "登录";
      }
    });
  };

  const start = () => {
    translateElement(document.body);
    new MutationObserver(records => {
      for (const record of records) {
        if (record.type === "characterData") {
          const before = record.target.nodeValue;
          const after = translate(before);
          if (after !== before) record.target.nodeValue = after;
        }
        for (const node of record.addedNodes || []) {
          if (node.nodeType === 3) {
            const before = node.nodeValue;
            const after = translate(before);
            if (after !== before) node.nodeValue = after;
          } else if (node.nodeType === 1) translateElement(node);
        }
      }
    }).observe(document.body, { subtree: true, childList: true, characterData: true });
    installLogin();
  };
  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", start, { once: true });
  else start();
})();
