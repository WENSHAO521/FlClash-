## v2.0.22

- Bump version to 2.0.22

- Fix invalid workflow file: v2.0.21's build.yaml used `secrets.X != ''`

- directly inside step `if:` conditions, but the `secrets` context is

- not a recognized named-value there (GitHub Actions rejected the whole

- workflow file with "Unrecognized named-value: 'secrets'"), so neither

- v2.0.21 tag push actually ran any jobs. Route the presence checks

- through job-level env vars (HAS_TELEGRAM_TOKEN / HAS_SSH_DEPLOY_KEY)

- instead, since `env` is valid inside `if:`.

## v2.0.21

- Bump version to 2.0.21

- All platform builds (Test, Linux x2, Windows x2, macOS x2, Android)

- succeeded on v2.0.20, confirming the earlier fixes. The "upload" job

- still failed, though: the Telegram-bot-api service and its

- TELEGRAM_API_ID/TELEGRAM_API_HASH/TELEGRAM_BOT_TOKEN secrets were

- never configured in this repo, so "Push to telegram" errored with a

- connection refused, which (with no `if` guard) blocked every

- following step in that job -- including the actual "Release" step

- that publishes the GitHub release.

- Guard "Push to telegram" on TELEGRAM_BOT_TOKEN being set, and guard

- "Push to fdroid repo" on SSH_DEPLOY_KEY being set, so these optional

- integrations skip gracefully instead of blocking the release when

- unconfigured.

## v2.0.20

- Bump version to 2.0.20

- Align Android applicationId with the real Firebase project. The

- google-services.json downloaded from the Firebase console only

- registers the package name "panorama.secure.access", not

- "com.psg.internal", so committing it as-is would make the Google

- Services Gradle plugin fail with "No matching client found for

- package name". Set applicationId to panorama.secure.access to match,

- and commit the real (non-secret) google-services.json in place of

- the placeholder.

## v2.0.19

- Bump version to 2.0.19

- Fix Android CI build: SERVICE_JSON secret referenced by the

- "Setup Android Signing" step was never actually created in this repo

- (only KEYSTORE/KEY_ALIAS/KEY_PASSWORD/STORE_PASSWORD exist), so CI

- overwrote android/app/google-services.json with an empty string,

- and the Google Services Gradle plugin failed with "Malformed root

- json". Only decode/overwrite the file when the secret is present,

- otherwise keep the placeholder google-services.json already

- committed in the repo.

## v2.0.18

- Bump version to 2.0.18

- Fix Linux packaging build failure: distribute_options.yaml's top-level

- app_name was set to the spaced display string "Panorama Secure Access",

- which flutter_distributor's RPM/AppImage makers use directly as an

- identifier (RPM spec "Name:" tag, AppImage .desktop Exec/dir names).

- RPM's Name tag rejects whitespace ("Tag takes single token only"),

- which broke the whole v2.0.17 build matrix via CI's fail-fast.

- Reverted to the single-token "PSA", matching the binary/executable

- name already used everywhere else (linux/CMakeLists.txt BINARY_NAME,

- windows executable_name).

## v2.0.17

- Bump version to 2.0.17

- Fix Dependabot alerts by bumping golang.org/x/net (>=0.55.0),

- golang.org/x/crypto (>=0.51.0), and golang.org/x/oauth2 (>=0.27.0)

- in core/go.mod, resolving all 7 open Go vulnerability alerts.

- Also restore several correctness fixes that "Apply Panorama Secure

- Access branding" (de8397d) accidentally reverted by overwriting files

- with a stale pre-branding snapshot:

- - core/hub.go: geo updater calls used WithPath variants that no longer

-   exist in the Clash.Meta submodule, breaking the Go core build entirely.

- - lib/core/service.dart & transport.dart: guarded IPC startup and

-   helper-based core start (from "Guard core IPC startup").

- - lib/providers/action.dart: connectCore() failure now stops

