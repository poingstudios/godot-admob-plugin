# 开始使用

将 AdMob 插件集成到您的 Godot 项目中（特别适用于 Godot v4.2+）是启用广告展示和产生收入的首要且关键的步骤。成功加入此插件后，您可以灵活地从各种广告格式（如横幅或插屏）中进行选择，并继续执行必要的实现步骤。

本文档基于：

- [Google Mobile Ads SDK Android 文档](https://developers.google.com/admob/android/quick-start)
- [Google Mobile Ads SDK iOS 文档](https://developers.google.com/admob/ios/quick-start)

## 前提条件

- 部署 Android：
	- 使用 Godot v4.2 或更高版本
	- `minSdkVersion` 为 24 或更高
	- `compileSdkVersion` 为 36 或更高
- 部署 iOS：
	- 使用 Godot v4.1 或更高版本
	- 使用 Xcode 26.2 或更高版本
	- 目标 iOS 14.0 或更高版本
- 推荐：[创建 AdMob 账号](https://support.google.com/admob/answer/7356219) 并 [注册应用](https://support.google.com/admob/answer/9989980)。

## 从 Poing Studios 下载 Godot AdMob 插件

Poing Studios 的 Godot AdMob 插件简化了 Godot 开发者将 Google 移动广告集成到其 Android 和 iOS 应用中的过程，无需编写 Java/Kotlin 或 Objective-C++ 代码。相反，该插件提供了一个基于 GDScript 和 C# 的广告请求接口，可以无缝集成到您的 Godot 项目中。

要访问该插件，您可以下载提供的 Godot 包，或通过以下链接在 GitHub 上探索其源代码。

[从 GitHub 下载](https://github.com/poingstudios/godot-admob-plugin/releases/latest){ .md-button .md-button--primary } [从资源商店下载](https://store.godotengine.org/asset/poingstudios/admob/){ .md-button .md-button--primary } [源代码](https://github.com/poingstudios/godot-admob-plugin){ .md-button .md-button--primary }

### 在项目中导入 Godot AdMob 插件

Godot 的 AdMob 插件可在 Godot 资源商店（Asset Store）中方便地获取。要将此插件导入您的 Godot 项目，请按照以下步骤操作：

1. 打开您的 Godot 项目。
2. 导航至 Godot 编辑器中的 Asset Store。
3. 在搜索栏中输入 `AdMob` 并确保发布者设置为 `Poing Studios`。
4. 找到 AdMob 插件并点击 `Download` 按钮。
5. 下载完成后，前往 Godot 编辑器中的 `Project → Project Settings`。
6. 在 `Plugins` 部分中，找到 `AdMob` 插件并激活它。
7. Android 和 iOS 库将自动下载并安装。
8. 通过这些步骤，您已成功将 AdMob 插件集成到您的 Godot 项目中，无需其他手动文件导入。

## 下载与安装 {: #download-install }
!!! info "信息"
    本节通常 **不是必需的**，因为插件会自动处理库。只有在自动下载失败时才需要按照以下步骤操作。

=== "Android"

	要集成 Godot 中 AdMob 所需的 Android 库，请按照以下步骤操作：

	1. 在 Godot 中，导航至 `Project → Tools → AdMob Manager → Android → Download & Install`。
	2. 此操作将下载适当的 Android 库并将其安装到您的项目中，路径为 `res://addons/admob/android/bin/`。

	如果您在下载时遇到任何问题，可以尝试点击 [此处](https://github.com/poingstudios/godot-admob-android/releases/latest) 手动下载该库。

=== "iOS"

	要集成 Godot 中 AdMob 所需的 iOS 库，请按照以下步骤操作：

	1. 在 Godot 中，导航至 `Project → Tools → AdMob Manager → iOS → Download & Install`。
	2. 此操作将自动下载所需的 iOS 库并将其安装到您的项目中，路径为 `res://ios/plugins/`。

	如果您在下载时遇到任何问题，可以尝试点击 [此处](https://github.com/poingstudios/godot-admob-ios/releases/latest) 手动下载该库。

### 导出

=== "Android"

	1. 通过导航至 `Project → Install Android Build Template` 安装 [Android 编译模板](https://docs.godotengine.org/en/stable/tutorials/export/android_gradle_build.html)。
	2. 在 `Project → Project Settings... → General` 中配置 Android 预设选项：
	    - 在左侧侧边栏中，找到 **Admob** 部分并点击 **Android**。
	    - 将您的 [AdMob App ID](https://support.google.com/admob/answer/7356431) 添加到 `App Id` 字段中。
	    - 通过切换各自的复选框来启用或禁用 `Enabled` 以及中介插件（`Mediation/Meta`，`Mediation/Vungle`）。
	
	    !!! tip "App ID vs 广告单元 ID"
	        - **App ID**（包含 `~`）：用于应用注册和内部配置。
	        - **广告单元 ID**（包含 `/`）：用于在代码中加载特定的广告格式。
	
	1. 导出项目时，选择 `Use Gradle Build`。

=== "iOS"

	该插件包含一个 **iOS 导出插件**，可自动完成所有 iOS 导出配置：

	1. 在 `项目 → 项目设置... → 常规` 中配置您的 AdMob 设置：

	    - 在左侧边栏的 **Admob** 部分下，单击 **常规**。
	    - 在 **iOS** 部分下，勾选 **已启用** 以激活平台，并将您的 [AdMob App ID](https://support.google.com/admob/answer/7356431) 添加到 **App Id** 字段。
	    - 要启用中介网络，请单击左侧边栏中的 **中介**，然后切换相应的复选框（例如 `Meta`、`Vungle`）。

	    !!! tip "App ID 与 Ad Unit ID"
	        - **App ID**（包含 `~`）：用于应用注册和内部配置。
	        - **Ad Unit ID**（包含 `/`）：用于在代码中加载特定广告格式。

	    ![Project Settings](assets/general_settings.png)
	    ![Mediation Settings](assets/mediation_settings.png)

	1. 像往常一样导出项目 — 无需手动 Xcode 配置。
	1. 运行游戏。
	1. [如果您尝试在模拟器上运行但无法运行，请阅读此文](https://github.com/godotengine/godot/issues/44681#issuecomment-751399783)。

## 初始化 Google 移动广告 SDK {: #initialize-the-google-mobile-ads-sdk }
在加载广告之前，请确保您的应用初始化了 Google 移动广告 SDK。您可以通过调用 [`MobileAds`](reference/classes/MobileAds.md).initialize() 来实现这一点。此函数会初始化 SDK，并在初始化过程完成或超过 30 秒超时后触发完成监听器。请注意，此初始化应仅执行一次，最好是在应用启动阶段。

=== "GDScript"

    ```gdscript
    func _ready() -> void:
    	MobileAds.initialize()
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
    	MobileAds.Initialize();
    }
    ```

如果您使用的是中介，在继续加载广告之前等待完成回调被调用是至关重要的。此步骤可确保在发出广告请求之前，所有中介适配器都已正确初始化。

## 选择广告格式
Google 移动广告 SDK 现已成功导入，您已准备好将广告集成到您的应用中。AdMob 提供了多种广告格式，允许您选择最适合您应用用户体验的格式。

### 开屏广告
<div class="image-text-container" markdown="1">

![app_open](https://developers.google.com/static/admob/images/format-app-open.svg)

开屏广告是在用户打开或切换回您的应用时出现的广告格式。广告会覆盖在加载屏幕上。

</div>

[实现开屏广告](ad_formats/app_open.md){ .md-button .md-button--primary }

### 横幅广告
<div class="image-text-container" markdown="1">

![banner](assets/ad_formats/banner.png)

横幅广告是矩形广告，由图片或文本组成，并集成在应用布局中。这些广告在用户与应用互动时保持在屏幕上，并可在指定的时间间隔后自动刷新。如果您是移动广告的新手，横幅广告是您广告实现之旅的一个绝佳起点。

</div>

[实现横幅广告](ad_formats/banner/get_started.md){ .md-button .md-button--primary }

### 插屏广告
<div class="image-text-container" markdown="1">

![interstitial](assets/ad_formats/interstitial.png)

插屏广告是展开式的全屏广告，会覆盖应用的界面，直到被用户关闭。它们在应用执行过程中的自然停顿（例如游戏关卡之间或任务完成之后）策略性地放置最为有效。

</div>

[实现插屏广告](ad_formats/interstitial.md){ .md-button .md-button--primary }

### 原生重叠广告
<div class="image-text-container" markdown="1">

![native_overlay](https://developers.google.com/static/admob/images/format-native.svg)

原生重叠广告允许您使用预先设计的模板在应用内容之上展示符合应用外观的广告。它们支持对颜色、字体和布局选项进行自定义，同时保持集成的简单性。

</div>

[实现原生重叠广告](ad_formats/native_overlay.md){ .md-button .md-button--primary }

### 激励广告
<div class="image-text-container" markdown="1">

![rewarded](assets/ad_formats/rewarded.png)

激励视频广告是沉浸式的全屏视频广告，为用户提供完全观看它们的选择。作为对其时间和注意力的回报，用户会收到应用内奖励或福利。

</div>

[实现激励广告](ad_formats/rewarded.md){ .md-button .md-button--primary }

### 激励插屏广告
<div class="image-text-container" markdown="1">

![rewarded_interstitial](assets/ad_formats/rewarded_interstitial.png)

激励插屏广告是一种特殊形式的激励广告格式，允许您提供奖励以换取在自然的应用过渡期间自动出现的广告。与常规激励广告不同，用户无需主动选择观看激励插屏广告；它们无缝地集成在应用体验中。

</div>

[实现激励插屏广告](ad_formats/rewarded_interstitial.md){ .md-button .md-button--primary }

<style>
  .image-text-container {
    display: flex;
    align-items: center;
  }
  .image-text-container img {
    margin-right: 20px;
    max-width: 130px;
    height: auto;
  }
</style>
