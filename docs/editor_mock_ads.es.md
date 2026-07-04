# Vista Previa de Anuncios Mock en el Editor

!!! note "Documentación Godot 3 (v1)"
    Esta página es para **Godot 3.x**. Para **Godot 4.2+**, consulte la [documentación estable](https://poingstudios.github.io/godot-admob-plugin/stable/).

El complemento incluye un sistema de Anuncios Mock integrado. Esto te permite probar los diseños visuales y el flujo lógico de tu integración de anuncios directamente dentro del Editor de Godot sin desplegar en un dispositivo físico.

Los anuncios mock simulan comportamientos de anuncios y disparan las mismas callbacks del ciclo de vida (como carga, muestra, clics y descartes) que los SDKs móviles reales.

---

## Cómo Funciona

El complemento detecta automáticamente cuando tu juego se ejecuta en una plataforma de escritorio (Windows, macOS o Linux) dentro del Editor de Godot. En lugar de fallar debido a singletons nativos de Android o iOS faltantes, el complemento instancia automáticamente mock singletons y nodos.

No necesitas cambiar nada de tu código C# o GDScript. Todas las APIs estándar del singleton `MobileAds` funcionan exactamente igual.

---

## Formatos Soportados

El sistema mock simula la apariencia visual e interacciones para los siguientes formatos de anuncio:

### Banners
- Renderiza un contenedor de banner mock en pantalla coincidiendo con tu posición y tamaño configurados (Estándar, Grande, Rectángulo Medio o Leaderboard).
- Incluye un botón de cerrar (`×`) para simular descartes.

### Intersticiales
- Renderiza una superposición intersticial de pantalla completa.
- Incluye un botón de cerrar (`X`) que oculta el anuncio y dispara la callback `interstitial_closed`.

### Recompensados e Intersticiales Recompensados
- Renderiza una simulación de video recompensado de pantalla completa.
- Reproduce un temporizador de cuenta regresiva de video simulado.
- Dispara automáticamente la callback `user_earned_rewarded` una vez que la cuenta regresiva se completa.
- Muestra un botón de cerrar (`X`) para volver al juego.

---

## Depuración de Callbacks del Ciclo de Vida

Los plugins mock disparan exactamente las mismas señales que los SDKs móviles reales:

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("interstitial_loaded", self, "_on_interstitial_loaded")
        MobileAds.connect("interstitial_closed", self, "_on_interstitial_closed")
        MobileAds.load_interstitial()

    func _on_interstitial_loaded() -> void:
        print("Ad loaded in Editor!")
        MobileAds.show_interstitial()

    func _on_interstitial_closed() -> void:
        print("Ad dismissed in Editor!")
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Connect("interstitial_loaded", this, nameof(_on_interstitial_loaded));
        MobileAds.Connect("interstitial_closed", this, nameof(_on_interstitial_closed));
        MobileAds.Call("load_interstitial");
    }

    private void _on_interstitial_loaded()
    {
        GD.Print("Ad loaded in Editor!");
        MobileAds.Call("show_interstitial");
    }

    private void _on_interstitial_closed()
    {
        GD.Print("Ad dismissed in Editor!");
    }
    ```