## v2.0.7

- Windows：修复 v2.0.6 构建分析失败，改用显式 `ResultType` 判断 helper 启动结果

## v2.0.6

- Windows：修复旧版 helper 服务残留或 token/hash 不匹配时 TUN 无法启动的问题，自动重装当前版本 `PSGHelperService`
- Windows：helper 启动 `PSGCore` 失败时显示具体错误并记录 helper 日志，避免虚拟网卡静默失效

## v2.0.5

- 网络：恢复原版 FlClash 的 DNS、VPN、TUN 配置生成与代理连接管理行为，仅保留 Panorama Secure Access 品牌和发布构建改动
- DNS：移除此前新增的“全球隐私优先 / 中国网络兼容”预设与自动迁移逻辑，默认回到原版 nameserver、fallback、fallback-filter 与 system DNS 追加策略
- 稳定性：撤回非原版的超时、测速、连接更新和生命周期改动，降低单站点访问异常时的软件侧变量
- 品牌：官方 Logo 与全平台应用图标改为透明底扁平样式，移除玻璃底板、渐变、高光和半透明效果

## v2.0.4

- DNS：优化 TUN 场景下的全球隐私优选，用户域名 DoH 按规则路由，代理节点域名使用兼容 bootstrap，降低 DNS 泄露与复杂网络连接中断风险
- DNS：旧版全球直连 DoH 预设会自动迁移到新的 TUN 兼容方案，减少 browserscan 等站点出现 ERR_CONNECTION_CLOSED 的情况

## v2.0.3

- 法务：免责声明主体统一为 Panorama Secure Access，并同步 en / zh_CN / ja / ru
- DNS：明确全球网络优先隐私与速度，中国大陆等复杂网络优先兼容与稳定，并持续兼顾安全、隐私与解析效率
- DNS：全球默认采用 Cloudflare / Quad9 / Google 多供应商 DoH 冗余，中国网络兼容预设采用区域加密 DNS，避免复杂网络下默认回落海外 DoH 导致解析失败
- DNS：全球隐私优选与中国网络兼容预设默认关闭 HTTP/3 DNS，提高复杂网络下的解析稳定性
- 安全：升级 Go 核心依赖 golang.org/x/crypto 与 golang.org/x/oauth2，消除 OSV 已知告警
- Android：发布包拆分为 ARMv8、ARMv7、x64，应用内更新按设备 ABI 自动选择

## v2.0.2

- 修复 Android 应用内更新安装失败：发布 ARMv8 / ARMv7 / x64 分架构 APK，避免下载固定 arm64 包导致 ABI 不匹配
- 修复 Android release 签名门禁：缺少正式 keystore 或签名参数时直接失败，避免 debug 签名包无法覆盖正式版
- 更新：Android 发布包拆分为 ARMv8、ARMv7、x64，应用内更新按设备 ABI 自动选择
- DNS：全球隐私优选关闭默认 HTTP/3 DNS，提升海外网络和受限网络下的解析稳定性

## v2.0.1

- 法务：重写免责声明，明确授权范围、合规用途、用户责任和责任限制，并同步 en / zh_CN / ja / ru
- DNS：默认改为全球隐私优先的加密公共 DNS，关闭系统 DNS 静默回退，降低 DNS 泄露风险
- DNS：新增“中国网络兼容”预设，由用户显式启用区域加密 DNS，提高中国网络环境下的可达性
- 隐私：默认启用 DNS 覆写、DNS 劫持保护和规则跟随，降低本机 IP 与 DNS 泄露风险
- 性能：修复代理延迟测试批处理逻辑，避免一次性创建过多测速任务

## v2.0.0

- 正式发布 Panorama Secure Access 2.0，基于最新 ClashMeta (mihomo) 核心
- 全平台支持：Android、Windows (x64/ARM64)、macOS (Intel/Apple Silicon)、Linux (x64/ARM64)
- 品牌全面升级为 Panorama Scholarly Group (PSG) 设计语言
- Material You 自适应界面，支持动态取色
- 修复 CI 全平台构建流程（Go 核心权限、CocoaPods BOM 解析、子模块依赖）

## v1.0.8

- 修复：统一四端 LOGO（macOS / Windows / Android Play Store 均替换为 PSG 黑底白字设计，此前仍显示旧版 FlClash 蓝色图标）

## v1.0.7

- 修复：下载完成后自动触发安装（Android 使用系统包安装器，Windows/macOS/Linux 自动打开安装包）
- 优化：更新下载进度弹窗 UI（圆角卡片、系统更新图标、文件名显示、更粗的进度条）

## v1.0.6

- 安全：修复 SSL 证书验证绕过漏洞，现仅对 localhost 跳过证书检查
- DNS：启用 HTTP/3 (QUIC) 优先，加快 DNS 解析速度
- DNS：fallback DNS 由 DoT(853端口) 改为 DoH(HTTPS 443端口)，更稳定且难被封锁
- 性能：TCP keepAlive 间隔由 30s 降至 15s，不稳定网络下连接恢复更快

## v1.0.5

- 安全：新增 PIN 锁屏功能（启动时、从后台返回时验证，支持自动锁定超时）
- 安全：PIN 以 SHA-256 哈希存储，支持设置/修改 PIN（修改时需验证旧 PIN）
- 更新：应用内下载安装包，显示实时进度条，支持取消

## v1.0.4

- 修复 Android 无法覆盖安装旧版问题（applicationId 改为 com.psg.internal，独立于原版 FlClash）
- 修复 Android 签名一致性问题（提交固定 keystore，每次构建签名一致）

## v1.0.3

- 图标全面更新为 Bauhaus 黑底几何 P 设计，四端统一，圆角处理
- 免责声明改为 PSG 内部工具专属说明
- 关于页「检查更新」确认后自动下载对应平台安装包

## v1.0.1

- 修复 Android 自适应图标被裁切问题（元素缩放至安全区）
- 修复 macOS 应用名称构建失败（PRODUCT_NAME = PSG）
- 修复所有残余 FlClash 字符串引用

## v1.0.0

- PSG 初版发布，基于 FlClash 完整品牌重塑
- Bauhaus 德式极简设计风格（黑白红配色）
- 支持 Android / Windows / macOS / Linux 四平台
