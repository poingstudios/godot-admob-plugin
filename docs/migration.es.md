# Migrar versiones del SDK

Esta página abarca migraciones para versiones actuales y anteriores.

## Migrar de v4 a v5

Las siguientes subsecciones describen cambios importantes y diferencias de comportamiento entre la versión principal 4 y 5 del Godot AdMob Editor Plugin.

### Eliminación de Smart Banner

El formato heredado `Smart Banner` ha sido marcado como obsoleto por Google y se ha eliminado por completo del plugin en v5.

| Lenguaje | Propiedad Eliminada | Reemplazo |
| :--- | :--- | :--- |
| **GDScript** | `AdSize.SMART_BANNER` | [`AdSize.get_current_orientation_anchored_adaptive_banner_ad_size()`](reference/classes/AdSize.md#adaptive-banners) |
| **C#** | `AdSize.SmartBanner` | [`AdSize.GetCurrentOrientationAnchoredAdaptiveBannerAdSize()`](reference/classes/AdSize.md#adaptive-banners) |

!!! danger "Cambio Importante (Breaking Change)"
    La propiedad estática `AdSize.SMART_BANNER` (GDScript) y `AdSize.SmartBanner` (C#) se han eliminado por completo. Debes actualizar tus scripts para usar métodos de tamaño adaptativo.

#### Cómo Migrar
Usa **Banners Adaptativos Anclados** en su lugar. Son el reemplazo moderno oficial, calculando dinámicamente la altura óptima según el ancho del dispositivo y la densidad de pantalla.

!!! note "Retrocompatibilidad de Respaldo"
    Por seguridad, tanto el plugin nativo de Android como el de iOS implementan un respaldo automático: si una escena o diseño antiguo sigue enviando un tamaño de ancho `-1` y altura `-1`, el puente nativo lo intercepta y devuelve un tamaño estándar de Banner Adaptativo Anclado que coincide con el ancho de la pantalla.

=== "v4"

    === "GDScript"

        ```gdscript
        var ad_view := AdView.new(unit_id, AdSize.SMART_BANNER, AdPosition.TOP)
        ```

    === "C#"

        ```csharp
        var adView = new AdView(unitId, AdSize.SmartBanner, AdPosition.Top);
        ```

=== "v5"

    === "GDScript"

        ```gdscript
        var ad_size := AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)
        var ad_view := AdView.new(unit_id, ad_size, AdPosition.TOP)
        ```

    === "C#"

        ```csharp
        var adSize = AdSize.GetCurrentOrientationAnchoredAdaptiveBannerAdSize(AdSize.FullWidth);
        var adView = new AdView(unitId, adSize, AdPosition.Top);
        ```

### Cambios en la Dependencia de Gradle

El plugin nativo de Android ahora incorpora el nuevo SDK Next-Gen:

* **Dependencia antigua:** `com.google.android.gms:play-services-ads`
* **Nueva dependencia:** `com.google.android.libraries.ads.mobile.sdk:ads-mobile-sdk`

!!! info "Exclusiones Automáticas de Mediación"
    Para evitar símbolos duplicados y conflictos al usar Adaptadores de Mediación (que podrían traer consigo de forma transitiva el SDK heredado), el plugin de exportación de Godot corrige automáticamente el `build.gradle` de tu exportación de Android para excluir `play-services-ads` y `play-services-ads-lite`. No se requiere ninguna exclusión manual en tu configuración de exportación.
