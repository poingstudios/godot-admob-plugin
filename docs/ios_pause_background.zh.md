# iOS 后台暂停

此步骤仅适用于iOS。它指示当全屏广告（如插页、激励或激励插页）处于活动状态时，您的Godot游戏是否应暂停。

在Android上，当显示全屏广告时，游戏会自动暂停（由操作系统控制，无法配置）。向此方法传递`true`可在iOS上复制此行为。在iOS上，默认值为`false`。

---

## 前提条件

- 完成[入门指南](index.zh.md)
- 使用Godot v3.3或更高版本。

---

## 使用方法

您可以随时调用此方法：

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.set_ios_app_pause_on_background(true)
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Call("set_ios_app_pause_on_background", true);
    }
    ```