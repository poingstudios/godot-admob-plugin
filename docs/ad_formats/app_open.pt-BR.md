# Anúncios de Abertura de App (App Open)

Este guia é voltado para editores que desejam integrar anúncios de abertura de app (App Open) usando o Google Mobile Ads SDK.

Os anúncios de abertura de app são um formato especial de anúncio desenvolvido para editores que desejam monetizar as telas de carregamento de seus aplicativos. Os anúncios de abertura de app podem ser fechados a qualquer momento e são projetados para serem exibidos quando os usuários trazem seu aplicativo para o primeiro plano (foreground).

!!! note
    Os formatos de anúncios específicos podem variar por região.

Os anúncios de abertura de app mostram automaticamente uma pequena área de identidade visual para que os usuários saibam que estão no seu aplicativo. Aqui está um exemplo de como é a aparência de um anúncio de abertura de app:

<img src="https://developers.google.com/static/admob/images/app-open-ad.png" width="300">

## Pré-requisitos

Antes de continuar, faça o seguinte:

- Concluir o [Guia de Início Rápido](../index.md).

## Sempre teste com anúncios de teste

A tabela a seguir contém um ID de bloco de anúncios que você pode usar para solicitar anúncios de teste. Ele foi especialmente configurado para retornar anúncios de teste em vez de anúncios de produção para cada solicitação, tornando seu uso seguro.

No entanto, após registrar um aplicativo no painel web do AdMob e criar seus próprios IDs de blocos de anúncios para usar no aplicativo, [configure explicitamente o seu dispositivo como um dispositivo de teste](../enable_test_ads.md) durante o desenvolvimento.

=== "Android"

    ```
    ca-app-pub-3940256099942544/9257395921
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/5575463023
    ```

## Implementação

As etapas principais para integrar os anúncios de abertura de app são:

1. Criar uma classe utilitária
2. Carregar o anúncio de abertura de app
3. Escutar os eventos do anúncio de abertura de app
4. Considerar a expiração do anúncio
5. Escutar eventos de estado do aplicativo
6. Exibir o anúncio de abertura de app
7. Limpar o anúncio de abertura de app
8. Pré-carregar o próximo anúncio de abertura de app

### Criar uma classe utilitária

Crie uma nova classe (por exemplo, `AppOpenAdManager`) para carregar o anúncio. Esta classe controla uma variável de instância para monitorar um anúncio carregado e o ID do bloco de anúncios para cada plataforma.

!!! tip
    Embora não seja estritamente necessário, adicionar este script como um **Autoload** (Singleton) é altamente recomendado. Isso garante que o gerenciador sobreviva a mudanças de cena e permaneça persistente na árvore de cenas — fornecendo um monitor de estado global transparente idêntico aos sistemas automatizados usados pelo Google em outras plataformas.

=== "GDScript"

    ```gdscript linenums="1"
    extends Node

    var _app_open_ad: AppOpenAd
    var _expire_time: int = 0
    var _is_showing_ad: bool = false

    # Estes blocos de anúncios são configurados para sempre exibir anúncios de teste.
    var _ad_unit_id: String:
        get:
            if OS.get_name() == "Android":
                return "ca-app-pub-3940256099942544/9257395921"
            return "ca-app-pub-3940256099942544/5575463023"

    func is_ad_available() -> bool:
        return _app_open_ad != null

    func load_app_open_ad() -> void:
        pass # implementação abaixo

    func show_app_open_ad() -> void:
        pass # implementação abaixo
    ```

=== "C#"

    ```csharp linenums="1"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    using System;
 
    public partial class AppOpenAdManager : Node
    {
        private AppOpenAd _appOpenAd;
        private long _expireTime;
        private bool _isShowingAd;
 
        // Estes blocos de anúncios são configurados para sempre exibir anúncios de teste.
        private string _adUnitId => OS.GetName() == "Android" 
            ? "ca-app-pub-3940256099942544/9257395921" 
            : "ca-app-pub-3940256099942544/5575463023";
 
        public bool IsAdAvailable => _appOpenAd != null;
 
        public void LoadAppOpenAd()
        {
            // implementação abaixo
        }
 
        public void ShowAppOpenAd()
        {
            // implementação abaixo
        }
    }
    ```

