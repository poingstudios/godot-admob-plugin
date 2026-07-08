# 通过中介集成 Zucks

本指南适用于有兴趣通过 AdMob 中介使用 Zucks 的发布商。它引导您完成在当前的 Godot 应用中设置中介适配器以及配置其他请求参数。

本文档基于：

- [Google Mobile Ads SDK Android 官方文档](https://developers.google.com/admob/android/mediation/zucks)
- [Google Mobile Ads SDK iOS 官方文档](https://developers.google.com/admob/ios/mediation/zucks)

## Zucks 资源

- [文档](https://ms.zucksadnetwork.com/media/sdk/manual/admob-mediation/)
- [SDK](https://ms.zucksadnetwork.com/media/sdk/manual/android/)
- [适配器](https://ms.zucksadnetwork.com/media/sdk/manual/admob-mediation/)
- 客户支持：[support@zucksadnetwork.com](mailto:support@zucksadnetwork.com)

## 前提条件

- 完成[入门指南](../../index.md)
- 完成中介[入门指南](../get_started.md)

### 实用入门指南

以下帮助中心文章提供了有关中介的背景信息：

- [关于 AdMob 中介](https://support.google.com/admob/answer/1354562)
- [设置 AdMob 中介](https://support.google.com/admob/answer/3124703)
- [优化 AdMob 中介](https://support.google.com/admob/answer/6162238)

## 包含网络适配器和 SDK

### Android

Zucks 通过 Maven 分发其 SDK 和 AdMob 中介适配器。您无需为 Android 下载任何本地 `.aar` 或 `.jar` 文件。

1. 在您的 Godot 项目中安装 **Android 编译模板**（通过 `Project → Install Android Build Template`）。
2. 在文本编辑器中打开 `android/build/build.gradle`。
3. 在 `allprojects > repositories` 块（或 `repositories` 块）内添加 Zucks Maven 仓库：
   ```groovy
   repositories {
       // ... 其他仓库
       maven { url 'https://github.com/zucks/ZucksAdNetworkSDK-Maven/raw/master/' }
   }
   ```
4. 在 `dependencies` 块内添加 Zucks 中介适配器依赖项（这将同时传递下载 Zucks SDK）：
   ```groovy
   dependencies {
       // ... 其他依赖项
       implementation 'net.zucks:zucks-ad-network-admob-adapter:6.1.0.1' // 替换为最新的适配器版本
   }
   ```

---

### iOS

将中介网络的 SDK 和适配器文件包含在 Godot 项目的相应目录中：

- **iOS**：Xcode 项目（导出后）

从 Godot 生成 Xcode 项目后，包含所选网络所需的任何框架、编译器标志或链接器标志。

1. 从 [Zucks 开发者页面](https://developers.google.com/admob/ios/mediation/zucks) 下载最新的 **Zucks iOS SDK** 和 **Zucks AdMob 适配器** 框架。
2. 将您的 Godot 项目导出为 iOS Xcode 项目。
3. 在 Xcode 中打开导出的项目。
4. 将下载的 Zucks SDK 和适配器框架文件（`.xcframework` 或 `.framework`）拖放到您的 Xcode 项目中。
5. 在应用目标的 **General** 选项卡下，确保这些框架列在 **Frameworks, Libraries, and Embedded Content** 下，并设置为 **Embed & Sign**。

---

您的应用无需直接调用任何第三方广告网络代码；Poing Godot AdMob 插件会与中介网络的适配器交互，代表您获取第三方广告。
