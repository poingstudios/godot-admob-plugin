# Android R8 最適化と難読化

このガイドでは、Google Play Console の要件に準拠するために、Godot プロジェクトで Android R8 のコード縮小（shrinking）、最適化、および難読化を有効にする方法について説明します。

## Overview

最近の Google Play Console の更新により、アプリはアプリ最適化のしきい値に基づいて評価されます：

> **アプリの最適化がしきい値を下回っています: 難読化 (10%)**  
> *アプリのいずれかのカテゴリで 25% 未満の割合になると、Google Play での認知度や公開機能に影響する可能性があります。*

### Why does this happen?

Google Mobile Ads (GMA) Next-Gen SDK では、実行時ロジック（Kotlin コルーチン、Jetpack ライブラリ、UI レンダリング）がアプリの DEX バイトコードに直接配置されます。これにより、DEX バイトコードが大幅に肥大化します（最大 11 個の classes.dex ファイル、約 91 MB）。

Godot の Android エクスポートテンプレートは、C++/JNI バインディングを保護するためにデフォルトで圧縮・難読化を無効（`minifyEnabled false`）にしているため、これらの DEX コードはまったく難読化されず、アプリの難読化率が 25% のしきい値を下回る原因となります。

---

## Automatic Configuration (Recommended)

Poing Godot AdMob プラグインは、R8 最適化を設定するための自動化されたプロジェクト設定を提供します：

1. Godot エディタでプロジェクトを開きます。
2. **プロジェクト > プロジェクト設定 > Admob > General > Android** に移動します。
3. **Enable R8 Optimization** を有効にします。

```
admob/general/android/enable_r8_optimization = true
```

Android ビルドテンプレート（`android/build/`）を使用して **Release** ビルドをエクスポートすると、エクスポートプラグインが自動的に以下を実行します：
- Release ビルド設定で `minifyEnabled true` と `shrinkResources false` を有効化。
- `proguard-rules.pro` を参照するように `proguardFiles` を設定。
- Godot Engine のコアクラス、シングルトン、およびネイティブ JNI メソッドが保持されることを保証。

---

## Embedded Consumer Rules (AAR)

Poing Godot AdMob プラグインは、Android `.aar` ライブラリバイナリ内にコンシューマー ProGuard ルール（`consumer-rules.pro`）を直接埋め込んでいます。

Gradle Release ビルド中に R8 が実行されると、Gradle はプラグインのルールを自動的にマージして以下を保護します：
- すべての AdMob プラグインクラス（`com.poingstudios.godot.admob.**`）。
- すべての `GodotPlugin` サブクラスおよび `@UsedByGodot` アノテーションが付いたメソッド。
- すべてのネイティブ JNI メソッド（`native <methods>;`）。

プロジェクトの `proguard-rules.pro` ファイルに AdMob プラグイン用の `-keep` ルールを手動で追加する**必要はありません**。

---

## Manual Configuration

プラグインの自動設定を使用せずに独自のカスタム Android Gradle ビルドを管理している場合は、次の手順に従ってください：

### 1. Enable Minification in Gradle

`android/build/build.gradle`（または `android/build/app/build.gradle`）を開き、`buildTypes` の下の `release` ブロックを更新します：

```groovy
buildTypes {
    release {
        minifyEnabled true
        shrinkResources false
        proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        // ... 署名およびその他の既存の設定
    }
}
```

### 2. Configure Godot ProGuard Rules

`android/build/proguard-rules.pro`（または `android/build/app/proguard-rules.pro`）を開き、Godot Engine ランタイムを保持するために次のルールを追加します：

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
```

---

## エンジンネイティブサポート

ネイティブエクスポートオプション（`gradle_build/minification`）が利用可能な新しいバージョンの Godot Engine を使用している場合は、Android エクスポートプリセットから直接難読化を有効にできます。プラグインに組み込まれたコンシューマールールは、引き続き AdMob コンポーネントを自動的に保護します。
