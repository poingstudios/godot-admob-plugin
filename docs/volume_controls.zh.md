# 音量控制

控制 AdMob 视频广告的音量，以便您可以将它们与应用的音频设置进行集成。音量控制在 Android 和 iOS 上均可运行。

使用 `set_app_volume()` 设置相对音量（0.0 至 1.0），并使用 `set_app_muted()` 静音或取消静音广告音频。

# 前提条件

- 完成 [开始使用指南](index.md)
- 使用 Godot v4.2 或更高版本

# 如何使用

=== "GDScript"

    ```gdscript
    # 设置广告音量（0.0 = 静音，1.0 = 最大音量）
    MobileAds.set_app_volume(0.5)
    
    # 静音或取消静音广告
    MobileAds.set_app_muted(true)
    ```

=== "C#"

    ```csharp
    // 设置广告音量（0.0 = 静音，1.0 = 最大音量）
    MobileAds.SetAppVolume(0.5f);
    
    // 静音或取消静音广告
    MobileAds.SetAppMuted(true);
    ```

# API 参考

**set_app_volume(volume: float)**

设置广告播放的相对音量。值被限制在 0.0（静音）到 1.0（当前设备音量）范围内。

**set_app_muted(muted: bool)**

在应用音频静音时通知 AdMob SDK。当为 `true` 时，广告音频被静音。

# 重要说明

- 这些设置适用于视频广告（插屏广告、激励广告、激励插屏广告、开屏广告）。横幅广告和原生广告可能不支持自定义音量控制。
- 音量设置可以随时更改，无论是在广告加载之前还是之后。
- 将这些调用与应用内游戏音量滑块或设置屏幕同步，以获得一致的用户体验。
