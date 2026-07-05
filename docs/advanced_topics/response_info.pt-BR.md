# Recuperar informações sobre a resposta do anúncio (ResponseInfo)

Para fins de depuração e registro em log, os anúncios carregados com sucesso fornecem um objeto [`ResponseInfo`](../reference/classes/ResponseInfo.md). Este objeto contém informações sobre o anúncio carregado, além de informações sobre a cascata (waterfall) de mediação usada para carregar o anúncio.

Para os casos em que um anúncio é carregado com sucesso e uma impressão é paga, as informações de resposta estão disponíveis por meio da propriedade `AdValue.response_info` (`AdValue.ResponseInfo` em C#) retornada pelo callback `on_ad_paid`. Além disso, especificamente para o [`AppOpenAd`](../reference/classes/AppOpenAd.md), você pode recuperá-las por meio do método `get_response_info()` (`GetResponseInfo()` em C#).

Para os casos em que os anúncios falham ao carregar e apenas um erro está disponível, as informações de resposta estão disponíveis por meio de [`LoadAdError`](../reference/classes/LoadAdError.md).response_info (`LoadAdError.ResponseInfo` em C#).

=== "GDScript"

    ```gdscript
    func _on_interstitial_ad_paid(ad_value: AdValue) -> void:
        var response_info: ResponseInfo = ad_value.response_info
        print(response_info)
    
    func _on_interstitial_ad_failed_to_load(load_ad_error: LoadAdError) -> void:
        var response_info: ResponseInfo = load_ad_error.response_info
        print(response_info)
    ```

=== "C#"

    ```csharp
    private void OnInterstitialAdPaid(AdValue adValue)
    {
        ResponseInfo responseInfo = adValue.ResponseInfo;
        GD.Print(responseInfo);
    }
    
    private void OnInterstitialAdFailedToLoad(LoadAdError loadAdError)
    {
        ResponseInfo responseInfo = loadAdError.ResponseInfo;
        GD.Print(responseInfo);
    }
    ```


## Response Info (Informações de Resposta)

Aqui estão dados de exemplo (representação JSON) retornados para um anúncio carregado:

```json
{
  "response_id": "COOllLGxlPoCFdAx4Aod-Q4A0g",
  "mediation_adapter_class_name": "com.google.ads.mediation.admob.AdMobAdapter",
  "adapter_responses": {
    "0": {
      "adapter_class_name": "com.google.ads.mediation.admob.AdMobAdapter",
      "latency_millis": 328,
      "ad_source_name": "Reservation campaign",
      "ad_source_id": "7068401028668408324",
      "ad_source_instance_name": "[DO NOT EDIT] Publisher Test Interstitial",
      "ad_source_instance_id": "4665218928925097",
      "ad_unit_mapping": {},
      "ad_error": {}
    }
  },
  "loaded_adapter_response_info": {
    "adapter_class_name": "com.google.ads.mediation.admob.AdMobAdapter",
    "latency_millis": 328,
    "ad_source_name": "Reservation campaign",
    "ad_source_id": "7068401028668408324",
    "ad_source_instance_name": "[DO NOT EDIT] Publisher Test Interstitial",
    "ad_source_instance_id": "4665218928925097",
    "ad_unit_mapping": {},
    "ad_error": {}
  },
  "response_extras": {
    "mediation_group_name": "Campaign"
  }
}
```

As propriedades e métodos no objeto [`ResponseInfo`](../reference/classes/ResponseInfo.md) incluem o seguinte:

| Property | Description |
| -------- | ----------- |
| `adapter_responses` (`AdapterResponses`) | Retorna a lista de [`AdapterResponseInfo`](../reference/classes/AdapterResponseInfo.md) contendo metadados para cada adaptador incluído na resposta do anúncio. Pode ser usado para depurar a execução de mediação em cascata (waterfall) e de lances (bidding). A ordem da lista corresponde à ordem da cascata de mediação para esta solicitação de anúncio. Consulte [Informações de resposta do adaptador](#informacoes-de-resposta-do-adaptador) para obter mais informações. |
| `loaded_adapter_response_info` (`LoadedAdapterResponseInfo`) | Retorna o [`AdapterResponseInfo`](../reference/classes/AdapterResponseInfo.md) correspondente ao adaptador que carregou o anúncio. |
| `mediation_adapter_class_name` (`MediationAdapterClassName`) | Retorna o nome da classe do adaptador de mediação da origem do anúncio que carregou o anúncio. |
| `response_id` (`ResponseId`) | O identificador de resposta é um identificador exclusivo para a resposta do anúncio. Esse identificador pode ser usado para identificar e bloquear o anúncio na Central de Revisão de Anúncios (ARC). |
| `response_extras` (`ResponseExtras`) | Retorna informações extras sobre a resposta do anúncio. Os extras podem retornar as seguintes chaves: <br> - `mediation_group_name`: O nome del grupo de mediação <br> - `mediation_ab_test_name`: O nome do teste A/B de mediação, se aplicável <br> - `mediation_ab_test_variant`: A variante usada no teste A/B de mediação, se aplicável |

=== "GDScript"

    ```gdscript
    func _on_interstitial_ad_paid(ad_value: AdValue) -> void:
        var response_info := interstitial_ad.get_response_info()
    
        var response_id: String = response_info.response_id
        var mediation_adapter_class_name: String = response_info.mediation_adapter_class_name
        var adapter_responses: Array[AdapterResponseInfo] = response_info.adapter_responses
        var loaded_adapter_response_info: AdapterResponseInfo = response_info.loaded_adapter_response_info
        var extras: Dictionary = response_info.response_extras
        
        var mediation_group_name = extras.get("mediation_group_name", "")
        var mediation_ab_test_name = extras.get("mediation_ab_test_name", "")
        var mediation_ab_test_variant = extras.get("mediation_ab_test_variant", "")
    ```

=== "C#"

    ```csharp
    private void OnInterstitialAdLoaded(InterstitialAd interstitialAd)
    {
        ResponseInfo responseInfo = interstitialAd.ResponseInfo;
    
        string responseId = responseInfo.ResponseId;
        string mediationAdapterClassName = responseInfo.MediationAdapterClassName;
        System.Collections.Generic.List<AdapterResponseInfo> adapterResponses = responseInfo.AdapterResponses;
        AdapterResponseInfo loadedAdapterResponseInfo = responseInfo.LoadedAdapterResponseInfo;
        Godot.Collections.Dictionary extras = responseInfo.ResponseExtras;
        
        string mediationGroupName = extras.ContainsKey("mediation_group_name") ? extras["mediation_group_name"].ToString() : "";
        string mediationABTestName = extras.ContainsKey("mediation_ab_test_name") ? extras["mediation_ab_test_name"].ToString() : "";
        string mediationABTestVariant = extras.ContainsKey("mediation_ab_test_variant") ? extras["mediation_ab_test_variant"].ToString() : "";
    }
    ```

## Informações de resposta do adaptador

[`AdapterResponseInfo`](../reference/classes/AdapterResponseInfo.md) contém informações de resposta para uma origem de anúncio individual em uma resposta de anúncio.

A seguinte saída de exemplo do `AdapterResponseInfo` mostra os metadados de um anúncio carregado:

```json
{
  "adapter_class_name": "com.google.ads.mediation.admob.AdMobAdapter",
  "latency_millis": 328,
  "ad_source_name": "Reservation campaign",
  "ad_source_id": "7068401028668408324",
  "ad_source_instance_name": "[DO NOT EDIT] Publisher Test Interstitial",
  "ad_source_instance_id": "4665218928925097",
  "ad_unit_mapping": {},
  "ad_error": {}
}
```

Para cada origem de anúncio, o [`AdapterResponseInfo`](../reference/classes/AdapterResponseInfo.md) fornece as seguintes propriedades:

| Property | Description |
| -------- | ----------- |
| `ad_error` ([`AdError`](../reference/classes/AdError.md)) | Obtém o erro associado à solicitação para a origem do anúncio. Retorna `null` se a origem do anúncio carregou um anúncio com sucesso ou se a origem do anúncio não foi tentada. |
| `ad_source_id` (`AdSourceId`) | Obtém o ID da origem do anúncio associado a esta resposta do adaptador. Para campanhas, `6060308706800320801` é retornado para um tipo de meta de campanha de anúncios mediados, e `7068401028668408324` é retornado para tipos de metas de impressão e clique. |
| `ad_source_instance_id` (`AdSourceInstanceId`) | Obtém o ID da instância da origem do anúncio associado a esta resposta do adaptador. |
| `ad_source_instance_name` (`AdSourceInstanceName`) | Obtém o nome da instância da origem do anúncio associado a esta resposta do adaptador. |
| `ad_source_name` (`AdSourceName`) | Obtém o nome da origem do anúncio associado a esta resposta do adaptador. Para campanhas, `Mediated House Ads` é retornado para um tipo de meta de campanha de anúncios mediados, e `Reservation Campaign` é retornado para tipos de metas de impressão e clique. |
| `adapter_class_name` (`AdapterClassName`) | Obtém o nome da classe do adaptador da origem do anúncio que carregou o anúncio. |
| `ad_unit_mapping` (`AdUnitMapping`) | Obtém as credenciais do adaptador da origem do anúncio especificadas na interface do usuário do AdMob. |
| `latency_millis` (`LatencyMillis`) | Obtém a quantidade de tempo que o adaptador da origem do anúncio gastou carregando um anúncio (em milissegundos). Retorna `0` se a origem do anúncio não foi tentada. |

=== "GDScript"

    ```gdscript
    func _on_interstitial_ad_paid(ad_value: AdValue) -> void:
        var loaded_adapter_response_info := interstitial_ad.get_response_info().loaded_adapter_response_info
    
        var ad_error: AdError = loaded_adapter_response_info.ad_error
        var ad_source_id: String = loaded_adapter_response_info.ad_source_id
        var ad_source_instance_id: String = loaded_adapter_response_info.ad_source_instance_id
        var ad_source_instance_name: String = loaded_adapter_response_info.ad_source_instance_name
        var ad_source_name: String = loaded_adapter_response_info.ad_source_name
        var adapter_class_name: String = loaded_adapter_response_info.adapter_class_name
        var ad_unit_mapping: Dictionary = loaded_adapter_response_info.ad_unit_mapping
        var latency_millis: int = loaded_adapter_response_info.latency_millis
    ```

=== "C#"

    ```csharp
    private void OnInterstitialAdPaid(AdValue adValue)
    {
        AdapterResponseInfo loadedAdapterResponseInfo = interstitialAd.GetResponseInfo().LoadedAdapterResponseInfo;
    
        AdError adError = loadedAdapterResponseInfo.AdError;
        string adSourceId = loadedAdapterResponseInfo.AdSourceId;
        string adSourceInstanceId = loadedAdapterResponseInfo.AdSourceInstanceId;
        string adSourceInstanceName = loadedAdapterResponseInfo.AdSourceInstanceName;
        string adSourceName = loadedAdapterResponseInfo.AdSourceName;
        string adapterClassName = loadedAdapterResponseInfo.AdapterClassName;
        Godot.Collections.Dictionary adUnitMapping = loadedAdapterResponseInfo.AdUnitMapping;
        int latencyMillis = loadedAdapterResponseInfo.LatencyMillis;
    }
    ```
