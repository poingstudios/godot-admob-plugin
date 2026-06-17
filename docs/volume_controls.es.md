# Controles de volumen

Controla el volumen de los anuncios de vídeo de AdMob para poder integrarlos con la configuración de audio de tu aplicación. Los controles de volumen funcionan tanto en Android como en iOS.

Utilice `set_app_volume()` para configurar el volumen relativo (0,0 a 1,0) y `set_app_muted()` para silenciar o reactivar el audio del anuncio.

## Requisitos previos

- Completa el [Guía de introducción](index.md)
- Utilice Godot v4.2 o superior

## Cómo usar

=== "GDScript"

    ```gdscript
    # Set ad volume (0.0 = silent, 1.0 = full volume)
    MobileAds.set_app_volume(0.5)
    
    # Mute or unmute ads
    MobileAds.set_app_muted(true)
    ```

=== "C#"

    ```csharp
    // Set ad volume (0.0 = silent, 1.0 = full volume)
    MobileAds.SetAppVolume(0.5f);
    
    // Mute or unmute ads
    MobileAds.SetAppMuted(true);
    ```

## Referencia de API

**set_app_volume(volumen: flotante)**
Establece el volumen relativo para la reproducción de anuncios. Los valores se limitan al rango de 0,0 (silencio) a 1,0 (volumen actual del dispositivo).

**set_app_muted(silenciado: bool)**
Informa al SDK de AdMob cuando el audio de la aplicación está silenciado. Cuando es "verdadero", el audio del anuncio se silencia.

## Notas importantes

- Esta configuración se aplica a los anuncios de vídeo (intersticiales, bonificados, intersticiales bonificados, aplicación abierta). Es posible que los anuncios nativos y de banner no admitan el control de volumen personalizado.
- La configuración del volumen se puede cambiar en cualquier momento, antes o después de cargar el anuncio.
- Sincroniza estas llamadas con el control deslizante de volumen del juego o la pantalla de configuración de tu aplicación para una experiencia de usuario consistente.
