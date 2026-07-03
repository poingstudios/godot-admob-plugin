# Fondo de pausa de iOS

Este paso es solo para iOS, indicará si tu Juego en Godot debe pausarse o no cuando se muestre un anuncio en pantalla completa, como Intersticial, Recompensado e Intersticial Recompensado.

En Android, tu juego se pausará automáticamente cuando se muestre un anuncio en pantalla completa (Google no permite configurarlo). Llamar a este método pasando un parámetro "verdadero" duplicará este comportamiento en iOS.

En iOS, el valor predeterminado es "falso".

## Requisitos previos

- Completa el [Guía de introducción](index.md)
- Utilice Godot v4.2 o superior

## Cómo usar
Puede utilizar este método siempre que desee, antes, durante o después de la inicialización, como por ejemplo:

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

## Notas importantes

Si tu juego es multijugador, probablemente necesitarás este valor como "falso" debido a problemas de conexión.
[Lea más sobre esto aquí](https://github.com/poingstudios/godot-admob-ios/issues/70).
