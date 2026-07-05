# Anuncios intersticiales recompensados (beta)

Un [Intersticial recompensado](https://support.google.com/admob/answer/9884467)es una forma específica de formato de anuncio incentivado que le permite ofrecer recompensas a cambio de anuncios que aparecen automáticamente durante las transiciones naturales de las aplicaciones. A diferencia de los anuncios bonificados habituales, los usuarios no están obligados a suscribirse activamente para ver un intersticial recompensado; están perfectamente integrados en la experiencia de la aplicación.

Este documento se basa en:

- [Documentación de Android del SDK de anuncios de Google para móviles](https://developers.google.com/admob/android/rewarded-interstitial)
- [Documentación de iOS del SDK de anuncios de Google para móviles](https://developers.google.com/admob/ios/rewarded-interstitial)

## Requisitos previos
- Completa la [Guía de introducción](../index.md)


## Pruebe siempre con anuncios de prueba

Al desarrollar y probar sus aplicaciones Godot, es fundamental utilizar anuncios de prueba en lugar de anuncios de producción en vivo. De lo contrario, se puede suspender su cuenta de AdMob.

El método más sencillo para cargar anuncios de prueba es utilizar nuestro ID de bloque de anuncios de prueba dedicado para intersticiales recompensados de Android e iOS:

=== "Android"
    ```
    ca-app-pub-3940256099942544/5354046379
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/6978759866
    ```

Este ID de bloque de anuncios en particular se ha configurado específicamente para ofrecer anuncios de prueba para cada solicitud. Puede emplearlo de forma segura durante las fases de codificación, prueba y depuración. Sin embargo, recuerde reemplazar este ID de bloque de anuncios de prueba por el suyo propio cuando esté listo para publicar su aplicación.

Para obtener una comprensión más completa de cómo funcionan los anuncios de prueba del SDK de anuncios móviles, consulte nuestra documentación en [Anuncios de prueba](../enable_test_ads.md).

## Ejemplo de intersticial recompensado

El siguiente ejemplo de código demuestra cómo utilizar el intersticial recompensado. En este ejemplo, creará una instancia de un intersticial recompensado, cargará un anuncio en él mediante una AdRequest y mejorará la funcionalidad gestionando varios eventos del ciclo de vida.


### Cargar un anuncio
Para cargar un anuncio intersticial recompensado, utilice la clase [`RewardedInterstitialAdLoader`](../reference/classes/RewardedInterstitialAdLoader.md). Pase un [`RewardedInterstitialAdLoadCallback`](../reference/listeners/RewardedInterstitialAdLoadCallback.md) para recibir el [`RewardedInterstitialAd`](../reference/classes/RewardedInterstitialAd.md) cargado o cualquier posible error. Vale la pena señalar que, al igual que otras devoluciones de llamada de carga de formato, [`RewardedInterstitialAdLoadCallback`](../reference/listeners/RewardedInterstitialAdLoadCallback.md) aprovecha [`LoadAdError`](../reference/classes/LoadAdError.md) para proporcionar detalles completos del error.

=== "GDScript"

    ```gdscript linenums="1" hl_lines="30"
    extends Node2D
    
    var _rewarded_interstitial_ad : RewardedInterstitialAd
    
    func _ready() -> void:
    	#The initializate needs to be done only once, ideally at app launch.
    	MobileAds.initialize()
    
    func _on_load_pressed():
    	#free memory
    	if _rewarded_interstitial_ad:
    		#always call this method on all AdFormats to free memory on Android/iOS
    		_rewarded_interstitial_ad.destroy()
    		_rewarded_interstitial_ad = null
    
    	var unit_id : String
    	if OS.get_name() == "Android":
    		unit_id = "ca-app-pub-3940256099942544/5354046379"
    	elif OS.get_name() == "iOS":
    		unit_id = "ca-app-pub-3940256099942544/6978759866"
    
    	var rewarded_interstitial_ad_load_callback := RewardedInterstitialAdLoadCallback.new()
    	rewarded_interstitial_ad_load_callback.on_ad_failed_to_load = func(adError : LoadAdError) -> void:
    		print(adError.message)
    
    	rewarded_interstitial_ad_load_callback.on_ad_loaded = func(rewarded_interstitial_ad : RewardedInterstitialAd) -> void:
    		print("rewarded interstitial ad loaded" + str(rewarded_interstitial_ad._uid))
    		_rewarded_interstitial_ad = rewarded_interstitial_ad
    
    	RewardedInterstitialAdLoader.new().load(unit_id, AdRequest.new(), rewarded_interstitial_ad_load_callback)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="42"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    
    public partial class RewardedInterstitialAdExample : Node2D
    {
        private RewardedInterstitialAd _rewardedInterstitialAd;
    
        public override void _Ready()
        {
            //The initializate needs to be done only once, ideally at app launch.
            MobileAds.Initialize();
        }
    
        private void OnLoadPressed()
        {
            //free memory
            if (_rewardedInterstitialAd != null)
            {
                //always call this method on all AdFormats to free memory on Android/iOS
                _rewardedInterstitialAd.Destroy();
                _rewardedInterstitialAd = null;
            }
    
            string unitId = null;
            if (OS.GetName() == "Android")
                unitId = "ca-app-pub-3940256099942544/5354046379";
            else if (OS.GetName() == "iOS")
                unitId = "ca-app-pub-3940256099942544/6978759866";
    
            var rewardedInterstitialAdLoadCallback = new RewardedInterstitialAdLoadCallback
            {
                OnAdFailedToLoad = (LoadAdError adError) => GD.Print(adError.Message),
                OnAdLoaded = (RewardedInterstitialAd rewardedInterstitialAd) => 
                {
                    GD.Print("rewarded interstitial ad loaded");
                    _rewardedInterstitialAd = rewardedInterstitialAd;
                }
            };
    
            new RewardedInterstitialAdLoader().Load(unitId, new AdRequest(), rewardedInterstitialAdLoadCallback);
        }
    }
    ```


### [Opcional] Validar las devoluciones de llamada de verificación del lado del servidor (SSV)
Para aplicaciones que requieren datos adicionales en la verificación del lado del servidor [Android](https://developers.google.com/admob/android/ssv)/[iOS](https://developers.google.com/admob/ios/ssv)devoluciones de llamada, se puede configurar usando [`ServerSideVerificationOptions`](../reference/classes/ServerSideVerificationOptions.md). Cualquier valor de cadena asignado a un objeto publicitario recompensado se transmite al parámetro de consulta `custom_data` de la devolución de llamada SSV. Si no se establecen datos personalizados, el parámetro de consulta `custom_data` estará ausente en la devolución de llamada SSV.

El siguiente fragmento de código ilustra cómo establecer datos personalizados en un objeto de anuncio intersticial recompensado antes de solicitar un anuncio:

=== "GDScript"

    ```gdscript linenums="1" hl_lines="4 5 6 7"
    rewarded_interstitial_ad_load_callback.on_ad_loaded = func(rewarded_interstitial_ad : RewardedInterstitialAd) -> void:
        print("rewarded interstitial ad loaded" + str(rewarded_interstitial_ad._uid))
    
        var server_side_verification_options := ServerSideVerificationOptions.new()
        server_side_verification_options.custom_data = "TEST PURPOSE"
        server_side_verification_options.user_id = "user_id_test"
        rewarded_interstitial_ad.set_server_side_verification_options(server_side_verification_options)
    
        _rewarded_interstitial_ad = rewarded_interstitial_ad
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="5 6 7 8"
    rewardedInterstitialAdLoadCallback.OnAdLoaded = (RewardedInterstitialAd rewardedInterstitialAd) => 
    {
        GD.Print("rewarded interstitial ad loaded");
        
        var serverSideVerificationOptions = new ServerSideVerificationOptions();
        serverSideVerificationOptions.CustomData = "TEST PURPOSE";
        serverSideVerificationOptions.UserId = "user_id_test";
        rewardedInterstitialAd.SetServerSideVerificationOptions(serverSideVerificationOptions);
        
        _rewardedInterstitialAd = rewardedInterstitialAd;
    };
    ```
!!! nota

La cadena de recompensa personalizada es [porcentaje escapó](https://en.wikipedia.org/wiki/Percent-encoding)y puede requerir decodificación cuando se analiza desde la devolución de llamada SSV.

### Configurar FullScreenContentCallback
[`FullScreenContentCallback`](../reference/listeners/FullScreenContentCallback.md) gestiona los eventos asociados con la visualización de su [`RewardedInterstitialAd`](../reference/classes/RewardedInterstitialAd.md). Antes de presentar el [`RewardedInterstitialAd`](../reference/classes/RewardedInterstitialAd.md), asegúrese de configurar la devolución de llamada:

=== "GDScript"

    ```gdscript linenums="1" hl_lines="28"
    extends Node2D
    
    var _rewarded_interstitial_ad : RewardedInterstitialAd
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
    	var rewarded_interstitial_ad_load_callback := RewardedInterstitialAdLoadCallback.new()
    
    	#...
    
    	rewarded_interstitial_ad_load_callback.on_ad_loaded = func(rewarded_interstitial_ad : RewardedInterstitialAd) -> void:
    		print("rewarded interstitial ad loaded" + str(rewarded_interstitial_ad._uid))
    		_rewarded_interstitial_ad = rewarded_interstitial_ad
    		_rewarded_interstitial_ad.full_screen_content_callback = _full_screen_content_callback
    
    	#...
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="34"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    
    public partial class RewardedInterstitialAdExample : Node2D
    {
        private RewardedInterstitialAd _rewardedInterstitialAd;
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
            var rewardedInterstitialAdLoadCallback = new RewardedInterstitialAdLoadCallback
            {
                //...
                OnAdLoaded = (RewardedInterstitialAd rewardedInterstitialAd) => 
                {
                    GD.Print("rewarded interstitial ad loaded");
                    _rewardedInterstitialAd = rewardedInterstitialAd;
                    _rewardedInterstitialAd.FullScreenContentCallback = _fullScreenContentCallback;
                }
            };
            //...
        }
    }
    ```

### Mostrar el anuncio

Al presentar un anuncio intersticial recompensado, empleará un objeto [`OnUserEarnedRewardListener`](../reference/listeners/OnUserEarnedRewardListener.md) para administrar eventos relacionados con la recompensa.

=== "GDScript"

    ```gdscript linenums="1" hl_lines="14"
    extends Node2D
    
    var _rewarded_interstitial_ad : RewardedInterstitialAd
    var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()
    
    func _ready() -> void:
    	#...
    	on_user_earned_reward_listener.on_user_earned_reward = func(rewarded_item : RewardedItem):
    		print("on_user_earned_reward, rewarded_item: rewarded", rewarded_item.amount, rewarded_item.type)
    
    #...
    func _on_show_pressed():
    	if _rewarded_interstitial_ad:
    		_rewarded_interstitial_ad.show(on_user_earned_reward_listener)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="27"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    
    public partial class RewardedInterstitialAdExample : Node2D
    {
        private RewardedInterstitialAd _rewardedInterstitialAd;
        private OnUserEarnedRewardListener _onUserEarnedRewardListener;
    
        public override void _Ready()
        {
            //...
            _onUserEarnedRewardListener = new OnUserEarnedRewardListener
            {
                OnUserEarnedReward = (RewardedItem rewardedItem) =>
                {
                    GD.Print($"on_user_earned_reward, rewarded_item: rewarded {rewardedItem.Amount} {rewardedItem.Type}");
                }
            };
        }
    
        //...
        private void OnShowPressed()
        {
            if (_rewardedInterstitialAd != null)
                _rewardedInterstitialAd.Show(_onUserEarnedRewardListener);
        }
    }
    ```

### Limpiar la memoria

Al completar un `RewardedInterstitialAd`, es importante invocar la función `destroy()` antes de publicar su referencia:

=== "GDScript"

    ```gdscript linenums="1"
    if _rewarded_interstitial_ad:
        _rewarded_interstitial_ad.destroy()
        _rewarded_interstitial_ad = null
    ```

=== "C#"

    ```csharp linenums="1"
    if (_rewardedInterstitialAd != null)
    {
        _rewardedInterstitialAd.Destroy();
        _rewardedInterstitialAd = null;
    }
    ```


Esta acción le indica al complemento que el objeto ya no está en uso y que la memoria que ocupa se puede recuperar. No llamar a este método puede provocar pérdidas de memoria.

## Referencias adicionales

### Muestras
- [Proyecto de muestra](https://github.com/poingstudios/godot-admob-plugin/tree/master/addons/admob/sample): Una ilustración mínima del uso de todos los formatos de anuncios
