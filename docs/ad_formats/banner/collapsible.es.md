# Anuncios de banner plegables

Los anuncios de banner plegables son anuncios de banner que inicialmente se presentan como una superposición más grande, con un botón para contraerlos al tamaño de banner solicitado originalmente. Los anuncios de banner plegables están destinados a mejorar el rendimiento de los anuncios anclados que, de otro modo, tienen un tamaño más pequeño. Esta guía muestra cómo activar anuncios de banner plegables para ubicaciones de banner existentes.

Este documento se basa en:

- [Documentación de Android del SDK de anuncios de Google para móviles](https://developers.google.com/admob/android/banner/collapsible)
- [Documentación de iOS del SDK de anuncios de Google para móviles](https://developers.google.com/admob/ios/banner/collapsible)

## Requisitos previos
- Completa el[Guía de inicio del banner](get_started.md).

## Implementación

Asegúrese de que su `AdView` esté definido con el tamaño que desea que los usuarios vean en el estado normal (contraído) del banner. Incluya un parámetro extras en `AdRequest` con `collapsible` como clave y la ubicación del anuncio como valor.

La ubicación plegable define cómo la región expandida se ancla al anuncio de banner.

 | Valor de colocación | Comportamiento | Caso de uso previsto | 
 | --- | --- | --- | 
 | `arriba` | La parte superior del anuncio expandido se alinea con la parte superior del anuncio contraído. | El anuncio se coloca en la parte superior de la pantalla. | 
 | `abajo` | La parte inferior del anuncio expandido se alinea con la parte inferior del anuncio contraído. | El anuncio se coloca en la parte inferior de la pantalla. | 

Si el anuncio cargado es un banner contraíble, el banner muestra la superposición contraíble inmediatamente una vez que se coloca en la jerarquía de vistas.

=== "GDScript"

    ```gdscript linenums="1" hl_lines="2"
    var ad_request := AdRequest.new()
    ad_request.extras["collapsible"] = "bottom"

    _ad_view.load_ad(ad_request)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="2"
    var adRequest = new AdRequest();
    adRequest.Extras["collapsible"] = "bottom";
    
    _adView.LoadAd(adRequest);
    ```

!!! información "importante"
La función de banner plegable no está disponible para banners adaptables anclados de gran tamaño. Si su aplicación requiere funcionalidad plegable, use[banners adaptables anclados estándar](sizes/anchored_adaptive.md).

## Comportamiento de actualización de anuncios

Para las aplicaciones que configuran la actualización automática para anuncios de banner en la interfaz web de AdMob, cuando se solicita un anuncio de banner plegable para un espacio de banner, las actualizaciones de anuncios posteriores no solicitarán anuncios de banner plegables. Esto se debe a que mostrar un banner plegable en cada actualización podría tener un impacto negativo en la experiencia del usuario.

Si desea cargar otro anuncio de banner plegable más adelante en la sesión, puede cargar un anuncio manualmente con una solicitud que contenga el parámetro "collapsible".

## Comprobar si un anuncio cargado es plegable

Los anuncios de banner no plegables son elegibles para regresar cuando se soliciten banners plegables para maximizar el rendimiento. Llame a `is_collapsible()` (o `IsCollapsible()` en C#) para comprobar si el último banner cargado es plegable.

=== "GDScript"
    ```gdscript linenums="1" hl_lines="6"
    func _ready() -> void:
    	# ...
    	_ad_view.ad_listener.on_ad_loaded = _on_ad_loaded

    func _on_ad_loaded() -> void:
    	var is_collapsible: bool = _ad_view.is_collapsible()
    	print("Ad loaded. Collapsible: %s" % is_collapsible)
    ```

=== "C#"
    ```csharp linenums="1" hl_lines="7"
    private void RegisterAdListener()
    {
    	_adView.AdListener = new AdListener
    	{
    		OnAdLoaded = () => 
    		{
    			bool isCollapsible = _adView.IsCollapsible();
    			GD.Print($"Ad loaded. Collapsible: {isCollapsible}");
    		}
    	};
    }
    ```

## Mediación

Los anuncios de banner plegables solo están disponibles para la demanda de Google. Los anuncios publicados a través de la mediación se muestran como anuncios de banner normales y no plegables.
