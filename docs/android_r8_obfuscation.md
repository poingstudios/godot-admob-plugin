# Android R8 Optimization & Obfuscation

This guide explains how to enable Android R8 code shrinking, optimization, and obfuscation in your Godot project to comply with Google Play Console requirements.

## Overview

Starting in recent Google Play Console updates, apps are evaluated against app optimization thresholds:

> **App optimization is below our threshold: Obfuscation (10%)**  
> *Percentages under 25% in any category of your app may impact your visibility and publishing capabilities on Google Play.*

### Why does this happen?

The Google Mobile Ads (GMA) Next-Gen SDK moves runtime execution logic (Kotlin coroutines, Jetpack libraries, UI rendering) directly into your app's DEX bytecode. This causes DEX bytecode to expand significantly (~91 MB DEX across up to 11 classes.dex files).

Because Godot's Android export template disables minification (`minifyEnabled false`) by default to protect C++/JNI bindings, none of this DEX code is obfuscated, causing your app's obfuscation ratio to drop below the 25% threshold.

---

## Automatic Configuration (Recommended)

The Poing Godot AdMob plugin provides an automated Project Setting to configure R8 optimization:

1. Open your project in the Godot Editor.
2. Navigate to **Project > Project Settings > Admob > General > Android**.
3. Enable **Enable R8 Optimization**.

```
admob/general/android/enable_r8_optimization = true
```

When exporting a **Release** build with an Android build template (`android/build/`), the export plugin automatically:

- Enables `minifyEnabled true` and `shrinkResources false` in your release build configuration.
- Configures `proguardFiles` to reference your `proguard-rules.pro`.
- Ensures essential Godot Engine core classes, singletons, and native JNI methods are preserved.

---

## Embedded Consumer Rules (AAR)

The Poing Godot AdMob plugin packages embedded consumer ProGuard rules (`consumer-rules.pro`) directly inside its Android `.aar` library binaries. 

When R8 runs during your Gradle release build, Gradle automatically merges the plugin's rules to protect:

- All AdMob plugin classes (`com.poingstudios.godot.admob.**`).
- All `GodotPlugin` subclasses and methods annotated with `@UsedByGodot`.
- All native JNI methods (`native <methods>;`).

You **do not** need to manually add `-keep` rules for the AdMob plugin in your project's `proguard-rules.pro`.

---

## Manual Configuration

If you manage your own custom Android Gradle build without using the plugin's automatic setting, follow these steps:

### 1. Enable Minification in Gradle

Open `android/build/build.gradle` (or `android/build/app/build.gradle`) and update the `release` block under `buildTypes`:

```groovy
buildTypes {
    release {
        minifyEnabled true
        shrinkResources false
        proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        // ... signing and other existing configurations
    }
}
```

### 2. Configure Godot ProGuard Rules

Open `android/build/proguard-rules.pro` (or `android/build/app/proguard-rules.pro`) and add the following rules to preserve the Godot engine runtime:

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

## Engine Native Support

In newer versions of Godot Engine where the native export option (`gradle_build/minification`) is available in the Android Export Preset, you can enable minification directly from the Godot Export dialog. The plugin's embedded consumer rules will continue to protect AdMob components automatically.
