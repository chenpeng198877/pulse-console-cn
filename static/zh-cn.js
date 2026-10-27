/* Pulse Console CN: lightweight UI translation layer. API payloads and protocol keys remain unchanged. */
(() => {
  document.documentElement.lang = "zh-CN";
  const dict = {
    "Skip to device fleet":"跳转到设备列表","Application navigation":"应用导航","Overview":"总览","Fleet":"设备集群","Activity":"活动记录","Guardian":"Guardian 守护程序",
    "Operations":"运维操作","Discovery":"设备发现","Heartbeats":"心跳检测","Versions":"版本检查","Analytics":"数据分析","Onboard":"添加设备","Import":"导入",
    "Control plane":"控制服务","Connecting":"连接中","Fleet Operations":"集群运维","Fleet Console":"设备集群控制台","Wireless ADB device management and remote control.":"通过无线 ADB 管理设备并进行远程控制。",
    "Last refresh":"上次刷新","Refresh fleet":"刷新设备","Discover":"发现设备","Roster":"设备清单","Mark all":"全部标记","Commands":"命令","Keyboard shortcuts":"键盘快捷键",
    "Console options":"控制台选项","Fleet settings":"集群设置","Fleet access token":"集群访问令牌","Required for actions":"执行操作需要令牌",
    "Auto-refresh every 4 seconds":"每 4 秒自动刷新","Reduce interface motion":"减少界面动画","Connection to the fleet control plane was lost.":"与集群控制服务的连接已断开。",
    "Retry now":"立即重试","Fleet status":"集群状态","Processor update":"处理器更新","Checking release state…":"正在检查版本状态…","Check now":"立即检查",
    "Update selected":"更新所选设备","Update all outdated":"更新所有过期设备","FLEET MAP":"设备分布图","Operational distribution":"运行分布",
    "Group":"分组","Subnet":"子网","Phone model":"手机型号","Alias":"别名","Custom groups":"自定义分组","None":"无","Groups…":"分组管理…",
    "Heatmap metric":"热力图指标","Health":"健康状态","Acurast Network":"Acurast 网络","LITE OTA":"Lite 在线更新","Phones waiting to pair":"等待配对的手机",
    "Refresh scan":"刷新扫描","Pair":"配对","Cancel":"取消","Save":"保存","Close":"关闭","Search":"搜索","Settings":"设置","Open server settings":"打开服务器设置",
    "Options":"选项","Device":"设备","Status":"状态","Model":"型号","Battery":"电池","Temperature":"温度","Online":"在线","Offline":"离线",
    "Connected":"已连接","Disconnected":"未连接","Unknown":"未知","Actions":"操作","Reboot":"重启","Screenshot":"截图","Live":"实时画面",
    "Onboard phone":"添加手机","Pair device":"配对设备","Host":"主机地址","Pairing code":"配对码","Token":"令牌","Apply":"应用","Enable":"启用",
    "Disable":"禁用","Update Guardian":"更新 Guardian","No devices selected":"未选择设备","Select all":"全选","Deselect all":"取消全选",
    "Filter":"筛选","All":"全部","Loading…":"加载中…","Connected devices":"已连接设备","Missing":"未连接","Maintenance":"维护模式",
    "Resume":"恢复","Pause":"暂停","Mark online":"标记在线","Import devices":"导入设备","Export":"导出","Copy":"复制","Copied":"已复制",
    "Error":"错误","Success":"成功","Warning":"警告","Last seen":"最后在线","Version":"版本","Heartbeat":"心跳","Running":"运行中","Idle":"空闲",
    "Busy":"忙碌","Stalled":"已停滞","Processor":"处理器","Guardian version":"Guardian 版本","Device roster":"设备清单",
    "Command palette":"命令面板","Search devices and run fleet commands":"搜索设备并执行集群命令"
  };
  const translate = s => { const t=(s||"").trim(); return t && dict[t] ? s.replace(t,dict[t]) : s; };
  const translateElement = el => {
    const w=document.createTreeWalker(el,NodeFilter.SHOW_TEXT); const ns=[];
    while(w.nextNode()) ns.push(w.currentNode);
    for(const n of ns){const b=n.nodeValue,a=translate(b);if(a!==b)n.nodeValue=a;}
    if(el.nodeType===1) for(const a of ["title","aria-label","placeholder","alt"]){const v=el.getAttribute(a);if(v&&dict[v.trim()])el.setAttribute(a,translate(v));}
  };
  const start=()=>{translateElement(document.body);new MutationObserver(rs=>{for(const r of rs){if(r.type==="characterData"){const b=r.target.nodeValue,a=translate(b);if(a!==b)r.target.nodeValue=a;}for(const n of r.addedNodes||[]){if(n.nodeType===3){const b=n.nodeValue,a=translate(b);if(a!==b)n.nodeValue=a;}else if(n.nodeType===1)translateElement(n);}}}).observe(document.body,{subtree:true,childList:true,characterData:true});};
  if(document.readyState==="loading")document.addEventListener("DOMContentLoaded",start,{once:true});else start();
})();