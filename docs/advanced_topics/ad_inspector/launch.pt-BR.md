# Iniciar o inspecionador de anúncios

Você pode iniciar o inspecionador de anúncios das seguintes maneiras:

- Usar o gesto selecionado na UI do AdMob após registrar um dispositivo de teste.
- Programaticamente através do SDK do Google Mobile Ads.

## Iniciar usando gestos

Para iniciar o inspecionador de anúncios com um gesto, execute o gesto (como um toque duplo ou agitar) configurado na UI do AdMob para o seu dispositivo de teste.

## Iniciar programaticamente

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
