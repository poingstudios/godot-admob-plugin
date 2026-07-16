# Migrar versões do SDK

Esta página abrange migrações para versões atuais e anteriores do Godot AdMob Editor Plugin.

## Migrar da v4 para a v5

As subseções a seguir descrevem alterações de quebra, diferenças de comportamento e novas APIs entre as versões principais 4 e 5 do Godot AdMob Editor Plugin.

### Migração do SDK Android Next-Gen

A versão 5.0.0 migra o plugin nativo do Android da dependência do SDK legado do Google Mobile Ads para o moderno SDK Google Mobile Ads Next-Gen:

* **Dependência antiga (v4):** `com.google.android.gms:play-services-ads`
* **Nova dependência (v5):** `com.google.android.libraries.ads.mobile.sdk:ads-mobile-sdk`

!!! danger "Conflitos de Mediação"
    Como alguns adaptadores de mediação legados de terceiros podem trazer de forma transitiva a antiga biblioteca `play-services-ads` ou `play-services-ads-lite`, a compilação do seu build do Android pode resultar em erros de classe ou símbolos duplicados.

#### Correção Automática
O manipulador de exportação do Godot na versão 5.0.0 intercepta automaticamente o processo de exportação do Android e corrige o arquivo Gradle do projeto (`res://android/build/build.gradle` ou `res://android/build/app/build.gradle`) para excluir explicitamente as dependências legadas:

```groovy
// Adicionado automaticamente pelo Poing Godot AdMob Plugin para suportar o GMA Next-Gen SDK
configurations.configureEach {
    exclude group: "com.google.android.gms", module: "play-services-ads"
    exclude group: "com.google.android.gms", module: "play-services-ads-lite"
}
```
Nenhuma intervenção ou configuração manual é necessária.

---

### Remoção do Smart Banner

O formato legado `Smart Banner` foi descontinuado pelo Google e foi completamente removido do plugin na v5.

| Linguagem | API de Tamanho Removida | Substituição |
| :--- | :--- | :--- |
| **GDScript** | `AdSize.get_smart_banner_ad_size()` | [`AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(width)`](reference/classes/AdSize.md) |
| **C#** | `AdSize.GetSmartBannerAdSize()` | [`AdSize.GetCurrentOrientationAnchoredAdaptiveBannerAdSize(width)`](reference/classes/AdSize.md) |

!!! note "Fallback de Compatibilidade Retroativo"
    Por segurança, tanto o plugin nativo do Android quanto o do iOS implementam um fallback automático: se uma cena ou layout antigo ainda enviar um tamanho de largura `-1` e altura `-1`, a ponte nativa intercepta e retorna um tamanho padrão de Banner Adaptativo Ancorado correspondente à largura da tela.

#### Como Migrar
Use **Banners Adaptativos Ancorados** no lugar. Eles são a substituição moderna oficial, calculando dinamicamente a altura ideal com base na largura do dispositivo e na densidade da tela.

=== "v4"

    === "GDScript"

        ```gdscript
        # Smart banner legado
        var ad_view := AdView.new(unit_id, AdSize.get_smart_banner_ad_size(), AdPosition.Values.TOP)
        ```

    === "C#"

        ```csharp
        // Smart banner legado
        var adView = new AdView(unitId, AdSize.GetSmartBannerAdSize(), AdPosition.Values.Top);
        ```

=== "v5"

    === "GDScript"

        ```gdscript
        # Banner adaptativo correspondente à largura total
        var ad_size := AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)
        var ad_view := AdView.new(unit_id, ad_size, AdPosition.TOP)
        ```

    === "C#"

        ```csharp
        // Banner adaptativo correspondente à largura total
        var adSize = AdSize.GetCurrentOrientationAnchoredAdaptiveBannerAdSize(AdSize.FullWidth);
        var adView = new AdView(unitId, adSize, AdPosition.Top);
        ```

---

### Alterações na API AdPosition (Alteração de Quebra)

Na versão 5.0.0, a API [`AdPosition`](reference/classes/AdPosition.md) mudou de um enum inteiro básico para uma instância de classe. Isso permite posicionar anúncios de banner usando coordenadas estáticas predefinidas ou deslocamentos de pixel personalizados.

| API v4 (Descontinuada) | API v5 (Substituta) |
| :--- | :--- |
| `AdPosition.Values.TOP` | `AdPosition.TOP` |
| `AdPosition.Values.BOTTOM` | `AdPosition.BOTTOM` |
| `AdPosition.Values.LEFT` | `AdPosition.LEFT` |
| `AdPosition.Values.RIGHT` | `AdPosition.RIGHT` |
| `AdPosition.Values.TOP_LEFT` | `AdPosition.TOP_LEFT` |
| `AdPosition.Values.TOP_RIGHT` | `AdPosition.TOP_RIGHT` |
| `AdPosition.Values.BOTTOM_LEFT` | `AdPosition.BOTTOM_LEFT` |
| `AdPosition.Values.BOTTOM_RIGHT` | `AdPosition.BOTTOM_RIGHT` |
| `AdPosition.Values.CENTER` | `AdPosition.CENTER` |
| Posicionamento personalizado não suportado | `AdPosition.custom(x, y)` |

#### Como Migrar
Atualize suas criações de banner e atualizações de posição para passar instâncias da classe [`AdPosition`](reference/classes/AdPosition.md) em vez dos valores brutos do enum.

=== "v4"

    === "GDScript"

        ```gdscript
        var ad_view := AdView.new(unit_id, ad_size, AdPosition.Values.TOP)
        ```

    === "C#"

        ```csharp
        var adView = new AdView(unitId, adSize, AdPosition.Values.Top);
        ```

