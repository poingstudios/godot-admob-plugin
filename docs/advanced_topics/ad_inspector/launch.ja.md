# 広告インスペクターの起動

広告インスペクターは以下の方法で起動できます。

- テストデバイスの登録後に AdMob UI で選択したジェスチャーを使用する。
- Google Mobile Ads SDK を使用してプログラムから呼び出す。

## ジェスチャーを使用した起動

ジェスチャーを使用して広告インスペクターを起動するには、テストデバイスに対して AdMob UI で設定したジェスチャー（ダブルフリックやシェイクなど）を行います。

## プログラムによる起動

=== "GDScript"

    ```gdscript
    func open_ad_inspector():
        var listener := AdInspectorClosedListener.new()
        listener.on_ad_inspector_closed = func(error: Dictionary):
            if error.is_empty():
                print("Ad inspector closed.")
            else:
                print("Ad inspector closed with error: ", error)
        
        MobileAds.open_ad_inspector(listener)
    ```

=== "C#"

    ```csharp
    public void OpenAdInspector()
    {
        var listener = new AdInspectorClosedListener
        {
            OnAdInspectorClosed = (error) =>
            {
                if (error.Count == 0)
                {
                    GD.Print("Ad inspector closed.");
                }
                else
                {
                    GD.Print("Ad inspector closed with error: ", error);
                }
            }
        };
        
        MobileAds.OpenAdInspector(listener);
    }
    ```
