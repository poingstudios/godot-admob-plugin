# iOS 后台暂停

此步骤仅适用于 iOS，它将指示在显示全屏广告（例如插屏广告、激励广告和激励插屏广告）时，您在 Godot 中的游戏是否应该暂停。

在 Android 上，当显示全屏广告时，您的游戏将自动暂停（Google 不允许对此进行配置）。调用此方法并传入 `true` 参数将在 iOS 上复制此行为。

在 iOS 上，默认值为 `false`。

## 前提条件

- 完成 [开始使用指南](index.md)
- 使用 Godot v4.2 或更高版本

## 如何使用
您可以在任何需要的时候使用此方法，无论是在初始化之前、期间还是之后，例如：

=== "GDScript"

    ```gdscript linenums="1" hl_lines="2"
    func _on_set_ios_app_pause_on_background_button_pressed() -> void:
    	MobileAds.set_ios_app_pause_on_background(true)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="3"
    private void OnSetIosAppPauseOnBackgroundButtonPressed()
    {
        MobileAds.SetIosAppPauseOnBackground(true);
    }
    ```

# 重要说明

如果您的游戏是多人游戏，由于连接问题，您可能需要将此值设置为 `false`。
[在此处阅读有关它的更多信息](https://github.com/poingstudios/godot-admob-ios/issues/70)。
