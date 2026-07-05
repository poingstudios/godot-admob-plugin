# Launch ad inspector

You can launch ad inspector in the following ways:

- Use the gesture you selected in the AdMob UI after registering a test device.
- Programmatically through the Google Mobile Ads SDK.

## Launch using gestures

To launch ad inspector with a gesture, perform the gesture (such as a double flick or shake) that you configured in AdMob UI for your test device.

## Launch programmatically

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
