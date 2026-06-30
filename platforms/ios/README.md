
<h1 align="center">
  <br>
  <img src="https://i.imgur.com/N2OW34R.png" alt="GodotAdMob" width=500>
  <br>
  Godot AdMob iOS
  <br>
</h1>

<h4 align="center">A Godot's plugin for iOS of <a href="https://admob.google.com" target="_blank">AdMob</a>.</h4>

<p align="center">
  <a href="https://github.com/Poing-Studios/godot-admob-ios/releases">
    <img src="https://img.shields.io/github/v/tag/Poing-Studios/godot-admob-ios?label=Version">
  </a>
  <a href="https://github.com/Poing-Studios/godot-admob-ios/actions/workflows/release_ios.yml">
    <img src="https://github.com/Poing-Studios/godot-admob-ios/actions/workflows/release_ios.yml/badge.svg?branch=v2">
  </a>
  <a href="https://github.com/Poing-Studios/godot-admob-ios/releases">
    <img src="https://img.shields.io/github/downloads/Poing-Studios/godot-admob-ios/total?style=social">
  </a>
  <img src="https://img.shields.io/github/stars/Poing-Studios/godot-admob-ios?style=social">
  <img src="https://img.shields.io/github/license/Poing-Studios/godot-admob-ios?style=plastic">
</p>

<p align="center">
  <a href="#about">About</a> •
  <a href="#installation">Installation</a> •
  <a href="#documentation">Docs</a> •
  <a href="https://github.com/Poing-Studios/godot-admob-ios/releases">Downloads</a> 
</p>

## About

<table>
  <tr>
  <td>

  This repository is for a _Godot Engine Plugin_ that allows showing the ads offered by **AdMob** in an **easy** way, without worrying about the building or version, **just download and use**.

  The **purpose** of this plugin is to always keep **up to date with Godot**, supporting **ALMOST ALL** versions from 3.x to 4.x (when it is released), and also make the code **compatible** on **[Android](https://github.com/Poing-Studios/godot-admob-android) and iOS**, so each advertisement will work **identically on both systems**.

  ![Preview](https://i.imgur.com/u5y2GEx.png)

  <p align="right">
    <sub>(Preview)</sub>
  </p>

  </td>
  </tr>
</table>

## Features
  
|                                       Ad Formats                                        | Available 🍏 |
| :-------------------------------------------------------------------------------------: | :---------: |
|                                         Banner                                          |      ✔️      |
|                                      Interstitial                                       |      ✔️      |
|                                        Rewarded                                         |      ✔️      |
|        [Rewarded Interstitial](https://support.google.com/admob/answer/9884467)         |      ✔️      |
| Native is [REMOVED](https://github.com/Poing-Studios/Godot-AdMob-Android-iOS/issues/75) |      ❗      |

|   Others   | Available 🍏 |
| :--------: | :---------: |
| EU consent |      ✔️      |
| Targeting  |      ✔️      |
| Mediation  |      ❌      |
|   CI/CD    |      ✔️      |


## Installation 
- First of all you need to install the [AdMob Editor Plugin](https://github.com/Poing-Studios/Godot-AdMob-Editor-Plugin), you can download direcly from [Godot Assets](https://godotengine.org/asset-library/asset/933).

## iOS (v3.3+):
- Tutorial: https://youtu.be/ZnlH3INcAGs
- Download the ```ios-template-v{{ your_godot_version }}.zip``` in the [releases tab](https://github.com/Poing-Studios/godot-admob-ios/releases/tag/iOS_v3.3%2B) we recommend you to use always the latest.
- Download the [googlemobileadssdkios.zip](https://github.com/Poing-Studios/godot-admob-ios/releases/download/iOS_v3.3%2B/googlemobileadssdkios.zip) used to build the plugin.
- Extract the content in ```ios-template-v{{ your_godot_version }}.zip``` into ```res://ios/plugins``` directory on your Godot project
- Extract the content in ```googlemobileadssdkios.zip``` into ```res://ios/plugins/admob/lib```, will be like this:
- ![Folder Structure](https://i.imgur.com/Xdj8yqV.png)
- Update the configuration in ```res://ios/plugins/admob.gdip```. Updating `GADApplicationIdentifier` is required.
- Export the project enabling the `AdMob Plugin`:
- ![Export Project](https://i.imgur.com/4Zm3sjp.png)

### XCode
On XCode, if you are facing some errors such as `Undefined symbol: __swift_FORCE_LOAD_$_swiftCompatibilityDynamicReplacements` do the following steps:

- Create a Swift `New Empty File` as any name you want:
- ![Empty File](https://i.imgur.com/TDz0DS0.png)
- Create Bridging Header
- ![Bridging Header](https://i.imgur.com/QTZBC62.png)

This is required due Swift Google Mobile Ads SDK Code. [Read more here.](https://forums.swift.org/t/could-not-find-or-use-auto-linked-library-swiftcompatibility50/54351/13)

## Android (v3.2.2+):
- https://github.com/Poing-Studios/godot-admob-android

## User Messaging Platform (UMP):
- To use UMP due of EUROPE ePrivacy Directive and the General Data Protection Regulation (GDPR), you first need to do configure your [Funding Choices](https://support.google.com/fundingchoices/answer/9180084).
- If your app is "ForChildDirectedTreatment" then the UMP [won't appear and signals won't work for consent](https://stackoverflow.com/a/63232045), this is normal so don't worry.
- To show personalized or non-personalized ads, then you need to change inside your [AdMob Account](https://apps.admob.com/?utm_source=internal&utm_medium=et&utm_campaign=helpcentrecontextualopt&utm_term=http://goo.gl/6Xkfcf&subid=ww-ww-et-amhelpv4)
![npa-image](https://i.stack.imgur.com/0v1eL.png)

## Documentation
For a complete documentation of this Plugin, [check our wiki](https://github.com/Poing-Studios/Godot-admob-android/wiki).

Alternatively, you can check the docs of AdMob itself of [Android](https://developers.google.com/admob/android/quick-start) and [iOS](https://developers.google.com/admob/ios/quick-start).

## Contribute
We are a dedicated area to how contribute for Android and iOS on our wiki.
- Android: https://github.com/Poing-Studios/Godot-AdMob-Android-iOS/wiki/Android-Plugin#developing
- iOS: https://github.com/Poing-Studios/Godot-AdMob-Android-iOS/wiki/iOS-Plugin#developing

## Getting help
[![DISCUSSIONS](https://img.shields.io/badge/Poing%20AdMob-%F0%9F%86%98%20Discussions%C2%A0%F0%9F%86%98-green?style=for-the-badge)](https://github.com/Poing-Studios/Godot-AdMob-Android-iOS/discussions)
