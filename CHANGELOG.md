## v2.0.2

- 修复 Android 应用内更新安装失败：发布 ARMv8 / ARMv7 / x64 分架构 APK，避免下载固定 arm64 包导致 ABI 不匹配
- 修复 Android release 签名门禁：缺少正式 keystore 或签名参数时直接失败，避免 debug 签名包无法覆盖正式版
- 更新：Android 发布包拆分为 ARMv8、ARMv7、x64，应用内更新按设备 ABI 自动选择

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
