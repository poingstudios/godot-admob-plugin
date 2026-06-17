# Adaptativo anclado
Los banners adaptables representan la evolución de los anuncios responsivos, mejorando el rendimiento al optimizar dinámicamente el tamaño del anuncio para cada dispositivo. A diferencia de los banners inteligentes, que solo admiten alturas fijas, los banners adaptables le permiten especificar el ancho del anuncio, que luego se utiliza para determinar el tamaño de anuncio más adecuado.

Para seleccionar el tamaño de anuncio óptimo, los banners adaptables se basan en relaciones de aspecto fijas en lugar de alturas fijas. Esto da como resultado anuncios publicitarios que mantienen una proporción constante de la pantalla en varios dispositivos, lo que ofrece la posibilidad de mejorar el rendimiento.

Cuando se trabaja con banners adaptables, es importante tener en cuenta que devuelven constantemente un tamaño establecido para un dispositivo y ancho en particular. Una vez que haya probado su diseño en un dispositivo específico, puede contar con que el tamaño del anuncio permanecerá sin cambios. Sin embargo, tenga en cuenta que el tamaño de la creatividad del banner puede variar según los diferentes dispositivos. Por lo tanto, recomendamos que su diseño tenga en cuenta las posibles diferencias en la altura del anuncio. En raras ocasiones, es posible que no se llene todo el tamaño adaptable y, en su lugar, se centrará una creatividad de tamaño estándar en ese espacio.

Este documento se basa en:

