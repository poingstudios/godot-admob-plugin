# Empezar
Los anuncios de banner son anuncios rectangulares, que constan de imágenes o texto, que se integran en el diseño de una aplicación. Estos anuncios permanecen en la pantalla mientras los usuarios interactúan con la aplicación y pueden actualizarse automáticamente después de un intervalo de tiempo designado. Si es nuevo en la publicidad móvil, los anuncios publicitarios proporcionan un excelente punto de partida para su proceso de implementación de anuncios.

Esta guía demuestra cómo integrar perfectamente anuncios publicitarios de AdMob en una aplicación Godot. Además de fragmentos de código e instrucciones detalladas, también brinda orientación sobre cómo dimensionar adecuadamente los banners y lo dirige a recursos adicionales para obtener más ayuda.

Este documento se basa en:

- [Documentación de Android del SDK de anuncios de Google para móviles](https://developers.google.com/admob/android/banner)
- [Documentación de iOS del SDK de anuncios de Google para móviles](https://developers.google.com/admob/ios/banner)

## Requisitos previos
- Completa el[Guía de introducción](../../index.md)

## Pruebe siempre con anuncios de prueba

Al desarrollar y probar sus aplicaciones Godot, es fundamental utilizar anuncios de prueba en lugar de anuncios de producción en vivo. De lo contrario, se puede suspender su cuenta de AdMob.

El método más sencillo para cargar anuncios de prueba es utilizar nuestro ID de bloque de anuncios de prueba dedicado para banners de Android e iOS:

=== "Androide"
    ```
    ca-app-pub-3940256099942544/6300978111
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/2934735716
    ```

Este ID de bloque de anuncios en particular se ha configurado específicamente para ofrecer anuncios de prueba para cada solicitud. Puede emplearlo de forma segura durante las fases de codificación, prueba y depuración. Sin embargo, recuerde reemplazar este ID de bloque de anuncios de prueba por el suyo propio cuando esté listo para publicar su aplicación.

Para obtener una comprensión más completa de cómo funcionan los anuncios de prueba del SDK de anuncios móviles, consulte nuestra documentación en[Anuncios de prueba](../../enable_test_ads.md).

## Ejemplo de visualización de anuncios

El siguiente código de ejemplo demuestra cómo utilizar AdView. En este ejemplo, creará una instancia de AdView, cargará un anuncio en ella mediante una AdRequest y mejorará la funcionalidad manejando varios eventos del ciclo de vida.


### Crear un AdView (banner)
El paso inicial para utilizar un anuncio publicitario es crear una instancia de AdView dentro de un script GDScript o C# adjunto a un Nodo.

=== "GDScript"

    ```gdscript linenums="1" hl_lines="20"
    extends Node2D
    
    var _ad_view : AdView
    
    func _ready():
    	#The initializate needs to be done only once, ideally at app launch.
    	MobileAds.initialize()
    
    func _create_ad_view() -> void:
    	#free memory
    	if _ad_view:
    		destroy_ad_view()
    
    	var unit_id : String
    	if OS.get_name() == "Android":
    		unit_id = "ca-app-pub-3940256099942544/6300978111"
    	elif OS.get_name() == "iOS":
    		unit_id = "ca-app-pub-3940256099942544/2934735716"
    
    	_ad_view = AdView.new(unit_id, AdSize.BANNER, AdPosition.TOP)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="28"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    
    public partial class BannerAd : Node2D
    {
        private AdView _adView;
    
        public override void _Ready()
        {
            //The initializate needs to be done only once, ideally at app launch.
            MobileAds.Initialize();
        }
    
        private void CreateAdView()
        {
            //free memory
            if (_adView != null)
                DestroyAdView();
    
            string unitId = null;
            if (OS.GetName() == "Android")
                unitId = "ca-app-pub-3940256099942544/6300978111";
            else if (OS.GetName() == "iOS")
                unitId = "ca-app-pub-3940256099942544/2934735716";
    
            _adView = new AdView(unitId, AdSize.Banner, AdPosition.Top);
        }
    }
    ```

El constructor de un AdView en Godot tiene los siguientes parámetros:

- `unit_id`: el ID del bloque de anuncios de AdMob desde el cual AdView debe cargar anuncios.
- `AdSize`: el tamaño de anuncio de AdMob que desea utilizar (consulte[Tamaños de AdView](#adview-sizes)para detalles).
- `AdPosition`: La posición en la que se debe colocar el anuncio publicitario. La clase `AdPosition` (GDScript) o `AdPosition` (C#) expone instancias estáticas para valores de posición de anuncio válidos (por ejemplo, `AdPosition.TOP`).

Tome nota de los distintos bloques de anuncios utilizados según la plataforma. Al realizar solicitudes de anuncios en iOS, debe utilizar un bloque de anuncios de iOS, mientras que para Android, debe utilizar un bloque de anuncios de Android.

#### (Opcional) Genere un AdView con una posición personalizada
En lugar de utilizar anclajes estándar (como "Arriba" o "Abajo"), puede definir coordenadas "x" e "y" específicas para colocar el banner en un punto personalizado. Las coordenadas determinan dónde se colocará la esquina superior izquierda de la vista del banner.

=== "GDScript"

    ```gdscript linenums="1"
    # Create a banner at coordinate (0, 50) on screen.
    var custom_position := AdPosition.custom(0, 50)
    _ad_view := AdView.new(unit_id, AdSize.BANNER, custom_position)
    ```

=== "C#"

    ```csharp linenums="1"
    // Create a banner at coordinate (0, 50) on screen.
    var customPosition = AdPosition.Custom(0, 50);
    _adView = new AdView(unitId, AdSize.Banner, customPosition);
    ```

#### (Opcional) Genere un AdView con un tamaño personalizado
Además de utilizar constantes AdSize predefinidas, también puede especificar un tamaño personalizado para su anuncio:

=== "GDScript"

    ```gdscript linenums="1"
    var ad_size := AdSize.new(200, 200)
    _ad_view := AdView.new(unit_id, ad_size, AdPosition.TOP)
    ```

=== "C#"

    ```csharp linenums="1"
    var adSize = new AdSize(200, 200);
    _adView = new AdView(unitId, adSize, AdPosition.Top);
    ```

### Cargar un AdView (banner)
La segunda fase en la utilización de AdView implica crear una AdRequest y luego pasarla al método `load_banner()`.

=== "GDScript"

    ```gdscript linenums="1" hl_lines="4 5"
    func _on_load_banner_pressed():
    	if _ad_view == null:
    		_create_ad_view()
    	var ad_request := AdRequest.new()
    	_ad_view.load_ad(ad_request)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="5 6"
    private void OnLoadBannerPressed()
    {
        if (_adView == null)
            CreateAdView();
        var adRequest = new AdRequest();
        _adView.LoadAd(adRequest);
    }
    ```


### Escuche las señales de AdView
Para personalizar el comportamiento de su anuncio, puede conectarse a varios eventos en el ciclo de vida del anuncio, como carga, apertura, cierre y más. Para monitorear estos eventos, puede registrar un `AdListener`:

=== "GDScript"

    ```gdscript linenums="1" hl_lines="3 18"
    func register_ad_listener() -> void:
    	if _ad_view != null:
    		var ad_listener := AdListener.new()
    		
    		ad_listener.on_ad_failed_to_load = func(load_ad_error : LoadAdError) -> void:
    			print("_on_ad_failed_to_load: " + load_ad_error.message)
    		ad_listener.on_ad_clicked = func() -> void:
    			print("_on_ad_clicked")
    		ad_listener.on_ad_closed = func() -> void:
    			print("_on_ad_closed")
    		ad_listener.on_ad_impression = func() -> void:
    			print("_on_ad_impression")
    		ad_listener.on_ad_loaded = func() -> void:
    			print("_on_ad_loaded")
    		ad_listener.on_ad_opened = func() -> void:
    			print("_on_ad_opened")
    			
    		_ad_view.ad_listener = ad_listener
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="5"
    private void RegisterAdListener()
    {
        if (_adView != null)
        {
            _adView.AdListener = new AdListener
            {
                OnAdFailedToLoad = (LoadAdError loadAdError) => GD.Print("_on_ad_failed_to_load: " + loadAdError.Message),
                OnAdClicked = () => GD.Print("_on_ad_clicked"),
                OnAdClosed = () => GD.Print("_on_ad_closed"),
                OnAdImpression = () => GD.Print("_on_ad_impression"),
                OnAdLoaded = () => GD.Print("_on_ad_loaded"),
                OnAdOpened = () => GD.Print("_on_ad_opened")
            };
        }
    }
    ```

### Destruye el AdView (banner)
Al finalizar el uso de AdView, recuerde llamar a Destroy() para liberar los recursos asignados y liberar memoria.

=== "GDScript"

    ```gdscript linenums="1" hl_lines="4"
    func destroy_ad_view() -> void:
    	if _ad_view:
    		#always call this method on all AdFormats to free memory on Android/iOS
    		_ad_view.destroy()
    		_ad_view = null
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="6"
    private void DestroyAdView()
    {
        if (_adView != null)
        {
            //always call this method on all AdFormats to free memory on Android/iOS
            _adView.Destroy();
            _adView = null;
        }
    }
    ```

¡Eso es todo lo que hay que hacer! Su aplicación ahora está completamente preparada para mostrar anuncios publicitarios de AdMob.

## Tamaños de AdView {: #adview-sizes }

A continuación se muestra una tabla que presenta los tamaños de anuncios de banner estándar:


 | Tamaño en dp (AnxAl) | Descripción | Disponibilidad | Constante de tamaño de anuncio | 
 | ---------------------------------- | ----------------------------------------------- | -------------------- | ------------------ | 
 | 320x50 | Estandarte estándar | Teléfonos y tabletas | BANDERA | 
 | 320x100 | Pancarta grande | Teléfonos y tabletas | LARGE_BANNER | 
 | 300x250 | Rectángulo mediano IAB | Teléfonos y tabletas | MEDIO_RECTANGLE | 
 | 468x60 | Banner de tamaño completo de IAB | tabletas | BANNER_COMPLETO | 
 | 728x90 | Tabla de clasificación de la IAB | tabletas | TABLA DE LÍDERES | 
 | Ancho proporcionado x alto adaptable | [Banner adaptable](sizes/anchored_adaptive.md) | Teléfonos y tabletas | N / A | 

## Referencias adicionales

### Muestras
- [Proyecto de muestra](https://github.com/poingstudios/godot-admob-plugin/tree/master/addons/admob/sample): Una ilustración mínima del uso de todos los formatos de anuncios


