# Premiado

Os anúncios de vídeo premiados são anúncios de vídeo em tela cheia e imersivos que oferecem aos usuários a opção de assisti-los por completo. Em troca de seu tempo e atenção, os usuários recebem recompensas ou benefícios no aplicativo.

Este documento é baseado em:

- [Documentação do SDK do Google Mobile Ads para Android (Inglês)](https://developers.google.com/admob/android/rewarded)
- [Documentação do SDK do Google Mobile Ads para iOS (Inglês)](https://developers.google.com/admob/ios/rewarded)

## Pré-requisitos
- Complete o [Guia de Primeiros Passos](../index.md)


## Sempre teste com anúncios de teste

Ao desenvolver e testar seus aplicativos Godot, é crucial usar anúncios de teste em vez de anúncios de produção reais. Não fazer isso pode resultar na suspensão da sua conta do AdMob.

O método mais direto para carregar anúncios de teste é utilizar nosso ID de bloco de anúncios de teste dedicado para anúncios premiados no Android e iOS:

=== "Android"
    ```
    ca-app-pub-3940256099942544/5224354917
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/1712485313
    ```

Este ID de bloco de anúncios específico foi configurado propositalmente para fornecer anúncios de teste para cada solicitação. Você pode usá-lo com segurança durante as fases de codificação, teste e depuração. No entanto, lembre-se de substituir esse ID de bloco de anúncios de teste pelo seu próprio quando estiver pronto para publicar seu aplicativo.

Para uma compreensão mais abrangente de como funcionam os anúncios de teste do SDK do Mobile Ads, consulte nossa documentação sobre [Anúncios de Teste](../enable_test_ads.md).


## Exemplo de Premiado

O exemplo de código abaixo demonstra como utilizar o Premiado (Rewarded). Neste exemplo, você criará uma instância de um Premiado, carregará um anúncio nele usando um AdRequest e aprimorará a funcionalidade manipulando vários eventos de ciclo de vida.


### Carregar um anúncio
Para carregar um anúncio premiado, utilize a classe [`RewardedAdLoader`](../reference/classes/RewardedAdLoader.md). Passe um [`RewardedAdLoadCallback`](../reference/listeners/RewardedAdLoadCallback.md) para receber o [`RewardedAd`](../reference/classes/RewardedAd.md) carregado ou quaisquer erros potenciais. Vale a pena notar que, semelhante aos callbacks de carregamento de outros formatos, o [`RewardedAdLoadCallback`](../reference/listeners/RewardedAdLoadCallback.md) aproveita [`LoadAdError`](../reference/classes/LoadAdError.md) para fornecer detalhes abrangentes do erro.

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

### [Opcional] Validar callbacks de verificação do lado do servidor (SSV)
Para aplicativos que necessitam de dados adicionais nos callbacks de verificação do lado do servidor [Android](https://developers.google.com/admob/android/ssv)/[iOS](https://developers.google.com/admob/ios/ssv), o recurso de dados personalizados de anúncios premiados pode ser configurado usando [`ServerSideVerificationOptions`](../reference/classes/ServerSideVerificationOptions.md). Qualquer valor de texto (string) atribuído a um objeto de anúncio premiado é transmitido para o parâmetro de consulta `custom_data` do callback SSV. Se nenhum dado personalizado for definido, o parâmetro de consulta `custom_data` estará ausente no callback SSV.

O trecho de código a seguir ilustra como definir dados personalizados em um objeto de anúncio premiado antes de solicitar um anúncio:

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
!!! note

    A string de recompensa personalizada é codificada com [percent-encoding](https://en.wikipedia.org/wiki/Percent-encoding) e pode exigir decodificação ao ser analisada a partir do callback SSV.

### Configurar o FullScreenContentCallback
O [`FullScreenContentCallback`](../reference/listeners/FullScreenContentCallback.md) gerencia eventos associados à exibição do seu [`RewardedAd`](../reference/classes/RewardedAd.md). Antes de apresentar o [`RewardedAd`](../reference/classes/RewardedAd.md), certifique-se de configurar o callback:

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

### Exibir o anúncio

Ao apresentar um anúncio premiado, você usará um objeto [`OnUserEarnedRewardListener`](../reference/listeners/OnUserEarnedRewardListener.md) para gerenciar eventos relacionados a recompensas.

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

### Limpar memória

Após a conclusão de um `RewardedAd`, é importante invocar a função `destroy()` antes de liberar sua referência a ele:

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


Esta ação sinaliza ao plugin que o objeto não está mais em uso e que a memória que ele ocupa pode ser liberada. Neglicenciar a chamada deste método pode levar a vazamentos de memória.

## Referências Adicionais

### Exemplos
- [Projeto de Exemplo](https://github.com/poingstudios/godot-admob-plugin/tree/master/addons/admob/sample): Uma ilustração básica do uso de todos os formatos de anúncios.
