# Migrar versiones del SDK

Esta página abarca migraciones para versiones actuales y anteriores del Godot AdMob Editor Plugin.

## Migrar de v4 a v5

Las siguientes subsecciones describen cambios importantes, diferencias de comportamiento y nuevas APIs entre la versión principal 4 y 5 del Godot AdMob Editor Plugin.

### Migración del SDK de Android Next-Gen

La versión 5.0.0 migra el plugin nativo de Android de la dependencia del SDK heredado de Google Mobile Ads al moderno SDK Google Mobile Ads Next-Gen:

* **Dependencia antigua (v4):** `com.google.android.gms:play-services-ads`
* **Nueva dependencia (v5):** `com.google.android.libraries.ads.mobile.sdk:ads-mobile-sdk`

!!! danger "Conflictos de Mediación"
    Dado que algunos adaptadores de mediación heredados de terceros pueden incluir de forma transitiva la antigua biblioteca `play-services-ads` o `play-services-ads-lite`, compilar su build de Android podría generar errores por clases o símbolos duplicados.

#### Solución Automática
El exportador de Godot en la versión 5.0.0 intercepta automáticamente el proceso de exportación de Android y corrige el archivo Gradle del proyecto (`res://android/build/build.gradle` o `res://android/build/app/build.gradle`) para excluir explícitamente las dependencias heredadas:

```groovy
// Agregado automáticamente por Poing Godot AdMob Plugin para soportar GMA Next-Gen SDK
configurations.configureEach {
    exclude group: "com.google.android.gms", module: "play-services-ads"
    exclude group: "com.google.android.gms", module: "play-services-ads-lite"
}
```
No se requiere ninguna intervención o configuración manual.

---

### Eliminación de Smart Banner

El formato heredado `Smart Banner` ha sido marcado como obsoleto por Google y se ha eliminado por completo del plugin en v5.

| Lenguaje | API de Tamaño Eliminada | Reemplazo |
| :--- | :--- | :--- |
| **GDScript** | `AdSize.get_smart_banner_ad_size()` | [`AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(width)`](reference/classes/AdSize.md) |
| **C#** | `AdSize.GetSmartBannerAdSize()` | [`AdSize.GetCurrentOrientationAnchoredAdaptiveBannerAdSize(width)`](reference/classes/AdSize.md) |

!!! note "Retrocompatibilidad de Respaldo"
    Por seguridad, tanto el plugin nativo de Android como el de iOS implementan un respaldo automático: si una escena o diseño antiguo sigue enviando un tamaño de ancho `-1` y altura `-1`, el puente nativo lo intercepta y devuelve un tamaño estándar de Banner Adaptativo Anclado que coincide con el ancho de la pantalla.

#### Cómo Migrar
Usa **Banners Adaptativos Anclados** en su lugar. Son el reemplazo moderno oficial, calculando dinámicamente la altura óptima según el ancho del dispositivo y la densidad de pantalla.

=== "v4"

    === "GDScript"

        ```gdscript
        # Smart banner heredado
        var ad_view := AdView.new(unit_id, AdSize.get_smart_banner_ad_size(), AdPosition.Values.TOP)
        ```

    === "C#"

        ```csharp
        // Smart banner heredado
        var adView = new AdView(unitId, AdSize.GetSmartBannerAdSize(), AdPosition.Values.Top);
        ```

=== "v5"

    === "GDScript"

        ```gdscript
        # Banner adaptativo que coincide con el ancho total
        var ad_size := AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)
        var ad_view := AdView.new(unit_id, ad_size, AdPosition.TOP)
        ```

    === "C#"

        ```csharp
        // Banner adaptativo que coincide con el ancho total
        var adSize = AdSize.GetCurrentOrientationAnchoredAdaptiveBannerAdSize(AdSize.FullWidth);
        var adView = new AdView(unitId, adSize, AdPosition.Top);
        ```

---

### Cambios en la API de AdPosition (Cambio Importante)

En la versión 5.0.0, la API de [`AdPosition`](reference/classes/AdPosition.md) cambió de un enum de enteros básico a una instancia de clase. Esto permite posicionar los anuncios de banner utilizando coordenadas estáticas predefinidas o desplazamientos de píxeles personalizados.

| API v4 (Obsoleta) | API v5 (Reemplazo) |
| :--- | :--- |
| `AdPosition.Values.TOP` | `AdPosition.TOP` |
| `AdPosition.Values.BOTTOM` | `AdPosition.BOTTOM` |
| `AdPosition.Values.LEFT` | `AdPosition.LEFT` |
| `AdPosition.Values.RIGHT` | `AdPosition.RIGHT` |
| `AdPosition.Values.TOP_LEFT` | `AdPosition.TOP_LEFT` |
| `AdPosition.Values.TOP_RIGHT` | `AdPosition.TOP_RIGHT` |
| `AdPosition.Values.BOTTOM_LEFT` | `AdPosition.BOTTOM_LEFT` |
| `AdPosition.Values.BOTTOM_RIGHT` | `AdPosition.BOTTOM_RIGHT` |
| `AdPosition.Values.CENTER` | `AdPosition.CENTER` |
| Posicionamiento personalizado no soportado | `AdPosition.custom(x, y)` |

#### Cómo Migrar
Actualiza las creaciones de tus banners y actualizaciones de posición para pasar instancias de la clase [`AdPosition`](reference/classes/AdPosition.md) en lugar de los valores brutos del enum.

=== "v4"

    === "GDScript"

        ```gdscript
        var ad_view := AdView.new(unit_id, ad_size, AdPosition.Values.TOP)
        ```

    === "C#"

        ```csharp
        var adView = new AdView(unitId, adSize, AdPosition.Values.Top);
        ```

