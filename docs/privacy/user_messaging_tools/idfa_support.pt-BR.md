# Suporte ao IDFA

Este guia descreve as etapas necessárias para oferecer suporte à mensagem do IDFA como parte do SDK do UMP. Ele deve ser pareado com o guia de [Primeiros Passos](get_started.md), que fornece uma visão geral de como colocar seu aplicativo em funcionamento com o SDK do UMP e o básico para configurar sua mensagem. As orientações abaixo são específicas para a mensagem do IDFA.

!!! note
    Se você habilitar tanto a mensagem do GDPR quanto do IDFA, consulte [Qual mensagem seus usuários verão](https://support.google.com/admob/answer/10115027#which_message) para conhecer os possíveis resultados.

Este documento é baseado em:

- [Documentação do SDK do Google Mobile Ads para iOS (Inglês)](https://developers.google.com/admob/ios/privacy/idfa)

## Pré-requisitos

- Complete o [Guia de Primeiros Passos](get_started.md)
- Crie uma [mensagem de IDFA](https://support.google.com/admob/answer/10115331)

## Atualizar o Info.plist

Se você planeja usar o SDK do UMP para gerenciar os requisitos de App Tracking Transparency (ATT) da Apple, certifique-se de ter criado, configurado e publicado sua [mensagem explicativa do IDFA](https://support.google.com/admob/answer/10115027) na interface do AdMob.

Para que o SDK do UMP exiba uma mensagem de alerta personalizada na caixa de diálogo do sistema iOS, atualize seu `Info.plist` para adicionar a chave `NSUserTrackingUsageDescription` com uma mensagem de texto personalizada descrevendo o uso.

```xml
<key>NSUserTrackingUsageDescription</key>
<string>Este identificador será usado para fornecer anúncios personalizados para você.</string>
```

A descrição de uso aparece como parte da caixa de diálogo da ATT quando você apresenta o formulário de consentimento:

![idfa-alert](https://developers.google.com/static/admob/ump/images/idfa-alert.png)

Em seguida, vincule o framework `AppTrackingTransparency`:

![link-att-framework](https://developers.google.com/static/admob/ump/images/link-att-framework.png)

E pronto! Seu aplicativo agora exibirá uma mensagem explicativa do IDFA antes da caixa de diálogo de ATT do IDFA.

### Testes

Ao testar, lembre-se de que a caixa de diálogo da ATT do IDFA só aparece uma única vez, já que [`requestTrackingAuthorization`](https://developer.apple.com/documentation/apptrackingtransparency/attrackingmanager/requesttrackingauthorization(completionhandler:)) é uma solicitação única. O SDK do UMP só possui um formulário disponível para carregar se o status de autorização for [`ATTrackingManagerAuthorizationStatusNotDetermined`](https://developer.apple.com/documentation/apptrackingtransparency/attrackingmanager/authorizationstatus/notdetermined?language=objc).

Para fazer o alerta aparecer uma segunda vez, você deve desinstalar e reinstalar seu aplicativo no dispositivo de teste.
