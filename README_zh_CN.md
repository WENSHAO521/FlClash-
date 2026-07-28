<div>

[**English**](README.md)

</div>

## Panorama Secure Access

[![Downloads](https://img.shields.io/github/downloads/WENSHAO521/panorama-secure-access/total?style=flat-square&logo=github)](https://github.com/WENSHAO521/panorama-secure-access/releases/)[![Last Version](https://img.shields.io/github/release/WENSHAO521/panorama-secure-access/all.svg?style=flat-square)](https://github.com/WENSHAO521/panorama-secure-access/releases/)[![License](https://img.shields.io/github/license/WENSHAO521/panorama-secure-access?style=flat-square)](LICENSE)

基于ClashMeta的多平台代理客户端，简单易用，开源无广告。本项目为 [FlClash](https://github.com/chen08209/FlClash) 的重新品牌化分支，
详见下方[许可证与鸣谢](#许可证与鸣谢)。

## 免责声明

本软件（Panorama Secure Access）由 **Panorama Scholarly Group** 出品，仅供内部人员测试与学习使用，不用于任何商业用途或公开传播。本软件按“原样”提供，不附带任何明示或默示的担保。使用者应自行承担因使用本软件而产生的一切风险及法律责任，并确保其使用行为符合所在地区的法律法规。Panorama Scholarly Group 及其开发者对因使用或无法使用本软件而导致的任何直接或间接损失不承担任何责任。

on Desktop:
<p style="text-align: center;">
    <img alt="desktop" src="snapshots/desktop.gif">
</p>

on Mobile:
<p style="text-align: center;">
    <img alt="mobile" src="snapshots/mobile.gif">
</p>

## Features

✈️ 多平台: Android, Windows, macOS and Linux

💻 自适应多个屏幕尺寸,多种颜色主题可供选择

💡 基本 Material You 设计, 类[Surfboard](https://github.com/getsurfboard/surfboard)用户界面

☁️ 支持通过WebDAV同步数据

✨ 支持一键导入订阅, 深色模式

## Use

### Linux

⚠️ 使用前请确保安装以下依赖

   ```bash
    sudo apt-get install libayatana-appindicator3-dev
    sudo apt-get install libkeybinder-3.0-dev
   ```

### Android

支持下列操作

   ```bash
    com.follow.clash.action.START
    
    com.follow.clash.action.STOP
    
    com.follow.clash.action.TOGGLE
   ```

## Download

<a href="https://github.com/WENSHAO521/panorama-secure-access/releases"><img alt="Get it on GitHub" src="snapshots/get-it-on-github.svg" width="200px"/></a>

### Homebrew

```bash
brew tap chen08209/tap
brew install --cask flclash
```

## Build

1. 更新 submodules
   ```bash
   git submodule update --init --recursive
   ```

2. 安装 `Flutter` 以及 `Golang` 环境

3. 构建应用

    - android

        1. 安装  `Android SDK` ,  `Android NDK`

        2. 设置 `ANDROID_NDK` 环境变量

        3. 运行构建脚本

           ```bash
           dart setup.dart android
           ```

    - windows

        1. 你需要一个windows客户端

        2. 安装 `GCC`，`Inno Setup`

        3. 运行构建脚本

           ```bash
           dart setup.dart windows
           ```

    - linux

        1. 你需要一个linux客户端

        2. 依赖会由 setup 脚本自动安装，也可以手动安装：
           ```bash
           sudo apt-get install -y libayatana-appindicator3-dev libkeybinder-3.0-dev
           ```

        3. 运行构建脚本

           ```bash
           dart setup.dart linux
           ```

    - macOS

        1. 你需要一个macOS客户端

        2. 运行构建脚本

           ```bash
           dart setup.dart macos
           ```

## 许可证与鸣谢

Panorama Secure Access 是 [FlClash](https://github.com/chen08209/FlClash)（作者 chen08209）的重新品牌化修改版分支，FlClash
本身基于 [Clash.Meta / mihomo](https://github.com/MetaCubeX/mihomo) 构建。原项目与本分支均采用
[GNU 通用公共许可证 v3.0](LICENSE) 授权；作为 GPL-3.0 代码的衍生作品，本分支继续沿用 GPL-3.0。本分支中的修改部分（品牌重塑、图标、
默认主题、免责声明等）版权归 Panorama Scholarly Group 所有，同样以该许可证发布。

## Star

支持开发者的最简单方式是点击页面顶部的星标（⭐）。

<p style="text-align: center;">
    <a href="https://api.star-history.com/svg?repos=WENSHAO521/panorama-secure-access&Date">
        <img alt="start" width=50% src="https://api.star-history.com/svg?repos=WENSHAO521/panorama-secure-access&Date"/>
    </a>
</p>
