# Receita de Anúncio no Nível de Impressão

Quando ocorre uma impressão, o Godot AdMob Plugin fornece dados de receita de anúncios associados a essa impressão. Você pode usar os dados para calcular o valor de vida útil (lifetime value) de um usuário ou encaminhar os dados para outros sistemas relevantes.

Este guia destina-se a ajudá-lo a implementar a captura de dados de receita de anúncios no nível de impressão em seu projeto Godot.

## Pré-requisitos
- Certifique-se de ter [ativado o recurso de receita de anúncios no nível de impressão](https://support.google.com/admob/answer/11322405) na interface do AdMob.
- Complete o [Guia de Primeiros Passos](../index.md). Seu projeto Godot já deve ter o plugin AdMob da Poing Studios importado e configurado.
- Antes de poder receber qualquer dado de receita de anúncios no nível de impressão, você precisa implementar pelo menos um formato de anúncio:
    - [App open](../ad_formats/app_open.md)
    - [Banner](../ad_formats/banner/get_started.md)
    - [Interstitial](../ad_formats/interstitial.md)
    - [Rewarded](../ad_formats/rewarded.md)
    - [Rewarded interstitial](../ad_formats/rewarded_interstitial.md)
    - [Native](../ad_formats/native_overlay.md)

## Implementando um manipulador de eventos pagos

Cada formato de anúncio possui um evento `on_ad_paid` (`OnAdPaid` em C#). Durante o ciclo de vida de um evento de anúncio, o Godot AdMob Plugin monitora os eventos de impressão e invoca o manipulador com um [`AdValue`](../reference/classes/AdValue.md) representando o valor ganho. O tipo de precisão deste valor é definido por [`AdValue.PrecisionType`](../reference/enums/AdValue.PrecisionType.md).

O exemplo a seguir gerencia eventos pagos para um anúncio premiado:

=== "GDScript"

    ```gdscript
    var _rewarded_ad: RewardedAd
    
    func _load_rewarded_ad() -> void:
        # Send the request to load the ad.
        var ad_request := AdRequest.new()
        RewardedAdLoader.new().load("AD_UNIT_ID", ad_request, func(rewarded_ad: RewardedAd, error: LoadAdError):
            # If the operation failed with a reason.
            if error != null:
                push_error("Rewarded ad failed to load an ad with error: %s" % error.message)
                return
            
            _rewarded_ad = rewarded_ad
            _rewarded_ad.on_ad_paid = _handle_ad_paid_event
        )
    
    func _handle_ad_paid_event(ad_value: AdValue) -> void:
        # TODO: Send the impression-level ad revenue information to your
        # preferred analytics server directly within this callback.
    
        var value_micros: int = ad_value.value_micros
        var currency: String = ad_value.currency_code
        var precision := ad_value.precision # (AdValue.PrecisionType)
        var response_info: ResponseInfo = _rewarded_ad.get_response_info()
        var response_id: String = response_info.response_id
    
        var loaded_adapter_response_info: AdapterResponseInfo = response_info.loaded_adapter_response_info
        if loaded_adapter_response_info:
            var ad_source_id: String = loaded_adapter_response_info.ad_source_id
            var ad_source_instance_id: String = loaded_adapter_response_info.ad_source_instance_id
            var ad_source_instance_name: String = loaded_adapter_response_info.ad_source_instance_name
            var ad_source_name: String = loaded_adapter_response_info.ad_source_name
            var adapter_class_name: String = loaded_adapter_response_info.adapter_class_name
            var latency_millis: int = loaded_adapter_response_info.latency_millis
            var credentials: Dictionary = loaded_adapter_response_info.ad_unit_mapping
        
        var extras: Dictionary = response_info.response_extras
        var mediation_group_name = extras.get("mediation_group_name", "")
        var mediation_ab_test_name = extras.get("mediation_ab_test_name", "")
        var mediation_ab_test_variant = extras.get("mediation_ab_test_variant", "")
    ```

=== "C#"

    ```csharp linenums="1"
    using Godot;
    using Godot.Collections;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    
    private RewardedAd _rewardedAd;
    
    private void LoadRewardedAd()
    {
        // Send the request to load the ad.
        AdRequest adRequest = new AdRequest();
        RewardedAdLoader.Load("AD_UNIT_ID", adRequest, (rewardedAd, error) =>
        {
            // If the operation failed with a reason.
            if (error != null)
            {
                GD.PrintErr("Rewarded ad failed to load an ad with error: " + error.Message);
                return;
            }
    
            _rewardedAd = rewardedAd;
            _rewardedAd.OnAdPaid += HandleAdPaidEvent;
        });
    }
    
    private void HandleAdPaidEvent(AdValue adValue)
    {
        // TODO: Send the impression-level ad revenue information to your
        // preferred analytics server directly within this callback.
    
        long valueMicros = adValue.ValueMicros;
        string currency = adValue.CurrencyCode;
        AdValue.PrecisionType precision = adValue.Precision;
        ResponseInfo responseInfo = _rewardedAd.GetResponseInfo();
        string responseId = responseInfo.ResponseId;
    
        AdapterResponseInfo loadedAdapterResponseInfo = responseInfo.LoadedAdapterResponseInfo;
        if (loadedAdapterResponseInfo != null)
        {
            string adSourceId = loadedAdapterResponseInfo.AdSourceId;
            string adSourceInstanceId = loadedAdapterResponseInfo.AdSourceInstanceId;
            string adSourceInstanceName = loadedAdapterResponseInfo.AdSourceInstanceName;
            string adSourceName = loadedAdapterResponseInfo.AdSourceName;
            string adapterClassName = loadedAdapterResponseInfo.AdapterClassName;
            int latencyMillis = loadedAdapterResponseInfo.LatencyMillis;
            Godot.Collections.Dictionary credentials = loadedAdapterResponseInfo.AdUnitMapping;
        }
    
        Godot.Collections.Dictionary extras = responseInfo.ResponseExtras;
        string mediationGroupName = extras.ContainsKey("mediation_group_name") ? extras["mediation_group_name"].ToString() : "";
        string mediationABTestName = extras.ContainsKey("mediation_ab_test_name") ? extras["mediation_ab_test_name"].ToString() : "";
        string mediationABTestVariant = extras.ContainsKey("mediation_ab_test_variant") ? extras["mediation_ab_test_variant"].ToString() : "";
    }
    ```

## Identificar o nome de origem do anúncio de um evento personalizado

Para origens de anúncios de eventos personalizados, a propriedade `ad_source_name` (`AdSourceName`) fornece o nome Custom Event. Se você usar múltiplos eventos personalizados, o nome de origem do anúncio não é granular o suficiente para diferenciá-los. Para localizar um evento personalizado específico, siga estas etapas:

1. Obtenha a propriedade `adapter_class_name` (`AdapterClassName`).
2. Defina um nome de origem de anúncio exclusivo.

O exemplo a seguir define um nome de origem de anúncio exclusivo para um evento personalizado:

=== "GDScript"

    ```gdscript
    func _get_ad_source_name(loaded_adapter_response_info: AdapterResponseInfo) -> String:
        if loaded_adapter_response_info == null:
            return ""
    
        var ad_source_name: String = loaded_adapter_response_info.ad_source_name
    
        if ad_source_name == "Custom Event":
            var adapter_class_name: String = loaded_adapter_response_info.adapter_class_name
            
            if OS.get_name() == "Android":
                if adapter_class_name == "com.google.ads.mediation.sample.customevent.SampleCustomEvent":
                    ad_source_name = "Sample Ad Network (Custom Event)"
            elif OS.get_name() == "iOS":
                if adapter_class_name == "SampleCustomEvent":
                    ad_source_name = "Sample Ad Network (Custom Event)"
    
        return ad_source_name
    ```

=== "C#"

    ```csharp linenums="1"
    private string GetAdSourceName(AdapterResponseInfo loadedAdapterResponseInfo)
    {
        if (loadedAdapterResponseInfo == null)
        {
            return string.Empty;
        }
    
        string adSourceName = loadedAdapterResponseInfo.AdSourceName;
    
        if (adSourceName == "Custom Event")
        {
            string adapterClassName = loadedAdapterResponseInfo.AdapterClassName;
    
            if (OS.GetName() == "Android")
            {
                if (adapterClassName == "com.google.ads.mediation.sample.customevent.SampleCustomEvent")
                {
                    adSourceName = "Sample Ad Network (Custom Event)";
                }
            }
            else if (OS.GetName() == "iOS")
            {
                if (adapterClassName == "SampleCustomEvent")
                {
                    adSourceName = "Sample Ad Network (Custom Event)";
                }
            }
        }
        return adSourceName;
    }
    ```

Para obter mais informações sobre a origem do anúncio vencedor, consulte [Recuperar informações sobre a resposta do anúncio](response_info.md).

## Integrar com Parceiros de Atribuição de Aplicativos (AAP)

Para detalhes completos sobre o encaminhamento de dados de receita de anúncios para plataformas de análise, consulte o guia do parceiro:

- [Adjust (Inglês)](https://dev.adjust.com/en/sdk/android/integrations/admob)
- [AppsFlyer (Inglês)](https://support.appsflyer.com/hc/en-us/articles/4416353506833-Integrate-the-ROI360-ad-revenue-SDK-API)
- [Singular (Inglês)](https://support.singular.net/hc/en-us/articles/360037635452-Unity-SDK-Basic-Integration#42_Adding_Ad_Revenue_Attribution_Support)
- [Tenjin (Inglês)](https://tenjin.com/docs/en/send-events/android.html#impression-level-ad-revenue-integration)

## Boas práticas de implementação

- Configure o evento `on_ad_paid` (`OnAdPaid`) imediatamente após criar ou obter acesso ao objeto do anúncio, e definitivamente antes de exibir o anúncio. Isso garante que você não perca nenhum callback.
- Envie as informações de receita de anúncios no nível de impressão para o seu servidor de análise preferido imediatamente no seu manipulador `on_ad_paid`. Isso garante que você não perca callbacks acidentalmente e evita discrepâncias de dados.

## AdValue

!!! tip "Ponto Chave"
    O valor de `AdValue` é um valor em micro que representa o valor de cada anúncio. Por exemplo, um valor de 5.000 indica que a estimativa de valor deste anúncio é de $0.005.

| `AdValue.PrecisionType` | Description |
|---|---|
| `UNKNOWN` | Um valor de anúncio com precisão desconhecida. |
| `ESTIMATED` | Um valor de anúncio estimado a partir de dados agregados. |
| `PUBLISHER_PROVIDED` | Um valor de anúncio fornecido pelo editor, como CPMs manuais em um grupo de mediação. |
| `PRECISE` | O valor exato pago por este anúncio. |

No caso de mediação, o AdMob tenta fornecer um valor `ESTIMATED` para origens de anúncios que são [otimizadas](https://support.google.com/admob/answer/7374110). Para origens de anúncios não otimizadas, ou nos casos em que não há dados agregados suficientes para relatar uma estimativa significativa, o valor `PUBLISHER_PROVIDED` é retornado.

## Impressões de teste de origens de anúncios de lances (bidding)

Após a ocorrência de um evento de receita de anúncios no nível de impressão para uma origem de anúncio de lances através de uma solicitação de teste, você receberá apenas os seguintes valores:

- `UNKNOWN`: indica o tipo de precisão.
- `0`: indica o valor do anúncio.

Anteriormente, você poderia ter visto o tipo de precisão com um valor diferente de `UNKNOWN` e um valor de anúncio maior que 0.

Para obter detalhes sobre o envio de uma solicitação de anúncio de teste, consulte [Ativar anúncios de teste](../enable_test_ads.md).