=== "v5"

    === "GDScript"

        ```gdscript
        # Posição predefinida
        var ad_view := AdView.new(unit_id, ad_size, AdPosition.TOP)
        
        # Coordenadas personalizadas (ex. x=0, y=100)
        var custom_ad_view := AdView.new(unit_id, ad_size, AdPosition.custom(0, 100))
        ```

    === "C#"

        ```csharp
        // Posição predefinida
        var adView = new AdView(unitId, adSize, AdPosition.Top);

        // Coordenadas personalizadas (ex. x=0, y=100)
        var customAdView = new AdView(unitId, adSize, AdPosition.Custom(0, 100));
        ```

---

### Alterações no Ecossistema de Mediação

O ecossistema de mediação foi limpo e atualizado. Parceiros de mediação descontinuados foram removidos e várias novas redes agora são suportadas.

#### Redes de Mediação Removidas
O seguinte adaptador de mediação legado foi removido devido à descontinuação:

* AdColony

#### Redes de Mediação Adicionadas
O suporte para as seguintes redes de mediação foi introduzido:

* AppLovin
* BidMachine
* Chartboost
* DT Exchange
* i-mobile
* InMobi
* IronSource
* LINE
* Unity Ads

---

### Novos Formatos de Anúncios

A versão 5.0.0 adiciona suporte de primeira classe para dois novos formatos de anúncios:

1. **Anúncios de Abertura do App (App Open Ads):** Exibidos quando os usuários abrem ou retornam ao aplicativo. Carregados usando [`AppOpenAdLoader`](reference/classes/AppOpenAdLoader.md) e controlados usando [`AppOpenAd`](reference/classes/AppOpenAd.md).
2. **Anúncios Native Overlay:** Renderizam anúncios nativos personalizáveis diretamente sobre o jogo usando modelos nativos (layouts Small ou Medium) personalizados com estilos ([`NativeTemplateStyle`](reference/classes/NativeTemplateStyle.md), [`NativeAdOptions`](reference/classes/NativeAdOptions.md)).

---

### Novas Configurações Globais e Recursos de Privacidade

Vários novos métodos de API foram adicionados à classe [`MobileAds`](reference/classes/MobileAds.md) e ao [`UserMessagingPlatform`](reference/classes/UserMessagingPlatform.md) para consentimento, conformidade de privacidade e depuração:

* **Ad Inspector:** Abra o Ad Inspector via [`MobileAds`](reference/classes/MobileAds.md).`open_ad_inspector(ad_inspector_closed_listener)`.
* **Opção de ID de Primeira Parte:** Ative ou desative o ID de primeira parte do editor com [`MobileAds`](reference/classes/MobileAds.md).`set_publisher_first_party_id_enabled(enabled)`.
* **Preferência de Cookie de Consentimento:** Configure se o SDK tem consentimento para cookies via [`MobileAds`](reference/classes/MobileAds.md).`set_gad_has_consent_for_cookies(enabled)` e consulte-o com `get_gad_has_consent_for_cookies()`.
* **Desativar Relatório de Falhas (apenas iOS):** Impeça que o SDK do Mobile Ads capture e envie relatórios de falhas via [`MobileAds`](reference/classes/MobileAds.md).`disable_sdk_crash_reporting()`.
* **Opções de Privacidade UMP:** Mostre o formulário de opções de configurações de privacidade sob demanda via [`UserMessagingPlatform`](reference/classes/UserMessagingPlatform.md).`show_privacy_options_form(on_privacy_options_form_dismissed)` e consulte seu status usando [`ConsentInformation`](reference/classes/ConsentInformation.md).`get_privacy_options_requirement_status()`.

---

### Configuração Unificada nas Configurações do Projeto

Na versão 5.0.0, o plugin unificou todas as opções de configuração diretamente nas **Configurações do Projeto** (Project Settings) nativas do Godot, na seção `admob/`. Isso substitui quaisquer fluxos de configuração legados ou entradas de menu de editor personalizadas.

!!! warning "Alteração de Configuração de Quebra: config.gd Removido"
    Na versão 4, o AdMob App ID era definido modificando o script de configuração estática localizado em `res://addons/admob/android/config.gd`.
    
    Na versão 5, **o `config.gd` foi completamente removido**. Você deve transferir seus App IDs para o novo local nas Configurações do Projeto.

As opções de configuração agora são registradas e configuradas em **Configurações do Projeto > Geral**:

* **Configurações do Android:** `admob/general/android/enabled`, `admob/general/android/app_id` e flags de otimização.
* **Configurações do iOS:** `admob/general/ios/enabled` e `admob/general/ios/app_id`.
* **Redes de Mediação:** Todos os parceiros de mediação são ativados ou desativados globalmente via flags booleanas sob `admob/mediation/` (ex. `admob/mediation/applovin`, `admob/mediation/meta`, etc.).

![General Settings](assets/general_settings.png)
![Mediation Settings](assets/mediation_settings.png)

---

### Instalador Dinâmico de Binários Headless (CI/CD)

Para suportar builds de CI headless sem empacotar grandes binários nativos no Git, a v5.0.0 inclui um downloader síncrono:

* Ao rodar em um ambiente headless (como o GitHub Actions), o plugin verifica automaticamente se os binários das plataformas Android/iOS estão faltando.
* Ele baixa e extrai esses binários de forma automática e dinâmica a partir dos lançamentos oficiais do repositório durante a inicialização do plugin.