-   restartCore() from calling initCore() (from "Stop init after core

-   connection failure"), and updateLocalIp() is called again after

-   admin/tun requests.

- - lib/common/system.dart: Windows helper service binary-path

-   verification (parseServiceBinaryPath/isSameWindowsPath), legacy

-   service cleanup, and user-facing error notification on registration

-   failure.

- - lib/common/constant.dart & request.dart: legacyAppHelperService

-   constant and getHelperLogs()/Result<bool> diagnostics for the

-   Windows helper.

- - lib/common/utils.dart & task.dart: preferred-interface local IP

-   detection and Windows-specific tun auto-detect-interface/strict-route

-   settings.

- - android: applicationId restored to com.psg.internal (matches the

-   existing PSG signing keystore/CI secrets; "com.follow.clash" was

-   upstream FlClash's id) and REQUEST_INSTALL_PACKAGES permission

-   restored.

- Also bump CI's pinned Go version to 1.25.0 to match the new go.mod

- minimum required by the updated golang.org/x/* modules.

## v2.0.16

- Bump version to 2.0.16

- Ignore .secrets/ (keystore and CI secrets should never be tracked).

## v2.0.15

- Bump version to 2.0.15

- Apply Panorama Secure Access branding

## v2.0.14

- Stop init after core connection failure

## v2.0.13

- Guard core IPC startup

## v2.0.12

- Improve Windows helper install cleanup

## v2.0.11

- Align Windows helper service name

## v2.0.10

- Strengthen Windows TUN routing

## v2.0.9

- Clean helper service during Windows install

## v2.0.8

- Fix Windows helper registration flow

## v2.0.7

- Fix helper startup result analysis

## v2.0.6

- Bump version to 2.0.6

- Fix Windows helper core startup diagnostics

## v2.0.5

- Use flat transparent logo assets

- Restore config default tests

- Restore upstream network defaults

## v2.0.4

- Release 2.0.4 TUN DNS routing

## v2.0.3

- Install macOS Rust targets in CI

- Update Go security dependencies

- Refine DNS presets for global and complex networks

- Release 2.0.3 policy copy updates

## v2.0.2

- Improve DNS preset compatibility

- Split Android release APKs by ABI

- Publish Android APK artifact

- Ignore local Android signing secrets

- Update setup tests for universal Android APK

- Fix Android update packaging for 2.0.2

- chore(deps): Bump golang.org/x/net from 0.35.0 to 0.55.0 in /core

- Bumps [golang.org/x/net](https://github.com/golang/net) from 0.35.0 to 0.55.0.

- - [Commits](https://github.com/golang/net/compare/v0.35.0...v0.55.0)

- ---

- updated-dependencies:

- - dependency-name: golang.org/x/net

-   dependency-version: 0.55.0

-   dependency-type: indirect

- ...

- Signed-off-by: dependabot[bot] <support@github.com>

## v2.0.1

- Update geo updater API usage

- Fix CI platform packaging prerequisites

- Normalize wrapper Go modules in CI

- Remove duplicate Linux diagnostic build

- Restore upstream submodule packaging flow

- Align CI packaging with upstream workflow

- Normalize Go core modules in CI

- Fix flutter distributor executable

- Fix CI distributor invocation

- Release 2.0.1 privacy and DNS updates

## v2.0.0

- release: v2.0.0 - restore full linux targets, add changelog entry

- Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>

## v2.0.0-rc7

- fix: remove UTF-8 BOM from project.pbxproj (fixes CocoaPods nanaimo parse error)

- BOM (EF BB BF) was introduced when editing project.pbxproj on Windows.

- CocoaPods nanaimo parser fails with ParseError on the BOM character.

- Affects both macOS arm64 and macOS amd64 builds.

- Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>

## v2.0.0-rc6

- fix: restore execute permissions on all shell scripts

- ZIP extraction strips +x bits; run_build_tool.sh and build_pod.sh

- need to be executable for CMake to invoke them directly.

- Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>

## v2.0.0-rc5

- fix: add fail-fast: false so platform failures are independent

- Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>

## v2.0.0-rc4

- fix: use submodule update --init --recursive instead of --shallow-submodules

- --shallow-submodules can fail to fetch exact pinned commit hashes inside

- Clash.Meta; switching to explicit submodule update with full depth so

- nested Go/native dependencies are always correctly initialized.

- Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>

## v2.0.0-rc3

- fix: add --recurse-submodules to clone steps to match FlClash original

- Original FlClash uses submodules: recursive in checkout action which

- initializes all nested submodules. Our shallow clones without

- --recurse-submodules left nested submodules empty (e.g. inside

- Clash.Meta), causing Go build to fail during flutter build linux.

- Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>

## v2.0.0-rc2

- diag: add flutter build linux verbose step to capture cmake errors

- Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>

## v2.0.0-rc1

- diag: limit linux-amd64 to deb-only to isolate AppImage/RPM failure

- Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>

- fix: pre-extract appimagetool to avoid FUSE dependency in CI

- Instead of relying on APPIMAGE_EXTRACT_AND_RUN propagating through the

- full process chain (dart -> flutter_distributor -> appimagetool), extract

- appimagetool to a native binary before setup.dart runs. setup.dart detects

- the pre-installed binary and skips its own download; flutter_distributor

- then calls the extracted AppRun which has no FUSE dependency.

- Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>

- fix: set app_name=PSA in distribute_options for correct artifact filenames

- flutter_distributor uses app_name as the artifact filename prefix.

- 'Panorama Secure Access' produces filenames with spaces; PSA matches

- the expected PSA-{version}-{platform}-{arch}.{ext} format used by

- the in-app updater and release template.

- Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>

- fix: add APPIMAGE_EXTRACT_AND_RUN=1 to bypass FUSE in CI

- appimagetool is itself an AppImage and needs FUSE to run in GitHub

- Actions containers. APPIMAGE_EXTRACT_AND_RUN=1 makes it extract and

- run without mounting via FUSE.

- Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>

- chore: rename repo references to panorama-secure-access

- Also fix release_template.md artifact prefix PSG- -> PSA-

- Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>

- fix: replace submodule gitlinks with explicit HTTPS clones in CI

- Submodules were never registered as gitlinks (fresh git init from zip).

- Replace 'submodules: recursive' with manual shallow clones to fix

- 'flutter pub get' failure for tray_manager and flutter_distributor.

- Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>

- chore: rename publisher to Panorama Scholarly Group

- Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>

- docs: rewrite README for Panorama Secure Access (PSG)

- Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>

- chore: bump version to 2.0.0+1

- Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>

- feat: rebrand to Panorama Secure Access (PSG)

- - Rename app to Panorama Secure Access across all platforms

- - Replace all logos with glassmorphism panorama/security design

- - Update Windows binary name to PSA.exe

- - Fix macOS podspec core binary reference (PSGCore)

- - Update all platform manifests, configs, and packaging metadata

- - Change TUN device default to PSA (Linux 15-char limit)

- - Update download artifact URLs to PSA-version prefix

- - Add PSG official branding to About page

- Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>

## v0.8.93

- Support custom overwrite

- Support run on demand

- Optimize windows ipc

- Optimize windows arm64

- Optimize build

- Optimize some details

- Update core

## v0.8.92

- Add sqlite store

- Optimize android quick action

- Optimize backup and restore

- Optimize more details

## v0.8.91

- Fix windows some issues

- Optimize overwrite handle

- Optimize access control page

- Optimize some details

## v0.8.90

- Fix android tile service

- Support append system DNS

- Fix some issues

- Update changelog

## v0.8.89

- Fix some issues

- Optimize Windows service mode

- Update core

- Update changelog

## v0.8.88

- Add android separates the core process

- Support core status check and force restart

- Optimize proxies page and access page

- Update flutter and pub dependencies

- Update go version

- Optimize more details

- Update changelog

## v0.8.87

- Optimize desktop view

- Optimize logs, requests, connection pages

- Optimize windows tray auto hide

- Optimize some details

- Update core

- Update changelog

## v0.8.86

- Fix windows tun issues

- Optimize android get system dns

- Optimize more details

- Update changelog

## v0.8.85

- Support override script

- Support proxies search

- Support svg display

- Optimize config persistence

- Add some scenes auto close connections

- Update core

- Optimize more details

## v0.8.84

- Fix windows service verify issues

- Update changelog

## v0.8.83

- Add windows server mode start process verify

- Add linux deb dependencies

- Add backup recovery strategy select

- Support custom text scaling

- Optimize the display of different text scale

- Optimize windows setup experience

- Optimize startTun performance

- Optimize android tv experience

- Optimize default option

- Optimize computed text size

- Optimize hyperOS freeform window

- Add developer mode

- Update core

- Optimize more details

- Add issues template

- Update changelog

## v0.8.82

- Optimize android vpn performance

- Add custom primary color and color scheme

- Add linux nad windows arm release

- Optimize requests and logs page

- Fix map input page delete issues

- Update changelog

## v0.8.81

- Add rule override

- Update core

- Optimize more details

- Update changelog

## v0.8.80

- Optimize dashboard performance

- Fix some issues

- Fix unselected proxy group delay issues

- Fix asn url issues

- Update changelog

## v0.8.79

- Fix tab delay view issues

- Fix tray action issues

- Fix get profile redirect client ua issues

- Fix proxy card delay view issues

- Add Russian, Japanese adaptation

- Fix some issues

- Update changelog

## v0.8.78

- Fix list form input view issues

- Fix traffic view issues

- Update changelog

## v0.8.77

- Optimize performance

- Update core

- Optimize core stability

- Fix linux tun authority check error

- Fix some issues

- Fix scroll physics error

- Update changelog

## v0.8.75

- Add windows storage corruption detection

- Fix core crash caused by windows resource manager restart

- Optimize logs, requests, access to pages

- Fix macos bypass domain issues

- Update changelog

## v0.8.74

- Fix some issues

- Update changelog

## v0.8.73

- Update popup menu

- Add file editor

- Fix android service issues

- Optimize desktop background performance

- Optimize android main process performance

- Optimize delay test

- Optimize vpn protect

- Update changelog

## v0.8.72

- Update core

- Fix some issues

- Update changelog

## v0.8.71

- Remake dashboard

- Optimize theme

- Optimize more details

- Update flutter version

- Update changelog

## v0.8.70

- Support better window position memory

- Add windows arm64 and linux arm64 build script

- Optimize some details

## v0.8.69

- Remake desktop

- Optimize change proxy

- Optimize network check

- Fix fallback issues

- Optimize lots of details

- Update change.yaml

- Fix android tile issues

- Fix windows tray issues

- Support setting bypassDomain

- Update flutter version

- Fix android service issues

- Fix macos dock exit button issues

- Add route address setting

- Optimize provider view

- Update changelog

- Update CHANGELOG.md

## v0.8.67

- Add android shortcuts

- Fix init params issues

- Fix dynamic color issues

- Optimize navigator animate

- Optimize window init

- Optimize fab

- Optimize save

## v0.8.66

- Fix the collapse issues

- Add fontFamily options

## v0.8.65

- Update core version

- Update flutter version

- Optimize ip check

- Optimize url-test

## v0.8.64

- Update release message

- Init auto gen changelog

- Fix windows tray issues

- Fix urltest issues

- Add auto changelog

- Fix windows admin auto launch issues

- Add android vpn options

- Support proxies icon configuration

- Optimize android immersion display

- Fix some issues

- Optimize ip detection

- Support android vpn ipv6 inbound switch

- Support log export

- Optimize more details

- Fix android system dns issues

- Optimize dns default option

- Fix some issues

- Update readme

## v0.8.60

- Fix build error2

- Fix build error

- Support desktop hotkey

- Support android ipv6 inbound

- Support android system dns

- fix some bugs

## v0.8.59

- Fix delete profile error

## v0.8.58

- Fix submit error 2

- Fix submit error

- Optimize DNS strategy

- Fix the problem that the tray is not displayed in some cases

- Optimize tray

- Update core

- Fix some error

## v0.8.57

- Fix tun update issues

- Add DNS override
- Fixed some bugs
- Optimize more detail

- Add Hosts override

## v0.8.56

- fix android tip error
- fix windows auto launch error

## v0.8.55

- Fix windows tray issues

- Optimize windows logic

- Optimize app logic

- Support windows administrator auto launch

- Support android close vpn

## v0.8.53

- Change flutter version

- Support profiles sort

- Support windows country flags display

- Optimize proxies page and profiles page columns

## v0.8.52

- Update flutter version

- Update version

- Update timeout time

- Update access control page

- Fix bug

## v0.8.51

- Optimize provider page

- Optimize delay test

- Support local backup and recovery

- Fix android tile service issues

## v0.8.49

- Fix linux core build error

- Add proxy-only traffic statistics

- Update core

- Optimize more details

- Merge pull request #140 from txyyh/main

- 添加自建 F-Droid 仓库相关 workflow
- Rename readme fingerprint

- Rename workflow deploy repo name

- Add download guide to README

- Add push release files to fdroid-repo

## v0.8.48

- Optimize proxies page

- Fix ua issues

- Optimize more details

## v0.8.47

- Fix windows build error

## v0.8.46

- Update app icon

- Fix desktop backup error

- Optimize request ua

- Change android icon

- Optimize dashboard

## v0.8.44

- Remove request validate certificate

- Sync core

## v0.8.43

- Fix windows error

## v0.8.42

- Fix setup.dart error

- Fix android system proxy not effective

- Add macos arm64

## v0.8.41

- Optimize proxies page

- Support mouse drag scroll

- Adjust desktop ui

- Revert "Fix android vpn issues"

- This reverts commit 891977408e6938e2acd74e9b9adb959c48c79988.

## v0.8.40

- Fix android vpn issues

- Fix android vpn issues

- Rollback partial modification

## v0.8.39

- Fix the problem that ui can't be synchronized when android vpn is occupied by an external

- Override default socksPort,port

## v0.8.38

- Fix fab issues

## v0.8.37

- Update version

- Fix the problem that vpn cannot be started in some cases

- Fix the problem that geodata url does not take effect

## v0.8.36

- Update ua

- Fix change outbound mode without check ip issues

- Separate android ui and vpn

- Fix url validate issues 2

- Add android hidden from the recent task

- Add geoip file

- Support modify geoData URL

## v0.8.35

- Fix url validate issues

- Fix check ip performance problem

- Optimize resources page

## v0.8.34

- Add ua selector

- Support modify test url

- Optimize android proxy

- Fix the error that async proxy provider could not selected the proxy

## v0.8.33

- Fix android proxy error

- Fix submit error

- Add windows tun

- Optimize android proxy

- Optimize change profile

- Update application ua

- Optimize delay test

## v0.8.32

- Fix android repeated request notification issues

## v0.8.31

- Fix memory overflow issues

## v0.8.30

- Optimize proxies expansion panel 2

- Fix android scan qrcode error

## v0.8.29

- Optimize proxies expansion panel

- Fix text error

## v0.8.28

- Optimize proxy

- Optimize delayed sorting performance

- Add expansion panel proxies page

- Support to adjust the proxy card size

- Support to adjust proxies columns number

- Fix autoRun show issues

- Fix Android 10 issues

- Optimize ip show

## v0.8.26

- Add intranet IP display

- Add connections page

- Add search in connections, requests

- Add keyword search in connections, requests, logs

- Add basic viewing editing capabilities

- Optimize update profile

## v0.8.25

- Update version

- Fix the problem of excessive memory usage in traffic usage.

- Add lightBlue theme color

- Fix start unable to update profile issues

- Fix flashback caused by process

## v0.8.23

- Add build version

- Optimize quick start

- Update system default option

## v0.8.22

- Update build.yml

- Fix android vpn close issues

- Add requests page

- Fix checkUpdate dark mode style error

- Fix quickStart error open app

- Add memory proxies tab index

- Support hidden group

- Optimize logs

- Fix externalController hot load error

## v0.8.21

- Add tcp concurrent switch

- Add system proxy switch

- Add geodata loader switch

- Add external controller switch

- Add auto gc on trim memory

- Fix android notification error

## v0.8.20

- Fix ipv6 error

- Fix android udp direct error

- Add ipv6 switch

- Add access all selected button

- Remove android low version splash

## v0.8.19

- Update version

- Add allowBypass

- Fix Android only pick .text file issues

## v0.8.18

- Fix search issues

## v0.8.17

- Fix LoadBalance, Relay load error

- Fix build.yml4

- Fix build.yml3

- Fix build.yml2

- Fix build.yml

- Add search function at access control

- Fix the issues with the profile add button to cover the edit button

- Adapt LoadBalance and Relay

- Add arm

- Fix android notification icon error

## v0.8.16

- Add one-click update all profiles
- Add expire show

## v0.8.15

- Temp remove tun mode

- Remove macos in workflow

- Change go version

## v0.8.14

- Update Version

- Fix tun unable to open

## v0.8.13

- Optimize delay test2

- Optimize delay test

- Add check ip

- add check ip request

## v0.8.12

- Fix the problem that the download of remote resources failed after GeodataMode was turned on, which caused the
  application to flash back.

- Fix edit profile error

- Fix quickStart change proxy error

- Fix core version

## v0.8.10

- Fix core version

## v0.8.9

- Update file_picker

- Add resources page

- Optimize more detail

- Add access selected sorted

- Fix notification duplicate creation issue

- Fix AccessControl click issue

## v0.8.7

- Fix Workflow

- Fix Linux unable to open

- Update README.md 3

- Create LICENSE
- Update README.md 2

- Update README.md

- Optimize workFlow

## v0.8.6

- optimize checkUpdate

## v0.8.5

- Fix submit error

## v0.8.4

- add WebDAV

- add Auto check updates

- Optimize more details

- optimize delayTest

## v0.8.2

- upgrade flutter version

## v0.8.1

- Update kernel
- Add import profile via QR code image

## v0.8.0

- Add compatibility mode and adapt clash scheme.

## v0.7.14

- update Version

- Reconstruction application proxy logic

## v0.7.13

- Fix Tab destroy error

## v0.7.12

- Optimize repeat healthcheck

## v0.7.11

- Optimize Direct mode ui

## v0.7.10

- Optimize Healthcheck

- Remove proxies position animation, improve performance
- Add Telegram Link

- Update healthcheck policy

- New Check URLTest

- Fix the problem of invalid auto-selection

## v0.7.8

- New Async UpdateConfig

- add changeProfileDebounce

- Update Workflow

- Fix ChangeProfile block

- Fix Release Message Error

## v0.7.7

- Update Selector 2

## v0.7.6

- Update Version

- Fix Proxies Select Error

## v0.7.5

- Fix the problem that the proxy group is empty in global mode.

- Fix the problem that the proxy group is empty in global mode.

## v0.7.4

- Add ProxyProvider2

## v0.7.3

- Add ProxyProvider

- Update Version

- Update ProxyGroup Sort

- Fix Android quickStart VpnService some problems

## v0.7.1

- Update version

- Set Android notification low importance

- Fix the issue that VpnService can't be closed correctly in special cases

- Fix the problem that TileService is not destroyed correctly in some cases

- Adjust tab animation defaults

- Add Telegram in README_zh_CN.md

- Add Telegram

## v0.7.0

- update mobile_scanner

- Initial commit