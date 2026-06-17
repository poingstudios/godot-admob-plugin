# iOS バックグラウンドでの一時停止

このステップは iOS のみに適用されます。インタースティシャル広告、リワード広告、リワードインタースティシャル広告などの全画面広告が表示されたときに、Godot のゲームを一時停止するかどうかを設定します。

Android では、全画面広告が表示されるとゲームは自動的に一時停止されます（Google はこの設定の変更を許可していません）。このメソッドを `true` パラメータを渡して呼び出すと、iOS 上でこの挙動を再現できます。

iOS 上でのデフォルト値は `false` です。

# 前提条件

- [はじめに](index.ja.md) ガイドを完了していること
- Godot v4.2 以上を使用していること

# 使い方
このメソッドは、初期化の前、最中、または後の任意のタイミングで呼び出すことができます。例：

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

# 重要な注意点

マルチプレイヤーゲームの場合、接続の問題が発生する可能性があるため、この値を `false` に設定する必要がある場合があります。
[詳細については、こちらをお読みください](https://github.com/poingstudios/godot-admob-ios/issues/70)。
