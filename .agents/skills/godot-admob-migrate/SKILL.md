---
name: godot-admob-migrate
description: Provides instructions to migrate your Godot AdMob project between different plugin versions (e.g. from version 4.x to version 5.x) in GDScript and C#. Use when upgrading plugin versions.
metadata:
  version: 1.0.0
  category: GodotAdMob
---
# Godot AdMob - Migration Guide

Assists with migrating your Godot AdMob integration between different plugin versions in GDScript and C#.

## Migrate from v4.x to v5.x

### Steps

1.  **Remove SMART_BANNER Constants**: Replace any references to `AdSize.SMART_BANNER` or `SmartBanner` with Anchored Adaptive Banner sizes.
2.  **Update Fallbacks**: Ensure that any legacy layouts using `-1, -1` size fallback values are replaced with the recommended Anchored Adaptive Banner sizes.
3.  **Update Gradle Dependencies**: Clean and rebuild your Android plugin template if necessary to fetch the GMA Next-Gen SDK dependencies.
4.  **Review Initialization Defaults**: By default, initialization and ad loading optimizations are enabled. If you run into threading issues, toggle **Disable Initialization Optimization** and **Disable Ad Loading Optimization** in the Godot project settings under **Admob > General > Android**.

### Size Migration Reference

| Removed Constant (v4.x) | Recommended Alternative (v5.x) |
| :--- | :--- |
| `AdSize.SMART_BANNER` (GDScript) | `AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)` |
| `AdSize.SmartBanner` (C#) | `AdSize.GetCurrentOrientationAnchoredAdaptiveBannerAdSize(AdSize.FullWidth)` |
