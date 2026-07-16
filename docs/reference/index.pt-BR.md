# Referência da API

Esta página lista as classes, enums e callbacks fornecidos pelo Godot AdMob Plugin.

## Classes

| Classe | Descrição |
| :--- | :--- |
| [MobileAds](classes/MobileAds.pt-BR.md) | Configurações globais e ponto de entrada de inicialização do SDK. |
| [RequestConfiguration](classes/RequestConfiguration.pt-BR.md) | Configurações aplicadas globalmente a todas as solicitações de anúncios. |
| [AdRequest](classes/AdRequest.pt-BR.md) | Parâmetros de solicitação usados para carregar anúncios. |
| [AdSize](classes/AdSize.pt-BR.md) | Definições de largura e altura para anúncios de banner. |
| [AdPosition](classes/AdPosition.pt-BR.md) | Layout de alinhamento da tela para anúncios de banner e nativos de sobreposição. |
| [AdView](classes/AdView.pt-BR.md) | Um nó do Godot que carrega e exibe anúncios de banner. |
| [AdVideoController](classes/AdVideoController.pt-BR.md) | Controlador de reprodução de vídeo dentro de anúncios nativos. |
| [AdVideoOptions](classes/AdVideoOptions.pt-BR.md) | Comportamento de reprodução para elementos de vídeo dentro de anúncios nativos. |
| [AppOpenAd](classes/AppOpenAd.pt-BR.md) | Formato de anúncio em tela cheia exibido quando os usuários abrem o aplicativo. |
| [AppOpenAdLoader](classes/AppOpenAdLoader.pt-BR.md) | Classe de carregamento responsável por buscar anúncios de abertura de aplicativo (App Open Ads). |
| [InterstitialAd](classes/InterstitialAd.pt-BR.md) | Formato de anúncio intersticial em tela cheia. |
| [InterstitialAdLoader](classes/InterstitialAdLoader.pt-BR.md) | Classe de carregamento responsável por buscar anúncios intersticiais. |
| [RewardedAd](classes/RewardedAd.pt-BR.md) | Formato de anúncio premiado em tela cheia. |
| [RewardedAdLoader](classes/RewardedAdLoader.pt-BR.md) | Classe de carregamento responsável por buscar anúncios premiados. |
| [RewardedInterstitialAd](classes/RewardedInterstitialAd.pt-BR.md) | Formato de anúncio intersticial premiado (sobreposição semitransparente). |
| [RewardedInterstitialAdLoader](classes/RewardedInterstitialAdLoader.pt-BR.md) | Classe de carregamento responsável por buscar anúncios intersticiais premiados. |
| [NativeOverlayAd](classes/NativeOverlayAd.pt-BR.md) | Formato de anúncio nativo sobreposto às cenas do Godot. |
| [NativeAdOptions](classes/NativeAdOptions.pt-BR.md) | Preferências para renderização de anúncios nativos de sobreposição. |
| [NativeTemplateStyle](classes/NativeTemplateStyle.pt-BR.md) | Modelo de estilo visual para anúncios nativos de sobreposição. |
| [NativeTemplateTextStyle](classes/NativeTemplateTextStyle.pt-BR.md) | Configuração de fonte e cor para elementos de texto. |
| [ResponseInfo](classes/ResponseInfo.pt-BR.md) | Contém metadados e informações de resposta do adaptador para anúncios carregados. |
| [AdapterResponseInfo](classes/AdapterResponseInfo.pt-BR.md) | Metadados de um adaptador de rede de mediação específico. |
| [AdError](classes/AdError.pt-BR.md) | Informações sobre erros que ocorrem durante a exibição do anúncio. |
| [LoadAdError](classes/LoadAdError.pt-BR.md) | Informações sobre erros que ocorrem durante o carregamento do anúncio. |
| [MediaContent](classes/MediaContent.pt-BR.md) | Representa recursos de mídia (vídeo/imagem) de um anúncio nativo. |
| [AdValue](classes/AdValue.pt-BR.md) | Representa o valor monetário de uma impressão de anúncio. |
| [RewardedItem](classes/RewardedItem.pt-BR.md) | Representa uma recompensa obtida pelo usuário (quantidade e tipo). |
| [InitializationStatus](classes/InitializationStatus.pt-BR.md) | Contém detalhes do status de inicialização para MobileAds. |
| [AdapterStatus](classes/AdapterStatus.pt-BR.md) | Representa o status de inicialização para um único adaptador de mediação. |
| [ServerSideVerificationOptions](classes/ServerSideVerificationOptions.pt-BR.md) | Configurações de segurança para callbacks premiados do lado do servidor (SSV). |
| [UserMessagingPlatform](classes/UserMessagingPlatform.pt-BR.md) | Ponto de entrada para fluxos de consentimento de privacidade e GDPR. |
| [ConsentInformation](classes/ConsentInformation.pt-BR.md) | Verifica e atualiza o status de consentimento do usuário. |
| [ConsentForm](classes/ConsentForm.pt-BR.md) | Formulário de consentimento que pode ser exibido ao usuário. |
| [ConsentRequestParameters](classes/ConsentRequestParameters.pt-BR.md) | Parâmetros para solicitar atualizações de informações de consentimento. |
| [ConsentDebugSettings](classes/ConsentDebugSettings.pt-BR.md) | Configuração de teste para o fluxo de consentimento. |
| [FormError](classes/FormError.pt-BR.md) | Informações de erro para operações do formulário de consentimento. |

