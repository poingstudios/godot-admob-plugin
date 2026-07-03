# Suporte ao GDPR IAB

Este guia descreve as etapas necessárias para oferecer suporte à mensagem do GDPR IAB TCF v2 como parte do SDK do UMP. Ele deve ser pareado com o guia de [Primeiros Passos](get_started.md), que fornece uma visão geral de como colocar seu aplicativo em funcionamento com o SDK do UMP e o básico para configurar sua mensagem. As orientações abaixo são específicas para a mensagem do GDPR IAB TCF v2.

Este documento é baseado em:

- [Documentação do SDK do Google Mobile Ads para Android (Inglês)](https://developers.google.com/admob/android/privacy/gdpr)
- [Documentação do SDK do Google Mobile Ads para iOS (Inglês)](https://developers.google.com/admob/ios/privacy/gdpr)

## Pré-requisitos

- Complete o [Guia de Primeiros Passos](get_started.md)
- Crie uma [mensagem de GDPR para aplicativos](https://support.google.com/admob/answer/10113207).

## Atrasar a medição do aplicativo (Delay app measurement)

Por padrão, o SDK do Google Mobile Ads inicializa a medição do aplicativo e começa a enviar dados de eventos no nível do usuário para o Google imediatamente quando o aplicativo inicia. Esse comportamento de inicialização garante que você possa habilitar as métricas de usuário do AdMob sem fazer alterações adicionais no código.

No entanto, se o seu aplicativo exigir o consentimento do usuário antes que esses eventos possam ser enviados, você poderá atrasar a medição do aplicativo até [inicializar explicitamente o SDK do Mobile Ads](../../index.md) ou carregar um anúncio.

=== "Android"
    Para atrasar a medição do aplicativo, adicione a seguinte tag `<meta-data>` no seu `res://android/build/AndroidManifest.xml`.
    ```xml
    <manifest>
        <application>
        <!-- Delay app measurement until MobileAds.initialize() is called. -->
        <meta-data
            android:name="com.google.android.gms.ads.DELAY_APP_MEASUREMENT_INIT"
            android:value="true"/>
        </application>
    </manifest>
    ```

=== "iOS"
    Para atrasar a medição do aplicativo, adicione a chave `GADDelayAppMeasurementInit` com um valor booleano de `YES` (ou `<true/>`) ao `Info.plist` do seu projeto Xcode exportado. Você pode fazer essa alteração de forma declarativa no arquivo:

    ```xml
    <key>GADDelayAppMeasurementInit</key>
    <true/>
    ```

## Revogação de consentimento

A [revogabilidade do consentimento](https://support.google.com/admob/answer/10113915) é um requisito do programa de consentimento do usuário de Privacidade e Mensagens. Você deve fornecer um link no menu do seu aplicativo que permita aos usuários que desejam revogar o consentimento fazê-lo e, em seguida, apresentar a mensagem de consentimento a esses usuários novamente.

Para realizar isso:

1. [Carregue um formulário](get_started.md#carregar-um-formulario-se-disponivel) toda vez que o usuário iniciar seu aplicativo, para que o formulário esteja pronto para ser exibido caso o usuário queira alterar sua configuração de consentimento.
2. Apresente o formulário quando o usuário selecionar o link no menu do seu aplicativo.

=== "GDScript"

    ```gdscript
    var _consent_form : ConsentForm
    
    func present_form() -> void:
    	_consent_form.show(_on_consent_form_dismissed)
    	
    func _on_consent_form_dismissed(form_error : FormError):
    	# Handle dismissal by reloading form.
    	load_form()
    ```

=== "C#"

    ```csharp
    private ConsentForm _consentForm;
    
    private void PresentForm()
    {
        _consentForm.Show(OnConsentFormDismissed);
    }
    
    private void OnConsentFormDismissed(FormError formError)
    {
        // Handle dismissal by reloading form.
        LoadForm();
    }
    ```

## Mediação
Siga as etapas em [Adicionar parceiros de anúncios a mensagens do GDPR publicadas](https://support.google.com/admob/answer/10113004#adding_ad_partners_to_published_gdpr_messages) para adicionar seus parceiros de mediação à lista de parceiros de anúncios. Caso contrário, os parceiros poderão não conseguir veicular anúncios no seu aplicativo.

Os parceiros de mediação também podem ter ferramentas adicionais para ajudar na conformidade com o GDPR. Consulte o [guia de integração](../../mediate/get_started.md) de um parceiro específico para obter mais detalhes.


## Resolução de Problemas

**Erro 3.3: A data da última atualização da string TC ocorreu há mais de 13 meses**

- O [consentimento deve ser reobtido](https://support.google.com/admob/answer/9999955#grace-period-2) do usuário. Você deve chamar `UserMessagingPlatform.consent_information.update()` no início de cada sessão do aplicativo. Se a string TC estiver expirada, o SDK do UMP indicará que o consentimento deve ser reobtido definindo `ConsentInformation.ConsentStatus` como `ConsentInformation.ConsentStatus.REQUIRED`. Se você ainda não fez isso, implemente uma solicitação para [carregar e apresentar um novo formulário UMP](get_started.md#apresentar-o-formulario-se-necessario) no seu aplicativo.

- É possível que a string TC expire no meio de uma sessão, resultando em uma pequena quantidade de erros `3.3`. E se na próxima sessão do aplicativo você começar a carregar anúncios ao mesmo tempo em que verifica `UserMessagingPlatform.consent_information.update()`, essas solicitações também poderão gerar erros `3.3` até que `UserMessagingPlatform.consent_information.update()` seja concluído; no entanto, isso deve representar uma fração muito pequena dos erros `3.3` no geral (menos de 0,1%) que são esperados.
