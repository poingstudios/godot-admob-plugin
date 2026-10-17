# Fazer divulgações para usuários dos EUA

!!! note
    **Importante:** Verifique se você tem a permissão de **Gerenciamento de conta** para concluir a configuração de consentimento da UE e GDPR, regulamentos dos estados dos EUA e a User Messaging Platform. Consulte [Gerenciar o acesso de usuários à sua conta](https://support.google.com/admob/answer/2784628) para mais detalhes.

Para ajudar você a cumprir as [leis de privacidade dos estados dos EUA](https://support.google.com/admob/answer/9561022), o SDK do Google Mobile Ads permite usar o parâmetro de [processamento de dados restrito (RDP)](https://business.safety.google/rdp/) do Google para indicar se o RDP deve ser ativado. O Google também oferece suporte à [Global Privacy Platform (GPP)](https://iabtechlab.com/standards/global-privacy-platform-gpp/) para os estados dos EUA aplicáveis.

Quando o SDK do Google Mobile Ads usa qualquer um dos sinais, o SDK restringe determinados identificadores exclusivos e outros dados processados na prestação de serviços a você.

Você deve decidir como o processamento de dados restrito pode apoiar seus planos de conformidade e quando ativá-lo. Determine se deve usar o parâmetro RDP diretamente ou sinalizar o consentimento e as escolhas de privacidade com a especificação GPP.

Este guia ajuda você a ativar o RDP globalmente via armazenamento local ou por solicitação de anúncio, e a usar o sinal GPP.

Este documento é baseado em:

- [Documentação do SDK do Google Mobile Ads para Android](https://developers.google.com/admob/android/privacy/us-states)
- [Documentação do SDK do Google Mobile Ads para iOS](https://developers.google.com/admob/ios/privacy/us-states)

## Pré-requisitos

- Conclua o [Guia de primeiros passos](../user_messaging_tools/get_started.md).
- Crie uma [mensagem de regulamentos dos estados dos EUA](https://support.google.com/admob/answer/13467025).

## Marcar como abaixo da idade de consentimento

Para indicar se um usuário está abaixo da idade de consentimento, defina `tag_for_under_age_of_consent` / `TagForUnderAgeOfConsent` (TFUA). Ao definir o TFUA como `true`, o SDK do UMP não solicita consentimento do usuário. Se o seu aplicativo tiver um público misto, defina este parâmetro para usuários menores para garantir que o consentimento não seja solicitado.

!!! warning "Importante"
    O SDK do UMP não encaminha a tag TFUA definida nas solicitações de consentimento para o SDK do Mobile Ads. Você deve definir explicitamente `tag_for_under_age_of_consent` nas solicitações de anúncios. Se você não definir `tag_for_under_age_of_consent` nas solicitações de anúncios, o SDK do UMP não coletará nenhuma informação que permita ao Google determinar se usuários abaixo da idade de consentimento usam seu aplicativo ou não.

    Para mais informações, consulte [Marcar uma solicitação de anúncio para usuários abaixo da idade de consentimento](../../advanced_topics/targeting.md).

O exemplo a seguir define TFUA como `true` em uma solicitação de consentimento do UMP:

=== "GDScript"

    ```gdscript
    var params := ConsentRequestParameters.new()
    params.tag_for_under_age_of_consent = true

    UserMessagingPlatform.consent_information.update(params, _on_consent_info_updated)
    ```

=== "C#"

    ```csharp
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Ump.Core;

    var parameters = new ConsentRequestParameters
    {
        // Indica que o usuário está abaixo da idade de consentimento.
        TagForUnderAgeOfConsent = true
    };

    UserMessagingPlatform.ConsentInformation.Update(parameters, OnConsentInfoUpdated);
    ```

## Ativar o sinal de RDP

O Google oferece suporte a duas formas de ativar o processamento de dados restrito (RDP). Ambas são válidas e suportadas pelo SDK do Google Mobile Ads:

### Globalmente no armazenamento local (Recomendado)

Nos SDKs oficiais para Android e iOS, o Google recomenda gravar a chave `gad_rdp` diretamente no armazenamento local (`SharedPreferences` no Android, `UserDefaults` no iOS). O SDK do Google Mobile Ads lê essa chave automaticamente durante o carregamento do anúncio e aplica o RDP a todas as solicitações de anúncios do aplicativo:

=== "GDScript"

    ```gdscript
    if OS.get_name() == "Android":
        ApplicationPreferences.set_int("gad_rdp", 1)
    elif OS.get_name() == "iOS":
        ApplicationPreferences.set_bool("gad_rdp", true)
    ```

=== "C#"

    ```csharp
    if (OperatingSystem.IsAndroid())
    {
        ApplicationPreferences.SetInt("gad_rdp", 1);
    }
    else if (OperatingSystem.IsIOS())
    {
        ApplicationPreferences.SetBool("gad_rdp", true);
    }
    ```

### Por solicitação de anúncio

Você também pode ativar o sinal de RDP por solicitação de anúncio inserindo a chave `rdp` com o valor `1` (ou `"1"` em C#) no dicionário `extras` de um [`AdRequest`](../../reference/classes/AdRequest.md):

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

## Usar o sinal IAB GPP

Se você coleta decisões de consentimento com uma plataforma de gerenciamento de consentimento (CMP) ou suas próprias mensagens personalizadas, o SDK do Google Mobile Ads respeita os sinais GPP gravados no armazenamento local. O SDK da User Messaging Platform (UMP) oferece suporte à gravação do sinal GPP. Para coletar o consentimento dos estados dos EUA, configure uma mensagem de **Regulamentos dos estados dos EUA** na sua conta da AdMob em **Privacidade e mensagens**. Para configurar o UMP, consulte [Configurar o SDK do UMP](../user_messaging_tools/get_started.md).

### Ler as escolhas de consentimento

O SDK do UMP grava os dados GPP no armazenamento local de acordo com a [especificação IAB GPP](https://iabtechlab.com/standards/global-privacy-platform-gpp/). Observe que o SDK do UMP preenche apenas essas duas chaves para gerenciar regulamentos dos estados dos EUA:

- `IABGPP_HDR_GppString`: A string GPP que contém o consentimento do usuário codificado e as preferências de desativação (opt-out).
- `IABGPP_GppSID`: Os IDs de seção incluídos na string GPP (por exemplo, `7` para US National).

Você pode ler as escolhas de consentimento do armazenamento local usando [`ApplicationPreferences`](../../reference/classes/ApplicationPreferences.md):

=== "GDScript"

    ```gdscript
    var gpp_string := ApplicationPreferences.get_string("IABGPP_HDR_GppString")
    var gpp_sid := ApplicationPreferences.get_string("IABGPP_GppSID")
    ```

=== "C#"

    ```csharp
    var gppString = ApplicationPreferences.GetString("IABGPP_HDR_GppString");
    var gppSid = ApplicationPreferences.GetString("IABGPP_GppSID");
    ```

## Testar suas mensagens de regulamentos dos estados dos EUA

Para testar o fluxo de mensagens de regulamentos dos estados dos EUA usando o SDK do UMP em um dispositivo de teste, force a geografia de depuração em [`ConsentDebugSettings`](../../reference/classes/ConsentDebugSettings.md):

- **Simular um estado regulamentado dos EUA:** Defina `debug_geography` como `DebugGeography.Values.REGULATED_US_STATE` (ou `DebugGeography.RegulatedUsState` em C#).
- **Suprimir mensagens de regulamentos dos estados dos EUA:** Defina `debug_geography` como `DebugGeography.Values.OTHER` (ou `DebugGeography.Other` em C#).

=== "GDScript"

    ```gdscript
    var request := ConsentRequestParameters.new()
    var debug_settings := ConsentDebugSettings.new()
    debug_settings.debug_geography = DebugGeography.Values.REGULATED_US_STATE
    debug_settings.test_device_hashed_ids.append("TEST-DEVICE-HASHED-ID")
    request.consent_debug_settings = debug_settings

    UserMessagingPlatform.consent_information.update(request, _on_consent_info_updated)
    ```

=== "C#"

    ```csharp
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Ump.Api;
    using PoingStudios.AdMob.Ump.Core;

    var request = new ConsentRequestParameters();
    var debugSettings = new ConsentDebugSettings();
    debugSettings.DebugGeography = DebugGeography.RegulatedUsState;
    debugSettings.TestDeviceHashedIds.Add("TEST-DEVICE-HASHED-ID");
    request.ConsentDebugSettings = debugSettings;

    UserMessagingPlatform.ConsentInformation.Update(request, OnConsentInfoUpdated);
    ```

## Mediação

Se você usa [mediação](../../mediate/get_started.md), acesse **Privacidade e mensagens** > **Regulamentos dos estados dos EUA** na interface da AdMob para gerenciar parceiros de anúncios para os estados dos EUA. Consulte a documentação de cada parceiro de rede de anúncios para determinar as opções que eles oferecem para conformidade com as regulamentações dos estados dos EUA.
