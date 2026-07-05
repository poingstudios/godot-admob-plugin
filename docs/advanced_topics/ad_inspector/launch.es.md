# Iniciar el inspector de anuncios

Puede iniciar el inspector de anuncios de las siguientes formas:

- Utilizar el gesto que seleccionó en la interfaz de usuario de AdMob después de registrar un dispositivo de prueba.
- De forma programada a través del Google Mobile Ads SDK.

## Iniciar con gestos

Para iniciar el inspector de anuncios con un gesto, realice el gesto (como un doble toque o agitar) que configuró en la interfaz de usuario de AdMob para su dispositivo de prueba.

## Iniciar mediante programación

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
