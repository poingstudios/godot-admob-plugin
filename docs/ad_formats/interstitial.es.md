# Anuncios Intersticiales

Los anuncios intersticiales son anuncios de pantalla completa que cubren la interfaz de su aplicación principal. Generalmente se muestran en puntos de transición naturales en el flujo de una aplicación, como entre actividades o durante la pausa entre niveles de un juego.

---

## Implementar Anuncios Intersticiales

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("interstitial_loaded", self, "_on_interstitial_loaded")
        MobileAds.connect("interstitial_failed_to_load", self, "_on_interstitial_failed_to_load")
        MobileAds.connect("interstitial_closed", self, "_on_interstitial_closed")
        
        # Cargar el anuncio intersticial
        MobileAds.load_interstitial()

    func _on_interstitial_loaded() -> void:
        print("Interstitial loaded! Ready to show.")
        # Mostrar intersticial inmediatamente o guardarlo para después
        MobileAds.show_interstitial()

    func _on_interstitial_failed_to_load(error_code: int) -> void:
        print("Interstitial failed to load: ", error_code)

    func _on_interstitial_closed() -> void:
        print("Interstitial ad closed by the user.")
        # Cargar el siguiente anuncio intersticial
        MobileAds.load_interstitial()
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Connect("interstitial_loaded", this, nameof(_on_interstitial_loaded));
        MobileAds.Connect("interstitial_failed_to_load", this, nameof(_on_interstitial_failed_to_load));
        MobileAds.Connect("interstitial_closed", this, nameof(_on_interstitial_closed));
        
        MobileAds.Call("load_interstitial");
    }

    private void _on_interstitial_loaded()
    {
        GD.Print("Interstitial loaded!");
        MobileAds.Call("show_interstitial");
    }

    private void _on_interstitial_failed_to_load(int errorCode)
    {
        GD.Print("Interstitial failed to load: " + errorCode);
    }

    private void _on_interstitial_closed()
    {
        GD.Print("Interstitial closed.");
        MobileAds.Call("load_interstitial");
    }
    ```

---

## Verificación

Puedes consultar si el anuncio intersticial ha terminado de cargarse antes de presentarlo:

=== "GDScript"

    ```gdscript
    if MobileAds.get_is_interstitial_loaded():
        MobileAds.show_interstitial()
    ```

=== "C#"

    ```csharp
    if ((bool)MobileAds.Call("get_is_interstitial_loaded"))
    {
        MobileAds.Call("show_interstitial");
    }
    ```