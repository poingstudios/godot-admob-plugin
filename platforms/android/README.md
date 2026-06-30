<h1 align="center">
  <img src="https://i.imgur.com/fLsHNCO.png" alt="GodotAdMob" width=500>
  <br>
  Godot AdMob Android
  <br>
</h1>

<p align="center">
  <a href="https://discord.gg/wVkTa3FV">
    <img src="https://img.shields.io/discord/838750671792373760?label=discord&logo=Discord">
  </a>
  <a href="https://godotengine.org">
    <img src="https://img.shields.io/badge/GODOT-%23FFFFFF.svg?&logo=godot-engine">
  </a>
  <a href="https://github.com/poingstudios/godot-admob-android/releases">
    <img src="https://img.shields.io/github/v/tag/poingstudios/godot-admob-android?label=Version">
  </a>
  <a href="https://github.com/poingstudios/godot-admob-android/actions">
    <img src="https://github.com/poingstudios/godot-admob-android/workflows/Build%20Android/badge.svg">
  </a>
  <a href="https://github.com/poingstudios/godot-admob-android/blob/master/admob/AdMob.gdap">
    <img src="https://img.shields.io/badge/GAD SDK Android-v24.9.0-informational">
  </a>
  <a href="https://github.com/poingstudios/godot-admob-android/releases">
    <img src="https://img.shields.io/github/downloads/poingstudios/godot-admob-android/total?style=social">
  </a>
  <a href="#🌠star-history">
    <img src="https://img.shields.io/github/stars/poingstudios/godot-admob-android?style=social">
  </a>
  <img src="https://img.shields.io/github/license/poingstudios/godot-admob-android?style=plastic">
</p>

<p align="center">
  <a href="/docs">📃Documentation</a> •
  <a href="https://github.com/poingstudios/godot-admob-android/releases">💾Downloads</a> 
</p>

## 📖About
This repository is a _Godot Engine Plugin_ that makes it **easy** to display **AdMob** ads in your game, **just download and use**, no need to worry about building or version compatibility.

The plugin supports most versions of Godot from 3.x to 4.x and is **compatible** with both **Android and [iOS](https://github.com/poingstudios/godot-admob-ios)**. 

## 💡Features
- **Supports** _Almost_ all [AdFormats](https://support.google.com/admob/answer/6128738?hl=en)💵: `Banner`, `Interstitial`, `Rewarded`, `Rewarded Interstitial`
- EU Consent for GDPR **compliance** 🏦 _[EU Consent/UMP](https://support.google.com/admob/answer/7666519?hl=en)_
- Targeting **specific** ⭕ audience segments 
- Has `CI/CD` to **test** ✅, **build** 🛠️ and **release versions** 📨
- Concise **documentation** 📄
- Same **behavior** as [iOS Plugin](https://github.com/poingstudios/godot-admob-ios) 🍎

## 🕵️‍♂️Preview
| Banner | Interstitial | Rewarded | Rewarded Interstitial |
|---|---|---|---|
| ![Banner](https://user-images.githubusercontent.com/20030153/214408452-4b5a7c59-1a7c-43cf-b669-1895863bef19.jpg) | ![Interstitial](https://user-images.githubusercontent.com/20030153/214408451-ef171be5-7c4f-48ae-bd03-3d95c8c5ab40.jpg) | ![Rewarded](https://user-images.githubusercontent.com/20030153/214408453-66261aba-aace-45a7-aa31-c35e9b8cbd44.jpg) | ![Rewarded Interstitial](https://user-images.githubusercontent.com/20030153/214408454-bbbc661c-7432-42ea-b893-ad5e41d8d106.jpg) |

## 🔌Usage
### Prerequisites
- Basic knowledge about usage of Godot Plugins and AdMob
- Usage of [AdMob Editor Plugin](https://github.com/poingstudios/godot-admob-plugin)

### Installation 
- [YouTube Tutorial](https://youtu.be/ZnlH3INcAGs)
- Download the ```android-?-template-v{{ your_godot_version }}.zip``` in the [releases tab](https://github.com/poingstudios/godot-admob-android/releases), we recommend you to use always the latest.
- Extract the content downloaded into ```res://android/plugins``` directory on your Godot project
- Add your [AdMob App ID](https://support.google.com/admob/answer/7356431) to your app's ```res://android/build/AndroidManifest.xml``` file by adding a ```<meta-data>``` tag with name ```com.google.android.gms.ads.APPLICATION_ID```, as shown below.
``` xml
<!-- Sample AdMob app ID: ca-app-pub-3940256099942544~3347511713 -->
<meta-data
	tools:replace="android:value"
	android:name="com.google.android.gms.ads.APPLICATION_ID"
	android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
```
- Export the project enabling the `Use Custom Build` and `AdMob Plugin`.

## 🔧Development
### Prerequisites
- [Android Studio](https://developer.android.com/studio)
- [AAR library for Android Plugins (standard/mono)](https://downloads.tuxfamily.org/godotengine/3.5.1/godot-lib.3.5.1.stable.release.aar)

### Install dependencies
1. Download the `godot-lib*.aar`
2. Rename `godot-lib*.aar` to `godot-lib.aar`
3. Paste `godot-lib.aar` into `./godot-lib/` folder

### Build
- Open Terminal and run: `./gradlew build`

## 📃Documentation
- For complete and detailed documentation check here: [LINK]()

## 🌠Star History
[![Star History Chart](https://api.star-history.com/svg?repos=poingstudios/godot-admob-android&type=Date)](https://star-history.com/#poingstudios/godot-admob-android&Date)

## 🪪License
This project is licensed under the [MIT License](https://github.com/poingstudios/godot-admob-android/blob/master/LICENSE).
