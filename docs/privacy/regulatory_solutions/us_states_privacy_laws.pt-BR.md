# Conformidade com as leis de privacidade dos estados dos EUA
!!! note
    **Importante**: Verifique se você tem a permissão de Gerenciamento de Conta para concluir a configuração para Consentimento da UE e GDPR, CCPA e UMP (User Messaging Platform). Para saber mais, consulte o artigo sobre [Novas Funções de Usuário](https://support.google.com/admob/answer/2784628).

Para ajudar os editores a cumprirem as [leis de privacidade dos estados dos EUA](https://support.google.com/admob/answer/9561022), o SDK do Google Mobile Ads permite que os editores usem dois parâmetros diferentes para indicar se o Google deve ativar o [processamento de dados restrito (RDP)](https://business.safety.google/rdp/). O SDK oferece aos editores a capacidade de definir o RDP no nível de solicitação de anúncio utilizando os seguintes sinais:

- Sinal RDP do Google
- `IABUSPrivacy_String` [definido pela IAB](https://iabtechlab.com/wp-content/uploads/2019/11/Technical-Specifications-FAQ-US-Privacy-IAB-Tech-Lab.pdf)

Quando qualquer um dos parâmetros é usado, o Google restringe como usa certos identificadores exclusivos e outros dados processados na prestação de serviços aos editores. Como resultado, o Google exibirá apenas anúncios não personalizados. Esses parâmetros substituem as configurações de RDP na interface do usuário.

Os editores devem decidir por si mesmos como o processamento de dados restrito pode apoiar seus planos de conformidade e quando ele deve ser ativado. É possível usar ambos os parâmetros opcionais ao mesmo tempo, embora eles tenham o mesmo efeito na veiculação de anúncios del Google.

Este guia destina-se a ajudar os editores a entender as etapas necessárias para ativar essas opções com base em cada solicitação de anúncio.

Este documento é baseado em:

- [Documentação do SDK do Google Mobile Ads para Android (Inglês)](https://developers.google.com/admob/android/privacy/us-states)
- [Documentação do SDK do Google Mobile Ads para iOS (Inglês)](https://developers.google.com/admob/ios/privacy/us-states)

## Sinal RDP

Para notificar o Google de que o RDP deve ser ativado usando o sinal do Google, insira a chave `rdp` como um parâmetro extra com o valor `1`.

=== "GDScript"

    ```gdscript
    var ad_request := AdRequest.new()
    ad_request.extras["rdp"] = 1
    ```

=== "C#"

    ```csharp
    var adRequest = new AdRequest();
    adRequest.Extras.Add("rdp", "1");
    ```

!!! note
    **Dica:** Você pode usar o rastreamento de rede ou uma ferramenta de proxy como o [Charles](https://www.charlesproxy.com/) para capturar o tráfego HTTPS do seu aplicativo e inspecionar as solicitações de anúncios em busca de um parâmetro **&rdp=**.

## Sinal IAB

Para notificar o Google de que o RDP deve ser ativado usando o sinal da IAB, insira a chave `IABUSPrivacy_String` como um parâmetro extra. Certifique-se de que o valor de texto que você usa está em conformidade com a [especificação da IAB](https://iabtechlab.com/wp-content/uploads/2019/11/Technical-Specifications-FAQ-US-Privacy-IAB-Tech-Lab.pdf).

=== "GDScript"

    ```gdscript
    var ad_request := AdRequest.new()
    ad_request.extras["IABUSPrivacy_String"] = "IAB_STRING"
    ```

=== "C#"

    ```csharp
    var adRequest = new AdRequest();
    adRequest.Extras.Add("IABUSPrivacy_String", "IAB_STRING");
    ```

!!! note
    **Dica:** Você pode usar o rastreamento de rede ou uma ferramenta de proxy como o [Charles](https://www.charlesproxy.com/) para capturar o tráfego HTTPS do seu aplicativo e inspecionar as solicitações de anúncios em busca de um parâmetro **&us_privacy=**.

## Mediação

!!! note
    **Importante:** Verifique se você tem as permissões de conta necessárias para concluir a configuração da mediação. Essas permissões incluem acesso ao gerenciamento de inventário, acesso ao aplicativo e recursos de privacidade e mensagens. Para saber mais, consulte o artigo sobre [Novas Funções de Usuário](https://support.google.com/admob/answer/2784628).

Se você usar a [mediação](../../mediate/get_started.md), siga as etapas nas [configurações da CPRA](https://support.google.com/admob/answer/10860309) para adicionar seus parceiros de mediação à lista de parceiros de anúncios da CCPA na interface do AdMob. Além disso, consulte a documentação de cada parceiro de rede de anúncios para determinar quais opções eles oferecem para ajudar na conformidade com a CCPA.