- [Documentación de Android del SDK de anuncios de Google para móviles](https://developers.google.com/admob/android/banner/anchored-adaptive)
- [Documentación de iOS del SDK de anuncios de Google para móviles](https://developers.google.com/admob/ios/banner/anchored-adaptive)


## Requisitos previos
- Completa el[Guía de introducción](../../../index.md)

## Notas de implementación para banners adaptativos en Godot

1. **Conocimiento del ancho**: Debe tener conocimiento del ancho de la vista donde se colocará el anuncio. **Esto debe tener en cuenta el ancho del dispositivo y cualquier área o corte seguro que pueda estar presente**.

2. **Versión del complemento**: asegúrese de estar utilizando la última versión del complemento Godot de anuncios móviles de Google. Para la mediación, asegúrese de utilizar también la última versión de cada adaptador de mediación.

3. **Uso óptimo del ancho**: los tamaños de banner adaptables funcionan mejor cuando utilizan todo el ancho disponible. En la mayoría de los casos, esto equivale al ancho total de la pantalla del dispositivo. Tenga en cuenta las áreas seguras que puedan aplicarse.

4. **Tamaño del anuncio**: el SDK de anuncios de Google para móviles ajusta automáticamente el tamaño del banner con una altura de anuncio optimizada según el ancho proporcionado cuando se utilizan las API de AdSize adaptables.

5. **Tamaños de banner adaptables**: puede obtener tamaños de anuncios adaptables utilizando tres funciones: `AdSize.get_landscape_anchored_adaptive_banner_ad_size` para paisaje, `AdSize.get_portrait_anchored_adaptive_banner_ad_size` para retrato y `AdSize.get_current_orientation_anchored_adaptive_banner_ad_size` para la orientación actual en el momento de la ejecución.

6. **Tamaño estable**: el tamaño devuelto para un ancho determinado en un dispositivo específico permanecerá constante. Por lo tanto, una vez que haya probado su diseño en un dispositivo en particular, puede estar seguro de que el tamaño del anuncio no cambiará.

7. **Altura del banner anclado**: La altura del banner anclado siempre está dentro de ciertos límites. Nunca excederá el 15% de la altura del dispositivo ni caerá por debajo de 50 píxeles independientes de la densidad (dp).

8. **Banners de ancho completo**: para banners de ancho completo, puede utilizar la constante `AdSize.FULL_WIDTH` en lugar de especificar un ancho específico.

## Guía de inicio rápido

Siga estos pasos para implementar un banner de anclaje adaptativo simple en Godot:

1. **Obtener tamaño de anuncio adaptable**:
    - Obtenga el ancho del dispositivo en uso en píxeles independientes de la densidad (dp) o establezca su ancho personalizado si no desea utilizar el ancho de pantalla completo. Que `DisplayServer.window_get_size().x` sea útil.
    - Alternativamente, establezca un ancho personalizado si no desea utilizar el ancho de pantalla completo.
    - Para banners de ancho completo, utilice la marca `AdSize.FullWidth`.
    - Utilice los métodos estáticos apropiados en la clase de tamaño de anuncio, como `AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(width)`, para obtener un objeto `AdSize` adaptable para la orientación actual.

2. **Crear una vista de anuncio**:
    - Cree una instancia de un objeto "AdView" con el ID de su bloque de anuncios, el tamaño adaptable obtenido en el paso 1 y la posición deseada para su anuncio.

3. **Creación de solicitud de anuncio**:
    - Cree un objeto de solicitud de anuncio.
    - Utilice la función `load_ad()` en su vista de anuncio preparada para cargar su banner ancla adaptable, tal como lo haría con una solicitud de banner estándar.

## Ilustración de código de muestra

A continuación se muestra un ejemplo de script que carga y actualiza un banner adaptable:
=== "GDScript"

    ```gdscript linenums="1" hl_lines="25 29"
    extends Node2D
    
    var _ad_view : AdView
    var _ad_listener := AdListener.new()
    
    func _ready() -> void:
    	var on_initialization_complete_listener := OnInitializationCompleteListener.new()
    	on_initialization_complete_listener.on_initialization_complete = func(initialization_status : InitializationStatus) -> void:
    		_request_ad_view()
    	MobileAds.initialize(on_initialization_complete_listener)
    	
    	_ad_listener.on_ad_failed_to_load = _on_ad_failed_to_load
    	_ad_listener.on_ad_loaded = _on_ad_loaded
    
    func _request_ad_view() -> void:
    	var unit_id : String
    	if OS.get_name() == "Android":
    		unit_id = "ca-app-pub-3940256099942544/6300978111"
    	elif OS.get_name() == "iOS":
    		unit_id = "ca-app-pub-3940256099942544/6300978111"
    	
    	if (_ad_view != null):
    		_ad_view.destroy()
    		
    	var adaptive_size := AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)	
    	_ad_view = AdView.new(unit_id, adaptive_size, AdPosition.TOP)
    	_ad_view.ad_listener = _ad_listener
    	
    	_ad_view.load_ad(AdRequest.new())
    
    func _on_ad_failed_to_load(load_ad_error : LoadAdError) -> void:
    	print("_on_ad_failed_to_load: " + load_ad_error.message)
    
    func _on_ad_loaded() -> void:
    	print("_on_ad_loaded")
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="37 41"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Listeners;
    using PoingStudios.AdMob.Api.Core;
    
    public partial class AnchoredAdaptiveExample : Node2D
    {
        private AdView _adView;
        private AdListener _adListener;
    
        public override void _Ready()
        {
            var onInitializationCompleteListener = new OnInitializationCompleteListener
            {
                OnInitializationComplete = (InitializationStatus status) => RequestAdView()
            };
            MobileAds.Initialize(onInitializationCompleteListener);
            
            _adListener = new AdListener
            {
                OnAdFailedToLoad = OnAdFailedToLoad,
                OnAdLoaded = OnAdLoaded
            };
        }
    
        private void RequestAdView()
        {
            string unitId = null;
            if (OS.GetName() == "Android")
                unitId = "ca-app-pub-3940256099942544/6300978111";
            else if (OS.GetName() == "iOS")
                unitId = "ca-app-pub-3940256099942544/6300978111";
    
            if (_adView != null)
                _adView.Destroy();
    
            var adaptiveSize = AdSize.GetCurrentOrientationAnchoredAdaptiveBannerAdSize(AdSize.FullWidth);
            _adView = new AdView(unitId, adaptiveSize, AdPosition.Top);
            _adView.AdListener = _adListener;
    
            _adView.LoadAd(new AdRequest());
        }
    
        private void OnAdFailedToLoad(LoadAdError loadAdError)
        {
            GD.Print("_on_ad_failed_to_load: " + loadAdError.Message);
        }
    
        private void OnAdLoaded()
        {
            GD.Print("_on_ad_loaded");
        }
    }
    ```

En este contexto, utilizamos funciones como `AdSize.get_current_orientation_anchored_adaptive_banner_ad_size` para recuperar el tamaño de un banner en una posición anclada, alineándolo con la orientación actual de la interfaz. Para precargar un banner anclado para una orientación específica, puede utilizar la función adecuada, ya sea `AdSize.get_portrait_anchored_adaptive_banner_ad_size` o `AdSize.get_landscape_anchored_adaptive_banner_ad_size`.
