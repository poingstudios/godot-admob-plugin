# Começar

A integração do plugin AdMob da Poing Studios no seu projeto Godot 3 permite exibir anúncios do Google Mobile Ads em dispositivos Android e iOS de forma simples.

---

## Pré-requisitos

- **Godot Engine 3.x Mono/Standard Edition** (v3.3 ou superior).
- **Para Exportação Android**:
  - Template de Build Android habilitado.
  - SDK Android configurado.
- **Para Exportação iOS**:
  - Computador macOS com Xcode instalado.
  - Conta de desenvolvedor Apple ativa.
- **Recomendado**: Uma conta ativa no [AdMob](https://admob.google.com/) com aplicativos Android/iOS registrados.

---

## Download e Importação do Plugin

1. Baixe o release mais recente na página de [GitHub Releases](https://github.com/poingstudios/godot-admob-plugin/releases).
2. Extraia o arquivo e copie a pasta `addons/admob` para o diretório `res://addons/` do seu projeto Godot.
3. Abra o Editor do Godot, navegue até **Projeto -> Configurações do Projeto -> Plugins** e altere o status do plugin **AdMob** para **Habilitado**.

Uma vez habilitado, o plugin registra automaticamente o singleton autoload `MobileAds` no seu projeto.

---

## Baixar Templates de Plataforma

Abra o painel AdMob no editor do Godot (**Projeto -> Ferramentas -> AdMob Manager** ou clique na aba **AdMob**).

* **Android**: Selecione **Download Android Template** para baixar e extrair os arquivos `.aar` e `.gdap` na sua pasta `res://android/plugins/`.
* **iOS**: Selecione **Download iOS Template** para baixar e extrair os arquivos `.gdip` e bibliotecas na sua pasta `res://ios/plugins/`.

---

## Configuração

No painel do AdMob:
1. Configure seus **IDs de Aplicativo AdMob (App IDs)** (ex: `ca-app-pub-3940256099942544~1458002511`).
2. Insira seus **IDs de Bloco de Anúncios (Ad Unit IDs)** para os formatos desejados (Banner, Intersticial, Premiado, Intersticial Premiado).
3. Ative se os anúncios estão habilitados e configure comportamentos padrão como tamanho e posição do Banner.

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

Agora que o SDK está inicializado, você pode implementar os formatos de anúncios que melhor se adaptam ao seu jogo:

* [Anúncios de Banner](ad_formats/banner.md)
* [Anúncios Intersticiais](ad_formats/interstitial.md)
* [Anúncios de Vídeo Premiado (Rewarded)](ad_formats/rewarded.md)
* [Anúncios Intersticiais Premiados](ad_formats/rewarded_interstitial.md)
