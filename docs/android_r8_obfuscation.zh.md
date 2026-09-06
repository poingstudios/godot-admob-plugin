# Android R8 优化与代码混淆

本指南说明如何在 Godot 项目中启用 Android R8 代码缩减（shrinking）、优化与混淆，以满足 Google Play Console 的发布要求。

## Overview

在最近的 Google Play Console 检查中，应用程序会根据优化阈值进行评估：

> **应用优化低于我们的阈值：代码混淆 (10%)**  
> *应用任何类别的百分比低于 25% 可能会影响您在 Google Play 上的展示率和发布功能。*

### Why does this happen?

Google Mobile Ads (GMA) Next-Gen SDK 将运行时执行逻辑（Kotlin 协程、Jetpack 库、UI 渲染）直接移入应用的 DEX 字节码中。这导致 DEX 字节码显著膨胀（多达 11 个 classes.dex 文件，总大小约 91 MB）。

由于 Godot 的 Android 导出模板默认禁用代码混淆（`minifyEnabled false`）以保护 C++/JNI 绑定，因此这些 DEX 代码完全未被混淆，导致应用的代码混淆率低于 25% 阈值。

---

## Automatic Configuration (Recommended)

Poing Godot AdMob 插件提供了自动化的项目设置来配置 R8 优化：

1. 在 Godot 编辑器中打开您的项目。
2. 导航至 **项目 > 项目设置 > Admob > General > Android**。
3. 启用 **Enable R8 Optimization**。

```
admob/general/android/enable_r8_optimization = true
```

在使用 Android 构建模板（`android/build/`）导出 **Release**（发布）版本时，导出插件会自动：
- 在 Release 构建配置中启用 `minifyEnabled true` 和 `shrinkResources false`。
- 配置 `proguardFiles` 引用您的 `proguard-rules.pro` 规则文件。
- 确保保留 Godot Engine 核心类、单例以及本地 JNI 方法。

---

## Embedded Consumer Rules (AAR)

Poing Godot AdMob 插件直接在其 Android `.aar` 库二进制文件中内置了消费者 ProGuard 规则（`consumer-rules.pro`）。

当 Gradle Release 构建运行 R8 时，Gradle 会自动合并插件规则以保护：
- 所有 AdMob 插件类（`com.poingstudios.godot.admob.**`）。
- 所有 `GodotPlugin` 子类及带有 `@UsedByGodot` 注解的方法。
- 所有本地 JNI 方法（`native <methods>;`）。

您**无需**在项目的 `proguard-rules.pro` 文件中手动为 AdMob 插件添加 `-keep` 规则。

---

## Manual Configuration

如果您在不使用插件自动设置的情况下管理自己的自定义 Android Gradle 构建，请按以下步骤操作：

### 1. Enable Minification in Gradle

打开 `android/build/build.gradle`（或 `android/build/app/build.gradle`），更新 `buildTypes` 下的 `release` 块：

```groovy
buildTypes {
    release {
        minifyEnabled true
        shrinkResources false
        proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        // ... 现有的签名和其他配置
    }
}
```

### 2. Configure Godot ProGuard Rules

打开 `android/build/proguard-rules.pro`（或 `android/build/app/proguard-rules.pro`），添加以下规则以保留 Godot Engine 运行时：

```proguard
# Godot Engine Core
-keep class org.godotengine.** { *; }
-keepclassmembers class org.godotengine.** { *; }
-keep class com.godot.** { *; }
-keepclassmembers class com.godot.** { *; }
-keep class * extends org.godotengine.godot.plugin.GodotPlugin { *; }
-keepclassmembers class * extends org.godotengine.godot.plugin.GodotPlugin {
    @org.godotengine.godot.plugin.UsedByGodot <methods>;
}

# Standard Android JNI
-keepclasseswithmembernames class * {
    native <methods>;
}
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service

# Suppress harmless warnings from Kotlin metadata and optional mediation dependencies
-dontwarn kotlin.Metadata
-dontwarn com.android.billingclient.**
-dontwarn com.bytedance.sdk.**
-dontwarn com.tiktok.**
-dontwarn jp.maio.sdk.**
-dontwarn ru.ok.tracer.**
```

---

## 引擎原生支持

在支持该导出选项（`gradle_build/minification`）的较新版本 Godot Engine 中，您可以直接在 Android 导出预设对话框中启用代码混淆。插件内置的消费者规则将继续自动保护 AdMob 组件。