### Carregar o anúncio de abertura de app

O carregamento de um anúncio de abertura de app é realizado usando o método `load()` na classe `AppOpenAdLoader`. O método requer um ID de bloco de anúncios, um objeto `AdRequest` e um listener de conclusão que é chamado quando o carregamento do anúncio é bem-sucedido ou falha. O objeto `AppOpenAd` carregado é fornecido como um parâmetro no listener de conclusão.

=== "GDScript"

    ```gdscript linenums="1"
    func load_app_open_ad() -> void:
        # Limpa o anúncio antigo antes de carregar um novo.
        if _app_open_ad:
            _app_open_ad.destroy()
            _app_open_ad = null
 
        print("Carregando o anúncio de abertura de app.")
 
        # Cria a nossa requisição usada para carregar o anúncio.
        var ad_request := AdRequest.new()
 
        # Envia a requisição para carregar o anúncio.
        var load_callback := AppOpenAdLoadCallback.new()
        load_callback.on_ad_loaded = func(ad: AppOpenAd):
            print("Anúncio de abertura de app carregado com resposta: " + ad.get_response_info().response_id)
            _app_open_ad = ad
            _register_event_handlers(ad)
 
        load_callback.on_ad_failed_to_load = func(error: LoadAdError):
            print("Falha ao carregar anúncio de abertura de app com erro: " + error.message)
 
        AppOpenAdLoader.new().load(_ad_unit_id, ad_request, load_callback)
    ```

=== "C#"

    ```csharp linenums="1"
    public void LoadAppOpenAd()
    {
        // Limpa o anúncio antigo antes de carregar um novo.
        if (_appOpenAd != null)
        {
            _appOpenAd.Destroy();
            _appOpenAd = null;
        }
 
        GD.Print("Carregando o anúncio de abertura de app.");
 
        // Cria a nossa requisição usada para carregar o anúncio.
        var adRequest = new AdRequest();
 
        // Envia a requisição para carregar o anúncio.
        var loadCallback = new AppOpenAdLoadCallback();
        loadCallback.OnAdLoaded = (ad) =>
        {
            GD.Print("Anúncio de abertura de app carregado com resposta: " + ad.GetResponseInfo().ResponseId);
            _appOpenAd = ad;
            RegisterEventHandlers(ad);
        };
        loadCallback.OnAdFailedToLoad = (error) =>
        {
            GD.Print("Falha ao carregar anúncio de abertura de app com erro: " + error.Message);
        };
 
        new AppOpenAdLoader().Load(_adUnitId, adRequest, loadCallback);
    }
    ```

!!! warning
    Tentar carregar um novo anúncio dentro do bloco de conclusão da solicitação quando um anúncio falhar no carregamento é fortemente desaconselhado. Se você precisar carregar um anúncio no bloco de conclusão, limite as tentativas de carregamento para evitar requisições consecutivas com falhas em situações como conectividade limitada de rede.

### Escutar os eventos do anúncio de abertura de app

Para personalizar ainda mais o comportamento do seu anúncio, você pode se conectar a uma série de eventos no ciclo de vida do anúncio: abertura, fechamento e assim por diante. Escute esses eventos registrando um delegate conforme mostrado abaixo.

=== "GDScript"

    ```gdscript linenums="1"
    func _register_event_handlers(ad: AppOpenAd) -> void:
        # Acionado quando o anúncio é estimado como tendo gerado receita.
        ad.on_ad_paid = func(ad_value: AdValue):
            print("Anúncio de abertura de app gerou %d %s." % [ad_value.value_micros, ad_value.currency_code])
 
        var content_callback := FullScreenContentCallback.new()
        # Acionado quando uma impressão é registrada para um anúncio.
        content_callback.on_ad_impression = func():
            print("Impressão de anúncio de abertura de app registrada.")
        # Acionado quando um clique é registrado para um anúncio.
        content_callback.on_ad_clicked = func():
            print("Anúncio de abertura de app foi clicado.")
        # Acionado quando um anúncio abriu conteúdo em tela cheia.
        content_callback.on_ad_showed_full_screen_content = func():
            print("Conteúdo em tela cheia do anúncio de abertura de app aberto.")
        # Acionado quando o anúncio fechou o conteúdo em tela cheia.
        content_callback.on_ad_dismissed_full_screen_content = func():
            print("Conteúdo em tela cheia do anúncio de abertura de app fechado.")
        # Acionado quando o anúncio falhou ao abrir conteúdo em tela cheia.
        content_callback.on_ad_failed_to_show_full_screen_content = func(error: AdError):
            print("Falha ao abrir conteúdo em tela cheia do anúncio de abertura de app com erro: " + error.message)
 
        ad.full_screen_content_callback = content_callback
    ```