## Enums

| Enum | Descrição |
| :--- | :--- |
| [AdPosition](enums/AdPosition.pt-BR.md) | Valores predefinidos de alinhamento de tela para anúncios de banner e nativos de sobreposição. |
| [AdChoicesPlacement](enums/AdChoicesPlacement.pt-BR.md) | Posicionamento do canto para o ícone do AdChoices. |
| [NativeMediaAspectRatio](enums/NativeMediaAspectRatio.pt-BR.md) | Preferência de proporção de tela para anúncios nativos. |
| [NativeTemplateFontStyle](enums/NativeTemplateFontStyle.pt-BR.md) | Pesos de fonte tipográfica para campos de texto de anúncios nativos. |
| [AdValue.PrecisionType](enums/AdValue.PrecisionType.pt-BR.md) | Nível de precisão do valor da receita do anúncio. |
| [AdapterStatus.InitializationState](enums/AdapterStatus.InitializationState.pt-BR.md) | Indica se um adaptador de mediação está pronto. |
| [RequestConfiguration.TagForChildDirectedTreatment](enums/RequestConfiguration.TagForChildDirectedTreatment.pt-BR.md) | Tratamento direcionado a crianças para conformidade com a COPPA. |
| [RequestConfiguration.TagForUnderAgeOfConsent](enums/RequestConfiguration.TagForUnderAgeOfConsent.pt-BR.md) | Tratamento para menores de idade de consentimento para conformidade com a GDPR. |
| [DebugGeography](enums/DebugGeography.pt-BR.md) | Geografia de depuração para testar o fluxo de consentimento. |
| [ConsentInformation.ConsentStatus](enums/ConsentInformation.ConsentStatus.pt-BR.md) | Status de consentimento do usuário para regulamentos de privacidade. |
| [ConsentInformation.PrivacyOptionsRequirementStatus](enums/ConsentInformation.PrivacyOptionsRequirementStatus.pt-BR.md) | Se as opções de privacidade são requeridas. |

## Interfaces / Callbacks

| Callback | Descrição |
| :--- | :--- |
| [OnInitializationCompleteListener](listeners/OnInitializationCompleteListener.pt-BR.md) | Callback acionado quando a inicialização do SDK é concluída. |
| [AdListener](listeners/AdListener.pt-BR.md) | Recebe eventos de banner e sobreposição. |
| [FullScreenContentCallback](listeners/FullScreenContentCallback.pt-BR.md) | Recebe eventos de apresentação para formatos de tela cheia. |
| [OnUserEarnedRewardListener](listeners/OnUserEarnedRewardListener.pt-BR.md) | Recebe o evento de quando o usuário ganha uma recompensa. |
| [AppOpenAdLoadCallback](listeners/AppOpenAdLoadCallback.pt-BR.md) | Manipula resultados de carregamento para anúncios de abertura de aplicativo. |
| [InterstitialAdLoadCallback](listeners/InterstitialAdLoadCallback.pt-BR.md) | Manipula resultados de carregamento para anúncios intersticiais. |
| [RewardedAdLoadCallback](listeners/RewardedAdLoadCallback.pt-BR.md) | Manipula resultados de carregamento para anúncios premiados. |
| [RewardedInterstitialAdLoadCallback](listeners/RewardedInterstitialAdLoadCallback.pt-BR.md) | Manipula resultados de carregamento para anúncios intersticiais premiados. |
| [VideoLifecycleCallbacks](listeners/VideoLifecycleCallbacks.pt-BR.md) | Recebe eventos de ciclo de vida de reprodução de vídeo para anúncios nativos. |
| [AdInspectorClosedListener](listeners/AdInspectorClosedListener.pt-BR.md) | Aciona quando o Ad Inspector nativo é fechado. |
