## v3.3.10

- Bump version to 3.3.10

- Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>

- Fix desktop dialog width regression from the AlertDialog -> Dialog + GlassSurface migration

- CommonDialog capped its content area at maxWidth: 300 while the outer

- Column used CrossAxisAlignment.start, so a wide title or actions row

- could stretch the GlassSurface past 300px while content (text fields,

- message text) stayed pinned at 300px, left-aligned, with dead space on

- the right. Affected every CommonDialog/InputDialog call site, not just

- the URL import dialog.

- Central fix in lib/widgets/dialog.dart: a responsive max width (560px

- default, 640px via a new opt-in isLarge flag, both clamped to the

- window size on desktop; screen width minus a safe inset on mobile) via

- ConstrainedBox, plus CrossAxisAlignment.stretch so title/content/

- actions always share that width instead of each shrink-wrapping

- independently. Public API is additive only (isLarge defaults false).

- Audited every CommonDialog/InputDialog call site: removed two

- now-redundant width: 300 hacks that would have fought the central fix

- (showMessage in state.dart, and dead code in profiles/add.dart's

- unused URLFormDialog); wrapped the palette and hotkey-recorder dialogs'

- genuinely-narrow content in Center so it doesn't end up left-aligned

- in the wider surface; marked the rule add/edit dialog isLarge (dropdown

- + field + dropdown + chips is the one genuinely content-heavy case).

- Everything else needed no changes since Wrap already passes a bounded

- max-width to its children.

- Added test/widgets/dialog_test.dart covering the 560/640 caps, the

- mobile inset, the stretch behavior, a long title no longer widening

- the surface past the cap, long text still scrolling within a capped

- height, and no overflow across devicePixelRatio 1.0-3.0.

- Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>

## v3.3.9

- Bump version to 3.3.9

- Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>

