<div>

[**简体中文**](README_zh_CN.md)

</div>

## Panorama Secure Access

[![Downloads](https://img.shields.io/github/downloads/WENSHAO521/panorama-secure-access/total?style=flat-square&logo=github)](https://github.com/WENSHAO521/panorama-secure-access/releases/)[![Last Version](https://img.shields.io/github/release/WENSHAO521/panorama-secure-access/all.svg?style=flat-square)](https://github.com/WENSHAO521/panorama-secure-access/releases/)[![License](https://img.shields.io/github/license/WENSHAO521/panorama-secure-access?style=flat-square)](LICENSE)

[![Project](https://img.shields.io/badge/GitHub-Project-blue?style=flat-square&logo=github)](https://github.com/WENSHAO521/panorama-secure-access)

Panorama Secure Access is a multi-platform proxy client for Panorama Scholarly Group.

on Desktop:
<p style="text-align: center;">
    <img alt="desktop" src="snapshots/desktop.gif">
</p>

on Mobile:
<p style="text-align: center;">
    <img alt="mobile" src="snapshots/mobile.gif">
</p>

## Features

✈️ Multi-platform: Android, Windows, macOS and Linux

💻 Adaptive multiple screen sizes, Multiple color themes available

💡 Based on Material You Design, [Surfboard](https://github.com/getsurfboard/surfboard)-like UI

☁️ Supports data sync via WebDAV

✨ Support subscription link, Dark mode

## Use

### Linux

⚠️ Make sure to install the following dependencies before using them

   ```bash
    sudo apt-get install libayatana-appindicator3-dev
    sudo apt-get install libkeybinder-3.0-dev
   ```

### Android

Support the following actions

   ```bash
    com.follow.clash.action.START

    com.follow.clash.action.STOP

    com.follow.clash.action.TOGGLE
   ```

## Download

<a href="https://github.com/WENSHAO521/panorama-secure-access/releases"><img alt="Get it on GitHub" src="snapshots/get-it-on-github.svg" width="200px"/></a>

## Build

1. Update submodules
   ```bash
   git submodule update --init --recursive
   ```

2. Install `Flutter` and `Golang` environment

3. Build Application

    - android

        1. Install `Android SDK`, `Android NDK`

        2. Set `ANDROID_NDK` environment variable

        3. Run build script

           ```bash
           dart setup.dart android
           ```

    - windows

        1. Requires a Windows client

        2. Install `GCC`, `Inno Setup`

        3. Run build script

           ```bash
           dart setup.dart windows
           ```

    - linux

        1. Requires a Linux client

        2. Dependencies are auto-installed by setup script, or manually:
           ```bash
           sudo apt-get install -y libayatana-appindicator3-dev libkeybinder-3.0-dev
           ```

        3. Run build script

           ```bash
           dart setup.dart linux
           ```

    - macOS

        1. Requires a macOS client

        2. Run build script

           ```bash
           dart setup.dart macos
           ```

## Star

The easiest way to support developers is to click on the star (⭐) at the top of the page.

<p style="text-align: center;">
    <a href="https://api.star-history.com/svg?repos=WENSHAO521/panorama-secure-access&Date">
        <img alt="start" width=50% src="https://api.star-history.com/svg?repos=WENSHAO521/panorama-secure-access&Date"/>
    </a>
</p>