=== "C#"

    ```csharp linenums="1"
    private void RegisterEventHandlers(AppOpenAd ad)
    {
        // Acionado quando o anúncio é estimado como tendo gerado receita.
        ad.OnAdPaid = (adValue) =>
        {
            GD.Print($"Anúncio de abertura de app gerou {adValue.ValueMicros} {adValue.CurrencyCode}.");
        };
 
        var contentCallback = new FullScreenContentCallback();
        // Acionado quando uma impressão é registrada para um anúncio.
        contentCallback.OnAdImpression = () => GD.Print("Impressão de anúncio de abertura de app registrada.");
        // Acionado quando um clique é registrado para um anúncio.
        contentCallback.OnAdClicked = () => GD.Print("Anúncio de abertura de app foi clicado.");
        // Acionado quando um anúncio abriu conteúdo em tela cheia.
        contentCallback.OnAdShowedFullScreenContent = () => GD.Print("Conteúdo em tela cheia do anúncio de abertura de app aberto.");
        // Acionado quando o anúncio fechou o conteúdo em tela cheia.
        contentCallback.OnAdDismissedFullScreenContent = () => GD.Print("Conteúdo em tela cheia do anúncio de abertura de app fechado.");
        // Acionado quando o anúncio falhou ao abrir conteúdo em tela cheia.
        contentCallback.OnAdFailedToShowFullScreenContent = (error) => 
            GD.Print("Falha ao abrir conteúdo em tela cheia do anúncio de abertura de app com erro: " + error.Message);
 
        ad.FullScreenContentCallback = contentCallback;
    }
    ```

### Considerar a expiração do anúncio

!!! info "Ponto Chave"
    Os anúncios de abertura de app expiram após quatro horas. Anúncios renderizados mais de quatro horas após a solicitação não serão mais válidos e podem não gerar receita.

Para garantir que você não exiba um anúncio expirado, adicione um método ao `AppOpenAdManager` que verifica há quanto tempo o anúncio foi carregado. Em seguida, utilize esse método para verificar se o anúncio ainda é válido.

O anúncio de abertura de app tem um tempo limite de 4 horas. Armazene o tempo de carregamento na variável `_expire_time`.

=== "GDScript"

    ```gdscript linenums="1" hl_lines="14-15"
    func load_app_open_ad() -> void:
        # ...
        # Envia a requisição para carregar o anúncio.
        var load_callback := AppOpenAdLoadCallback.new()
 
        load_callback.on_ad_failed_to_load = func(error: LoadAdError):
            # Se a operação falhou, um erro é retornado.
            print("Falha ao carregar anúncio de abertura de app com erro: " + error.message)
 
        load_callback.on_ad_loaded = func(ad: AppOpenAd):
            # Se a operação foi concluída com sucesso, nenhum erro é retornado.
            print("Anúncio de abertura de app carregado com resposta: " + ad.get_response_info().response_id)
 
            # Anúncios de abertura de app podem ser pré-carregados por até 4 horas.
            _expire_time = Time.get_unix_time_from_system() + (4 * 60 * 60)
 
            _app_open_ad = ad
            _register_event_handlers(ad)
    ```

    ```gdscript linenums="1"
    func is_ad_available() -> bool:
        return _app_open_ad != null \
               and Time.get_unix_time_from_system() < _expire_time
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="29-30"
    public void LoadAppOpenAd()
    {
        // Limpa o anúncio antigo antes de carregar um novo.
        if (_appOpenAd != null)
        {
            _appOpenAd.Destroy();
            _appOpenAd = null;
        }
 
        GD.Print("Carregando o anúncio de abertura de app.");
 
        // Cria a nossa requisição usada para carregar o anúncio.
        var adRequest = new AdRequest();
 
        // Envia a requisição para carregar o anúncio.
        var loadCallback = new AppOpenAdLoadCallback();
 
        loadCallback.OnAdFailedToLoad = (error) =>
        {
            // Se a operação falhou, um erro é retornado.
            GD.Print("Falha ao carregar anúncio de abertura de app com erro: " + error.Message);
        };
 
        loadCallback.OnAdLoaded = (ad) =>
        {
            // Se a operação foi concluída com sucesso, nenhum erro é retornado.
            GD.Print("Anúncio de abertura de app carregado com resposta: " + ad.GetResponseInfo().ResponseId);
 
            // Anúncios de abertura de app podem ser pré-carregados por até 4 horas.
            _expireTime = DateTimeOffset.UtcNow.ToUnixTimeSeconds() + (4 * 60 * 60);
 
            _appOpenAd = ad;
            RegisterEventHandlers(ad);
        };
 
        new AppOpenAdLoader().Load(_adUnitId, adRequest, loadCallback);
    }
    ```

    ```csharp linenums="1"
    public bool IsAdAvailable
    {
        get
        {
            return _appOpenAd != null 
                   && DateTimeOffset.UtcNow.ToUnixTimeSeconds() < _expireTime;
        }
    }
    ```

