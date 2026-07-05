# Intersticial
Os anúncios intersticiais são anúncios em tela cheia que cobrem a interface de um aplicativo e persistem até serem fechados pelo usuário. Eles são mais eficazes quando colocados estrategicamente durante pausas naturais na execução do aplicativo, como entre os níveis de um jogo ou imediatamente após a conclusão de uma tarefa.

Este documento é baseado em:

- [Documentação do SDK do Google Mobile Ads para Android (Inglês)](https://developers.google.com/admob/android/interstitial)
- [Documentação do SDK do Google Mobile Ads para iOS (Inglês)](https://developers.google.com/admob/ios/interstitial)

## Pré-requisitos
- Complete o [Guia de Primeiros Passos](../index.md)

## Sempre teste com anúncios de teste

Ao desenvolver e testar seus aplicativos Godot, é crucial usar anúncios de teste em vez de anúncios de produção reais. Não fazer isso pode resultar na suspensão da sua conta do AdMob.

O método mais direto para carregar anúncios de teste é utilizar nosso ID de bloco de anúncios de teste dedicado para intersticiais do Android e iOS:

=== "Android"
    ```
    ca-app-pub-3940256099942544/1033173712
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/4411468910
    ```

Este ID de bloco de anúncios específico foi configurado propositalmente para fornecer anúncios de teste para cada solicitação. Você pode usá-lo com segurança durante as fases de codificação, teste e depuração. No entanto, lembre-se de substituir esse ID de bloco de anúncios de teste pelo seu próprio quando estiver pronto para publicar seu aplicativo.

Para uma compreensão mais abrangente de como funcionam os anúncios de teste do SDK do Mobile Ads, consulte nossa documentação sobre [Anúncios de Teste](../enable_test_ads.md).


## Exemplo de Intersticial

O exemplo de código abaixo demonstra como utilizar o Intersticial. Neste exemplo, você criará uma instância de um Intersticial, carregará um anúncio nele usando um AdRequest e aprimorará a funcionalidade manipulando vários eventos de ciclo de vida.


### Carregar um anúncio
Para carregar um anúncio intersticial, utilize a classe [`InterstitialAdLoader`](../reference/classes/InterstitialAdLoader.md). Passe um [`InterstitialAdLoadCallback`](../reference/listeners/InterstitialAdLoadCallback.md) para receber o [`InterstitialAd`](../reference/classes/InterstitialAd.md) carregado ou quaisquer erros potenciais. Vale a pena notar que, semelhante aos callbacks de carregamento de outros formatos, o [`InterstitialAdLoadCallback`](../reference/listeners/InterstitialAdLoadCallback.md) aproveita o [`LoadAdError`](../reference/classes/LoadAdError.md) para fornecer detalhes abrangentes do erro.

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

### Configurar o FullScreenContentCallback
O [`FullScreenContentCallback`](../reference/listeners/FullScreenContentCallback.md) gerencia eventos associados à exibição do seu [`InterstitialAd`](../reference/classes/InterstitialAd.md). Antes de apresentar o [`InterstitialAd`](../reference/classes/InterstitialAd.md), certifique-se de configurar o callback:

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

### Exibir o anúncio

Os anúncios intersticiais são idealmente exibidos durante intervalos orgânicos na progressão do aplicativo. Os exemplos incluem entre níveis do jogo ou depois que um usuário realiza uma tarefa. Para apresentar um anúncio intersticial, utilize a função `show()`.


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

### Limpar memória

Após a conclusão de um `InterstitialAd`, é importante invocar a função `destroy()` antes de liberar sua referência a ele:

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


Esta ação sinaliza ao plugin que o objeto não está mais em uso e que a memória que ele ocupa pode ser liberada. Negligenciar a chamada desse método pode levar a vazamentos de memória.

## Boas Práticas para Anúncios Intersticiais

1. **Considere a Relevância**:
    - Avalie se os anúncios intersticiais são adequados para o seu aplicativo.
    - Os anúncios intersticiais funcionam melhor em aplicativos com pontos de transição naturais, como conclusões de tarefas ou avanços de nível. Certifique-se de que esses pontos estejam alinhados com a expectativa do usuário por uma pausa na ação.

2. **Pausar Atividade do Aplicativo**:
    - Ao exibir um anúncio intersticial, pause as atividades relevantes do aplicativo para permitir que o anúncio use recursos específicos de maneira eficaz.
    - Por exemplo, suspenda a saída de áudio ao exibir um anúncio intersticial para melhorar a experiência do anúncio.

3. **Otimizar o Tempo de Carregamento**:
    - Carregue anúncios intersticiais com antecedência chamando `InterstitialAdLoader.new().load()` antes de invocar `show()`. Isso garante que seu aplicativo tenha um anúncio intersticial totalmente carregado pronto quando for a hora de exibir um.

4. **Evite Sobrecarga de Anúncios**:
    - Evite inundar os usuários com anúncios intersticiais excessivos.
    - Uma exibição de anúncios excessivamente frequente pode prejudicar a experiência do usuário e reduzir as taxas de cliques. Encontre um equilíbrio que permita aos usuários desfrutar do seu aplicativo sem interrupções constantes.

Lembre-se de que a implementação de anúncios intersticiais deve aprimorar, não prejudicar, a experiência do usuário em seu aplicativo.

## Referências Adicionais

### Exemplos
- [Projeto de Exemplo](https://github.com/poingstudios/godot-admob-plugin/tree/master/addons/admob/sample): Uma ilustração básica do uso de todos os formatos de anúncios.
