# Recompensado

Los anuncios de video recompensados ​​son anuncios de video inmersivos en pantalla completa que brindan a los usuarios la opción de verlos por completo. A cambio de su tiempo y atención, los usuarios reciben recompensas o beneficios dentro de la aplicación.

Este documento se basa en:

- [Documentación de Android del SDK de anuncios de Google para móviles](https://developers.google.com/admob/android/rewarded)
- [Documentación de iOS del SDK de anuncios de Google para móviles](https://developers.google.com/admob/ios/rewarded)

## Requisitos previos
- Completa el[Guía de introducción](../index.md)


## Pruebe siempre con anuncios de prueba

Al desarrollar y probar sus aplicaciones Godot, es fundamental utilizar anuncios de prueba en lugar de anuncios de producción en vivo. De lo contrario, se puede suspender su cuenta de AdMob.

El método más sencillo para cargar anuncios de prueba es utilizar nuestro ID de bloque de anuncios de prueba dedicado para Android e iOS recompensados:

=== "Androide"
    ```
    ca-app-pub-3940256099942544/5224354917
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/1712485313
    ```

Este ID de bloque de anuncios en particular se ha configurado específicamente para ofrecer anuncios de prueba para cada solicitud. Puede emplearlo de forma segura durante las fases de codificación, prueba y depuración. Sin embargo, recuerde reemplazar este ID de bloque de anuncios de prueba por el suyo propio cuando esté listo para publicar su aplicación.

Para obtener una comprensión más completa de cómo funcionan los anuncios de prueba del SDK de anuncios móviles, consulte nuestra documentación en[Anuncios de prueba](../enable_test_ads.md).


## Ejemplo recompensado

El siguiente código de ejemplo demuestra cómo utilizar Rewarded. En este ejemplo, creará una instancia de Rewarded, cargará un anuncio en ella mediante una AdRequest y mejorará la funcionalidad manejando varios eventos del ciclo de vida.


### Cargar un anuncio
Para cargar un anuncio recompensado, utilice la clase `RewardedAdLoader`. Pase un `RewardedAdLoadCallback` para recibir el anuncio cargado o cualquier posible error. Vale la pena señalar que, al igual que otras devoluciones de llamada de carga de formato, `RewardedAdLoadCallback` aprovecha `LoadAdError` para proporcionar detalles completos del error.

=== "GDScript"

    ```gdscript linenums="1" hl_lines="30"
    extends Node2D
    
    var _rewarded_ad : RewardedAd
    
    func _ready() -> void:
        #The initializate needs to be done only once, ideally at app launch.
    	MobileAds.initialize()
    
    func _on_load_pressed():
    	#free memory
    	if _rewarded_ad:
    		#always call this method on all AdFormats to free memory on Android/iOS
    		_rewarded_ad.destroy()
    		_rewarded_ad = null
    
    	var unit_id : String
    	if OS.get_name() == "Android":
    		unit_id = "ca-app-pub-3940256099942544/5224354917"
    	elif OS.get_name() == "iOS":
    		unit_id = "ca-app-pub-3940256099942544/1712485313"
    
    	var rewarded_ad_load_callback := RewardedAdLoadCallback.new()
    	rewarded_ad_load_callback.on_ad_failed_to_load = func(adError : LoadAdError) -> void:
    		print(adError.message)
    
    	rewarded_ad_load_callback.on_ad_loaded = func(rewarded_ad : RewardedAd) -> void:
    		print("rewarded ad loaded" + str(rewarded_ad._uid))
    		_rewarded_ad = rewarded_ad
    
    	RewardedAdLoader.new().load(unit_id, AdRequest.new(), rewarded_ad_load_callback)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="42"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    
    public partial class RewardedAdExample : Node2D
    {
        private RewardedAd _rewardedAd;
    
        public override void _Ready()
        {
            //The initializate needs to be done only once, ideally at app launch.
            MobileAds.Initialize();
        }
    
        private void OnLoadPressed()
        {
            //free memory
            if (_rewardedAd != null)
            {
                //always call this method on all AdFormats to free memory on Android/iOS
                _rewardedAd.Destroy();
                _rewardedAd = null;
            }
    
            string unitId = null;
            if (OS.GetName() == "Android")
                unitId = "ca-app-pub-3940256099942544/5224354917";
            else if (OS.GetName() == "iOS")
                unitId = "ca-app-pub-3940256099942544/1712485313";
    
            var rewardedAdLoadCallback = new RewardedAdLoadCallback
            {
                OnAdFailedToLoad = (LoadAdError adError) => GD.Print(adError.Message),
                OnAdLoaded = (RewardedAd rewardedAd) => 
                {
                    GD.Print("rewarded ad loaded");
                    _rewardedAd = rewardedAd;
                }
            };
    
            new RewardedAdLoader().Load(unitId, new AdRequest(), rewardedAdLoadCallback);
        }
    }
    ```

### [Opcional] Validar las devoluciones de llamada de verificación del lado del servidor (SSV)
Para aplicaciones que requieren datos adicionales en la verificación del lado del servidor[Androide](https://developers.google.com/admob/android/ssv)/[iOS](https://developers.google.com/admob/ios/ssv)devoluciones de llamada, se puede emplear la función de datos personalizados de los anuncios recompensados. Cualquier valor de cadena asignado a un objeto publicitario recompensado se transmite al parámetro de consulta `custom_data` de la devolución de llamada SSV. Si no se establecen datos personalizados, el parámetro de consulta `custom_data` estará ausente en la devolución de llamada SSV.

El siguiente fragmento de código ilustra cómo establecer datos personalizados en un objeto publicitario recompensado antes de solicitar un anuncio:

=== "GDScript"

    ```gdscript linenums="1" hl_lines="4 5 6 7"
    rewarded_ad_load_callback.on_ad_loaded = func(rewarded_ad : RewardedAd) -> void:
        print("rewarded ad loaded" + str(rewarded_ad._uid))
        
        var server_side_verification_options := ServerSideVerificationOptions.new()
        server_side_verification_options.custom_data = "TEST PURPOSE"
        server_side_verification_options.user_id = "user_id_test"
        rewarded_ad.set_server_side_verification_options(server_side_verification_options)
        
        _rewarded_ad = rewarded_ad
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="5 6 7 8"
    rewardedAdLoadCallback.OnAdLoaded = (RewardedAd rewardedAd) => 
    {
        GD.Print("rewarded ad loaded");
        
        var serverSideVerificationOptions = new ServerSideVerificationOptions();
        serverSideVerificationOptions.CustomData = "TEST PURPOSE";
        serverSideVerificationOptions.UserId = "user_id_test";
        rewardedAd.SetServerSideVerificationOptions(serverSideVerificationOptions);
        
        _rewardedAd = rewardedAd;
    };
    ```
!!! nota

La cadena de recompensa personalizada es[porcentaje escapó](https://en.wikipedia.org/wiki/Percent-encoding)y puede requerir decodificación cuando se analiza desde la devolución de llamada SSV.

### Configurar FullScreenContentCallback
`FullScreenContentCallback` gestiona los eventos asociados con la visualización de su `RewardedAd`. Antes de presentar el `RewardedAd`, asegúrese de configurar la devolución de llamada:

=== "GDScript"

    ```gdscript linenums="1" hl_lines="28"
    extends Node2D
    
    var _rewarded_ad : RewardedAd
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
    	var rewarded_ad_load_callback := RewardedAdLoadCallback.new()
    
    	#...
    
    	rewarded_ad_load_callback.on_ad_loaded = func(rewarded_ad : RewardedAd) -> void:
    		print("rewarded ad loaded" + str(rewarded_ad._uid))
    		_rewarded_ad = rewarded_ad
    		_rewarded_ad.full_screen_content_callback = _full_screen_content_callback
    
    	#...
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="34"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    
    public partial class RewardedAdExample : Node2D
    {
        private RewardedAd _rewardedAd;
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
            var rewardedAdLoadCallback = new RewardedAdLoadCallback
            {
                //...
                OnAdLoaded = (RewardedAd rewardedAd) => 
                {
                    GD.Print("rewarded ad loaded");
                    _rewardedAd = rewardedAd;
                    _rewardedAd.FullScreenContentCallback = _fullScreenContentCallback;
                }
            };
            //...
        }
    }
    ```

### Mostrar el anuncio

Al presentar un anuncio recompensado, empleará un objeto `OnUserEarnedRewardListener` para administrar eventos relacionados con la recompensa.

=== "GDScript"

    ```gdscript linenums="1" hl_lines="14"
    extends Node2D
    
    var _rewarded_ad : RewardedAd
    var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()
    
    func _ready() -> void:
    	#...
    	on_user_earned_reward_listener.on_user_earned_reward = func(rewarded_item : RewardedItem):
    		print("on_user_earned_reward, rewarded_item: rewarded", rewarded_item.amount, rewarded_item.type)
    
    #...
    func _on_show_pressed():
    	if _rewarded_ad:
    		_rewarded_ad.show(on_user_earned_reward_listener)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="27"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    
    public partial class RewardedAdExample : Node2D
    {
        private RewardedAd _rewardedAd;
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
            if (_rewardedAd != null)
                _rewardedAd.Show(_onUserEarnedRewardListener);
        }
    }
    ```

### Limpiar la memoria

Al completar un `RewardedAd`, es importante invocar la función `destroy()` antes de publicar su referencia:

=== "GDScript"

    ```gdscript
    if _rewarded_ad:
        _rewarded_ad.destroy()
        _rewarded_ad = null
    ```

=== "C#"

    ```csharp
    if (_rewardedAd != null)
    {
        _rewardedAd.Destroy();
        _rewardedAd = null;
    }
    ```


Esta acción le indica al complemento que el objeto ya no está en uso y que la memoria que ocupa se puede recuperar. No llamar a este método puede provocar pérdidas de memoria.

## Referencias adicionales

### Muestras
- [Proyecto de muestra](https://github.com/poingstudios/godot-admob-plugin/tree/master/addons/admob/sample): Una ilustración mínima del uso de todos los formatos de anuncios
