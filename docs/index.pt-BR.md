# Começar

!!! note "Documentação Godot 3 (v1)"
    Esta documentação é para o plugin **v1**, que suporta apenas **Godot 3.x**.
    Para **Godot 4.2+**, veja a [documentação estável](https://poingstudios.github.io/godot-admob-plugin/stable/).

A integração do plugin AdMob da Poing Studios no seu projeto Godot 3 permite exibir anúncios do Google Mobile Ads em dispositivos Android e iOS de forma simples.

---

## Pré-requisitos

- **Godot Engine 3.x Mono/Standard Edition** (v3.3 ou superior).
- **Recomendado**: Uma conta ativa no [AdMob](https://admob.google.com/) com aplicativos Android/iOS registrados.

=== "Android"

    - Template de Build Android habilitado.
    - SDK Android configurado.

=== "iOS"

    - Computador macOS com Xcode instalado.
    - Conta de desenvolvedor Apple ativa.

---

## Download e Importação do Plugin

1. Baixe o release mais recente na página de [GitHub Releases](https://github.com/poingstudios/godot-admob-plugin/releases).
2. Extraia o arquivo e copie a pasta `addons/admob` para o diretório `res://addons/` do seu projeto Godot.
3. Abra o Editor do Godot, navegue até **Projeto -> Configurações do Projeto -> Plugins** e altere o status do plugin **AdMob** para **Habilitado**.

Uma vez habilitado, o plugin registra automaticamente o singleton autoload `MobileAds` no seu projeto.

---

## Baixar Templates de Plataforma

Após habilitar o plugin, a aba **AdMob** aparecerá nas abas principais do editor (ao lado de **2D**, **3D**, **AssetLib**, etc.) no topo do editor. Abra-a para acessar o gerenciador AdMob.

=== "Android"

    Selecione **Download Android Template**. O plugin irá baixar e extrair automaticamente os arquivos de template necessários (`.aar` e `.gdap`) diretamente na sua pasta `res://android/plugins/` (não é necessário extrair o zip manualmente).

=== "iOS"

    Selecione **Download iOS Template**. O plugin irá baixar e extrair automaticamente os arquivos de template necessários (`.gdip` e arquivos de biblioteca) diretamente na sua pasta `res://ios/plugins/` (não é necessário extrair o zip manualmente).

---

## Configuração

No **painel do AdMob** (`Projeto -> Ferramentas -> AdMob Manager`), configure as seguintes opções:

| Opção | Descrição |
|-------|-----------|
| **App ID** | Seu ID de aplicativo AdMob (ex: `ca-app-pub-3940256099942544~1458002511`). |
| **Ad Unit IDs** | IDs para cada formato de anúncio que você planeja usar (Banner, Intersticial, Premiado, Intersticial Premiado). |
| **Is Enabled** | Ative/desative os anúncios globalmente. |
| **Banner Position** | Escolha onde o banner aparece (Topo, Rodapé, Personalizado). |
| **Banner Size** | Selecione o tamanho do banner (Banner, Banner Grande, Retângulo Médio, etc.). |

---

## Inicializar o SDK

Antes de carregar anúncios, o SDK do Google Mobile Ads deve ser inicializado. Se a opção **Is Enabled** estiver ativa na sua configuração, o plugin se inicializará automaticamente ao iniciar.

Se preferir inicializar manualmente, ou quiser monitorar a conclusão, conecte-se ao sinal `initialization_complete`:

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("initialization_complete", self, "_on_AdMob_initialization_complete")
        MobileAds.initialize()

    func _on_AdMob_initialization_complete(status: int, adapter_name: String) -> void:
        print("AdMob Inicializado: ", status)
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Connect("initialization_complete", this, nameof(_on_AdMob_initialization_complete));
        MobileAds.Call("initialize");
    }

    private void _on_AdMob_initialization_complete(int status, string adapterName)
    {
        GD.Print("AdMob Inicializado: " + status);
    }
    ```

---

## Selecionar um Formato de Anúncio

O SDK do Google Mobile Ads foi importado com sucesso e você está pronto para integrar anúncios ao seu aplicativo. O AdMob oferece uma variedade de formatos de anúncios, permitindo que você selecione aquele que melhor se alinha à experiência do usuário do seu aplicativo.

### Banner
<div class="image-text-container" markdown="1">

![banner](assets/ad_formats/banner.png)

Anúncios de banner são retangulares, compostos por imagens ou texto, integrados ao layout do aplicativo. Eles permanecem na tela enquanto os usuários interagem com o aplicativo e podem ser atualizados automaticamente. Se você é novo em publicidade móvel, os anúncios de banner são um excelente ponto de partida.

</div>

[Implementar anúncios de banner](ad_formats/banner.md){ .md-button .md-button--primary }

### Intersticial
<div class="image-text-container" markdown="1">

![interstitial](assets/ad_formats/interstitial.png)

Anúncios intersticiais são propagandas expansivas em tela cheia que cobrem a interface do aplicativo até serem fechadas pelo usuário. São mais eficazes quando colocados em pausas naturais, como entre fases de um jogo.

</div>

[Implementar anúncios intersticiais](ad_formats/interstitial.md){ .md-button .md-button--primary }

### Premiado (Rewarded)
<div class="image-text-container" markdown="1">

![rewarded](assets/ad_formats/rewarded.png)

Anúncios em vídeo premiado são propagandas imersivas em tela cheia que oferecem aos usuários a opção de assisti-los por completo. Em troca, os usuários recebem recompensas ou benefícios no aplicativo.

</div>

[Implementar anúncios premiados](ad_formats/rewarded.md){ .md-button .md-button--primary }

### Intersticial Premiado
<div class="image-text-container" markdown="1">

![rewarded_interstitial](assets/ad_formats/rewarded_interstitial.png)

O Intersticial Premiado é um formato de anúncio incentivado que oferece recompensas em troca de anúncios que aparecem automaticamente durante transições naturais do aplicativo.

</div>

[Implementar anúncios intersticiais premiados](ad_formats/rewarded_interstitial.md){ .md-button .md-button--primary }

<style>
  .image-text-container {
    display: flex;
    align-items: center;
  }
  .image-text-container img {
    margin-right: 20px;
    max-width: 130px;
    height: auto;
  }
</style>
