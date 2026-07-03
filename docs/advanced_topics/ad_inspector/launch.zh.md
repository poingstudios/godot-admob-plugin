# 启动广告检查器

您可以通过以下方式启动广告检查器：

- 在注册测试设备后，使用您在 AdMob UI 中选择的手势。
- 通过 Google Mobile Ads SDK 以编程方式启动。

## 使用手势启动

要使用手势启动广告检查器，请执行您在 AdMob UI 中为测试设备配置的手势（例如双击或摇晃）。

## 以编程方式启动

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
