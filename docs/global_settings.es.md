# Configuración Global

La clase `MobileAds` proporciona configuración global para Google Mobile Ads SDK.

## Control de volumen de anuncios

Si su aplicación tiene controles de volumen propios, como volúmenes personalizados de música o efectos de sonido, divulgar el volumen de la aplicación al Google Mobile Ads SDK permite que los anuncios en video respeten la configuración de volumen de la aplicación. Esto garantiza que los usuarios reciban anuncios en video con el volumen de audio esperado.

El volumen del dispositivo, controlado por los botones de volumen o el control deslizante de volumen del nivel del sistema operativo, determina el volumen de la salida de audio del dispositivo. Sin embargo, las aplicaciones pueden ajustar independientemente los niveles de volumen en relación con el volumen del dispositivo para personalizar la experiencia de audio.

Puede reportar el volumen relativo de la aplicación al Google Mobile Ads SDK llamando al método `set_app_volume()` antes de cargar el anuncio. Los valores válidos de volumen del anuncio varían de `0.0` (silencioso) a `1.0` (volumen actual del dispositivo). Aquí hay un ejemplo de cómo reportar el volumen relativo de la aplicación al SDK:

=== "GDScript"

    ```gdscript
    # Establecer el volumen de la aplicación a la mitad del volumen actual del dispositivo.
    MobileAds.set_app_volume(0.5)
    ```

=== "C#"

    ```csharp
    // Establecer el volumen de la aplicación a la mitad del volumen actual del dispositivo.
    MobileAds.SetAppVolume(0.5f);
    ```

!!! warning
    Disminuir el volumen del audio de su aplicación reduce la elegibilidad de los anuncios de video y podría disminuir los ingresos publicitarios de su aplicación. Solo debe usar este método si su aplicación proporciona controles de volumen personalizados al usuario, y el volumen del usuario se refleja correctamente en la aplicación.

Para informar al SDK que el volumen de la aplicación ha sido silenciado, llame al método `set_app_muted()` antes de cargar el anuncio:

=== "GDScript"

    ```gdscript
    # Establecer la aplicación como silenciada.
    MobileAds.set_app_muted(true)
    ```

=== "C#"

    ```csharp
    // Establecer la aplicación como silenciada.
    MobileAds.SetAppMuted(true);
    ```

Por defecto, el volumen de la aplicación se establece en `1`, el volumen actual del dispositivo, y la aplicación no está silenciada.

!!! warning
    Silenciar su aplicación reduce la elegibilidad de los anuncios de video y podría disminuir los ingresos publicitarios de su aplicación. Solo debe usar este método si su aplicación proporciona un control de silencio personalizado al usuario, y la decisión de silencio del usuario se refleja correctamente en la aplicación.

## Consentimiento para cookies

Si su aplicación tiene requisitos especiales, puede establecer la clave opcional `gad_has_consent_for_cookies` en cero para habilitar [anuncios limitados](https://support.google.com/admob/answer/10105530):

=== "GDScript"

    ```gdscript
    # Habilitar anuncios limitados
    MobileAds.set_gad_has_consent_for_cookies(false)
    ```

=== "C#"

    ```csharp
    // Habilitar anuncios limitados
    MobileAds.SetGadHasConsentForCookies(false);
    ```

## Desactivar reporte de fallos

El Google Mobile Ads SDK recopila reportes de fallos para depuración y análisis. Para desactivar el reporte de fallos, vea las siguientes secciones para Android e iOS.

=== "Android"

    Agregue la etiqueta `<meta-data>` con `DISABLE_CRASH_REPORTING` establecido en `true` en el archivo `AndroidManifest.xml` de su aplicación:

    ```xml
    <manifest>
       <application>
           <meta-data
               android:name="com.google.android.gms.ads.flag.DISABLE_CRASH_REPORTING"
               android:value="true" />
       </application>
    </manifest>
    ```

=== "iOS"

    Llame al método `disable_sdk_crash_reporting()` para desactivar los reportes de fallos en iOS:

    === "GDScript"

        ```gdscript
        func _ready() -> void:
            MobileAds.disable_sdk_crash_reporting()
        ```

    === "C#"

        ```csharp
        public override void _Ready()
        {
            MobileAds.DisableSdkCrashReporting();
        }
        ```

## Obtener versión del plugin

Para obtener la versión del plugin, ejecute lo siguiente:

=== "GDScript"

    ```gdscript
    # Obtener la versión del plugin.
    print("Versión del Plugin: " + MobileAds.get_version())
    ```

=== "C#"

    ```csharp
    // Obtener la versión del plugin.
    GD.Print("Versión del Plugin: " + MobileAds.GetVersion());
    ```

## Obtener versión de la plataforma

El Google Mobile Ads SDK depende de las SDK de plataforma Android e iOS. Para obtener la versión de la SDK de la plataforma, ejecute lo siguiente:

=== "GDScript"

    ```gdscript
    # Obtener la versión de la SDK de la plataforma subyacente.
    print("Versión de la SDK de la Plataforma: " + MobileAds.get_platform_version())
    ```

=== "C#"

    ```csharp
    // Obtener la versión de la SDK de la plataforma subyacente.
    GD.Print("Versión de la SDK de la Plataforma: " + MobileAds.GetPlatformVersion());
    ```
