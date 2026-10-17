# Fazer divulgações para usuários do EEE

De acordo com a [Política de consentimento de usuários da UE](https://www.google.com/about/company/user-consent-policy/) do Google, você precisa fazer determinadas divulgações aos usuários no Espaço Econômico Europeu (EEE), no Reino Unido e na Suíça e obter o consentimento deles para usar cookies ou outro armazenamento local, quando legalmente exigido, e usar dados pessoais (como o AdID) para veicular anúncios. Essa política reflete os requisitos da Diretiva de privacidade eletrônica da UE e do Regulamento geral de proteção de dados (GDPR).

Este guia descreve as etapas necessárias para oferecer suporte à mensagem do GDPR IAB TCF v2 como parte do SDK do UMP. Ele deve ser pareado com o guia de [Primeiros passos](get_started.md), que fornece uma visão geral de como colocar seu aplicativo em funcionamento com o SDK do UMP e as noções básicas para configurar sua mensagem. As orientações a seguir são específicas para a mensagem do GDPR IAB TCF v2. Para mais informações, consulte [Como os requisitos do IAB afetam as mensagens de consentimento da UE](https://support.google.com/admob/answer/10207733).

Este documento é baseado em:

- [Documentação do SDK do Google Mobile Ads para Android (Inglês)](https://developers.google.com/admob/android/privacy/gdpr)
- [Documentação do SDK do Google Mobile Ads para iOS (Inglês)](https://developers.google.com/admob/ios/privacy/gdpr)

## Pré-requisitos

- Conclua o [Guia de Primeiros passos](get_started.md).
- Crie uma [mensagem sobre as regulamentações europeias para apps](https://support.google.com/admob/answer/10113207).

## Revogação de consentimento

O GDPR exige a [revogação de consentimento](https://support.google.com/admob/answer/10113915) para permitir que os usuários retirem as escolhas de consentimento a qualquer momento. Consulte [Opções de privacidade](get_started.md) para implementar uma maneira de os usuários retirarem suas opções de consentimento.

## Marcar como abaixo da idade de consentimento

Para indicar se um usuário está abaixo da idade de consentimento, defina `tag_for_under_age_of_consent` / `TagForUnderAgeOfConsent` (TFUA). Quando você define o TFUA como `true`, o SDK do UMP não solicita o consentimento do usuário. Se o seu app tiver um público misto, defina esse parâmetro para usuários menores de idade para garantir que o consentimento não seja solicitado.

!!! warning "Importante"
    O SDK do UMP não encaminha a tag TFUA definida nas solicitações de consentimento para o SDK do Google Mobile Ads. Você precisa definir explicitamente `tag_for_under_age_of_consent` nas configurações de solicitação de anúncios. Se você não definir `tag_for_under_age_of_consent` nas solicitações de anúncios, o SDK do UMP não coletará nenhuma informação que permita ao Google determinar se usuários abaixo da idade de consentimento usam seu app.

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
        // Indicar que o usuário está abaixo da idade de consentimento.
        TagForUnderAgeOfConsent = true
    };

    UserMessagingPlatform.ConsentInformation.Update(parameters, OnConsentInfoUpdated);
    ```

## Configurar consentimento na mediação da AdMob

Para configurar o consentimento na mediação da AdMob, conclua as etapas das seções a seguir.

### Adicionar parceiros de publicidade a mensagens do GDPR

Siga as etapas em [Adicionar parceiros de publicidade a mensagens do GDPR publicadas](https://support.google.com/admob/answer/10113004#adding_ad_partners_to_published_gdpr_messages) para adicionar seus parceiros de mediação à lista de parceiros de publicidade. Não fazer isso pode fazer com que os parceiros não consigam veicular anúncios no seu app.

A tabela a seguir lista o nome do parceiro de tecnologia de publicidade para cada origem de anúncios:

| Origem de anúncios | Nome do parceiro de ad tech |
| --- | --- |
| AppLovin | AppLovin Corp. |
| BidMachine | BidMachine |
| BIGO Ads SDK | Empathy Technology Pte.Ltd. (BIGO Ads) |
| Chartboost | Chartboost |
| DT Exchange | DT Exchange (Fyber Monetization) |
| i-mobile | i-mobile |
| InMobi | InMobi |
| ironSource Ads | ironSource Mobile |
| Liftoff Monetize | Liftoff |
| LY Ads Network | LY Ads Network |
| maio | maio |
| Meta Audience Network | Meta |
| Mintegral | Mobvista/Mintegral |
| Moloco Ads SDK | Moloco Ads |
| myTarget | Mail.ru |
| Pangle | Pangle DSP |
| PubMatic OpenWrap SDK | PubMatic |
| Unity Ads | Unity Ads |
| Verve HyBid SDK | Verve Group |

### Encaminhar consentimento para origens de anúncios

A tabela a seguir mostra quais origens de anúncios oferecem suporte ao envio de sinais de consentimento do GDPR de plataformas de gerenciamento de consentimento que se integram à Transparency and Consent Framework (TCF) do IAB e à [especificação de consentimento adicional do Google](https://support.google.com/admob/answer/9681999) para o SDK das origens de anúncios:

| Origem de anúncios | Versão mínima compatível |
| --- | --- |
| AppLovin | 7.0.0 |
| BidMachine | 1.0.0 |
| BIGO Ads SDK | 1.0.0 |
| Chartboost | 4.14.0 |
| DT Exchange | 3.3.0 |
| i-mobile | N/A¹ |
| InMobi | 4.6.4 |
| ironSource Ads | 2.6.0 |
| Liftoff Monetize | 5.2.2 |
| LY Ads Network | N/A¹ |
| maio | N/A¹ |
| Meta Audience Network | N/A² |
| Mintegral | 2.2.3 |
| Moloco Ads SDK | 1.0.0 |
| myTarget | 3.40.0 |
| Pangle | 5.9.0 |
| PubMatic OpenWrap SDK | 1.0.0 |
| Unity Ads | 3.20.0 |

¹ *A origem de anúncios não atende ao tráfego do EEE.*  
² *Para mais detalhes, entre em contato com o gerente de parcerias da Meta.*

## Como ler as escolhas de consentimento

Depois que o consentimento do GDPR tiver sido coletado, você poderá ler as escolhas de consentimento no armazenamento local seguindo a [especificação do TCF v2](https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/blob/master/TCFv2/IAB%20Tech%20Lab%20-%20CMP%20API%20v2.md#in-app-details).

A chave `IABTCF_PurposeConsents` indica o consentimento para cada uma das [finalidades do TCF](https://iabeurope.eu/iab-europe-transparency-consent-framework-policies/#Appendix_A_Purposes_Features_and_Special_Purposes_Definitions). Você pode ler e gravar as preferências do aplicativo usando [`ApplicationPreferences`](../../reference/classes/ApplicationPreferences.md).

O snippet de código a seguir mostra como verificar o consentimento para a Finalidade 1:

=== "GDScript"

    ```gdscript
    # Valor de exemplo: "1111111111"
    var purpose_consents := ApplicationPreferences.get_string("IABTCF_PurposeConsents")

    # As finalidades têm índice baseado em zero. O índice 0 contém informações sobre a Finalidade 1.
    if not purpose_consents.is_empty():
        var purpose_one_string := purpose_consents[0]
        var has_consent_for_purpose_one := purpose_one_string == "1"
    ```

=== "C#"

    ```csharp
    using PoingStudios.AdMob.Api;

    // Valor de exemplo: "1111111111"
    string purposeConsents = ApplicationPreferences.GetString("IABTCF_PurposeConsents");

    // As finalidades têm índice baseado em zero. O índice 0 contém informações sobre a Finalidade 1.
    if (!string.IsNullOrEmpty(purposeConsents))
    {
        char purposeOneString = purposeConsents[0];
        bool hasConsentForPurposeOne = purposeOneString == '1';
    }
    ```

## Perguntas frequentes

!!! note
    Consulte as [Perguntas frequentes sobre mensagens dos regulamentos europeus](https://support.google.com/admob/answer/13554116) para mais perguntas e respostas.

**O que acontece se eu não tomar nenhuma medida para atender aos requisitos da Plataforma de gerenciamento de consentimento para veicular anúncios no EEE, no Reino Unido e na Suíça?**

A partir de 16 de janeiro de 2024, se um parceiro não adotar uma [CMP certificada pelo Google](https://support.google.com/admob/answer/13554116), apenas [Anúncios limitados](https://support.google.com/admob/answer/9882911) estarão qualificados para veiculação no tráfego do EEE e do Reino Unido. Tenha uma CMP certificada em vigor para garantir que sua monetização não seja afetada.

**Como posso verificar se o usuário consentiu?**

O consentimento não é representado por um único bit, mas por um conjunto de finalidades e fornecedores, conforme definido na especificação do IAB TCF. Consulte [Políticas de consentimento: anúncios personalizados e não personalizados](https://support.google.com/admanager/answer/9012903) para saber mais sobre os critérios de personalização do Google Ads.

Além disso, as ad techs na lista de [provedores de tecnologia de publicidade](https://support.google.com/admob/answer/9012903) (ATP) do Google que não estão registradas na lista de fornecedores do TCF usam a [especificação técnica de consentimento adicional do Google](https://support.google.com/admob/answer/9681999) para a coleta de consentimento. O Google publica a lista em [additional-consent-providers.csv](https://storage.googleapis.com/tcfac/additional-consent-providers.csv).

Para depurar uma solicitação de anúncio individual, use o recurso [Solucionar problemas de configurações de privacidade](../../advanced_topics/ad_inspector/troubleshoot_privacy.md) no inspecionador de anúncios para visualizar estes sinais de privacidade:

| Rótulo do inspetor de anúncios | Parâmetro de consulta | Significado |
| --- | --- | --- |
| GDPR se aplica (`IABTCF_gdprApplies`) | `gdpr` | Se o GDPR se aplica a esta solicitação de anúncio. |
| String TC (`IABTCF_TCString`) | `gdpr_consent` | A string TC. O IAB fornece uma ferramenta da Web para decodificar o valor. |
| String AC (`IABTCF_AddtlConsent`) | `addtl_consent` | A string AC da especificação técnica de consentimento adicional do Google. |

Para ler escolhas de consentimento de maneira programática, consulte [Como ler as escolhas de consentimento](#como-ler-as-escolhas-de-consentimento).

**Preciso usar o SDK do UMP do Google para atender ao requisito de CMP?**

Não, você pode usar qualquer CMP da [lista de CMPs certificadas pelo Google](https://support.google.com/admob/answer/13554116) para veicular anúncios.

**Como posso mostrar o formulário de consentimento novamente usando o SDK do UMP mesmo se o usuário já consentiu?**

Se um usuário já tiver tomado uma decisão de consentimento, a solução de gerenciamento de consentimento do Google não solicitará novo consentimento até que a string TC expire ou se torne inválida.

O GDPR exige a modificação do consentimento para permitir que os usuários retirem as escolhas de consentimento a qualquer momento. Consulte [opções de privacidade](get_started.md) para implementar uma forma de retirar as escolhas. Para exibir o formulário novamente, chame `UserMessagingPlatform.show_privacy_options_form()` (`UserMessagingPlatform.ShowPrivacyOptionsForm()`).

**Integrei uma CMP certificada pelo Google, mas não vejo nenhuma solicitação de anúncio sendo feita aos parceiros de mediação, mesmo de usuários que consentiram. Por que isso está acontecendo?**

No TCF, o Google verifica se os provedores de tecnologia de publicidade e outras origens programáticas de demanda não violam a política do Google e têm pelo menos uma base legal para processar dados antes de incluí-los na cadeia de mediação. Acesse a seção [Configurar consentimento na mediação da AdMob](#configurar-consentimento-na-mediacao-da-admob) para mais detalhes.

Ao usar uma CMP de terceiros, confirme que ela oferece suporte ao armazenamento da ACString e inclua cada parceiro de mediação na lista de provedores de ad tech que a CMP de terceiros usa para coletar o consentimento.

**Posso mudar o funcionamento do meu app se os usuários não consentirem? Isso é permitido pelas políticas?**

Os editores podem ler a string IAB TCF em seus apps. Consulte [Como ler as escolhas de consentimento](#como-ler-as-escolhas-de-consentimento) para ler o consentimento de forma programática. Os editores devem revisar suas obrigações legais com uma assessoria jurídica.

**Ao selecionar "Gerenciar opções" e consentir com todas as finalidades, não vejo anúncios. Por que isso acontece?**

Além de coletar o consentimento das finalidades, você também precisa coletar o consentimento dos fornecedores. Ambos os consentimentos são necessários para que qualquer fornecedor, como o Google, veicule anúncios apropriados.

**Qual é a prática recomendada para exibir o alerta do ATT do iOS e o consentimento do GDPR para o mesmo usuário?**

Recomendamos exibir a mensagem de consentimento do GDPR primeiro e o alerta do ATT do iOS em segundo lugar, caso o usuário tenha consentido com o GDPR. O SDK do UMP processa isso automaticamente se você configurar as duas mensagens na interface da AdMob. Consulte [Qual mensagem os usuários vão ver](https://support.google.com/admob/answer/10115027) para mais informações.

Se você não estiver exibindo o alerta do ATT com o SDK do UMP, recomendamos [ler as escolhas de consentimento assim que o consentimento do GDPR for coletado](#como-ler-as-escolhas-de-consentimento) para determinar se deve exibir o alerta do ATT do iOS.

**Como implemento a string AC versão 2 para usuários que já consentiram com a versão 1?**

Verifique a chave `IABTCF_AddtlConsent` no armazenamento local de acordo com a [especificação técnica de consentimento adicional do Google](https://support.google.com/admob/answer/9681999) para determinar se um usuário consentiu com a versão 2 da string AC e se você precisa exibir o formulário de consentimento novamente:

=== "GDScript"

    ```gdscript
    # Exemplo de valor: "2~1.35.41.101~dv.9.21.81"
    var additional_consent := ApplicationPreferences.get_string("IABTCF_AddtlConsent")

    # O índice 0 contém informações sobre o número da versão da especificação.
    if not additional_consent.is_empty():
        var spec_ac_version := additional_consent[0]
        var is_ac_version_2 := spec_ac_version == "2"
    ```

=== "C#"

    ```csharp
    // Exemplo de valor: "2~1.35.41.101~dv.9.21.81"
    string additionalConsent = ApplicationPreferences.GetString("IABTCF_AddtlConsent");

    // O índice 0 contém informações sobre o número da versão da especificação.
    if (!string.IsNullOrEmpty(additionalConsent))
    {
        char specACVersion = additionalConsent[0];
        bool isACVersion2 = specACVersion == '2';
    }
    ```
