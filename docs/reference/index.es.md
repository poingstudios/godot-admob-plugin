# Referencia de API

Esta página enumera las clases, enumeraciones y devoluciones de llamada proporcionadas por el complemento Godot AdMob.

## Clases

| Clase | Descripción |
| :--- | :--- |
| [MobileAds](classes/MobileAds.es.md) | Configuraciones globales y punto de entrada de inicialización del SDK. |
| [RequestConfiguration](classes/RequestConfiguration.es.md) | Configuraciones aplicadas globalmente a todas las solicitudes de anuncios. |
| [AdRequest](classes/AdRequest.es.md) | Parámetros de solicitud utilizados para cargar anuncios. |
| [AdSize](classes/AdSize.es.md) | Definiciones de ancho y alto para anuncios de banner. |
| [AdPosition](classes/AdPosition.es.md) | Diseño de alineación de pantalla para anuncios de banner y native overlay. |
| [AdView](classes/AdView.es.md) | Un nodo de Godot que carga y muestra anuncios de banner. |
| [AdVideoController](classes/AdVideoController.es.md) | Controlador de reproducción de video dentro de anuncios nativos. |
| [AdVideoOptions](classes/AdVideoOptions.es.md) | Comportamiento de reproducción para elementos de video dentro de anuncios nativos. |
| [AppOpenAd](classes/AppOpenAd.es.md) | Formato de anuncio de pantalla completa que se muestra al abrir la aplicación. |
| [AppOpenAdLoader](classes/AppOpenAdLoader.es.md) | Clase de carga responsable de obtener anuncios de apertura de aplicación (App Open Ads). |
| [InterstitialAd](classes/InterstitialAd.es.md) | Formato de anuncio intersticial de pantalla completa. |
| [InterstitialAdLoader](classes/InterstitialAdLoader.es.md) | Clase de carga responsable de obtener anuncios intersticiales. |
| [RewardedAd](classes/RewardedAd.es.md) | Formato de anuncio bonificado de pantalla completa. |
| [RewardedAdLoader](classes/RewardedAdLoader.es.md) | Clase de carga responsable de obtener anuncios bonificados. |
| [RewardedInterstitialAd](classes/RewardedInterstitialAd.es.md) | Formato de anuncio intersticial bonificado (superposición semitransparente). |
| [RewardedInterstitialAdLoader](classes/RewardedInterstitialAdLoader.es.md) | Clase de carga responsable de obtener anuncios intersticiales bonificados. |
| [NativeOverlayAd](classes/NativeOverlayAd.es.md) | Formato de anuncio nativo superpuesto en las escenas de Godot. |
| [NativeAdOptions](classes/NativeAdOptions.es.md) | Preferencias para renderizar anuncios nativos de sobreposición. |
| [NativeTemplateStyle](classes/NativeTemplateStyle.es.md) | Plantilla de estilo visual para anuncios nativos de sobreposición. |
| [NativeTemplateTextStyle](classes/NativeTemplateTextStyle.es.md) | Configuración de fuente y color para elementos de texto. |
| [ResponseInfo](classes/ResponseInfo.es.md) | Contiene metadados e información de respuesta del adaptador para anuncios cargados. |
| [AdapterResponseInfo](classes/AdapterResponseInfo.es.md) | Metadados de un adaptador de red de mediación específico. |
| [AdError](classes/AdError.es.md) | Información sobre los errores que ocurren durante la visualización del anuncio. |
| [LoadAdError](classes/LoadAdError.es.md) | Información sobre los errores que ocurren durante la carga del anuncio. |
| [MediaContent](classes/MediaContent.es.md) | Representa recursos multimedia (video/imagen) de un anuncio nativo. |
| [AdValue](classes/AdValue.es.md) | Representa el valor monetario de una impresión de anuncio. |
| [RewardedItem](classes/RewardedItem.es.md) | Representa una recompensa ganada por el usuario (cantidad y tipo). |
| [InitializationStatus](classes/InitializationStatus.es.md) | Contiene detalles del estado de inicialización para MobileAds. |
| [AdapterStatus](classes/AdapterStatus.es.md) | Representa el estado de inicialización de un único adaptador de mediación. |
| [ServerSideVerificationOptions](classes/ServerSideVerificationOptions.es.md) | Configuraciones de seguridad para devoluciones de llamada de recompensa del lado del servidor (SSV). |
| [UserMessagingPlatform](classes/UserMessagingPlatform.es.md) | Punto de entrada para flujos de consentimiento de privacidad y GDPR. |
| [ConsentInformation](classes/ConsentInformation.es.md) | Verifica y actualiza el estado de consentimiento del usuario. |
| [ConsentForm](classes/ConsentForm.es.md) | Formulario de consentimiento que se puede mostrar al usuario. |
| [ConsentRequestParameters](classes/ConsentRequestParameters.es.md) | Parámetros para solicitar actualizaciones de información de consentimiento. |
| [ConsentDebugSettings](classes/ConsentDebugSettings.es.md) | Configuración de prueba para el flujo de consentimiento. |
| [FormError](classes/FormError.es.md) | Información de error para operaciones de formularios de consentimiento. |

