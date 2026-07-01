# Pausa en Segundo Plano de iOS

Este paso es solo para iOS. Indica si tu juego de Godot debe pausarse cuando un anuncio de pantalla completa (como Intersticial, Recompensado o Intersticial Recompensado) está activo.

En Android, tu juego se pausa automáticamente cuando se muestra un anuncio de pantalla completa (esto está controlado por el OS y no se puede configurar). Pasar `true` a este método replica este comportamiento en iOS. En iOS, el valor predeterminado es `false`.

---

## Prerrequisitos

- Completa la [guía de Primeros Pasos](index.es.md)
- Usa Godot v3.3 o superior.

---

## Cómo Usar

Puedes llamar a este método en cualquier momento:

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