### Escutar eventos de estado do aplicativo

Use as notificações de foco do Godot para escutar eventos de primeiro plano (foreground) e segundo plano (background) do aplicativo.

=== "GDScript"

    ```gdscript linenums="1"
    func _notification(what: int) -> void:
        if what == NOTIFICATION_APPLICATION_FOCUS_IN:
            # Se o aplicativo voltou para primeiro plano e o anúncio está disponível, exiba-o.
            if is_ad_available():
                show_app_open_ad()
    ```

=== "C#"

    ```csharp linenums="1"
    public override void _Notification(int what)
    {
        if (what == NotificationApplicationFocusIn)
        {
            // Se o aplicativo voltou para primeiro plano e o anúncio está disponível, exiba-o.
            if (IsAdAvailable)
            {
                ShowAppOpenAd();
            }
        }
    }
    ```

### Exibir o anúncio de abertura de app

Para exibir um anúncio de abertura de app carregado, chame o método `show()` na instância do `AppOpenAd`.

!!! note
    Os anúncios de abertura de app devem ser exibidos durante pausas naturais no fluxo do aplicativo. Entre os níveis de um jogo é um bom exemplo, ou após o usuário concluir uma tarefa.

=== "GDScript"

    ```gdscript linenums="1"
    func show_app_open_ad() -> void:
        if _app_open_ad:
            print("Exibindo anúncio de abertura de app.")
            _app_open_ad.show()
        else:
            print("O anúncio de abertura de app ainda não está pronto.")
    ```

=== "C#"

    ```csharp linenums="1"
    public void ShowAppOpenAd()
    {
        if (_appOpenAd != null)
        {
            GD.Print("Exibindo anúncio de abertura de app.");
            _appOpenAd.Show();
        }
        else
        {
            GD.Print("O anúncio de abertura de app ainda não está pronto.");
        }
    }
    ```

### Limpar o anúncio de abertura de app

Quando terminar de usar um `AppOpenAd`, certifique-se de chamar o método `destroy()` antes de descartar a referência a ele:

=== "GDScript"

    ```gdscript
    _app_open_ad.destroy()
    ```

=== "C#"

    ```csharp
    _appOpenAd.Destroy();
    ```

Isso notifica o plugin que o objeto não é mais utilizado e a memória ocupada por ele pode ser liberada. A falha em chamar este método resultará em vazamentos de memória (memory leaks).

### Pré-carregar o próximo anúncio de abertura de app

O `AppOpenAd` é um objeto de uso único. Isso significa que, uma vez exibido, o anúncio de abertura de app não pode ser reutilizado. Para solicitar outro anúncio de abertura de app, você precisará instanciar um novo objeto `AppOpenAd`.

