# 通过中介集成 Vpon

本指南适用于有兴趣通过 AdMob 中介使用 Vpon 的发布商。它引导您完成在当前的 Godot 应用中设置中介适配器以及配置其他请求参数。

## Vpon 资源

- [文档](https://wiki.vpon.com/android/mediation/admob/)
- [SDK](https://wiki.vpon.com/android/download/index.html)
- [适配器](https://wiki.vpon.com/android/download/#admob)
- 客户支持：[fae@vpon.com](mailto:fae@vpon.com)

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

1. 在您的 Godot 项目中安装 **Android 编译模板**（通过 `Project → Install Android Build Template`）。
2. 从 Vpon 资源部分的链接下载最新的 **Vpon Android SDK** 和 **Vpon AdMob 适配器**（`.aar` 或 `.jar` 文件）。
3. 将下载的文件复制到 Godot 项目中的以下目录：
   - `android/build/libs/`
4. 在文本编辑器中打开 `android/build/build.gradle`。
5. 将下载的文件作为依赖项添加到 `dependencies` 块中：
   ```groovy
   dependencies {
       // ... 其他依赖项
       implementation files('libs/admob-adapter-2.3.0.aar') // 替换为已下载适配器的确切文件名
       implementation files('libs/vpon-sdk-5.8.0.aar') // 替换为已下载 SDK 的确切文件名
   }
   ```

---

### iOS

将中介网络的 SDK 和适配器文件包含在 Godot 项目的相应目录中：

- **iOS**：Xcode 项目（导出后）

从 Godot 生成 Xcode 项目后，包含所选网络所需的任何框架、编译器标志或链接器标志。

1. 从 [Vpon 开发者页面](https://developers.google.com/admob/ios/mediation/vpon) 下载最新的 **Vpon iOS SDK** 和 **Vpon AdMob 适配器** 框架。
2. 将您的 Godot 项目导出为 iOS Xcode 项目。
3. 在 Xcode 中打开导出的项目。
4. 将下载的 Vpon SDK 和适配器框架文件（`.xcframework` 或 `.framework`）拖放到您的 Xcode 项目中。
5. 在应用目标的 **General** 选项卡下，确保这些框架列在 **Frameworks, Libraries, and Embedded Content** 下，并设置为 **Embed & Sign**。

---

您的应用无需直接调用任何第三方广告网络代码；Poing Godot AdMob 插件会与中介网络的适配器交互，代表您获取第三方广告。