=== "v5"

    === "GDScript"

        ```gdscript
        # Posición predefinida
        var ad_view := AdView.new(unit_id, ad_size, AdPosition.TOP)
        
        # Coordenadas personalizadas (ej. x=0, y=100)
        var custom_ad_view := AdView.new(unit_id, ad_size, AdPosition.custom(0, 100))
        ```

    === "C#"

        ```csharp
        // Posición predefinida
        var adView = new AdView(unitId, adSize, AdPosition.Top);

        // Coordenadas personalizadas (ej. x=0, y=100)
        var customAdView = new AdView(unitId, adSize, AdPosition.Custom(0, 100));
        ```

---

### Cambios en el Ecosistema de Mediación

El ecosistema de mediación se ha limpiado y actualizado. Los socios de mediación obsoletos se han eliminado y ahora se admiten varias redes nuevas.

#### Redes de Mediación Eliminadas
El siguiente adaptador de mediación heredado se ha eliminado debido a su obsolescencia:

* AdColony

#### Redes de Mediación Agregadas
Se ha introducido soporte para las siguientes redes de mediación:

* AppLovin
* BidMachine
* Chartboost
* DT Exchange
* i-mobile
* InMobi
* IronSource
* LINE
* Unity Ads

---

### Nuevos Formatos de Anuncios

La versión 5.0.0 agrega soporte de primera clase para dos nuevos formatos de anuncios:

1. **Anuncios de Abertura de la Aplicación (App Open Ads):** Se muestran cuando los usuarios abren o reanudan la aplicación. Se cargan mediante [`AppOpenAdLoader`](reference/classes/AppOpenAdLoader.md) y se controlan usando [`AppOpenAd`](reference/classes/AppOpenAd.md).
2. **Anuncios de Native Overlay:** Permiten renderizar anuncios nativos personalizables directamente sobre el juego utilizando plantillas nativas (diseños Small o Medium) personalizadas con estilos ([`NativeTemplateStyle`](reference/classes/NativeTemplateStyle.md), [`NativeAdOptions`](reference/classes/NativeAdOptions.md)).

---

### Nuevas Configuraciones Globales y Funciones de Privacidad

Se han agregado varios métodos nuevos de API a la clase [`MobileAds`](reference/classes/MobileAds.md) y [`UserMessagingPlatform`](reference/classes/UserMessagingPlatform.md) para el consentimiento, el cumplimiento de la privacidad y la depuración:

* **Ad Inspector:** Abre el Ad Inspector mediante [`MobileAds`](reference/classes/MobileAds.md).`open_ad_inspector(ad_inspector_closed_listener)`.
* **Opción de ID de Primera Parte:** Activa o desactiva el ID de primera parte del editor con [`MobileAds`](reference/classes/MobileAds.md).`set_publisher_first_party_id_enabled(enabled)`.
* **Preferencia de Cookies de Consentimiento:** Configura si el SDK tiene consentimiento para cookies mediante [`MobileAds`](reference/classes/MobileAds.md).`set_gad_has_consent_for_cookies(enabled)` y consúltalo con `get_gad_has_consent_for_cookies()`.
* **Desactivar Reportes de Bloqueos (solo iOS):** Evita que el SDK de Mobile Ads capture y envíe reportes de bloqueos mediante [`MobileAds`](reference/classes/MobileAds.md).`disable_sdk_crash_reporting()`.
* **Opciones de Privacidad UMP:** Muestra el formulario de opciones de configuración de privacidad bajo demanda mediante [`UserMessagingPlatform`](reference/classes/UserMessagingPlatform.md).`show_privacy_options_form(on_privacy_options_form_dismissed)` y consulta su estado usando [`ConsentInformation`](reference/classes/ConsentInformation.md).`get_privacy_options_requirement_status()`.

---

### Configuración Unificada en los Ajustes del Proyecto

En la versión 5.0.0, el plugin ha unificado todas las opciones de configuración directamente en los **Ajustes del Proyecto** (Project Settings) nativos de Godot, bajo la sección `admob/`. Esto reemplaza cualquier flujo de configuración heredado o entradas de menú de editor personalizadas.

!!! warning "Cambio de Configuración Importante: config.gd Eliminado"
    En la versión 4, el AdMob App ID se configuraba modificando el script de configuración estática ubicado en `res://addons/admob/android/config.gd`.
    
    En la versión 5, **el archivo `config.gd` ha sido completamente eliminado**. Debes transferir tus App IDs a la nueva ubicación en los Ajustes del Proyecto.

Las opciones de configuración ahora se registran y configuran en **Ajustes del Proyecto > General**:

* **Configuración de Android:** `admob/general/android/enabled`, `admob/general/android/app_id` y banderas de optimización.
* **Configuración de iOS:** `admob/general/ios/enabled` y `admob/general/ios/app_id`.
* **Redes de Mediación:** Todos los socios de mediación se activan o desactivan globalmente mediante banderas booleanas bajo `admob/mediation/` (ej. `admob/mediation/applovin`, `admob/mediation/meta`, etc.).

![General Settings](assets/general_settings.png)
![Mediation Settings](assets/mediation_settings.png)

---

### Instalador Dinámico de Binarios Headless (CI/CD)

Para soportar builds de CI headless sin empaquetar grandes binarios nativos en Git, v5.0.0 incluye un descargador síncrono:

* Al ejecutarse en un entorno headless (como GitHub Actions), el plugin verifica automáticamente si faltan los binarios de las plataformas Android/iOS.
* Descarga y extrae automáticamente estos binarios de manera dinámica a partir de los lanzamientos oficiales del repositorio durante el inicio del plugin.
