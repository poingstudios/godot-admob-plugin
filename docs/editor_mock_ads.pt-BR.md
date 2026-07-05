# Pré-visualizar Anúncios de Teste no Editor

Use o recurso Pré-visualizar Anúncios de Teste (Preview Mock Ads) para testar a integração dos seus anúncios dentro do Editor do Godot antes de exportar o jogo para dispositivos móveis.

Os anúncios simulados (mock ads) simulam o comportamento dos anúncios, os callbacks de ciclo de vida (como carregamento, exibição, cliques e fechamento) e a apresentação da interface diretamente no Editor do Godot. Isso ajuda você a validar o fluxo de integração, os layouts personalizados e o posicionamento da interface logo no início do desenvolvimento.

## Como funciona

O plugin detecta automaticamente quando seu jogo está sendo executado em uma plataforma desktop (Windows, macOS ou Linux) dentro do Editor do Godot (`OS.has_feature("editor")`). Em vez de falhar devido à ausência dos singletons nativos do Android ou iOS, o plugin instancia singletons e nós simulados automaticamente.

Você não precisa alterar nenhum código GDScript ou C# ou configuração para usar os anúncios simulados. Todas as APIs padrão do [`MobileAds`](reference/classes/MobileAds.md) e dos formatos de anúncios funcionam exatamente da mesma maneira.

## Benefícios de usar anúncios simulados

Os anúncios simulados são uma ferramenta poderosa durante o desenvolvimento para ajudar você a:

- **Validar o fluxo de integração dos anúncios**: Verifique se a inicialização, o carregamento, a exibição e todos os outros callbacks de ciclo de vida são acionados corretamente na lógica do seu jogo.
- **Visualizar layouts visuais**: Verifique como os anúncios aparecem na interface do seu jogo, incluindo o layout e o posicionamento de diferentes formatos de anúncios em relação aos seus elementos de interface (como `SafeArea`).
- **Iteração rápida**: Evite o processo demorado de compilação, exportação e implantação do seu aplicativo em dispositivos físicos ou simuladores apenas para testar comportamentos básicos de anúncios.

## Formatos suportados

O sistema simulado simula a aparência visual e as interações de cada um dos principais formatos de anúncios:

### Banners
- Renderiza um contêiner na tela que corresponde ao tamanho padrão selecionado (por exemplo, banner padrão, banner grande, retângulo médio, leaderboard) ou tamanho personalizado.
- Suporta posições de tela personalizadas ([`AdPosition`](reference/classes/AdPosition.md).custom(x, y)).
- **Banners Retráteis (Collapsible Banners)**: Se você especificar `collapsible` nos extras da solicitação de anúncio, o banner simulado exibirá um botão de alternância para recolher/expandir (`^`), permitindo testar os ajustes de layout e os callbacks quando o banner for recolhido.
- Renderiza um botão de fechar (`×`) para simular o encerramento do anúncio.

![Mock Banner Ad](assets/mock_ad_banner.png)

### App Open
- Renderiza uma sobreposição de anúncio simulado App Open em tela cheia na inicialização do app para testar as transições.

![Mock App Open Ad](assets/mock_ad_app_open.png)

### Intersticial
- Renderiza um card intersticial em tela cheia com identidade visual realista.
- Apresenta um botão de fechar (`X`) que oculta o anúncio e aciona os callbacks de encerramento.

![Mock Interstitial Ad](assets/mock_ad_interstitial.png)

### Premiado (Rewarded) & Intersticial Premiado
- Renderiza uma sobreposição em tela cheia de anúncio premiado.
- Reproduz um temporizador de contagem regressiva de vídeo simulado (geralmente de 8 segundos).
- Apresenta um pop-up de aviso se você tentar fechar o anúncio antes que a contagem regressiva termine ("Tem certeza que deseja fechar? Você perderá sua recompensa").
- Concede a recompensa automaticamente (aciona o callback `on_rewarded_ad_user_earned_reward` / `UserEarnedReward` com detalhes de recompensa fictícios) assim que a contagem regressiva for concluída.
- O botão de fechar (`X`) só é exibido/ativado após a duração mínima (5 segundos) ou quando a recompensa é concedida.

![Mock Rewarded Ad](assets/mock_ad_rewarded.png)

### Native Overlay
- Renderiza anúncios nativos simulados estilizados (suportando layouts `small` e `medium`) usando nós Control do Godot.
- Exibe elementos simulados como ícones de aplicativos, títulos, botões de chamada para ação (CTA) e textos informativos.

![Mock Native Ad](assets/mock_ad_native.png)

## Callbacks de Ciclo de Vida

Os plugins simulados acionam exatamente os mesmos sinais que os SDKs móveis reais, permitindo que você depure a resposta do seu código aos eventos de anúncios.

Por exemplo, quando você solicita um anúncio intersticial, a seguinte sequência é simulada:

=== "GDScript"

    ```gdscript
    var _interstitial_ad: InterstitialAd

    func _load_interstitial():
        var listener := InterstitialAdLoadListener.new()
        listener.on_ad_loaded = func(ad: InterstitialAd) -> void:
            _interstitial_ad = ad
            # O callback simulado é acionado após 0.5s
            print("Ad loaded in Editor!")
            
        listener.on_ad_failed_to_load = func(error: LoadAdError) -> void:
            print("Failed to load: ", error.message)
            
        InterstitialAd.load(unit_id, AdRequest.new(), listener)

    func _show_interstitial():
        if _interstitial_ad:
            var full_screen_listener := FullScreenContentCallback.new()
            full_screen_listener.on_ad_showed_full_screen_content = func() -> void:
                print("Ad shown in Editor!")
                
            full_screen_listener.on_ad_dismissed_full_screen_content = func() -> void:
                print("Ad dismissed in Editor!")
                
            _interstitial_ad.full_screen_content_callback = full_screen_listener
            _interstitial_ad.show()
    ```

=== "C#"

    ```csharp
    private InterstitialAd _interstitialAd;

    private void LoadInterstitial()
    {
        var listener = new InterstitialAdLoadListener
        {
            OnAdLoaded = (ad) =>
            {
                _interstitialAd = ad;
                // O callback simulado é acionado após 0.5s
                GD.Print("Ad loaded in Editor!");
            },
            OnAdFailedToLoad = (error) =>
            {
                GD.Print("Failed to load: " + error.Message);
            }
        };

        InterstitialAd.Load(unitId, new AdRequest(), listener);
    }

    private void ShowInterstitial()
    {
        if (_interstitialAd != null)
        {
            _interstitialAd.FullScreenContentCallback = new FullScreenContentCallback
            {
                OnAdShowedFullScreenContent = () => GD.Print("Ad shown in Editor!"),
                OnAdDismissedFullScreenContent = () => GD.Print("Ad dismissed in Editor!")
            };
            _interstitialAd.Show();
        }
    }
    ```

## Limitações

!!! warning "Não substitui os testes em dispositivos reais"

    Embora o recurso Pré-visualizar Anúncios de Teste no Editor seja ótimo para verificar o fluxo lógico e os layouts de interface, você ainda deve realizar verificações finais em dispositivos móveis físicos ou simuladores/emuladores antes de publicar seu jogo.

- Os anúncios simulados **não** simulam latência de rede, estados de falha de rede ou adaptadores de rede de mediação reais.
- Os anúncios simulados **não** verificam se o seu AdMob App ID ou Ad Unit IDs são registrados/válidos nos servidores do AdMob. Consulte [Ativar anúncios de teste](enable_test_ads.md) para configurar dispositivos de teste para validação em dispositivos reais.
