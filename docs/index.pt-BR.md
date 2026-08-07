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

## Baixar e Importar o Plugin

=== "Asset Library (Recomendado)"

    1. Abra o seu projeto no Godot Editor e clique na aba **AssetLib** no topo.
    2. Pesquise por **AdMob** (por `poing.studios`).
    3. Clique em **Download** e depois em **Instalar** para adicionar os arquivos do plugin ao seu projeto.
    4. Vá em **Projeto -> Configurações do Projeto -> Plugins** e altere o status do plugin **AdMob** para **Ativo**.

=== "GitHub Releases (Manual)"

    1. Baixe a versão mais recente na página de [Releases no GitHub](https://github.com/poingstudios/godot-admob-plugin/releases).
    2. Extraia o arquivo e copie a pasta `addons/admob` para o diretório `res://addons/` do seu projeto Godot.
    3. Abra o Godot Editor, navegue até **Projeto -> Configurações do Projeto -> Plugins** e altere o status do plugin **AdMob** para **Ativo**.

Assim que ativado, o plugin registrará automaticamente o singleton autoload `MobileAds` no seu projeto.

---

## Baixar Templates de Plataforma

O plugin requer templates binários nativos (`.aar`/`.gdap` para Android, `.gdip`/`.xcframework` para iOS) para compilar as exportações móveis. Você pode obtê-los de três formas:

=== "Automático (Padrão)"

    Ao ativar o plugin, ele tentará automaticamente baixar e extrair os templates nativos correspondentes à sua versão do Godot diretamente no seu projeto (`res://android/plugins/` ou `res://ios/plugins/`).

=== "Aba do Editor AdMob (Manual)"

    Caso o download automático falhe ao ativar o plugin, você pode realizar o download manualmente pelo editor:

    1. Abra a aba **AdMob** no topo do espaço de trabalho do editor.
    2. Acesse a sub-aba **Downloads**.
    3. Selecione a plataforma desejada (**Android** ou **iOS**) e clique em **Download Android Template** ou **Download iOS Template**.

=== "GitHub Releases (Zip Direto)"

    Você também pode baixar o arquivo do template diretamente na página de [Releases no GitHub (v1.3.6-godot3)](https://github.com/poingstudios/godot-admob-plugin/releases/tag/v1.3.6-godot3):

    1. Localize a tag de release para o Godot 3 (ex: `v1.3.6-godot3`) e baixe o arquivo zip correspondente à sua versão do Godot (`android-template-v<godot_version>.zip` ou `ios-template-v<godot_version>.zip`).
    2. Extraia o conteúdo do arquivo diretamente no diretório de plugins da plataforma no seu projeto (`res://android/plugins/` para Android ou `res://ios/plugins/` para iOS).

---

## Configuração

No **painel do AdMob** (`Projeto -> Ferramentas -> AdMob Manager`), configure as seguintes opções:

![Editor AdMob](assets/editor.png)

| Opção | Aba | Descrição |
|-------|-----|-----------|
| **Enabled** | Geral | Ativa/desativa os anúncios mock / funcionalidade do plugin no editor globalmente. |
| **Child Directed Treatment** | Geral | Configura a conformidade COPPA (Tratamento direcionado a crianças). |
| **MaxAdContentRating** | Geral | Define a classificação máxima de conteúdo dos anúncios (`G`, `PG`, `T`, `MA`). |
| **Banner Size** | Banner | Seleciona o tamanho do banner (Padrão, Banner Grande, Retângulo Médio, etc.). |
| **Position** | Banner | Escolha a posição do banner (Topo ou Rodapé). |
| **Show Instantly** | Banner | Exibe o banner automaticamente ao carregar. |
| **Respect Safe Area** | Banner | Ajusta o posicionamento do banner para respeitar áreas seguras (recortes de tela / notches). |

### Configuração do App ID

Antes de exportar para um dispositivo físico, configure o seu [App ID do AdMob](https://support.google.com/admob/answer/7356431) (`ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY`) para cada plataforma desejada:

=== "Android"

    Adicione uma tag `<meta-data>` com seu App ID dentro de `<application>` em `res://android/build/AndroidManifest.xml`:

    ```xml
    <!-- Exemplo de App ID do AdMob: ca-app-pub-3940256099942544~3347511713 -->
    <meta-data
        tools:replace="android:value"
        android:name="com.google.android.gms.ads.APPLICATION_ID"
        android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
    ```

=== "iOS"

    Você pode configurar o seu App ID do AdMob diretamente no Godot Editor sem a necessidade de editar arquivos de configuração manualmente:

    1. Abra as configurações de exportação em **Projeto -> Exportar...**.
    2. Selecione a sua definição de exportação para **iOS**.
    3. Na aba **Opções**, navegue até a seção **Plugins Plist**.
    4. Preencha o campo **Gad Application Identifier** com o seu App ID do AdMob (ex: `ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy`).

    !!! tip "Configuração Alternativa"
        Você também pode pré-definir `GADApplicationIdentifier="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"` diretamente na seção `[plist]` do arquivo `res://ios/plugins/admob.gdip`.

---

## Exportando o Projeto

Ao compilar o seu jogo para plataformas móveis, configure as definições de exportação em **Projeto -> Exportar...**:

=== "Android"

    1. Selecione (ou adicione) a sua definição de exportação para **Android**.
    2. Na aba **Opções**:
       - Marque **Use Custom Build** como **Ativo** (requer o Template de Build do Android instalado via **Projeto -> Instalar Template de Build do Android...**).
       - Marque **Ad Mob** como **Ativo** em **Plugins**.

=== "iOS"

    1. Selecione (ou adicione) a sua definição de exportação para **iOS**.
    2. Na aba **Opções**:
       - Marque **Ad Mob** como **Ativo** em **Plugins**.

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
