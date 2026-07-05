# Direcionamento (Targeting)

Este guia explica como fornecer informações de direcionamento (targeting) a uma solicitação de anúncio.

Este documento é baseado em:

- [Documentação do SDK do Google Mobile Ads para Android (Inglês)](https://developers.google.com/admob/android/targeting)
- [Documentação do SDK do Google Mobile Ads para iOS (Inglês)](https://developers.google.com/admob/ios/targeting)

## Pré-requisitos
- Complete o [Guia de Primeiros Passos](../index.md)


## RequestConfiguration

`RequestConfiguration` é uma entidade usada para reunir detalhes de direcionamento que podem ser aplicados globalmente por meio de um método estático dentro de `MobileAds`. E é aplicada por `MobileAds.set_request_configuration(request_configuration)`

### Configuração direcionada a crianças {: #configuracao-direcionada-a-criancas }

Para cumprir a [Lei de Proteção da Privacidade Online das Crianças (COPPA)](https://www.ftc.gov/tips-advice/business-center/privacy-and-security/children%27s-privacy), você pode definir a opção "tag para tratamento direcionado a crianças". Isso significa que você deseja que seu conteúdo seja tratado como direcionado a crianças para fins da COPPA. É importante garantir que você tenha autoridade para tomar essa decisão em nome do proprietário do aplicativo. Esteja ciente de que o uso indevido dessa configuração pode levar ao encerramento da sua conta do Google.

Como desenvolvedor de aplicativos, você pode indicar se o seu conteúdo é direcionado a crianças ao fazer solicitações de anúncios. Quando você especifica que seu conteúdo é direcionado a crianças, o Google tomará medidas para desativar a Publicidade Baseada em Interesses (IBA) e os anúncios de remarketing para essa solicitação de anúncio específica.

Para implementar essa configuração, você pode usar `RequestConfiguration.new().tag_for_child_directed_treatment = int` com as seguintes opções:

- Use `tag_for_child_directed_treatment` com `RequestConfiguration.TagForChildDirectedTreatment.TRUE` para indicar que seu conteúdo deve ser tratado como direcionado a crianças para conformidade com a COPPA. Isso impedirá a transmissão do identificador de publicidade do Android (AAID) e do Identificador de Publicidade do iOS, IDFA.

- Use `tag_for_child_directed_treatment` com `RequestConfiguration.TagForChildDirectedTreatment.FALSE` para especificar que seu conteúdo não deve ser tratado como direcionado a crianças para fins da COPPA.

- Use `tag_for_child_directed_treatment` com `RequestConfiguration.TagForChildDirectedTreatment.UNSPECIFIED` se você não quiser especificar como seu conteúdo deve ser tratado nas solicitações de anúncios em relação à COPPA.

O exemplo a seguir indica que você deseja que seu conteúdo seja tratado como direcionado a crianças para fins da COPPA:

=== "GDScript"

    ```gdscript
    var request_configuration := RequestConfiguration.new()
    request_configuration.tag_for_child_directed_treatment = RequestConfiguration.TagForChildDirectedTreatment.TRUE
    MobileAds.set_request_configuration(request_configuration)
    ```

=== "C#"

    ```csharp linenums="1"
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    
    var requestConfiguration = new RequestConfiguration();
    requestConfiguration.ChildDirectedTreatment = RequestConfiguration.TagForChildDirectedTreatment.True;
    MobileAds.SetRequestConfiguration(requestConfiguration);
    ```

### Usuários abaixo da idade de consentimento

Você pode configurar suas solicitações de anúncios para receber tratamento para usuários no Espaço Econômico Europeu (EEE) que estejam abaixo da idade de consentimento. Este recurso foi projetado para auxiliar na conformidade sob o [Regulamento Geral sobre a Proteção de Dados (GDPR)](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32016R0679). É importante observar que o GDPR pode impor obrigações legais adicionais, por isso é aconselhável consultar a assessoria jurídica e revisar as diretrizes da União Europeia. As ferramentas do Google destinam-se a apoiar a conformidade, mas não substituem as responsabilidades legais dos editores. [Saiba mais sobre como o GDPR afeta os editores](https://support.google.com/admob/answer/7666366).

Ao usar este recurso, uma solicitação de anúncio conterá um parâmetro "Tag For Users under the Age of Consent in Europe" (TFUA). Este parâmetro desativa a publicidade personalizada, incluindo remarketing, para todas as solicitações de anúncios. Ele também impede solicitações a fornecedores de anúncios terceirizados, como pixels de medição de anúncios e servidores de anúncios terceirizados.

Semelhante às configurações direcionadas a crianças, você pode utilizar a propriedade na classe `RequestConfiguration.new()` para definir o parâmetro TFUA: `tag_for_under_age_of_consent = int`. Ela oferece as seguintes opções:

- Use `tag_for_under_age_of_consent` com `RequestConfiguration.TagForUnderAgeOfConsent.TRUE` para indicar que você deseja que a solicitação de anúncio receba tratamento para usuários no Espaço Econômico Europeu (EEE) abaixo da idade de consentimento. Isso também impedirá a transmissão do identificador de publicidade do Android (AAID) e do Identificador de Publicidade do iOS, IDFA.

- Use `tag_for_under_age_of_consent` com `RequestConfiguration.TagForUnderAgeOfConsent.FALSE` para especificar que você não deseja que a solicitação de anúncio receba tratamento para usuários no Espaço Econômico Europeu (EEE) abaixo da idade de consentimento.

- Use `tag_for_under_age_of_consent` com `RequestConfiguration.TagForUnderAgeOfConsent.UNSPECIFIED` para indicar que você não especificou se a solicitação de anúncio deve receber tratamento para usuários no Espaço Econômico Europeu (EEE) abaixo da idade de consentimento.

Aqui está um exemplo indicando sua intenção de incluir o TFUA em suas solicitações de anúncios:

=== "GDScript"

    ```gdscript
    var request_configuration := RequestConfiguration.new()
    request_configuration.tag_for_under_age_of_consent = RequestConfiguration.TagForUnderAgeOfConsent.UNSPECIFIED
    MobileAds.set_request_configuration(request_configuration)
    ```

=== "C#"

    ```csharp linenums="1"
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    
    var requestConfiguration = new RequestConfiguration();
    requestConfiguration.UnderAgeOfConsent = RequestConfiguration.TagForUnderAgeOfConsent.Unspecified;
    MobileAds.SetRequestConfiguration(requestConfiguration);
    ```

As tags para ativar a [Configuração direcionada a crianças](#configuracao-direcionada-a-criancas) e a propriedade `tag_for_under_age_of_consent` não devem ser definidas simultaneamente como `true`. Se forem, a configuração direcionada a crianças terá precedência.


### Filtragem de conteúdo do anúncio

Para garantir a conformidade com a [Política de Anúncios Inadequados](https://support.google.com/googleplay/android-developer/answer/9857753#zippy=%2Cexamples-of-common-violations) do Google Play, que abrange ofertas associadas em anúncios, é essencial que todos os anúncios e suas ofertas associadas exibidos em seu aplicativo estejam alinhados com a [classificação de conteúdo](https://support.google.com/googleplay/android-developer/answer/9898843) do seu aplicativo. Isso se aplica mesmo se o próprio conteúdo estiver em conformidade com as políticas do Google Play.

Ferramentas como a classificação máxima do conteúdo do anúncio oferecem maior controle sobre o conteúdo dos anúncios exibidos aos seus usuários. Você pode definir uma classificação máxima de conteúdo para garantir a adesão às políticas da plataforma.

Os aplicativos podem especificar uma classificação máxima do conteúdo do anúncio para suas solicitações de anúncios usando a propriedade `max_ad_content_rating`. Os anúncios do AdMob retornados com essa configuração terão uma classificação de conteúdo que corresponde ou fica abaixo do nível especificado. Os valores disponíveis para esse extra de rede são baseados nas [classificações de rótulos de conteúdo digital](https://support.google.com/admob/answer/7562142) e devem ser uma das seguintes strings:

- `RequestConfiguration.MAX_AD_CONTENT_RATING_G`
- `RequestConfiguration.MAX_AD_CONTENT_RATING_PG`
- `RequestConfiguration.MAX_AD_CONTENT_RATING_T`
- `RequestConfiguration.MAX_AD_CONTENT_RATING_MA`

O código a seguir demonstra como configurar um objeto `RequestConfiguration` para especificar que o conteúdo do anúncio retornado não deve exceder a designação de rótulo de conteúdo digital `G`:

=== "GDScript"

    ```gdscript
    var request_configuration := RequestConfiguration.new()
    request_configuration.max_ad_content_rating = RequestConfiguration.MAX_AD_CONTENT_RATING_G
    MobileAds.set_request_configuration(request_configuration)
    ```

=== "C#"

    ```csharp linenums="1"
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    
    var requestConfiguration = new RequestConfiguration();
    requestConfiguration.MaxAdContentRating = RequestConfiguration.MaxAdContentRatingG;
    MobileAds.SetRequestConfiguration(requestConfiguration);
    ```

## AdRequest

O `AdRequest` coleta informações de segmentação a serem enviadas com uma solicitação de anúncio individual.

### Adicionar extras de rede

Os extras de rede são detalhes adicionais enviados com uma solicitação de anúncio que são específicos de uma única origem de anúncio.

Para enviar um parâmetro extra ao Google (por exemplo, uma chave de `collapsible` com o valor de `bottom` para solicitar um [Banner Colapsável](../ad_formats/banner/collapsible.md)), preencha o dicionário `extras`:

=== "GDScript"

    ```gdscript
    var ad_request := AdRequest.new()
    ad_request.extras = {
        "collapsible": "bottom"
    }
    # Em seguida, carregue o anúncio com a solicitação, ex.:
    # ad_view.load_ad(ad_request)
    ```

=== "C#"

    ```csharp
    var adRequest = new AdRequest();
    adRequest.Extras = new Godot.Collections.Dictionary
    {
        { "collapsible", "bottom" }
    };
    // Em seguida, carregue o anúncio com a solicitação, ex.:
    // adView.LoadAd(adRequest);
    ```


Saiba mais sobre:

- [Definir a classificação máxima de conteúdo para cada solicitação de anúncio](https://support.google.com/admob/answer/10477886)
- [Definir a classificação máxima do conteúdo do anúncio para um aplicativo ou conta](https://support.google.com/admob/answer/7562142)
