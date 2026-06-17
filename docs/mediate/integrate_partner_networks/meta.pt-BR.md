# Integrar Meta Audience Network com Lances (Bidding)
!!! info
    
    **Importante**: Facebook Audience Network agora é Meta Audience Network. Consulte o [comunicado da Meta](https://about.fb.com/news/2021/10/facebook-company-is-now-meta/) para obter mais informações.

Este guia explica como utilizar o SDK do Google Mobile Ads para carregar e apresentar anúncios da Meta Audience Network por meio de [mediação](../get_started.md), com foco em integrações de lances (bidding). Ele fornece instruções sobre como integrar a Meta Audience Network na configuração de mediação de um aplicativo Godot e integrar o SDK e adaptador da Meta Audience Network ao seu aplicativo Godot.

Este documento é baseado em:

- [Documentação do SDK do Google Mobile Ads para Android (Inglês)](https://developers.google.com/admob/android/mediation/meta)
- [Documentação do SDK do Google Mobile Ads para iOS (Inglês)](https://developers.google.com/admob/ios/mediation/meta)

## Integrações e formatos de anúncios suportados

O adaptador de mediação do AdMob para Meta Audience Network tem as seguintes capacidades:

| Integração |   |
|-------------|---|
| Bidding     | ✅ |
| Waterfall [^1]   | ❌ |

| Formats      |   |
|--------------|---|
| Banner       | ✅ |
| Interstitial | ✅ |
| Rewarded     | ✅ |

[^1]: O Meta Audience Network passou a ser [apenas lances (bidding only)](https://www.facebook.com/audiencenetwork/resources/blog/audience-network-to-become-bidding-only-beginning-with-ios-in-2021) em 2021.

## Pré-requisitos
- Complete o [Guia de Primeiros Passos](../../index.md)
- Complete o [Guia de Primeiros Passos da mediação](../get_started.md)

## Etapa 1: Configurar o Meta Audience Network
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/meta#setup) ou [iOS](https://developers.google.com/admob/ios/mediation/meta#setup), pois será o mesmo para ambos.

## Etapa 2: Configurar as definições de mediação para o seu bloco de anúncios do AdMob
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/meta#configure_mediation) ou [iOS](https://developers.google.com/admob/ios/mediation/meta#configure_mediation), pois será o mesmo para ambos.

## Etapa 3: Importar o plugin do Meta Audience Network

=== "Android"
    1. Baixe o plugin para [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extraia o arquivo `.zip`. Dentro dele, você encontrará uma pasta `meta`.
    3. Copie o conteúdo da pasta `meta` e cole-o na pasta do plugin Android em `res://addons/admob/android/bin/`.
    ![android-meta](../../assets/android/meta.png)

=== "iOS"
    O adaptador da Meta Audience Network **já está incluso** no download padrão do plugin iOS. Se você seguiu o [Guia de Instalação do iOS](../../index.md#download-instalacao), você já deve ter os arquivos necessários (`poing-godot-admob-meta.gdip` e frameworks relacionados) no diretório `res://ios/plugins/`.

## Etapa 4: Habilitar o plugin

=== "Android"
    Certifique-se de habilitar o **Meta** nas **Configurações do Projeto** (em `Admob > Android > Mediation > Meta`).

=== "iOS"
    Certifique-se de marcar tanto o `Ad Mob` quanto o `Ad Mob Meta` na lista de Plugins em seus **Presets de Exportação do iOS** (além de inserir o ID do seu Aplicativo AdMob nas configurações do Plist).

    ![ios-meta-export](../../assets/ios/meta-export.png)

## Etapa 5: Código adicional necessário

=== "Android"
    Nenhum código adicional é necessário para a integração da Meta Audience Network.

=== "iOS"
    **Integração com SKAdNetwork**

    Siga a [documentação do Meta Audience Network](https://developers.facebook.com/docs/setting-up/platform-setup/ios/SKAdNetwork) para adicionar os identificadores do SKAdNetwork ao arquivo `Info.plist` do seu projeto.

    ---
    **Erros de compilação**

    Você deve seguir as etapas abaixo para adicionar caminhos do Swift às Build Settings do seu target para evitar erros de compilação.

    Adicione os seguintes caminhos nas **Build Settings** do target em **Library Search Paths**:

    ```
    $(TOOLCHAIN_DIR)/usr/lib/swift/$(PLATFORM_NAME)
    $(SDKROOT)/usr/lib/swift
    ```

    Adicione o seguinte caminho nas **Build Settings** do target em **Runpath Search Paths**:
    ```
    /usr/lib/swift
    ```

    Leia mais sobre: https://developers.google.com/admob/ios/mediation/meta#step_4_additional_code_required

    ---
    **Acompanhamento de anúncios habilitado (Advertising tracking enabled)**

    Se você estiver desenvolvendo para iOS 14 ou posterior, o Meta Audience Network exige que você configure explicitamente a flag [Advertising Tracking Enabled](https://developers.facebook.com/docs/audience-network/setting-up/platform-setup/ios/advertising-tracking-enabled) deles usando o seguinte código:

    !!! info
        
        **Ponto Importante**: Você precisa configurar esta flag antes de inicializar o SDK do Mobile Ads.

=== "GDScript"

    ```gdscript
    if OS.get_name() == "iOS":
        #FBAdSettings is available only for iOS, Google didn't put this method on Android SDK
        FBAdSettings.set_advertiser_tracking_enabled(true)
    ```

=== "C#"

    ```csharp
    if (OS.GetName() == "iOS")
    {
        //FBAdSettings is available only for iOS, Google didn't put this method on Android SDK
        FBAdSettings.SetAdvertiserTrackingEnabled(true);
    }
    ```

## Etapa 6: Testar sua implementação
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/meta#step_5_test_your_implementation) ou [iOS](https://developers.google.com/admob/ios/mediation/meta#step_5_test_your_implementation), pois será o mesmo para ambos.


## Etapas opcionais

!!! info
    
    **Importante**: Verifique se você tem a permissão de Gerenciamento de Conta para concluir a configuração para Consentimento da UE e GDPR, CCPA e UMP (User Messaging Platform). Para saber mais, consulte o artigo sobre [Novas Funções de Usuário](https://support.google.com/admob/answer/2784628).


### Consentimento da UE e GDPR
Sob a [Política de Consentimento de Usuários da UE](https://www.google.com/about/company/consentstaging.html) do Google, é obrigatório fornecer certas divulgações e obter consentimentos de usuários dentro do Espaço Econômico Europeu (EEE) sobre a utilização de identificadores de dispositivo e dados pessoais. Esta política alinha-se com a Diretiva de Privacidade Eletrônica da UE e o Regulamento Geral sobre a Proteção de Dados (GDPR). Ao solicitar o consentimento, você deve identificar explicitamente cada rede de anúncios em sua cadeia de mediação que possa coletar, receber ou utilizar dados pessoais. Além disso, você deve fornecer informações sobre como cada rede pretende usar esses dados. Importante: no momento, o Google não pode transmitir automaticamente a escolha de consentimento do usuário para essas redes.

Revise a [orientação](https://www.facebook.com/business/gdpr) da Meta para obter informações sobre GDPR e anúncios da Meta.

#### Adicionar o Facebook à lista de parceiros de anúncios do GDPR
Siga as etapas em [configurações do GDPR](https://support.google.com/admob/answer/10113004#adding_ad_partners_to_published_gdpr_messages) para adicionar o **Facebook** à lista de parceiros de anúncios do GDPR na interface do AdMob.


### CCPA
A [Lei de Privacidade do Consumidor da Califórnia (CCPA)](https://support.google.com/admob/answer/9561022) determina que os residentes do estado da Califórnia têm o direito de optar por não participar da "venda" de suas "informações pessoais", conforme definido pela lei. Essa opção de exclusão deve ser exibida com destaque por meio de um link "Não vender minhas informações pessoais" na página inicial da parte envolvida na venda.

O guia de [preparação da CCPA](../../privacy/regulatory_solutions/us_states_privacy_laws.md) oferece um recurso para ativar o [processamento de dados restrito](https://privacy.google.com/businesses/rdp/) para a veiculação de anúncios do Google. No entanto, o Google não pode aplicar essa configuração a todas as redes de anúncios em sua cadeia de mediação. Portanto, é essencial identificar cada rede de anúncios em sua cadeia de mediação que possa estar envolvida na venda de informações pessoais e seguir a orientação específica fornecida por cada uma dessas redes para garantir a conformidade com a CCPA.

Revise a [documentação](https://developers.facebook.com/docs/marketing-apis/data-processing-options) da Meta para obter opções de processamento de dados para usuários na Califórnia.

#### Adicionar o Facebook à lista de parceiros de anúncios do CCPA
Siga as etapas em [configurações do CCPA](https://support.google.com/admob/answer/10860309) para adicionar o **Facebook** à lista de parceiros de anúncios do CCPA na interface do AdMob.

### Cache
=== "Android"
    **Android 9**:

    A partir do Android 9 (API nível 28), o [suporte a cleartext está desativado por padrão](https://developer.android.com/training/articles/security-config#CleartextTrafficPermitted), o que afetará a funcionalidade de cache de mídia do SDK do Meta Audience Network e poderá afetar a experiência do usuário e a receita de anúncios. Siga a [documentação da Meta](https://developers.facebook.com/docs/audience-network/android-network-security-config/) para atualizar a configuração de segurança de rede em seu aplicativo.

=== "iOS"
    Não aplicável.

## Códigos de erro
Se o adaptador falhar ao receber um anúncio do Audience Network, os editores podem verificar o erro subjacente da resposta de anúncio usando `ResponseInfo` nas seguintes classes:

=== "Android"
    ```
    com.google.ads.mediation.facebook.FacebookAdapter
    com.google.ads.mediation.facebook.FacebookMediationAdapter
    ```

=== "iOS"
    ```
    GADMAdapterFacebook
    GADMediationAdapterFacebook
    ```

Aqui estão os códigos e as mensagens acompanhantes geradas pelo adaptador do Meta Audience Network quando um anúncio falha ao carregar:

=== "Android"
    | Error code | Reason                                                                                                   |
    |------------|----------------------------------------------------------------------------------------------------------|
    | 101        | Invalid server parameters (e.g. missing Placement ID).                                                   |
    | 102        | The requested ad size does not match a Meta Audience Network supported banner size.                      |
    | 103        | The publisher must request ads with an **Activity** context.                                             |
    | 104        | The Meta Audience Network SDK failed to initialize.                                                      |
    | 105        | The publisher did not request for Unified native ads.                                                    |
    | 106        | The native ad loaded is a different object than the one expected.                                        |
    | 107        | The **Context** object used is invalid.                                                                  |
    | 108        | The loaded ad is missing the required native ad assets.                                                  |
    | 109        | Failed to create a native ad from the bid payload.                                                       |
    | 110        | The Meta Audience Network SDK failed to present their interstitial/rewarded ad.                          |
    | 111        | Exception thrown when creating a Meta Audience Network **AdView** object.                                |
    | 1000-9999  | The Meta Audience Network returned an SDK-specific error. See Meta Audience Network's [documentation](https://developers.facebook.com/docs/audience-network/setting-up/test/checklist-errors) for more details. |

=== "iOS"
    | Error code | Reason                                                                                                                |
    |------------|-----------------------------------------------------------------------------------------------------------------------|
    | 101        | Invalid server parameters (e.g. missing Placement ID).                                                                |
    | 102        | The requested ad size does not match a Meta Audience Network supported banner size.                                   |
    | 103        | The Meta Audience Network ad object failed to initialize.                                                             |
    | 104        | The Meta Audience Network SDK failed to present their interstitial/rewarded ad.                                       |
    | 105        | Root view controller of the banner ad is **nil**.                                                                     |
    | 106        | The Meta Audience Network SDK failed to initialize.                                                                   |
    | 1000-9999  | The Meta Audience Network returned an SDK-specific error. See Meta Audience Network's [documentation](https://developers.facebook.com/docs/audience-network/setting-up/test/checklist-errors) for more details. |
