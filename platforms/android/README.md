
<h1 align="center">
  <br>
  <img src="https://i.imgur.com/fLsHNCO.png" alt="GodotAdMob" width=500>
  <br>
  Godot AdMob Android
  <br>
</h1>

<h4 align="center">A Godot's plugin for Android of <a href="https://admob.google.com" target="_blank">AdMob</a>.</h4>

<p align="center">
  <a href="https://github.com/poingstudios/godot-admob-android/releases">
    <img src="https://img.shields.io/github/v/tag/poingstudios/godot-admob-android?label=Version">
  </a>
  <a href="https://github.com/poingstudios/godot-admob-android/actions/workflows/release_android.yml">
    <img src="https://github.com/poingstudios/godot-admob-android/actions/workflows/release_android.yml/badge.svg">
  </a>
  <a href="https://github.com/poingstudios/godot-admob-plugin/releases">
    <img src="https://img.shields.io/github/downloads/poingstudios/godot-admob-plugin/total?style=social">
  </a>
  <img src="https://img.shields.io/github/stars/poingstudios/godot-admob-android?style=social">
  <img src="https://img.shields.io/github/license/poingstudios/godot-admob-android?style=plastic">
</p>

<p align="center">
  <a href="#❓-about">About</a> •
  <a href="#🙋‍♂️how-to-use">How to use</a> •
  <a href="#📄documentation">Docs</a> •
  <a href="https://github.com/poingstudios/godot-admob-android/releases">Downloads</a> 
</p>

     
## ❓ About 

<img src="../../docs/assets/usage-android.webp" align="right"
     alt="Preview" width="auto" height="390">

This repository is for a _Godot Engine Plugin_ that allows showing the ads offered by **AdMob** in an **easy** way, without worrying about the building or version, **just download and use**.

The **purpose** of this plugin is to always keep **up to date with Godot**, supporting **ALMOST ALL** versions from v4.2+, and also make the code **compatible** on **Android and [iOS](https://github.com/poingstudios/godot-admob-ios)**, so each advertisement will work **identically on both systems**.

### 🔑 Key features

- It's a wrapper for [Google Mobile Ads SDK](https://developers.google.com/admob/android/sdk). 🎁
- Easy Configuration. 😀
- Supports nearly all Ad Formats: **Banner**, **Interstitial**, **Rewarded**, **Rewarded Interstitial**. 📺
- GDPR Compliance with UMP Support. ✉️
- Targeting Capabilities. 🎯
- Seamless integration with Mediation partners: **AdColony**, **Meta**, **Vungle**. 💰
- CI/CD for streamlined development and deployment. 🔄🚀
- Features a dedicated [Godot Plugin](https://github.com/poingstudios/godot-admob-plugin), reducing the need for extensive coding. 🔌
- There is also an [iOS plugin](https://github.com/poingstudios/godot-admob-ios) available, which has the same behavior. 🍎


## 🙋‍♂️How to use 
- Video tutorial: https://youtu.be/TB7WhP8mieo
- Download [AdMob Plugin](https://github.com/poingstudios/godot-admob-plugin), you can download directly from [Godot Assets](https://godotengine.org/asset-library/asset/2063).
- After download, we recommend you to read the [README.md](https://github.com/poingstudios/godot-admob-plugin/blob/master/README.md) of the Plugin to know how to use.
- Add your [AdMob App ID](https://support.google.com/admob/answer/7356431) to your app's ```res://addons/admob/android/config.gd``` script by changing  `APPLICATION_ID` const.

## 📦 Manual Installation:

### 📥Download
- To get started, download the `poing-godot-admob-android-v{{ your_godot_version }}.zip` file from the [releases tab](https://github.com/poingstudios/godot-admob-plugin/releases). You can also use the [AdMob Plugin](https://github.com/poingstudios/godot-admob-plugin) for this step by navigating to `Project -> Tools -> AdMob Manager -> Android -> Download & Install`.

### 🧑‍💻Usage
- Enable Android Build Template. [Check the tutorial here](https://docs.godotengine.org/en/stable/tutorials/export/android_gradle_build.html).
- Extract the `.zip` and paste the content inside your `res://addons/admob/android/bin/` folder in your Godot project.

## 📎Useful links:
- 🦾 Godot Plugin: https://github.com/poingstudios/godot-admob-plugin
- 🍏 iOS: https://github.com/poingstudios/godot-admob-ios
- ⏳ Plugin for Godot below v4.1: https://github.com/poingstudios/godot-admob-android/tree/v2
- ⏱️ For strictly Godot v4.1 version use the v3.0.x versions, recommended: https://github.com/poingstudios/godot-admob-android/releases/tag/v3.0.6 

## 📄Documentation
For a complete documentation of this Plugin: [check here](https://poingstudios.github.io/godot-admob-plugin/).

Alternatively, you can check the docs of AdMob itself of [Android](https://developers.google.com/admob/android/quick-start).

## 🙏 Support
If you find our work valuable and would like to support us, consider contributing via these platforms:

[![Patreon](https://img.shields.io/badge/Support%20us%20on-Patreon-orange?style=for-the-badge&logo=patreon)](https://patreon.com/poingstudios)

[![Ko-fi](https://img.shields.io/badge/Buy%20us%20a-coffee-yellow?style=for-the-badge&logo=ko-fi)](https://ko-fi.com/poingstudios)

[![Paypal](https://img.shields.io/badge/Donate-via%20Paypal-blue?style=for-the-badge&logo=paypal)](https://www.paypal.com/donate/?hosted_button_id=EBUVPEGF4BUR8)

Your support helps us continue to improve and maintain this plugin. Thank you for being a part of our community!


## 🆘Getting help
[![DISCUSSIONS](https://img.shields.io/badge/Discussions-green?style=for-the-badge)](https://github.com/poingstudios/godot-admob-android/discussions)
[![DISCORD](https://img.shields.io/badge/Discord-7289DA?style=for-the-badge)](https://discord.com/invite/YEPvYjSSMk)


## Development
All scripts must be executed within the project root folder

### Downloading
#### Clear Download & Build Script:
Unix (Linux & MacOS):
```shell
./scripts/unix/clean_build.sh 4.6.0
```

Windows:
```shell
./scripts/windows/clean_build.ps1 4.6.0
```

#### Just Download:
Unix (Linux & MacOS):
```shell
./scripts/unix/download_godot.sh 4.6.0
```

Windows:
```shell
./scripts/windows/download_godot.ps1 4.6.0
```

### Building, Exporting, Zipping

#### Just Build:
```shell
./gradlew build
```

#### Export files:
```shell
./gradlew exportFiles -PpluginExportPath=D:\godot-admob-editor\addons\admob\android\bin
```

#### Build and exporting plugin files into the desired directory:
```shell
./gradlew build ; ./gradlew exportFiles -PpluginExportPath=D:\godot-admob-editor\addons\admob\android\bin
```


#### Zip:
(-PgodotVersion is optional)
```shell
./gradlew zipPlugins -PgodotVersion=4.6.0
```

### Logging
If you are having some issues with crashing or any expected behavior, you can easily get the log of the plugin with [ADB](https://developer.android.com/tools/adb):

#### Logcat AdMob Plugin & Godot (recommended)
```shell
adb logcat -s poing-godot-admob godot
```

#### Logcat AdMob Plugin
```shell
adb logcat -s poing-godot-admob
```

#### Logcat Godot
```shell
adb logcat -s godot
```


## ⭐ Star History
If you appreciate our work, don't forget to give us a star on GitHub! ⭐

![Star History Chart](https://api.star-history.com/svg?repos=poingstudios/godot-admob-android&type=Date)
