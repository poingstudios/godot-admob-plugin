# Adaptativo ancorado (Anchored adaptive)

Os banners adaptativos representam a evolução dos anúncios responsivos, melhorando o desempenho ao otimizar dinamicamente o tamanho do anúncio para cada dispositivo. Ao contrário dos smart banners, que suportavam apenas alturas fixas, os banners adaptativos permitem que você especifique a largura do anúncio, que é então usada para determinar o tamanho mais adequado.

Para selecionar o tamanho ideal de anúncio, os banners adaptativos baseiam-se em proporções de aspecto (aspect ratios) fixas em vez de alturas fixas. Isso resulta em anúncios de banner que mantêm uma proporção consistente da tela em vários dispositivos, oferecendo potencial para um melhor desempenho.

Ao trabalhar com banners adaptativos, é importante notar que eles sempre retornam um tamanho definido para um determinado dispositivo e largura. Uma vez testado o seu layout em um dispositivo específico, você pode contar com o tamanho do anúncio permanecendo inalterado. No entanto, lembre-se de que o tamanho do criativo do banner pode variar entre diferentes dispositivos. Portanto, recomendamos que seu layout acomode possíveis diferenças na altura do anúncio. Em casos raros, o tamanho adaptativo total pode não ser preenchido, e um criativo de tamanho padrão será centralizado nesse espaço.

Este documento é baseado em:

- [Documentação de Banners Adaptativos Ancorados do Google Mobile Ads SDK para Android](https://developers.google.com/admob/android/banner/anchored-adaptive)
- [Documentação de Banners Adaptativos Ancorados do Google Mobile Ads SDK para iOS](https://developers.google.com/admob/ios/banner/anchored-adaptive)

## Pré-requisitos
- Concluir o [Guia de Início Rápido](../../../index.md)

## Notas de Implementação para Banners Adaptativos no Godot

1. **Conhecimento da Largura**: Você deve saber a largura da área onde o anúncio será posicionado. **Isso deve levar em consideração a largura do dispositivo e quaisquer safe areas ou recortes de tela (cutouts) que possam estar presentes**.

2. **Versão do Plugin**: Certifique-se de usar a versão mais recente do plugin do Google Mobile Ads para Godot. Para mediação, garanta que também está usando a versão mais recente de cada adaptador de mediação.

3. **Uso de Largura Ideal**: Os tamanhos de banners adaptativos funcionam melhor quando utilizam toda a largura disponível. Na maioria dos casos, isso equivale à largura total da tela do dispositivo. Leve em consideração as safe areas aplicáveis.

4. **Dimensionamento do Anúncio**: O Google Mobile Ads SDK dimensiona automaticamente o banner com uma altura de anúncio otimizada com base na largura fornecida ao usar as APIs de AdSize adaptativo.

5. **Tamanhos de Banner Adaptativo**: Você pode obter tamanhos de anúncios adaptativos usando três funções: `AdSize.get_landscape_anchored_adaptive_banner_ad_size` para modo paisagem, `AdSize.get_portrait_anchored_adaptive_banner_ad_size` para modo retrato e `AdSize.get_current_orientation_anchored_adaptive_banner_ad_size` para a orientação atual do dispositivo no momento da execução.

6. **Dimensionamento Estável**: O tamanho retornado para uma determinada largura em um dispositivo específico permanecerá constante. Portanto, depois de testar seu layout em um dispositivo específico, você pode ter certeza de que o tamanho do anúncio não mudará.

7. **Altura do Banner Ancorado**: A altura do banner ancorado está sempre dentro de certos limites. Ela nunca excederá 15% da altura do dispositivo ou ficará abaixo de 50 pixels independentes de densidade (dp).

8. **Banners de Largura Total**: Para banners de largura total, você pode usar a constante `AdSize.FULL_WIDTH` em vez de especificar uma largura específica.

## Guia de Início Rápido

Siga estas etapas para implementar um banner adaptativo ancorado simples no Godot:

1. **Obter Tamanho do Anúncio Adaptativo**:
    - Obtenha a largura do dispositivo em uso em pixels independentes de densidade (dp), ou defina sua largura personalizada caso não queira usar a largura total da tela. Usar `DisplayServer.window_get_size().x` pode ser útil.
    - Como alternativa, defina uma largura personalizada se não desejar usar a largura total da tela.
    - Para banners de largura total, use a flag `AdSize.FullWidth`.
    - Utilize os métodos estáticos adequados na classe de tamanho de anúncio, como `AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(width)`, para obter um objeto `AdSize` adaptativo para a orientação atual.

2. **Criar um AdView**:
    - Instancie um objeto `AdView` com o seu ID do bloco de anúncios, o tamanho adaptativo obtido no passo 1 e a posição desejada para o seu anúncio.

3. **Criação da Solicitação de Anúncio**:
    - Crie um objeto de solicitação de anúncio (AdRequest).
    - Use a função `load_ad()` no seu ad view preparado para carregar seu banner adaptativo ancorado, exatamente como faria com uma solicitação de banner padrão.

## Exemplo de Código Ilustrativo

Abaixo está um exemplo de script que carrega e atualiza um banner adaptativo:

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

Neste contexto, usamos funções como `AdSize.get_current_orientation_anchored_adaptive_banner_ad_size` para recuperar o tamanho do banner em uma posição ancorada, alinhando-se com a orientação atual da interface. Para pré-carregar um banner ancorado para uma orientação específica, você pode utilizar a função apropriada, seja `AdSize.get_portrait_anchored_adaptive_banner_ad_size` ou `AdSize.get_landscape_anchored_adaptive_banner_ad_size`.
