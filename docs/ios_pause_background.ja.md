# iOS バックグラウンドの一時停止

この手順はiOSのみです。フルスクリーン広告（インタースティシャル、リワード、リワードインタースティシャルなど）がアクティブな場合、Godotゲームを一時停止するかどうかを指定します。

Androidでは、フルスクリーン広告が表示されるとゲームが自動的に一時停止されます（OSによって制御され、設定できません）。このメソッドに`true`を渡すと、iOSでこの動作を複製します。iOSでは、デフォルト値は`false`です。

---

## 前提条件

- [はじめにガイド](index.ja.md)を完了
- Godot v3.3以上を使用

---

## 使用方法

いつでもこのメソッドを呼び出すことができます：

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