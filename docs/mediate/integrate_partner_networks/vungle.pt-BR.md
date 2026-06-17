# Integrar Liftoff Monetize (Vungle) com Mediação
!!! info
    
    **Nota**: A Vungle agora é Liftoff Monetize.

Este guia explica como utilizar o SDK do Google Mobile Ads para carregar e apresentar anúncios da Liftoff Monetize por meio de [mediação](../get_started.md), com cobertura abrangente de integrações de lances (bidding) e cascata (waterfall). Ele fornece instruções sobre como integrar a Liftoff Monetize na configuração de mediação de um aplicativo Godot e integrar o SDK e adaptador da Vungle ao seu aplicativo Godot.

Este documento é baseado em:

- [Documentação do SDK do Google Mobile Ads para Android (Inglês)](https://developers.google.com/admob/android/mediation/liftoff-monetize)
- [Documentação do SDK do Google Mobile Ads para iOS (Inglês)](https://developers.google.com/admob/ios/mediation/liftoff-monetize)

## Integrações e formatos de anúncios suportados

O adaptador de mediação do AdMob para Vungle tem as seguintes capacidades:

| Integração |   |
|-------------|---|
| Bidding     | ✅ |
| Waterfall   | ✅ |

| Formats               |            |
|-----------------------|------------|
| Banner                | [^1]       |
| Interstitial          | ✅          |
| Rewarded              | ✅          |
| Rewarded Interstitial | [^1], [^2] |

[^1]: Não suportado em lances/bidding (suportado apenas para mediação em cascata/waterfall).
[^2]: Para ter acesso a este recurso, entre em contato com o gerente de conta da sua Liftoff Monetize.

## Pré-requisitos
- Complete o [Guia de Primeiros Passos](../../index.md)
- Complete o [Guia de Primeiros Passos da mediação](../get_started.md)


## Limitações

- A Liftoff Monetize não suporta o carregamento de múltiplos anúncios usando o mesmo ID de Referência de Posicionamento (Placement Reference ID).
    - O adaptador da Vungle falha graciosamente na segunda solicitação se outra solicitação para esse posicionamento estiver carregando ou aguardando para ser exibida.
- A Liftoff Monetize suporta apenas o carregamento de 1 anúncio de banner por vez.
    - O adaptador da Vungle falha graciosamente nas solicitações subsequentes de banner se um anúncio de banner já estiver carregado.

## Etapa 1: Configurar a Liftoff Monetize
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/liftoff-monetize#step_1_set_up_liftoff_monetize) ou [iOS](https://developers.google.com/admob/ios/mediation/liftoff-monetize#step_1_set_up_liftoff_monetize), pois será o mesmo para ambos.

## Etapa 2: Configurar as definições de mediação para o seu bloco de anúncios do AdMob
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/liftoff-monetize#step_2) ou [iOS](https://developers.google.com/admob/ios/mediation/liftoff-monetize#step_2), pois será o mesmo para ambos.

## Etapa 3: Importar o plugin do SDK da Vungle

=== "Android"
    1. Baixe o plugin para [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extraia o arquivo `.zip`. Dentro dele, você encontrará uma pasta `vungle`.
    3. Copie o conteúdo da pasta `vungle` e cole-o na pasta do plugin Android em `res://addons/admob/android/bin/`.
    ![android-vungle](../../assets/android/vungle.png)

=== "iOS"
    O adaptador da Liftoff Monetize (Vungle) **já está incluso** no download padrão do plugin iOS. Se você seguiu o [Guia de Instalação do iOS](../../index.md#download-instalacao), você já deve ter os arquivos necessários (`poing-godot-admob-vungle.gdip` e frameworks relacionados) no diretório `res://ios/plugins/`.

## Etapa 4: Habilitar o plugin

=== "Android"
    Certifique-se de habilitar o **Vungle** nas **Configurações do Projeto** (em `Admob > Android > Mediation > Vungle`).

=== "iOS"
    Certifique-se de marcar tanto o `Ad Mob` quanto o `Ad Mob vungle` na lista de Plugins em seus **Presets de Exportação do iOS** (além de inserir o ID do seu Aplicativo AdMob nas configurações do Plist).

    ![ios-vungle-export](../../assets/ios/vungle-export.png)

## Etapa 5: Código adicional necessário

A Liftoff Monetize necessita que uma lista de todos os posicionamentos (placements) que serão utilizados no seu aplicativo Godot seja enviada para o SDK deles. Você pode fornecer esta lista de posicionamentos ao adaptador usando as classes `VungleInterstitialMediationExtras` e `VungleRewardedVideoMediationExtras`. Os exemplos de código subsequentes ilustram como usar essas classes.

=== "Interstitial"

    === "GDScript"
    
        ```gdscript
        var vungle_mediation_extras := VungleInterstitialMediationExtras.new()
    
        if OS.get_name() == "iOS":
            vungle_mediation_extras.all_placements = ["ios_placement1", "ios_placement2"]
        elif OS.get_name() == "Android":
            vungle_mediation_extras.all_placements = ["android_placement1", "android_placement2"]
    
        var ad_request := AdRequest.new()
        ad_request.mediation_extras.append(vungle_mediation_extras)
        ```
    
    === "C#"
    
        ```csharp
        var vungleMediationExtras = new VungleInterstitialMediationExtras();
        
        if (OS.GetName() == "iOS")
        {
            vungleMediationExtras.AllPlacements = new string[] { "ios_placement1", "ios_placement2" };
        }
        else if (OS.GetName() == "Android")
        {
            vungleMediationExtras.AllPlacements = new string[] { "android_placement1", "android_placement2" };
        }
        
        var adRequest = new AdRequest();
        adRequest.MediationExtras.Add(vungleMediationExtras);
        ```
=== "Rewarded"

    === "GDScript"
    
        ```gdscript
    	var vungle_mediation_extras := VungleRewardedMediationExtras.new()
    	
    	if OS.get_name() == "iOS":
    		vungle_mediation_extras.all_placements = ["ios_placement1", "ios_placement2"]
    	elif OS.get_name() == "Android":
    		vungle_mediation_extras.all_placements = ["android_placement1", "android_placement2"]
    	
    	var ad_request := AdRequest.new()
    	ad_request.mediation_extras.append(vungle_mediation_extras)
        ```
    
    === "C#"
    
        ```csharp
        var vungleMediationExtras = new VungleRewardedMediationExtras();
        
        if (OS.GetName() == "iOS")
        {
            vungleMediationExtras.AllPlacements = new string[] { "ios_placement1", "ios_placement2" };
        }
        else if (OS.GetName() == "Android")
        {
            vungleMediationExtras.AllPlacements = new string[] { "android_placement1", "android_placement2" };
        }
        
        var adRequest = new AdRequest();
        adRequest.MediationExtras.Add(vungleMediationExtras);
        ```

---

=== "Android"
    Nenhum código adicional é necessário para a integração da Meta Audience Network.

=== "iOS"
    **Integração com SKAdNetwork**

    Siga a [documentação do Liftoff Monetize](https://support.vungle.com/hc/en-us/articles/360002925791-Integrate-Vungle-SDK-for-iOS#h_01EM0AZYJ84W7CWZHW4KRHQHXF) para adicionar os identificadores do SKAdNetwork ao arquivo `Info.plist` do seu projeto.

## Etapa 6: Testar sua implementação
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/liftoff-monetize#step_5_test_your_implementation) ou [iOS](https://developers.google.com/admob/ios/mediation/liftoff-monetize#step_5_test_your_implementation), pois será o mesmo para ambos.

## Etapas opcionais

!!! info
    
    **Importante**: Verifique se você tem a permissão de Gerenciamento de Conta para concluir a configuração para Consentimento da UE e GDPR, CCPA e UMP (User Messaging Platform). Para saber mais, consulte o artigo sobre [Novas Funções de Usuário](https://support.google.com/admob/answer/2784628).


### Consentimento da UE e GDPR
Sob a [Política de Consentimento de Usuários da UE](https://www.google.com/about/company/consentstaging.html) do Google, é obrigatório fornecer certas divulgações e obter consentimentos de usuários dentro do Espaço Econômico Europeu (EEE) sobre a utilização de identificadores de dispositivo e dados pessoais. Esta política alinha-se com a Diretiva de Privacidade Eletrônica da UE e o Regulamento Geral sobre a Proteção de Dados (GDPR). Ao solicitar o consentimento, você deve identificar explicitamente cada rede de anúncios em sua cadeia de mediação que possa coletar, receber ou utilizar dados pessoais. Além disso, você deve fornecer informações sobre como cada rede pretende usar esses dados. Importante: no momento, o Google não pode transmitir automaticamente a escolha de consentimento do usuário para essas redes.

O exemplo de código a seguir mostra como passar essas informações de consentimento para o SDK da Vungle. Se você optar por chamar esse método, recomenda-se fazê-lo antes de solicitar anúncios através do SDK do Google Mobile Ads.

=== "GDScript"

    ```gdscript
    Vungle.update_consent_status(Vungle.Consent.OPTED_IN, "1.0.0")
    ```

=== "C#"

    ```csharp
    Vungle.UpdateConsentStatus(Vungle.Consent.OptedIn, "1.0.0");
    ```

Consulte as [instruções de implementação recomendadas para GDPR](https://support.vungle.com/hc/en-us/articles/360047780372#gdpr-recommended-implementation-instructions-0-1) para obter mais detalhes e os valores que podem ser fornecidos no método.

#### Adicionar Liftoff à lista de parceiros de anúncios do GDPR
Siga as etapas em [configurações do GDPR](https://support.google.com/admob/answer/10113004#adding_ad_partners_to_published_gdpr_messages) para adicionar a Liftoff à lista de parceiros de anúncios do GDPR na interface do AdMob.

### CCPA
A [Lei de Privacidade do Consumidor da Califórnia (CCPA)](https://support.google.com/admob/answer/9561022) determina que os residentes do estado da Califórnia têm o direito de optar por não participar da "venda" de suas "informações pessoais", conforme definido pela lei. Essa opção de exclusão deve ser exibida com destaque por meio de um link "Não vender minhas informações pessoais" na página inicial da parte envolvida na venda.

O guia de [preparação da CCPA](../../privacy/regulatory_solutions/us_states_privacy_laws.md) oferece um recurso para ativar o [processamento de dados restrito](https://privacy.google.com/businesses/rdp/) para a veiculação de anúncios do Google. No entanto, o Google não pode aplicar essa configuração a todas as redes de anúncios em sua cadeia de mediação. Portanto, es essencial identificar cada rede de anúncios em sua cadeia de mediação que possa estar envolvida na venda de informações pessoais e seguir a orientação específica fornecida por cada uma dessas redes para garantir a conformidade com a CCPA.

O exemplo de código a seguir mostra como passar essas informações de consentimento para o SDK da Vungle. Se você optar por chamar esse método, recomenda-se fazê-lo antes de solicitar anúncios através do SDK do Google Mobile Ads.

=== "GDScript"

    ```gdscript
    Vungle.update_ccpa_status(Vungle.Consent.OPTED_IN)
    ```

=== "C#"

    ```csharp
    Vungle.UpdateCcpaStatus(Vungle.Consent.OptedIn);
    ```

#### Adicionar Liftoff à lista de parceiros de anúncios do CCPA
Siga as etapas em [configurações do CCPA](https://support.google.com/admob/answer/10860309) para adicionar a Liftoff à lista de parceiros de anúncios do CCPA na interface do AdMob.

### Parâmetros específicos de rede
O adaptador da Vungle para Godot suporta um parâmetro de solicitação adicional que pode ser enviado ao adaptador usando a classe `VungleRewardedMediationExtras` ou `VungleInterstitialMediationExtras`, dependendo do formato de anúncio que você está implementando. Essas classes incluem as seguintes propriedades:

- `sound_enabled`: Determina se o som deve ser ativado ao reproduzir anúncios de vídeo.

- `user_id`: Uma string que representa o ID de Usuário Incentivado (Incentivized User ID) para a integração do Liftoff Monetize no Godot.

- `all_placements`: Uma matriz contendo todos os IDs de Posicionamento (Placement IDs) dentro do aplicativo (isso não é necessário para aplicativos que empregam o SDK da Vungle 6.2.0 ou superior).

Para iOS, você pode simplesmente usar la classe `VungleAdNetworkExtras` class.

Aqui está um exemplo de código de como criar uma solicitação de anúncio que define esses parâmetros:

=== "Interstitial"

    === "GDScript"
    
        ```gdscript
    	var vungle_mediation_extras := VungleInterstitialMediationExtras.new()
    	
    	if OS.get_name() == "iOS":
    		vungle_mediation_extras.all_placements = ["ios_placement1", "ios_placement2"]
    		vungle_mediation_extras.sound_enabled = true
    		vungle_mediation_extras.user_id = "ios_user_id"
    	elif OS.get_name() == "Android":
    		vungle_mediation_extras.all_placements = ["android_placement1", "android_placement2"]
    		vungle_mediation_extras.sound_enabled = true
    		vungle_mediation_extras.user_id = "android_user_id"
    	
    	var ad_request := AdRequest.new()
    	ad_request.mediation_extras.append(vungle_mediation_extras)
        ```
    
    === "C#"
    
        ```csharp
        var vungleMediationExtras = new VungleInterstitialMediationExtras();
        
        if (OS.GetName() == "iOS")
        {
            vungleMediationExtras.AllPlacements = new string[] { "ios_placement1", "ios_placement2" };
            vungleMediationExtras.SoundEnabled = true;
            vungleMediationExtras.UserId = "ios_user_id";
        }
        else if (OS.GetName() == "Android")
        {
            vungleMediationExtras.AllPlacements = new string[] { "android_placement1", "android_placement2" };
            vungleMediationExtras.SoundEnabled = true;
            vungleMediationExtras.UserId = "android_user_id";
        }
        
        var adRequest = new AdRequest();
        adRequest.MediationExtras.Add(vungleMediationExtras);
        ```
=== "Rewarded"

    === "GDScript"
    
        ```gdscript
        var vungle_mediation_extras := VungleRewardedMediationExtras.new()
    
        if OS.get_name() == "iOS":
            vungle_mediation_extras.all_placements = ["ios_placement1", "ios_placement2"]
            vungle_mediation_extras.sound_enabled = true
            vungle_mediation_extras.user_id = "ios_user_id"
        elif OS.get_name() == "Android":
            vungle_mediation_extras.all_placements = ["android_placement1", "android_placement2"]
            vungle_mediation_extras.sound_enabled = true
            vungle_mediation_extras.user_id = "android_user_id"
    
        var ad_request := AdRequest.new()
        ad_request.mediation_extras.append(vungle_mediation_extras)
        ```
    
    === "C#"
    
        ```csharp
        var vungleMediationExtras = new VungleRewardedMediationExtras();
        
        if (OS.GetName() == "iOS")
        {
            vungleMediationExtras.AllPlacements = new string[] { "ios_placement1", "ios_placement2" };
            vungleMediationExtras.SoundEnabled = true;
            vungleMediationExtras.UserId = "ios_user_id";
        }
        else if (OS.GetName() == "Android")
        {
            vungleMediationExtras.AllPlacements = new string[] { "android_placement1", "android_placement2" };
            vungleMediationExtras.SoundEnabled = true;
            vungleMediationExtras.UserId = "android_user_id";
        }
        
        var adRequest = new AdRequest();
        adRequest.MediationExtras.Add(vungleMediationExtras);
        ```


## Códigos de erro
Se o adaptador falhar ao receber um anúncio do Audience Network, os editores podem verificar o erro subjacente da resposta de anúncio usando `ResponseInfo` nas seguintes classes:

=== "Android"
    | Format       | Class name                                     |
    |--------------|------------------------------------------------|
    | Banner       | com.vungle.mediation.VungleInterstitialAdapter |
    | Interstitial | com.vungle.mediation.VungleInterstitialAdapter |
    | Rewarded     | com.vungle.mediation.VungleAdapter             |

=== "iOS"
    | Format       | Class name                          |
    |--------------|-------------------------------------|
    | Banner       | GADMAdapterVungleInterstitial       |
    | Interstitial | GADMAdapterVungleInterstitial       |
    | Rewarded     | GADMAdapterVungleRewardBasedVideoAd |

Aqui estão os códigos e as mensagens acompanhantes geradas pelo adaptador do Liftoff Monetize quando um anúncio falha ao carregar:

=== "Android"
    | Error code | Domain                          | Reason                                                                                                         |
    |------------|---------------------------------|----------------------------------------------------------------------------------------------------------------|
    | 0-100      | com.vungle.warren               | Vungle SDK returned an error. See [document](https://support.vungle.com/hc/en-us/articles/360047780372-Advanced-Settings#exception-codes-for-debugging-0-9) for more details. |
    | 101        | com.google.ads.mediation.vungle | Invalid server parameters (e.g. app ID or placement ID).                                                       |
    | 102        | com.google.ads.mediation.vungle | The requested banner size does not map to a valid Liftoff Monetize ad size.                                    |
    | 103        | com.google.ads.mediation.vungle | Liftoff Monetize requires an Activity context to request ads.                                                  |
    | 104        | com.google.ads.mediation.vungle | The Vungle SDK cannot load multiple ads for the same placement ID.                                             |
    | 105        | com.google.ads.mediation.vungle | The Vungle SDK failed to initialize.                                                                           |
    | 106        | com.google.ads.mediation.vungle | Vungle SDK returned a successful load callback, but Banners.getBanner() or Vungle.getNativeAd() returned null. |
    | 107        | com.google.ads.mediation.vungle | Vungle SDK is not ready to play the ad.                                                                        |

=== "iOS"
    | Error code | Domain                      | Reason                                                                                                                |
    |------------|-----------------------------|-----------------------------------------------------------------------------------------------------------------------|
    | 1-100      | Sent by Vungle SDK          | Vungle SDK returned an error. See [code](https://github.com/Vungle/iOS-SDK/blob/6.12.0/VungleSDK.xcframework/ios-arm64_armv7/VungleSDK.framework/Headers/VungleSDK.h) for more details. |
    | 101        | com.google.mediation.vungle | Liftoff Monetize server parameters configured in the AdMob UI are missing/invalid.                                    |
    | 102        | com.google.mediation.vungle | An ad is already loaded for this network configuration. Vungle SDK cannot load a second ad for the same placement ID. |
    | 103        | com.google.mediation.vungle | The requested ad size does not match a Liftoff Monetize supported banner size.                                        |
    | 104        | com.google.mediation.vungle | Vungle SDK could not render the banner ad.                                                                            |
    | 105        | com.google.mediation.vungle | Vungle SDK only supports loading 1 banner ad at a time, regardless of placement ID.                                   |
    | 106        | com.google.mediation.vungle | Vungle SDK sent a callback saying the ad is not playable.                                                             |