- Regenerate core/go.sum after the golang.org/x/* version bumps

- The previous commit only bumped go.mod version constraints without

- go.sum, since no Go toolchain was available at the time — that broke

- every platform build in CI with "missing go.sum entry" errors (v3.3.8

- build run 32278684532).

- Ran `go mod tidy` in core/ for real this time, which also pulled in a

- few more transitive bumps (x/mod, x/sys, x/term, x/text, x/tools,

- x/sync) and raised the go directive to 1.25.0 to satisfy them — still

- well under CI's Go 1.26.4. Verified `go build ./...` succeeds locally.

- Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>

## v3.3.8

- Bump version to 3.3.8

- Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>

- Bump vulnerable golang.org/x/* deps in core/go.mod

- Addresses 20 open Dependabot alerts (7 critical) against

- golang.org/x/crypto, golang.org/x/net, and golang.org/x/oauth2 —

- all transitively pulled into core/go.mod at versions below their

- patched releases.

- go.sum is NOT regenerated here (no Go toolchain in this environment).

- Run `go mod tidy` inside core/ before building so the checksums and

- any further transitive bumps get resolved.

- Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>

- Bump version to 3.3.7

- Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>

- Fix sub-pages leaking the previous page's content through glass gaps

- CommonRoute/CommonDesktopRoute were deliberately non-opaque so a

- transparent Scaffold could reveal the single AmbientBackground painted

- at the app shell root. That kept whatever page was underneath fully

- mounted and painted, so gaps between glass panels on a pushed page

- showed the actual content of the page behind it, not just the ambient

- gradient.

- Each pushed page now paints its own AmbientBackground and the routes

- are opaque again, so Flutter properly offstages the page underneath

- once the transition ends. Also drops the FloatLayout bottom-nav-bar

- avoidance hack in profiles/edit's floating save button, since the nav

- bar is no longer visible behind pushed pages.

- Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>

## v3.3.6

- Bump version to 3.3.6

- Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>

- Fix double-borders, dead-code input styling, and a sheet header regression

- An 8-agent review pass over the v3.3.5 glass token diff found and this

- fixes:

- - CommonCard painted its own border (_buildBorderSide) and GlassSurface's

-   new default border on the same outline, compositing to roughly double

-   the intended alpha on every idle proxy/provider card. GlassSurface.repeated

-   now gets showBorder: false so the button's own side: is the only source.

- - glassInputDecoration() was built as the opt-in replacement for the

-   removed global InputDecorationTheme but was never actually called,

-   leaving the profile editor, code editor find bar, general config's

-   port fields, backup/WebDAV fields, and InputDialog/AddDialog rendering

-   as bare unfilled outlines. Wired it into all of them.

- - The AdaptiveSheetScaffold rewrite's suffixPop positioning (move the

-   close button to the trailing slot when there are no other actions)

-   only survived in the bottom-sheet branch; the AppBar used for

-   SheetType.page/sideSheet ignored it, silently moving the close button

-   from trailing back to leading. Applied the same rule there.

- - sheetAppBarHeight (reserved top padding under a floating sheet header)

-   was stale against the new header's actual rendered height, clipping

-   a couple pixels of scrolled content at rest.

- Also removes a couple of now-dead symbols this same diff introduced

- (a deprecated alias with zero callers, a blur constant hand-synced with

- GlassTokens.blurChrome instead of just reading it).

- Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>

## v3.3.5

- Bump version to 3.3.5

- Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>

- Introduce a formal glass token system and fix the config editor regression

- The previous glass pass used a single flat opacity for every physical

- surface, which was wrong: a settings panel, a modal BottomSheet, and a

- repeated proxy card all need different opacity/blur. Replaces the ad-hoc

- glassPanelOpacity with GlassSurfaceType (chrome/panel/modal/floating/

- repeated) and GlassTokens, and migrates AppBar, NavigationBar, sidebar,

- title bar, dialogs, popups, toasts, and both sheet paths onto it.

- Fixes the config/profile editor regression the previous global

- InputDecorationTheme caused: removed the app-wide filled/fillColor/border

- forcing (every field already defines its own decoration), added an

- opt-in glassInputDecoration() helper, pulled the URL field out of a

- ListTile (which was silently capping it at one-line height), and fixed

- the Save FAB overlapping the still-visible HomePage bottom NavigationBar

- on pages pushed as non-opaque routes.

- Rebuilds the BottomSheet's glass hierarchy: the physical sheet previously

- had no BackdropFilter at all (only a flat, unblurred tint), so anything

- behind it — including the bottom NavigationBar — stayed sharply readable.

- Now wraps the whole sheet in one GlassSurface.modal, fixes the default

- modal barrier (Colors.black54 was excessively dark), rebuilds the header

- as a deterministic Row with reserved slot widths instead of AppBar's

- centring math, and drops CommonCard/strategy-button opacity to a

- repeated-tier value so it no longer reads as nested glass inside the

- sheet's own glass.

- Also fixes a dead/misleading opaque Colors.white/grey[900] override on

- the search-mode AppBar, and a raw Card badge and popup-menu rows that

- painted opaque backgrounds over their glass parents.

- Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>

## v3.3.4

- Bump version to 3.3.4

- Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>

- Fix nested opaque row backgrounds on Settings/Tools list

- ListItem.open's container-transform (package:animations) painted an

- opaque colorScheme.surface Material behind every row at rest, on top

- of the transparent AmbientBackground shell, which is what actually

- produced the near-solid white rows. Rows are now transparent, and each

- Tools/Settings section renders as a single glass panel (one

- BackdropFilter per group via a new generateGlassSection helper)

- instead of a flat divided list.

- Also makes glassPanelOpacity brightness-aware (0.36 light / 0.50 dark,

- down from a flat 0.62) and gives Dividers a low-alpha outlineVariant

- theme, so groups read as frosted glass instead of a stack of

- near-opaque cards.

- Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>

## v3.3.3

- Bump version to 3.3.3

- Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>

- Give dialogs real backdrop blur and unify status colors

- CommonDialog now wraps GlassSurface instead of AlertDialog's flat tint,

- matching the AppBar/NavBar/popup menu blur. Status colors (connected/

- warning) are now fixed semantic colors instead of ad hoc/inconsistent

- green-orange-red literals scattered across dashboard, backup/restore,

- groups, and rule views, and inputs/chips pick up glass-consistent

- theming globally.

- Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>

## v3.3.2

- Bump version to 3.3.2

- Fix unused import left over from the opaque-route fix

- Making CommonRoute/CommonDesktopRoute's transparent fillColor a

- literal Colors.transparent (instead of context.colorScheme.surface)

- removed the last use of common/common.dart in this file, which

- flutter analyze correctly flagged as a warning and failed the v3.3.1

- CI build at the Analyze step before it ever reached the actual builds.

## v3.3.1

- Bump version to 3.3.1

- Extend the glass system to popups, toasts, and full-page pushes

- - CommonPopupMenu (right-click/dropdown menus) and StatusManager's

-   floating toast card now use GlassSurface instead of an opaque Card.

- - The proxy list's sticky group header, and the group-tab-bar's

-   fade-to-background gradient, were still painting/fading to an

-   opaque colorScheme.surface — now glass/translucent to match the

-   AmbientBackground actually behind them.

- - The real fix for "nothing past the Tools list looks changed":

-   CommonRoute and CommonDesktopRoute (lib/common/navigator.dart) are

-   PageRoute subclasses and default to opaque=true. Once their push

-   transition finished, Flutter was offstaging whatever sat below them

-   in the same Navigator — on mobile, where each tab has no nested

-   Navigator of its own, that's HomePage itself, taking the

-   AmbientBackground down with it. Every full-page push (any

-   ListItem.open, which is most of Settings/Tools) was rendering on

-   nothing behind its own transparent Scaffold. Both routes now

-   override opaque to false.

## v3.3.0

- Bump version to 3.3.0

- Drop the ring from tray status icons, encode state by glyph color

- The dashed status ring around the P mark read as visual noise at tray

- size and wasn't wanted. status_1/2/3 are now just the P glyph itself,

- larger and centered, colored by state instead of ring-bordered:

- graphite gray (idle), violet gradient (running, system proxy), amber

- (running, TUN) — same semantic mapping as before, carried by the

- glyph's own color rather than a ring around it.

- Frosted-glass visual system across the app shell

- Adds a shared glass design system (lib/widgets/glass.dart):

- - AmbientBackground: one gradient + soft color-blob layer painted once

-   behind the whole app shell, derived from the active ColorScheme so

-   it follows dynamic color / the user's chosen primary automatically.

- - GlassSurface: translucent panel with an opt-in BackdropFilter blur.

-   Blur is real only where a surface can only appear once on screen at

-   a time (top bar, nav rail/bar, dialogs, settings groups); it's

-   skipped in favor of flat tint for anything that can appear dozens of

-   times at once (CommonCard, used in proxy grids/lists) since stacking

-   that many backdrop filters is a real scroll-jank risk.

- Wires it into the app shell: WindowHeader (desktop title bar),

- CommonScaffold's AppBar, the desktop nav rail and mobile nav bar,

- CommonCard/SettingsBlock, CommonDialog, and AdaptiveSheetScaffold's

- bottom/side sheets. ThemeData.scaffoldBackgroundColor is now

- transparent globally so every page reveals the ambient background

- instead of each needing its own override.

- Fix Windows whole-group delay-test flooding and a WebDAV ping race

- Two bug fixes identified while diffing against upstream FlClash (this

- fork's Linux silent-launch fix and the real 220-commit upstream

- history are already merged in via the earlier upstream-sync work, so

- just these two remain):

- - delayTest() was batching already-created Futures instead of the

-   proxy list itself - an async closure starts running up to its first

-   await the moment it's created, so `.map().toList()` was firing every

-   delay-test request immediately regardless of "batch" size. That's

-   exactly what floods the Core's own delay-test queue and times out

-   whole-group tests, especially noticeable on Windows. Now batches the

-   proxies first, capped at the Core's own concurrency

-   (maxConcurrentDelayTests = 50, matching mBatch in core/common.go).

- - The backup/restore screen's WebDAV connectivity check was fired

-   fire-and-forget from build(), so a slow ping for an old credential

-   set could resolve after (and overwrite) a newer one. Adds

-   DAVConnectionController, a small request-generation guard, and wires

-   it into the settings page.

- Rebrand: abstract P monogram logo and unified icon set

- Replaces the shield-and-globe mark with a geometric P monogram (stem +

- aperture bowl, an off-center counter hole standing in for "panorama"

- and "secure access") in a new ink-to-violet palette (#14162B ->

- #6D5EF7), replacing the old navy-to-cyan gradient this fork used

- before the upstream sync.

- Regenerates every platform's app icon from the same vector-equivalent

- geometry so they're pixel-consistent: macOS iconset, Windows .ico

- (app + installer + tray), Android adaptive icon (foreground now

- per-density raster PNGs in this codebase rather than a vector

- drawable, rescaled to the 66dp safe zone) plus legacy mipmap

- webp/Play Store/TV banner, and the icon.png used by the

- AppImage/deb/rpm packaging configs. Tray status icons keep their

- existing gray/blue/amber ring (a functional state indicator, not

- branding) and only swap the center glyph. The service module's

- tile/notification icons (ic.png/ic_service.png, also per-density

- raster here) get the same new glyph as flat white silhouettes,

- matching how this codebase already treated them.

- Also updates the app's default Material You seed color and preset

- palette to the new violet (was upstream's default black/mixed

- palette, unrelated to this fork's branding).

## v3.2.3

- Change default proxy delay/speed-test URL back to gstatic generate_204 (Dart default and Go core
  fallback default)

## v3.2.2

- Change default proxy delay/speed-test URL from speed.cloudflare.com to cp.cloudflare.com (Dart
  default and Go core fallback default)

## v3.2.1

- Remove About page's Telegram link, which pointed at upstream FlClash's own community channel
  instead of this fork's
- Remove the Homebrew and F-Droid tap publish CI steps, which were hardcoded to push to upstream's
  own repos (chen08209/homebrew-tap, chen08209/FlClash-fdroid-repo); the Homebrew one had no secret
  guard and was failing the release build's upload job on every stable tag
- Fix release notes generation comparing against upstream's latest release tag instead of this repo's
  own, which caused release notes to re-include every prior release's changes

## v3.2.0

- Sync with upstream FlClash v0.8.94: macOS performance fix, custom global-ua support, updated core,
  new l10n system, and various dependency/detail updates (graft-assisted merge onto this fork's own
  history, keeping this fork's branding, monochrome theme, and release URLs)
- Change default proxy delay/speed-test URL from gstatic generate_204 to speed.cloudflare.com (Dart
  default and Go core fallback default)
- Retry the core process's IPC pipe/socket dial instead of panicking on the first timeout right after
  a restart
- Fix the Windows uninstaller showing a generic icon instead of the branded one in Add/Remove Programs;
  clean up a stale helper service before install
- Give the TUN adapter its own short device name instead of a leftover unbranded literal, avoiding a
  wintun adapter-creation issue tied to long/space-containing device names
- Bound the core IPC connect wait instead of hanging forever (with more headroom when launched via the
  Windows helper, since TUN bring-up can be slow), with diagnostics surfaced on timeout
- Bound Windows helper sc.exe queries with a timeout and add a catch-all around core connect, so a
  hung system call can no longer leave the UI stuck on "connecting" forever
- Attempt a graceful shutdown of the core process on Windows before force-killing it, so the wintun
  adapter it created gets torn down instead of leaking orphaned adapters across restarts
- Cache the Windows helper's core-binary SHA256 check (keyed by file mtime) and widen the client
  timeout, fixing helper /start timing out on a slow disk or during antivirus scanning
- Propagate a real error when the TUN adapter fails to come up instead of silently reporting success
- Stop the core restart flow before further init when the core failed to connect, instead of
  continuing into steps that would just hang; remove a dead duplicate code path

## v3.1.2

- Change default test URL to speed.cloudflare.com; bump to v3.1.2

## v3.1.1

- Sync Android notification and quick-settings tile icons to the new logo (were still showing the old mark)
- Update the Android TV banner to the new logo and brand name
- Fix release page download links to point to this fork's releases

## v3.1.0

- Point in-app update checks at this fork's own releases instead of upstream FlClash

- Update dialog now downloads the matching platform/arch release asset in the background with a progress
  indicator, then hands it to the platform installer (Windows installer, macOS Finder/dmg, Linux
  AppImage/deb/rpm via xdg-open, Android install intent) instead of just opening a browser link

- README: added License & Credits section (GPL-3.0, attribution to original FlClash project), pointed
  download/star-history links at this fork's repo

## v3.0.0

- Rebrand to Panorama Secure Access (new name, logo, and app icons across all platforms)

- Add disclaimer identifying Panorama Scholarly Group as producer, for internal/educational use only

- Default UI color scheme switched to monochrome (black and white)

## v0.8.94

- Fix macos performance issue

- Support custom global-ua

- Update core

- Optimize some details

- Fix linux silent launching not working

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