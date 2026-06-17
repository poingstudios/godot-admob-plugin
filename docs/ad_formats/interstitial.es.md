# Intersticial
Los anuncios intersticiales son anuncios expansivos de pantalla completa que se superponen a la interfaz de una aplicación y persisten hasta que el usuario los cierra. Son más efectivos cuando se colocan estratégicamente durante las pausas naturales en la ejecución de la aplicación, como entre niveles de un juego o inmediatamente después de completar una tarea.

Este documento se basa en:

- [Documentación de Android del SDK de anuncios de Google para móviles](https://developers.google.com/admob/android/interstitial)
- [Documentación de iOS del SDK de anuncios de Google para móviles](https://developers.google.com/admob/ios/interstitial)

## Requisitos previos
- Completa el[Guía de introducción](../index.md)

## Pruebe siempre con anuncios de prueba

Al desarrollar y probar sus aplicaciones Godot, es fundamental utilizar anuncios de prueba en lugar de anuncios de producción en vivo. De lo contrario, se puede suspender su cuenta de AdMob.

El método más sencillo para cargar anuncios de prueba es utilizar nuestro ID de bloque de anuncios de prueba dedicado para intersticiales de Android e iOS:

=== "Androide"
    ```
    ca-app-pub-3940256099942544/1033173712
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/4411468910
    ```

Este ID de bloque de anuncios en particular se ha configurado específicamente para ofrecer anuncios de prueba para cada solicitud. Puede emplearlo de forma segura durante las fases de codificación, prueba y depuración. Sin embargo, recuerde reemplazar este ID de bloque de anuncios de prueba por el suyo propio cuando esté listo para publicar su aplicación.

Para obtener una comprensión más completa de cómo funcionan los anuncios de prueba del SDK de anuncios móviles, consulte nuestra documentación en[Anuncios de prueba](../enable_test_ads.md).


## Ejemplo intersticial

El siguiente código de ejemplo demuestra cómo utilizar el Intersticial. En este ejemplo, creará una instancia de un intersticial, cargará un anuncio en él mediante una AdRequest y mejorará la funcionalidad manejando varios eventos del ciclo de vida.


### Cargar un anuncio
Para cargar un anuncio intersticial, utilice la clase `InterstitialAdLoader`. Pase un `InterstitialAdLoadCallback` para recibir el anuncio cargado o cualquier posible error. Vale la pena señalar que, al igual que otras devoluciones de llamada de carga de formato, `InterstitialAdLoadCallback` aprovecha `LoadAdError` para proporcionar detalles completos del error.

=== "GDScript"

    ```gdscript linenums="1" hl_lines="30"
    extends Node2D
    
    var _interstitial_ad : InterstitialAd
    
    func _ready() -> void:
        #The initializate needs to be done only once, ideally at app launch.
    	MobileAds.initialize()
    
    func _on_load_pressed():
    	#free memory
    	if _interstitial_ad:
    		#always call this method on all AdFormats to free memory on Android/iOS
    		_interstitial_ad.destroy()
    		_interstitial_ad = null
    
    	var unit_id : String
    	if OS.get_name() == "Android":
    		unit_id = "ca-app-pub-3940256099942544/1033173712"
    	elif OS.get_name() == "iOS":
    		unit_id = "ca-app-pub-3940256099942544/4411468910"
    
    	var interstitial_ad_load_callback := InterstitialAdLoadCallback.new()
    	interstitial_ad_load_callback.on_ad_failed_to_load = func(adError : LoadAdError) -> void:
    		print(adError.message)
    
    	interstitial_ad_load_callback.on_ad_loaded = func(interstitial_ad : InterstitialAd) -> void:
    		print("interstitial ad loaded" + str(interstitial_ad._uid))
    		_interstitial_ad = interstitial_ad
    
    	InterstitialAdLoader.new().load(unit_id, AdRequest.new(), interstitial_ad_load_callback)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="42"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    
    public partial class InterstitialAdExample : Node2D
    {
        private InterstitialAd _interstitialAd;
    
        public override void _Ready()
        {
            //The initializate needs to be done only once, ideally at app launch.
            MobileAds.Initialize();
        }
    
        private void OnLoadPressed()
        {
            //free memory
            if (_interstitialAd != null)
            {
                //always call this method on all AdFormats to free memory on Android/iOS
                _interstitialAd.Destroy();
                _interstitialAd = null;
            }
    
            string unitId = null;
            if (OS.GetName() == "Android")
                unitId = "ca-app-pub-3940256099942544/1033173712";
            else if (OS.GetName() == "iOS")
                unitId = "ca-app-pub-3940256099942544/4411468910";
    
            var interstitialAdLoadCallback = new InterstitialAdLoadCallback
            {
                OnAdFailedToLoad = (LoadAdError adError) => GD.Print(adError.Message),
                OnAdLoaded = (InterstitialAd interstitialAd) => 
                {
                    GD.Print("interstitial ad loaded");
                    _interstitialAd = interstitialAd;
                }
            };
    
            new InterstitialAdLoader().Load(unitId, new AdRequest(), interstitialAdLoadCallback);
        }
    }
    ```

### Configurar FullScreenContentCallback
`FullScreenContentCallback` gestiona los eventos asociados con la visualización de su `InterstitialAd`. Antes de presentar el `InterstitialAd`, asegúrese de configurar la devolución de llamada:

=== "GDScript"

    ```gdscript linenums="1" hl_lines="28"
    extends Node2D
    
    var _interstitial_ad : InterstitialAd
    var _full_screen_content_callback := FullScreenContentCallback.new()
    
    func _ready() -> void:
    	#...
    	_full_screen_content_callback.on_ad_clicked = func() -> void:
    		print("on_ad_clicked")
    	_full_screen_content_callback.on_ad_dismissed_full_screen_content = func() -> void:
    		print("on_ad_dismissed_full_screen_content")
    	_full_screen_content_callback.on_ad_failed_to_show_full_screen_content = func(ad_error : AdError) -> void:
    		print("on_ad_failed_to_show_full_screen_content")
    	_full_screen_content_callback.on_ad_impression = func() -> void:
    		print("on_ad_impression")
    	_full_screen_content_callback.on_ad_showed_full_screen_content = func() -> void:
    		print("on_ad_showed_full_screen_content")
    
    func _on_load_pressed():
    	#...
    	var interstitial_ad_load_callback := InterstitialAdLoadCallback.new()
    
    	#...
    
    	interstitial_ad_load_callback.on_ad_loaded = func(interstitial_ad : InterstitialAd) -> void:
    		print("interstitial ad loaded" + str(interstitial_ad._uid))
    		_interstitial_ad = interstitial_ad
    		_interstitial_ad.full_screen_content_callback = _full_screen_content_callback
    
    	#...
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="34"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    
    public partial class InterstitialAdExample : Node2D
    {
        private InterstitialAd _interstitialAd;
        private FullScreenContentCallback _fullScreenContentCallback;
    
        public override void _Ready()
        {
            //...
            _fullScreenContentCallback = new FullScreenContentCallback
            {
                OnAdClicked = () => GD.Print("on_ad_clicked"),
                OnAdDismissedFullScreenContent = () => GD.Print("on_ad_dismissed_full_screen_content"),
                OnAdFailedToShowFullScreenContent = (AdError adError) => GD.Print("on_ad_failed_to_show_full_screen_content"),
                OnAdImpression = () => GD.Print("on_ad_impression"),
                OnAdShowedFullScreenContent = () => GD.Print("on_ad_showed_full_screen_content")
            };
        }
    
        private void OnLoadPressed()
        {
            //...
            var interstitialAdLoadCallback = new InterstitialAdLoadCallback
            {
                //...
                OnAdLoaded = (InterstitialAd interstitialAd) => 
                {
                    GD.Print("interstitial ad loaded");
                    _interstitialAd = interstitialAd;
                    _interstitialAd.FullScreenContentCallback = _fullScreenContentCallback;
                }
            };
            //...
        }
    }
    ```

### Mostrar el anuncio

Lo ideal es que los anuncios intersticiales se muestren durante las pausas orgánicas en la progresión de la aplicación. Los ejemplos incluyen entre niveles de juego o después de que un usuario realiza una tarea. Para presentar un anuncio intersticial, utilice la función `show()`.


=== "GDScript"

    ```gdscript linenums="1" hl_lines="3"
    func _on_show_pressed():
    	if _interstitial_ad:
    		_interstitial_ad.show()
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="4"
    private void OnShowPressed()
    {
        if (_interstitialAd != null)
            _interstitialAd.Show();
    }
    ```

### Limpiar la memoria

Al completar un `InterstitialAd`, es importante invocar la función `destroy()` antes de publicar su referencia:

=== "GDScript"

    ```gdscript 
    if _interstitial_ad:
    	_interstitial_ad.destroy()
    	_interstitial_ad = null
    ```

=== "C#"

    ```csharp
    if (_interstitialAd != null)
    {
        _interstitialAd.Destroy();
        _interstitialAd = null;
    }
    ```


Esta acción le indica al complemento que el objeto ya no está en uso y que la memoria que ocupa se puede recuperar. No llamar a este método puede provocar pérdidas de memoria.

## Mejores prácticas para anuncios intersticiales

1. **Considere la relevancia**:
    - Evalúe si los anuncios intersticiales son adecuados para su aplicación.
    - Los anuncios intersticiales funcionan mejor en aplicaciones con puntos de transición naturales, como la finalización de tareas o avances de nivel. Asegúrese de que estos puntos se alineen con las expectativas del usuario de una pausa en la acción.

2. **Pausar actividad de la aplicación**:
    - Al mostrar un anuncio intersticial, pausa las actividades relevantes de la aplicación para permitir que el anuncio utilice recursos específicos de manera efectiva.
    - Por ejemplo, suspenda la salida de audio cuando muestre un anuncio intersticial para mejorar la experiencia publicitaria.

3. **Optimizar el tiempo de carga**:
    - Cargue anuncios intersticiales por adelantado llamando a `InterstitialAdLoader.new().load()` antes de invocar `show()`. Esto garantiza que su aplicación tenga un anuncio intersticial completamente cargado listo cuando llegue el momento de mostrar uno.

4. **Evite la sobrecarga de anuncios**:
    - Abstenerse de inundar a los usuarios con anuncios intersticiales excesivos.
    - Una visualización de anuncios demasiado frecuente puede dificultar la experiencia del usuario y reducir las tasas de clics. Logre un equilibrio que permita a los usuarios disfrutar de su aplicación sin interrupciones constantes.

Recuerde que la implementación de anuncios intersticiales debería mejorar, no perjudicar, la experiencia del usuario en su aplicación.

## Referencias adicionales

### Muestras
- [Proyecto de muestra](https://github.com/poingstudios/godot-admob-plugin/tree/master/addons/admob/sample): Una ilustración mínima del uso de todos los formatos de anuncios
