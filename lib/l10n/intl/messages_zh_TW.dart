// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh_TW';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("關於"),
    "accessControl": MessageLookupByLibrary.simpleMessage("存取控制"),
    "accessControlAllowDesc": MessageLookupByLibrary.simpleMessage(
      "僅允許選定的應用程式進入 VPN",
    ),
    "accessControlDesc": MessageLookupByLibrary.simpleMessage(
      "配置應用程式存取代理",
    ),
    "accessControlNotAllowDesc": MessageLookupByLibrary.simpleMessage(
      "選定的應用程式將被排除在 VPN 之外",
    ),
    "account": MessageLookupByLibrary.simpleMessage("帳戶"),
    "accountTip": MessageLookupByLibrary.simpleMessage(
      "帳戶不能為空",
    ),
    "action": MessageLookupByLibrary.simpleMessage("動作"),
    "action_mode": MessageLookupByLibrary.simpleMessage("切換模式"),
    "action_proxy": MessageLookupByLibrary.simpleMessage("系統代理"),
    "action_start": MessageLookupByLibrary.simpleMessage("開始/停止"),
    "action_tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "action_view": MessageLookupByLibrary.simpleMessage("顯示/隱藏"),
    "add": MessageLookupByLibrary.simpleMessage("新增"),
    "address": MessageLookupByLibrary.simpleMessage("地址"),
    "addressHelp": MessageLookupByLibrary.simpleMessage(
      "WebDAV 伺服器地址",
    ),
    "addressTip": MessageLookupByLibrary.simpleMessage(
      "請輸入有效的 WebDAV 地址",
    ),
    "adminAutoLaunch": MessageLookupByLibrary.simpleMessage(
      "管理員自動啟動",
    ),
    "adminAutoLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "使用管理員模式啟動",
    ),
    "ago": MessageLookupByLibrary.simpleMessage(" 前"),
    "agree": MessageLookupByLibrary.simpleMessage(" 同意"),
    "allApps": MessageLookupByLibrary.simpleMessage("所有應用程式"),
    "allowBypass": MessageLookupByLibrary.simpleMessage(
      "允許應用程式繞過 VPN",
    ),
    "allowBypassDesc": MessageLookupByLibrary.simpleMessage(
      "開啟後，某些應用程式可以繞過 VPN",
    ),
    "allowLan": MessageLookupByLibrary.simpleMessage("允許 LAN"),
    "allowLanDesc": MessageLookupByLibrary.simpleMessage(
      "允許透過 LAN 存取代理",
    ),
    "app": MessageLookupByLibrary.simpleMessage("應用程式"),
    "appAccessControl": MessageLookupByLibrary.simpleMessage(
      "應用程式存取控制",
    ),
    "appDesc": MessageLookupByLibrary.simpleMessage(
      "處理應用程式相關設定",
    ),
    "application": MessageLookupByLibrary.simpleMessage("應用程式"),
    "applicationDesc": MessageLookupByLibrary.simpleMessage(
      "修改應用程式相關設定",
    ),
    "auto": MessageLookupByLibrary.simpleMessage("自動"),
    "autoCheckUpdate": MessageLookupByLibrary.simpleMessage(
      "自動檢查更新",
    ),
    "autoCheckUpdateDesc": MessageLookupByLibrary.simpleMessage(
      "應用程式啟動時自動檢查更新",
    ),
    "autoCloseConnections": MessageLookupByLibrary.simpleMessage(
      "自動關閉連線",
    ),
    "autoCloseConnectionsDesc": MessageLookupByLibrary.simpleMessage(
      "更換節點後自動關閉連線",
    ),
    "autoLaunch": MessageLookupByLibrary.simpleMessage("自動啟動"),
    "autoLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "隨系統自啟動",
    ),
    "autoRun": MessageLookupByLibrary.simpleMessage("自動運行"),
    "autoRunDesc": MessageLookupByLibrary.simpleMessage(
      "應用程式開啟時自動運行",
    ),
    "autoUpdate": MessageLookupByLibrary.simpleMessage("自動更新"),
    "autoUpdateInterval": MessageLookupByLibrary.simpleMessage(
      "自動更新間隔 (分鐘)",
    ),
    "backup": MessageLookupByLibrary.simpleMessage("備份"),
    "backupAndRecovery": MessageLookupByLibrary.simpleMessage(
      "備份與恢復",
    ),
    "backupAndRecoveryDesc": MessageLookupByLibrary.simpleMessage(
      "透過 WebDAV 或檔案同步資料",
    ),
    "backupSuccess": MessageLookupByLibrary.simpleMessage("備份成功"),
    "bind": MessageLookupByLibrary.simpleMessage("綁定"),
    "blacklistMode": MessageLookupByLibrary.simpleMessage("黑名單模式"),
    "bypassDomain": MessageLookupByLibrary.simpleMessage("繞過域名"),
    "bypassDomainDesc": MessageLookupByLibrary.simpleMessage(
      "僅在系統代理啟用時生效",
    ),
    "cacheCorrupt": MessageLookupByLibrary.simpleMessage(
      "快取已損壞。您想清除它嗎？",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("取消"),
    "cancelFilterSystemApp": MessageLookupByLibrary.simpleMessage(
      "取消過濾系統應用程式",
    ),
    "cancelSelectAll": MessageLookupByLibrary.simpleMessage(
      "取消全選",
    ),
    "checkError": MessageLookupByLibrary.simpleMessage("檢查錯誤"),
    "checkUpdate": MessageLookupByLibrary.simpleMessage("檢查更新"),
    "checkUpdateError": MessageLookupByLibrary.simpleMessage(
      "當前應用程式已是最新版本",
    ),
    "checking": MessageLookupByLibrary.simpleMessage("檢查中..."),
    "clipboardExport": MessageLookupByLibrary.simpleMessage("匯出剪貼簿"),
    "clipboardImport": MessageLookupByLibrary.simpleMessage("匯入剪貼簿"),
    "columns": MessageLookupByLibrary.simpleMessage("欄"),
    "compatible": MessageLookupByLibrary.simpleMessage("相容模式"),
    "compatibleDesc": MessageLookupByLibrary.simpleMessage(
      "開啟後將失去部分應用程式功能並獲得 Clash 的完整支援。",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("確認"),
    "connections": MessageLookupByLibrary.simpleMessage("連線"),
    "connectionsDesc": MessageLookupByLibrary.simpleMessage(
      "查看當前連線資料",
    ),
    "connectivity": MessageLookupByLibrary.simpleMessage("連線狀態："),
    "copy": MessageLookupByLibrary.simpleMessage("複製"),
    "copyEnvVar": MessageLookupByLibrary.simpleMessage(
      "複製環境變數",
    ),
    "copyLink": MessageLookupByLibrary.simpleMessage("複製連結"),
    "copySuccess": MessageLookupByLibrary.simpleMessage("複製成功"),
    "core": MessageLookupByLibrary.simpleMessage("核心"),
    "coreInfo": MessageLookupByLibrary.simpleMessage("核心資訊"),
    "country": MessageLookupByLibrary.simpleMessage("國家"),
    "create": MessageLookupByLibrary.simpleMessage("創建"),
    "cut": MessageLookupByLibrary.simpleMessage("剪下"),
    "dark": MessageLookupByLibrary.simpleMessage("暗色"),
    "dashboard": MessageLookupByLibrary.simpleMessage("儀表板"),
    "days": MessageLookupByLibrary.simpleMessage("天"),
    "defaultNameserver": MessageLookupByLibrary.simpleMessage(
      "預設名稱伺服器",
    ),
    "defaultNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "用於解析 DNS 伺服器",
    ),
    "defaultSort": MessageLookupByLibrary.simpleMessage("預設排序"),
    "defaultText": MessageLookupByLibrary.simpleMessage("預設"),
    "delay": MessageLookupByLibrary.simpleMessage("延遲"),
    "delaySort": MessageLookupByLibrary.simpleMessage("按延遲排序"),
    "delete": MessageLookupByLibrary.simpleMessage("刪除"),
    "deleteProfileTip": MessageLookupByLibrary.simpleMessage(
      "您確定要刪除當前設定檔嗎？",
    ),
    "desc": MessageLookupByLibrary.simpleMessage(
      "基於 ClashMeta 的多平台代理客戶端，簡單易用，開源且無廣告。",
    ),
    "detectionTip": MessageLookupByLibrary.simpleMessage(
      "依賴第三方 API，僅供參考",
    ),
    "direct": MessageLookupByLibrary.simpleMessage("直接"),
    "disclaimer": MessageLookupByLibrary.simpleMessage("免責聲明"),
    "disclaimerDesc": MessageLookupByLibrary.simpleMessage(
      "本軟體僅用於學習交流及科學研究等非商業用途，嚴禁將本軟體用於商業目的。任何商業活動（如有）與本軟體無關。",
    ),
    "discoverNewVersion": MessageLookupByLibrary.simpleMessage(
      "發現新版本",
    ),
    "discovery": MessageLookupByLibrary.simpleMessage(
      "發現新版本",
    ),
    "dnsDesc": MessageLookupByLibrary.simpleMessage(
      "更新 DNS 相關設定",
    ),
    "dnsMode": MessageLookupByLibrary.simpleMessage("DNS 模式"),
    "doYouWantToPass": MessageLookupByLibrary.simpleMessage(
      "您想通過嗎？",
    ),
    "domain": MessageLookupByLibrary.simpleMessage("域名"),
    "download": MessageLookupByLibrary.simpleMessage("下載"),
    "edit": MessageLookupByLibrary.simpleMessage("編輯"),
    "en": MessageLookupByLibrary.simpleMessage("英語"),
    "entries": MessageLookupByLibrary.simpleMessage(" 條目"),
    "exclude": MessageLookupByLibrary.simpleMessage("從最近任務中隱藏"),
    "excludeDesc": MessageLookupByLibrary.simpleMessage(
      "當應用程式在背景時，從最近任務中隱藏應用程式",
    ),
    "exit": MessageLookupByLibrary.simpleMessage("退出"),
    "expand": MessageLookupByLibrary.simpleMessage("標準"),
    "expirationTime": MessageLookupByLibrary.simpleMessage("到期時間"),
    "exportFile": MessageLookupByLibrary.simpleMessage("匯出檔案"),
    "exportLogs": MessageLookupByLibrary.simpleMessage("匯出日誌"),
    "exportSuccess": MessageLookupByLibrary.simpleMessage("匯出成功"),
    "externalController": MessageLookupByLibrary.simpleMessage(
      "外部控制器",
    ),
    "externalControllerDesc": MessageLookupByLibrary.simpleMessage(
      "啟用後，可在 9090 端口控制 Clash 核心",
    ),
    "externalLink": MessageLookupByLibrary.simpleMessage("外部連結"),
    "externalResources": MessageLookupByLibrary.simpleMessage(
      "外部資源",
    ),
    "fakeipFilter": MessageLookupByLibrary.simpleMessage("虛假 IP 過濾"),
    "fakeipRange": MessageLookupByLibrary.simpleMessage("虛假 IP 範圍"),
    "fallback": MessageLookupByLibrary.simpleMessage("後備"),
    "fallbackDesc": MessageLookupByLibrary.simpleMessage(
      "通常使用海外 DNS",
    ),
    "fallbackFilter": MessageLookupByLibrary.simpleMessage("後備過濾"),
    "file": MessageLookupByLibrary.simpleMessage("檔案"),
    "fileDesc": MessageLookupByLibrary.simpleMessage("直接上傳設定檔"),
    "fileIsUpdate": MessageLookupByLibrary.simpleMessage(
      "檔案已修改。您想儲存更改嗎？",
    ),
    "filterSystemApp": MessageLookupByLibrary.simpleMessage(
      "過濾系統應用程式",
    ),
    "findProcessMode": MessageLookupByLibrary.simpleMessage("查找進程"),
    "findProcessModeDesc": MessageLookupByLibrary.simpleMessage(
      "開啟後有閃退風險",
    ),
    "fontFamily": MessageLookupByLibrary.simpleMessage("字體家族"),
    "fourColumns": MessageLookupByLibrary.simpleMessage("四欄"),
    "general": MessageLookupByLibrary.simpleMessage("一般"),
    "generalDesc": MessageLookupByLibrary.simpleMessage(
      "覆蓋一般設定",
    ),
    "geoData": MessageLookupByLibrary.simpleMessage("地理資料"),
    "geodataLoader": MessageLookupByLibrary.simpleMessage(
      "地理低記憶體模式",
    ),
    "geodataLoaderDesc": MessageLookupByLibrary.simpleMessage(
      "啟用後將使用地理低記憶體載入器",
    ),
    "geoipCode": MessageLookupByLibrary.simpleMessage("地理 IP 代碼"),
    "global": MessageLookupByLibrary.simpleMessage("全局"),
    "go": MessageLookupByLibrary.simpleMessage("前往"),
    "goDownload": MessageLookupByLibrary.simpleMessage("前往下載"),
    "hasCacheChange": MessageLookupByLibrary.simpleMessage(
      "您想快取更改嗎？",
    ),
    "hostsDesc": MessageLookupByLibrary.simpleMessage("新增主機"),
    "hotkeyConflict": MessageLookupByLibrary.simpleMessage("快捷鍵衝突"),
    "hotkeyManagement": MessageLookupByLibrary.simpleMessage(
      "快捷鍵管理",
    ),
    "hotkeyManagementDesc": MessageLookupByLibrary.simpleMessage(
      "使用鍵盤控制應用程式",
    ),
    "hours": MessageLookupByLibrary.simpleMessage("小時"),
    "icon": MessageLookupByLibrary.simpleMessage("圖標"),
    "iconConfiguration": MessageLookupByLibrary.simpleMessage(
      "圖標配置",
    ),
    "iconStyle": MessageLookupByLibrary.simpleMessage("圖標樣式"),
    "importFromURL": MessageLookupByLibrary.simpleMessage("從 URL 匯入"),
    "infiniteTime": MessageLookupByLibrary.simpleMessage("長期有效"),
    "init": MessageLookupByLibrary.simpleMessage("初始化"),
    "inputCorrectHotkey": MessageLookupByLibrary.simpleMessage(
      "請輸入正確的快捷鍵",
    ),
    "intelligentSelected": MessageLookupByLibrary.simpleMessage(
      "智能選擇",
    ),
    "intranetIP": MessageLookupByLibrary.simpleMessage("內網 IP"),
    "ipcidr": MessageLookupByLibrary.simpleMessage("IPCIDR"),
    "ipv6Desc": MessageLookupByLibrary.simpleMessage(
      "開啟後將能夠接收 IPv6 流量",
    ),
    "ipv6InboundDesc": MessageLookupByLibrary.simpleMessage(
      "允許 IPv6 入站",
    ),
    "ja": MessageLookupByLibrary.simpleMessage("日語"),
    "just": MessageLookupByLibrary.simpleMessage("剛剛"),
    "keepAliveIntervalDesc": MessageLookupByLibrary.simpleMessage(
      "TCP 保持活躍間隔",
    ),
    "key": MessageLookupByLibrary.simpleMessage("鍵"),
    "language": MessageLookupByLibrary.simpleMessage("語言"),
    "layout": MessageLookupByLibrary.simpleMessage("佈局"),
    "light": MessageLookupByLibrary.simpleMessage("亮色"),
    "list": MessageLookupByLibrary.simpleMessage("列表"),
    "listen": MessageLookupByLibrary.simpleMessage("監聽"),
    "local": MessageLookupByLibrary.simpleMessage("本地"),
    "localBackupDesc": MessageLookupByLibrary.simpleMessage(
      "將本地資料備份到本地",
    ),
    "localRecoveryDesc": MessageLookupByLibrary.simpleMessage(
      "從檔案恢復資料",
    ),
    "logLevel": MessageLookupByLibrary.simpleMessage("日誌級別"),
    "logcat": MessageLookupByLibrary.simpleMessage("日誌捕獲"),
    "logcatDesc": MessageLookupByLibrary.simpleMessage(
      "禁用後將隱藏日誌條目",
    ),
    "logs": MessageLookupByLibrary.simpleMessage("日誌"),
    "logsDesc": MessageLookupByLibrary.simpleMessage("日誌捕獲記錄"),
    "loopback": MessageLookupByLibrary.simpleMessage("回環解鎖工具"),
    "loopbackDesc": MessageLookupByLibrary.simpleMessage(
      "用於 UWP 回環解鎖",
    ),
    "loose": MessageLookupByLibrary.simpleMessage("鬆散"),
    "memoryInfo": MessageLookupByLibrary.simpleMessage("記憶體資訊"),
    "min": MessageLookupByLibrary.simpleMessage("分"),
    "minimizeOnExit": MessageLookupByLibrary.simpleMessage("退出時最小化"),
    "minimizeOnExitDesc": MessageLookupByLibrary.simpleMessage(
      "修改預設系統退出事件",
    ),
    "minutes": MessageLookupByLibrary.simpleMessage("分鐘"),
    "mode": MessageLookupByLibrary.simpleMessage("模式"),
    "months": MessageLookupByLibrary.simpleMessage("月"),
    "more": MessageLookupByLibrary.simpleMessage("更多"),
    "name": MessageLookupByLibrary.simpleMessage("名稱"),
    "nameSort": MessageLookupByLibrary.simpleMessage("按名稱排序"),
    "nameserver": MessageLookupByLibrary.simpleMessage("名稱伺服器"),
    "nameserverDesc": MessageLookupByLibrary.simpleMessage(
      "用於解析域名",
    ),
    "nameserverPolicy": MessageLookupByLibrary.simpleMessage(
      "名稱伺服器政策",
    ),
    "nameserverPolicyDesc": MessageLookupByLibrary.simpleMessage(
      "指定對應的名稱伺服器政策",
    ),
    "network": MessageLookupByLibrary.simpleMessage("網絡"),
    "networkDesc": MessageLookupByLibrary.simpleMessage(
      "修改網絡相關設定",
    ),
    "networkDetection": MessageLookupByLibrary.simpleMessage(
      "網絡檢測",
    ),
    "networkSpeed": MessageLookupByLibrary.simpleMessage("網絡速度"),
    "noData": MessageLookupByLibrary.simpleMessage("無資料"),
    "noHotKey": MessageLookupByLibrary.simpleMessage("無快捷鍵"),
    "noIcon": MessageLookupByLibrary.simpleMessage("無"),
    "noInfo": MessageLookupByLibrary.simpleMessage("無資訊"),
    "noMoreInfoDesc": MessageLookupByLibrary.simpleMessage("無更多資訊"),
    "noNetwork": MessageLookupByLibrary.simpleMessage("無網絡"),
    "noProxy": MessageLookupByLibrary.simpleMessage("無代理"),
    "noProxyDesc": MessageLookupByLibrary.simpleMessage(
      "請創建設定檔或新增有效的設定檔",
    ),
    "notEmpty": MessageLookupByLibrary.simpleMessage("不能為空"),
    "notSelectedTip": MessageLookupByLibrary.simpleMessage(
      "當前代理群組無法選擇。",
    ),
    "nullConnectionsDesc": MessageLookupByLibrary.simpleMessage(
      "無連線",
    ),
    "nullCoreInfoDesc": MessageLookupByLibrary.simpleMessage(
      "無法獲取核心資訊",
    ),
    "nullLogsDesc": MessageLookupByLibrary.simpleMessage("無日誌"),
    "nullProfileDesc": MessageLookupByLibrary.simpleMessage(
      "無設定檔，請新增設定檔",
    ),
    "nullProxies": MessageLookupByLibrary.simpleMessage("無代理"),
    "nullRequestsDesc": MessageLookupByLibrary.simpleMessage("無請求"),
    "oneColumn": MessageLookupByLibrary.simpleMessage("一欄"),
    "onlyIcon": MessageLookupByLibrary.simpleMessage("圖標"),
    "onlyOtherApps": MessageLookupByLibrary.simpleMessage(
      "僅第三方應用程式",
    ),
    "onlyStatisticsProxy": MessageLookupByLibrary.simpleMessage(
      "僅統計代理",
    ),
    "onlyStatisticsProxyDesc": MessageLookupByLibrary.simpleMessage(
      "開啟後，僅統計代理流量",
    ),
    "options": MessageLookupByLibrary.simpleMessage("選項"),
    "other": MessageLookupByLibrary.simpleMessage("其他"),
    "otherContributors": MessageLookupByLibrary.simpleMessage(
      "其他貢獻者",
    ),
    "outboundMode": MessageLookupByLibrary.simpleMessage("出站模式"),
    "override": MessageLookupByLibrary.simpleMessage("覆蓋"),
    "overrideDesc": MessageLookupByLibrary.simpleMessage(
      "覆蓋代理相關配置",
    ),
    "overrideDns": MessageLookupByLibrary.simpleMessage("覆蓋 DNS"),
    "overrideDnsDesc": MessageLookupByLibrary.simpleMessage(
      "開啟後將覆蓋設定檔中的 DNS 選項",
    ),
    "password": MessageLookupByLibrary.simpleMessage("密碼"),
    "passwordTip": MessageLookupByLibrary.simpleMessage(
      "密碼不能為空",
    ),
    "paste": MessageLookupByLibrary.simpleMessage("貼上"),
    "pleaseBindWebDAV": MessageLookupByLibrary.simpleMessage(
      "請綁定 WebDAV",
    ),
    "pleaseInputAdminPassword": MessageLookupByLibrary.simpleMessage(
      "請輸入管理員密碼",
    ),
    "pleaseUploadFile": MessageLookupByLibrary.simpleMessage(
      "請上傳檔案",
    ),
    "pleaseUploadValidQrcode": MessageLookupByLibrary.simpleMessage(
      "請上傳有效的 QR 碼",
    ),
    "port": MessageLookupByLibrary.simpleMessage("端口"),
    "preferH3Desc": MessageLookupByLibrary.simpleMessage(
      "優先使用 DOH 的 http/3",
    ),
    "pressKeyboard": MessageLookupByLibrary.simpleMessage(
      "請按鍵盤。",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("預覽"),
    "profile": MessageLookupByLibrary.simpleMessage("設定檔"),
    "profileAutoUpdateIntervalInvalidValidationDesc":
        MessageLookupByLibrary.simpleMessage(
          "請輸入有效的間隔時間格式",
        ),
    "profileAutoUpdateIntervalNullValidationDesc":
        MessageLookupByLibrary.simpleMessage(
          "請輸入自動更新間隔時間",
        ),
    "profileHasUpdate": MessageLookupByLibrary.simpleMessage(
      "設定檔已修改。您想停用自動更新嗎？",
    ),
    "profileNameNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "請輸入設定檔名稱",
    ),
    "profileParseErrorDesc": MessageLookupByLibrary.simpleMessage(
      "設定檔解析錯誤",
    ),
    "profileUrlInvalidValidationDesc": MessageLookupByLibrary.simpleMessage(
      "請輸入有效的設定檔 URL",
    ),
    "profileUrlNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "請輸入設定檔 URL",
    ),
    "profiles": MessageLookupByLibrary.simpleMessage("設定檔"),
    "profilesSort": MessageLookupByLibrary.simpleMessage("設定檔排序"),
    "project": MessageLookupByLibrary.simpleMessage("項目"),
    "providers": MessageLookupByLibrary.simpleMessage("提供者"),
    "proxies": MessageLookupByLibrary.simpleMessage("代理"),
    "proxiesSetting": MessageLookupByLibrary.simpleMessage("代理設定"),
    "proxyGroup": MessageLookupByLibrary.simpleMessage("代理群組"),
    "proxyNameserver": MessageLookupByLibrary.simpleMessage("代理名稱伺服器"),
    "proxyNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "用於解析代理節點的域名",
    ),
    "proxyPort": MessageLookupByLibrary.simpleMessage("代理端口"),
    "proxyPortDesc": MessageLookupByLibrary.simpleMessage(
      "設定 Clash 監聽端口",
    ),
    "proxyProviders": MessageLookupByLibrary.simpleMessage("代理提供者"),
    "pureBlackMode": MessageLookupByLibrary.simpleMessage("純黑模式"),
    "qrcode": MessageLookupByLibrary.simpleMessage("QR 碼"),
    "qrcodeDesc": MessageLookupByLibrary.simpleMessage(
      "掃描 QR 碼以獲取設定檔",
    ),
    "recovery": MessageLookupByLibrary.simpleMessage("恢復"),
    "recoveryAll": MessageLookupByLibrary.simpleMessage("恢復所有資料"),
    "recoveryProfiles": MessageLookupByLibrary.simpleMessage(
      "僅恢復設定檔",
    ),
    "recoverySuccess": MessageLookupByLibrary.simpleMessage("恢復成功"),
    "regExp": MessageLookupByLibrary.simpleMessage("正則表達式"),
    "remote": MessageLookupByLibrary.simpleMessage("遠端"),
    "remoteBackupDesc": MessageLookupByLibrary.simpleMessage(
      "將本地資料備份到 WebDAV",
    ),
    "remoteRecoveryDesc": MessageLookupByLibrary.simpleMessage(
      "從 WebDAV 恢復資料",
    ),
    "remove": MessageLookupByLibrary.simpleMessage("移除"),
    "requests": MessageLookupByLibrary.simpleMessage("請求"),
    "requestsDesc": MessageLookupByLibrary.simpleMessage(
      "查看最近請求記錄",
    ),
    "reset": MessageLookupByLibrary.simpleMessage("重置"),
    "resetTip": MessageLookupByLibrary.simpleMessage("確認重置"),
    "resources": MessageLookupByLibrary.simpleMessage("資源"),
    "resourcesDesc": MessageLookupByLibrary.simpleMessage(
      "外部資源相關資訊",
    ),
    "respectRules": MessageLookupByLibrary.simpleMessage("遵守規則"),
    "respectRulesDesc": MessageLookupByLibrary.simpleMessage(
      "DNS 連線遵循規則，需配置代理-伺服器-名稱伺服器",
    ),
    "routeAddress": MessageLookupByLibrary.simpleMessage("路由地址"),
    "routeAddressDesc": MessageLookupByLibrary.simpleMessage(
      "配置監聽路由地址",
    ),
    "routeMode": MessageLookupByLibrary.simpleMessage("路由模式"),
    "routeMode_bypassPrivate": MessageLookupByLibrary.simpleMessage(
      "繞過私有路由地址",
    ),
    "routeMode_config": MessageLookupByLibrary.simpleMessage("使用配置"),
    "ru": MessageLookupByLibrary.simpleMessage("俄語"),
    "rule": MessageLookupByLibrary.simpleMessage("規則"),
    "ruleProviders": MessageLookupByLibrary.simpleMessage("規則提供者"),
    "save": MessageLookupByLibrary.simpleMessage("儲存"),
    "search": MessageLookupByLibrary.simpleMessage("搜尋"),
    "seconds": MessageLookupByLibrary.simpleMessage("秒"),
    "selectAll": MessageLookupByLibrary.simpleMessage("全選"),
    "selected": MessageLookupByLibrary.simpleMessage("已選"),
    "settings": MessageLookupByLibrary.simpleMessage("設定"),
    "show": MessageLookupByLibrary.simpleMessage("顯示"),
    "shrink": MessageLookupByLibrary.simpleMessage("收縮"),
    "silentLaunch": MessageLookupByLibrary.simpleMessage("靜默啟動"),
    "silentLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "在背景啟動",
    ),
    "size": MessageLookupByLibrary.simpleMessage("大小"),
    "sort": MessageLookupByLibrary.simpleMessage("排序"),
    "source": MessageLookupByLibrary.simpleMessage("來源"),
    "stackMode": MessageLookupByLibrary.simpleMessage("堆疊模式"),
    "standard": MessageLookupByLibrary.simpleMessage("標準"),
    "start": MessageLookupByLibrary.simpleMessage("開始"),
    "startVpn": MessageLookupByLibrary.simpleMessage("正在啟動 VPN..."),
    "status": MessageLookupByLibrary.simpleMessage("狀態"),
    "statusDesc": MessageLookupByLibrary.simpleMessage(
      "關閉時將使用系統 DNS",
    ),
    "stop": MessageLookupByLibrary.simpleMessage("停止"),
    "stopVpn": MessageLookupByLibrary.simpleMessage("正在停止 VPN..."),
    "style": MessageLookupByLibrary.simpleMessage("樣式"),
    "submit": MessageLookupByLibrary.simpleMessage("提交"),
    "sync": MessageLookupByLibrary.simpleMessage("同步"),
    "system": MessageLookupByLibrary.simpleMessage("系統"),
    "systemFont": MessageLookupByLibrary.simpleMessage("系統字體"),
    "systemProxy": MessageLookupByLibrary.simpleMessage("系統代理"),
    "systemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "將 HTTP 代理附加到 VpnService",
    ),
    "tab": MessageLookupByLibrary.simpleMessage("標籤"),
    "tabAnimation": MessageLookupByLibrary.simpleMessage("標籤動畫"),
    "tabAnimationDesc": MessageLookupByLibrary.simpleMessage(
      "啟用後，主頁標籤將新增切換動畫",
    ),
    "tcpConcurrent": MessageLookupByLibrary.simpleMessage("TCP 並發"),
    "tcpConcurrentDesc": MessageLookupByLibrary.simpleMessage(
      "啟用後將允許 TCP 並發",
    ),
    "testUrl": MessageLookupByLibrary.simpleMessage("測試 URL"),
    "theme": MessageLookupByLibrary.simpleMessage("主題"),
    "themeColor": MessageLookupByLibrary.simpleMessage("主題顏色"),
    "themeDesc": MessageLookupByLibrary.simpleMessage(
      "設定暗色模式，調整顏色",
    ),
    "themeMode": MessageLookupByLibrary.simpleMessage("主題模式"),
    "threeColumns": MessageLookupByLibrary.simpleMessage("三欄"),
    "tight": MessageLookupByLibrary.simpleMessage("緊密"),
    "time": MessageLookupByLibrary.simpleMessage("時間"),
    "tip": MessageLookupByLibrary.simpleMessage("提示"),
    "toggle": MessageLookupByLibrary.simpleMessage("切換"),
    "tools": MessageLookupByLibrary.simpleMessage("工具"),
    "trafficUsage": MessageLookupByLibrary.simpleMessage("流量使用"),
    "tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "tunDesc": MessageLookupByLibrary.simpleMessage(
      "僅在管理員模式下有效",
    ),
    "twoColumns": MessageLookupByLibrary.simpleMessage("兩欄"),
    "unableToUpdateCurrentProfileDesc": MessageLookupByLibrary.simpleMessage(
      "無法更新當前設定檔",
    ),
    "unifiedDelay": MessageLookupByLibrary.simpleMessage("統一延遲"),
    "unifiedDelayDesc": MessageLookupByLibrary.simpleMessage(
      "移除握手等額外延遲",
    ),
    "unknown": MessageLookupByLibrary.simpleMessage("未知"),
    "update": MessageLookupByLibrary.simpleMessage("更新"),
    "upload": MessageLookupByLibrary.simpleMessage("上傳"),
    "url": MessageLookupByLibrary.simpleMessage("URL"),
    "urlDesc": MessageLookupByLibrary.simpleMessage(
      "透過 URL 獲取設定檔",
    ),
    "useHosts": MessageLookupByLibrary.simpleMessage("使用主機"),
    "useSystemHosts": MessageLookupByLibrary.simpleMessage("使用系統主機"),
    "value": MessageLookupByLibrary.simpleMessage("值"),
    "view": MessageLookupByLibrary.simpleMessage("查看"),
    "vpnDesc": MessageLookupByLibrary.simpleMessage(
      "修改 VPN 相關設定",
    ),
    "vpnEnableDesc": MessageLookupByLibrary.simpleMessage(
      "自動將所有系統流量透過 VpnService 路由",
    ),
    "vpnSystemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "將 HTTP 代理附加到 VpnService",
    ),
    "vpnTip": MessageLookupByLibrary.simpleMessage(
      "重啟 VPN 後更改生效",
    ),
    "webDAVConfiguration": MessageLookupByLibrary.simpleMessage(
      "WebDAV 配置",
    ),
    "whitelistMode": MessageLookupByLibrary.simpleMessage("白名單模式"),
    "years": MessageLookupByLibrary.simpleMessage("年"),
    "zh_CN": MessageLookupByLibrary.simpleMessage("簡體中文"),
  };
}