## Enumeraciones

| Enumeración | Descripción |
| :--- | :--- |
| [AdPosition](enums/AdPosition.es.md) | Valores predefinidos de alineación de pantalla para anuncios de banner y native overlay. |
| [AdChoicesPlacement](enums/AdChoicesPlacement.es.md) | Ubicación de esquina para el ícono de AdChoices. |
| [NativeMediaAspectRatio](enums/NativeMediaAspectRatio.es.md) | Preferencia de relación de aspecto de medios para anuncios nativos. |
| [NativeTemplateFontStyle](enums/NativeTemplateFontStyle.es.md) | Grosores de fuente tipográfica para campos de texto de anuncios nativos. |
| [AdValue.PrecisionType](enums/AdValue.PrecisionType.es.md) | Nivel de precisión del valor de los ingresos del anuncio. |
| [AdapterStatus.InitializationState](enums/AdapterStatus.InitializationState.es.md) | Indica si un adaptador de mediación está listo. |
| [RequestConfiguration.TagForChildDirectedTreatment](enums/RequestConfiguration.TagForChildDirectedTreatment.es.md) | Tratamiento dirigido a niños para el cumplimiento de COPPA. |
| [RequestConfiguration.TagForUnderAgeOfConsent](enums/RequestConfiguration.TagForUnderAgeOfConsent.es.md) | Tratamiento para menores de edad de consentimiento para el cumplimiento de GDPR. |
| [DebugGeography](enums/DebugGeography.es.md) | Geografía de depuración para probar el flujo de consentimiento. |
| [ConsentInformation.ConsentStatus](enums/ConsentInformation.ConsentStatus.es.md) | Estado de consentimiento del usuario para regulaciones de privacidad. |
| [ConsentInformation.PrivacyOptionsRequirementStatus](enums/ConsentInformation.PrivacyOptionsRequirementStatus.es.md) | Si se requieren opciones de privacidad. |

## Interfaces / Devoluciones de llamada

| Devolución de llamada | Descripción |
| :--- | :--- |
| [OnInitializationCompleteListener](listeners/OnInitializationCompleteListener.es.md) | Devolución de llamada activada cuando se completa la inicialización del SDK. |
| [AdListener](listeners/AdListener.es.md) | Recibe eventos de banner y superposición. |
| [FullScreenContentCallback](listeners/FullScreenContentCallback.es.md) | Recibe eventos de presentación para formatos de pantalla completa. |
| [OnUserEarnedRewardListener](listeners/OnUserEarnedRewardListener.es.md) | Recibe el evento cuando el usuario obtiene una recompensa. |
| [AppOpenAdLoadCallback](listeners/AppOpenAdLoadCallback.es.md) | Maneja resultados de carga para anuncios de apertura de aplicación. |
| [InterstitialAdLoadCallback](listeners/InterstitialAdLoadCallback.es.md) | Maneja resultados de carga para anuncios intersticiales. |
| [RewardedAdLoadCallback](listeners/RewardedAdLoadCallback.es.md) | Maneja resultados de carga para anuncios bonificados. |
| [RewardedInterstitialAdLoadCallback](listeners/RewardedInterstitialAdLoadCallback.es.md) | Maneja resultados de carga para anuncios intersticiales bonificados. |
| [VideoLifecycleCallbacks](listeners/VideoLifecycleCallbacks.es.md) | Recibe eventos de ciclo de vida de reproducción de video para anuncios nativos. |
| [AdInspectorClosedListener](listeners/AdInspectorClosedListener.es.md) | Se activa cuando se cierra el Ad Inspector nativo. |
