# Começar
Os anúncios de banner são anúncios retangulares, compostos por imagens ou texto, que são integrados ao layout do aplicativo. Esses anúncios permanecem na tela enquanto os usuários interagem com o aplicativo e podem ser atualizados automaticamente após um intervalo de tempo designado. Se você é novo no mundo da publicidade móvel, os anúncios de banner oferecem um excelente ponto de partida para a implementação de anúncios.

Este guia demonstra como integrar de forma simples anúncios de banner do AdMob em um aplicativo Godot. Além de snippets de código e instruções detalhadas, ele também fornece orientações sobre como dimensionar adequadamente os banners e direciona para recursos adicionais para obter ajuda.

Este documento é baseado em:

- [Documentação de Banners do Google Mobile Ads SDK para Android](https://developers.google.com/admob/android/banner)
- [Documentação de Banners do Google Mobile Ads SDK para iOS](https://developers.google.com/admob/ios/banner)

## Pré-requisitos
- Concluir o [Guia de Início Rápido](../../index.md)

## Sempre teste com anúncios de teste

Ao desenvolver e testar seus aplicativos Godot, é crucial usar anúncios de teste em vez de anúncios reais de produção. O descumprimento desta regra pode resultar na suspensão da sua conta do AdMob.

O método mais direto para carregar anúncios de teste é utilizar os nossos IDs de blocos de anúncios de teste dedicados para banners no Android e iOS:

=== "Android"
    ```
    ca-app-pub-3940256099942544/6300978111
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/2934735716
    ```

Estes IDs de blocos de anúncios foram configurados propositalmente para exibir anúncios de teste a cada requisição. Você pode usá-los com segurança durante suas fases de programação, testes e depuração. No entanto, lembre-se de substituir esses IDs pelos seus próprios quando estiver pronto para publicar o seu aplicativo.

Para um entendimento mais completo sobre como funcionam os anúncios de teste do Mobile Ads SDK, consulte nossa documentação sobre [Anúncios de Teste](../../enable_test_ads.md).

## Exemplo de AdView

O exemplo de código abaixo demonstra como utilizar o AdView. Neste exemplo, você criará uma instância de um AdView, carregará um anúncio nele usando um AdRequest e adicionará mais funcionalidades tratando vários eventos de ciclo de vida.

### Criar um AdView (banner)
A etapa inicial para usar um anúncio de banner é criar uma instância de um AdView dentro de um script GDScript ou C# anexado a um Node.

=== "GDScript"

    ```gdscript linenums="1" hl_lines="20"
    extends Node2D
    
    var _ad_view : AdView
    
    func _ready():
    	#A inicialização precisa ser feita apenas uma vez, idealmente na inicialização do aplicativo.
    	MobileAds.initialize()
    
    func _create_ad_view() -> void:
    	#libera a memória anterior
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
            //A inicialização precisa ser feita apenas uma vez, idealmente na inicialização do aplicativo.
            MobileAds.Initialize();
        }
    
        private void CreateAdView()
        {
            //libera a memória anterior
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

O construtor do AdView no Godot possui os seguintes parâmetros:

- `unit_id`: O ID do bloco de anúncios do AdMob a partir do qual o AdView deve carregar os anúncios.
- `AdSize`: O tamanho do anúncio do AdMob que você deseja utilizar (consulte [Tamanhos do AdView](#tamanhos-do-adview) para mais detalhes).
- `AdPosition`: A posição onde o anúncio de banner deve ser posicionado. A classe `AdPosition` (GDScript) ou `AdPosition` (C#) expõe instâncias estáticas para valores de posição válidos (por exemplo, `AdPosition.TOP`).

Observe os blocos de anúncios distintos utilizados com base na plataforma. Ao fazer solicitações de anúncios no iOS, você deve usar um bloco do iOS, enquanto para o Android, você deve usar um bloco do Android.

#### (Opcional) Gerar um AdView com uma posição personalizada
Em vez de usar posições padrão (como `Top` ou `Bottom`), você pode definir coordenadas `x` e `y` específicas para posicionar o banner em um ponto personalizado. As coordenadas determinam onde o canto superior esquerdo do banner será posicionado na tela.

=== "GDScript"

    ```gdscript linenums="1"
    # Cria um banner na coordenada (0, 50) da tela.
    var custom_position := AdPosition.custom(0, 50)
    _ad_view := AdView.new(unit_id, AdSize.BANNER, custom_position)
    ```

=== "C#"

    ```csharp linenums="1"
    // Cria um banner na coordenada (0, 50) da tela.
    var customPosition = AdPosition.Custom(0, 50);
    _adView = new AdView(unitId, AdSize.Banner, customPosition);
    ```

#### (Opcional) Gerar um AdView com um tamanho personalizado
Além de utilizar as constantes predefinidas do AdSize, você também pode especificar um tamanho personalizado para o seu anúncio:

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

### Carregar o AdView (banner)
A segunda fase para utilizar o AdView envolve criar um AdRequest e passá-lo para o método `load_banner()`.

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

### Escutar os sinais do AdView
Para personalizar o comportamento do seu anúncio, você pode se conectar a vários eventos do ciclo de vida dele, como carregamento, abertura, fechamento e mais. Para monitorar esses eventos, você pode registrar um `AdListener`:

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

### Destruir o AdView (banner)
Após a conclusão do uso do AdView, lembre-se de chamar `destroy()` para liberar os recursos alocados e liberar espaço na memória.

=== "GDScript"

    ```gdscript linenums="1" hl_lines="4"
    func destroy_ad_view() -> void:
    	if _ad_view:
    		# Sempre chame este método em todos os formatos de anúncio para liberar memória no Android/iOS
    		_ad_view.destroy()
    		_ad_view = null
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="6"
    private void DestroyAdView()
    {
        if (_adView != null)
        {
            // Sempre chame este método em todos os formatos de anúncio para liberar memória no Android/iOS
            _adView.Destroy();
            _adView = null;
        }
    }
    ```

Isso é tudo! Seu aplicativo está agora totalmente preparado para exibir anúncios de banner do AdMob.

## Tamanhos do AdView

Abaixo está uma tabela com os tamanhos padrão de anúncios de banner:

| Tamanho em dp (LxA)              | Descrição                                     | Disponibilidade    | Constante do AdSize |
|----------------------------------|-----------------------------------------------|--------------------|---------------------|
| 320x50                           | Standard Banner                               | Celulares e Tablets| BANNER              |
| 320x100                          | Large Banner                                  | Celulares e Tablets| LARGE_BANNER        |
| 300x250                          | IAB Medium Rectangle                          | Celulares e Tablets| MEDIUM_RECTANGLE    |
| 468x60                           | IAB Full-Size Banner                          | Tablets            | FULL_BANNER         |
| 728x90                           | IAB Leaderboard                               | Tablets            | LEADERBOARD         |
| Largura fornecida x Altura adapt.| [Banner adaptativo](sizes/anchored_adaptive.md) | Celulares e Tablets| N/A                 |
| Largura da tela x 32/50/90       | [Smart banner](sizes/smart_banner.md)         | Celulares e Tablets| N/A                 |

## Outras Referências

### Exemplos
- [Projeto de Exemplo](https://github.com/poingstudios/godot-admob-plugin/tree/master/addons/admob/sample): Uma ilustração minimalista do uso de todos os Formatos de Anúncios.