Para preparar um anúncio de abertura de app para a próxima oportunidade de exibição, pré-carregue o anúncio de abertura de app assim que o evento `on_ad_dismissed_full_screen_content` ou `on_ad_failed_to_show_full_screen_content` for acionado.

=== "GDScript"

    ```gdscript linenums="1"
    # Dentro de _register_event_handlers...
    content_callback.on_ad_dismissed_full_screen_content = func():
        print("Conteúdo em tela cheia do anúncio de abertura de app fechado.")
        # Recarrega o anúncio para que possamos exibir outro o mais rápido possível.
        load_app_open_ad()
 
    content_callback.on_ad_failed_to_show_full_screen_content = func(error: AdError):
        print("Falha ao abrir conteúdo em tela cheia do anúncio de abertura de app.")
        # Recarrega o anúncio para que possamos exibir outro o mais rápido possível.
        load_app_open_ad()
    ```

=== "C#"

    ```csharp linenums="1"
    // Dentro de RegisterEventHandlers...
    contentCallback.OnAdDismissedFullScreenContent = () => 
    {
        GD.Print("Conteúdo em tela cheia do anúncio de abertura de app fechado.");
        // Recarrega o anúncio para que possamos exibir outro o mais rápido possível.
        LoadAppOpenAd();
    };
 
    contentCallback.OnAdFailedToShowFullScreenContent = (error) => 
    {
        GD.Print("Falha ao abrir conteúdo em tela cheia do anúncio de abertura de app.");
        // Recarrega o anúncio para que possamos exibir outro o mais rápido possível.
        LoadAppOpenAd();
    };
    ```

## Inicializações a frio (Cold starts) e telas de carregamento

A documentação até este ponto assume que você apenas exibe anúncios de abertura de app quando os usuários trazem o app para primeiro plano com ele já suspenso na memória. As inicializações a frio ocorrem quando o aplicativo é iniciado, mas não estava suspenso na memória anteriormente.

Um exemplo de inicialização a frio é quando um usuário abre seu app pela primeira vez. Com inicializações a frio, você não terá um anúncio de abertura de app carregado anteriormente que esteja pronto para ser exibido de imediato. O atraso entre quando você solicita um anúncio e recebe a resposta do anúncio de volta pode criar uma situação em que o usuário consegue usar brevemente o seu app antes de ser surpreendido por um anúncio. Isso deve ser evitado, pois prejudica a experiência do usuário.

A maneira preferível de usar anúncios de abertura de app em inicializações a frio é usar uma tela de carregamento para carregar os recursos do seu jogo ou app, e apenas exibir o anúncio a partir dessa tela de carregamento. Se o seu app já concluiu o carregamento e enviou o usuário para o conteúdo principal, não exiba o anúncio.

!!! info "Ponto Chave"
    Para continuar carregando os recursos do app enquanto o anúncio de abertura de app está sendo exibido, sempre carregue os recursos em uma thread em segundo plano (background thread).

## Boas práticas

Os anúncios de abertura de app ajudam a monetizar a tela de carregamento do seu aplicativo quando ele é iniciado pela primeira vez e durante a alternância entre apps, mas é importante ter em mente as seguintes boas práticas para que seus usuários gostem de usar seu aplicativo.

* Exiba seu primeiro anúncio de abertura de app depois que os usuários usarem seu aplicativo algumas vezes.
* Exiba anúncios de abertura de app durante períodos em que seus usuários estariam aguardando o carregamento do aplicativo de qualquer maneira.
* Se houver uma tela de carregamento sob o anúncio de abertura de app e a tela concluir o carregamento antes do anúncio ser fechado, oculte a tela de carregamento dentro do handler de eventos `on_ad_dismissed_full_screen_content`.
* Certifique-se de que o seu `AppOpenAdManager` (o nó que implementa o listener de estado do app) esteja presente na árvore de cenas. As notificações de ciclo de vida, como `NOTIFICATION_APPLICATION_FOCUS_IN`, são necessárias para que os eventos sejam acionados, portanto não remova esse nó; os eventos param de ser disparados se o nó for removido da árvore.

## Recursos adicionais

- [Projeto de Exemplo](https://github.com/poingstudios/godot-admob-plugin/tree/master/addons/admob/sample): Uma implementação minimalista de todos os formatos de anúncios.
