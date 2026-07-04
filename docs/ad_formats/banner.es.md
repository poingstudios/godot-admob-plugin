# Anuncios Banner

!!! note "Documentación Godot 3 (v1)"
    Esta página es para **Godot 3.x**. Para **Godot 4.2+**, consulte la [documentación estable](https://poingstudios.github.io/godot-admob-plugin/stable/).

Los anuncios banner ocupan un lugar dentro del diseño de una aplicación, ya sea en la parte superior o inferior de la pantalla. Permanecen en pantalla mientras los usuarios interactúan con la aplicación.

---

## Cargar un Banner

Para cargar un anuncio banner, llama a `MobileAds.load_banner()`.

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("banner_loaded", self, "_on_banner_loaded")
        MobileAds.connect("banner_failed_to_load", self, "_on_banner_failed_to_load")
        
        # Carga un banner usando tu ID de Unidad de Anuncio Banner configurado
        MobileAds.load_banner()

    func _on_banner_loaded() -> void:
        print("Banner loaded successfully!")

    func _on_banner_failed_to_load(error_code: int) -> void:
        print("Banner failed to load with error code: ", error_code)
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Connect("banner_loaded", this, nameof(_on_banner_loaded));
        MobileAds.Connect("banner_failed_to_load", this, nameof(_on_banner_failed_to_load));
        
        MobileAds.Call("load_banner");
    }

    private void _on_banner_loaded()
    {
        GD.Print("Banner loaded successfully!");
    }

    private void _on_banner_failed_to_load(int errorCode)
    {
        GD.Print("Banner failed to load with error code: " + errorCode);
    }
    ```

---

## Mostrar y Ocultar Banners

Si configuraste el banner para que no se muestre instantáneamente, puedes controlar su visibilidad manualmente usando los siguientes métodos:

=== "GDScript"

    ```gdscript
    # Muestra el anuncio banner cargado
    MobileAds.show_banner()

    # Oculta el anuncio banner de la pantalla
    MobileAds.hide_banner()

    # Destruye el banner para liberar memoria
    MobileAds.destroy_banner()
    ```

=== "C#"

    ```csharp
    // Muestra el anuncio banner cargado
    MobileAds.Call("show_banner");

    // Oculta el anuncio banner de la pantalla
    MobileAds.Call("hide_banner");

    // Destruye el banner para liberar memoria
    MobileAds.Call("destroy_banner");
    ```

---

## Verificar Dimensiones del Banner

Puedes verificar el ancho y alto del banner usando los métodos auxiliares:

=== "GDScript"

    ```gdscript
    var width = MobileAds.get_banner_width()
    var height = MobileAds.get_banner_height()
    var width_px = MobileAds.get_banner_width_in_pixels()
    var height_px = MobileAds.get_banner_height_in_pixels()
    ```

=== "C#"

    ```csharp
    // Usa Convert.ToInt32 para obtener tamaños de forma segura en iOS/Android Mono:
    int width = System.Convert.ToInt32(MobileAds.Call("get_banner_width"));
    int height = System.Convert.ToInt32(MobileAds.Call("get_banner_height"));
    ```