# Estratégias de privacidade

!!! note
    **Importante**: Verifique se você tem a permissão de Gerenciamento de Conta para concluir a configuração das estratégias de privacidade. Para saber mais, consulte o artigo sobre [Novas Funções de Usuário](https://support.google.com/admob/answer/2784628).

Este guia explica as estratégias de privacidade disponíveis no SDK do Google Mobile Ads para ajudá-lo a entregar anúncios mais relevantes, respeitando a privacidade do usuário.

Este documento é baseado em:

- [SDK do Google Mobile Ads para Android - Estratégias de Privacidade](https://developers.google.com/admob/android/privacy/strategies)
- [SDK do Google Mobile Ads para iOS - Estratégias de Privacidade](https://developers.google.com/admob/ios/privacy/strategies)

## ID de primeira parte do editor

O SDK do Google Mobile Ads introduziu o ID de primeira parte do editor para ajudá-lo a entregar anúncios mais relevantes e personalizados usando dados coletados dos seus aplicativos.

O ID de primeira parte do editor está habilitado por padrão, mas você pode desabilitá-lo usando os seguintes métodos.

=== "GDScript"

    ```gdscript
    # Desabilita o ID de primeira parte do editor.
    MobileAds.set_publisher_first_party_id_enabled(false)
    ```

=== "C#"

    ```csharp
    // Desabilita o ID de primeira parte do editor.
    MobileAds.SetPublisherFirstPartyIDEnabled(false);
    ```

!!! note
    **Dica:** O ID de primeira parte do editor requer o SDK do Google Mobile Ads versão 22.6.0 ou superior para Android, e 10.14.0 ou superior para iOS.
