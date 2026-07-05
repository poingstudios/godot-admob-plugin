# Recuperar información sobre la respuesta al anuncio.

Para fines de depuración y registro, los anuncios cargados correctamente proporcionan un objeto [`ResponseInfo`](../reference/classes/ResponseInfo.md). Este objeto contiene información sobre el anuncio que cargó, además de información sobre la cascada de mediación utilizada para cargar el anuncio.

Para los casos en los que un anuncio se carga correctamente y se paga una impresión, la información de respuesta está disponible a través de la propiedad `AdValue.response_info` (`AdValue.ResponseInfo` en C#) devuelta por la devolución de llamada `on_ad_paid`. Además, específicamente para [`AppOpenAd`](../reference/classes/AppOpenAd.md), puede recuperarlo mediante el método `get_response_info()` (`GetResponseInfo()` en C#).

Para los casos en los que los anuncios no se cargan y solo hay un error disponible, la información de respuesta está disponible a través de [`LoadAdError`](../reference/classes/LoadAdError.md).response_info (`LoadAdError.ResponseInfo` en C#).

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


## Información de respuesta

A continuación se muestran datos de muestra (representación JSON) devueltos para un anuncio cargado:

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

Los métodos del objeto [`ResponseInfo`](../reference/classes/ResponseInfo.md) incluyen lo siguiente:

 | Propiedad | Descripción | 
 | -------- | ----------- | 
 | `adapter_responses` (`AdapterResponses`) | Devuelve la lista de [`AdapterResponseInfo`](../reference/classes/AdapterResponseInfo.md) que contiene metadatos para cada adaptador incluido en la respuesta del anuncio. Se puede utilizar para depurar la mediación en cascada y la ejecución de ofertas. El orden de la lista coincide con el orden de la cascada de mediación para esta solicitud de anuncio. Ver [Información de respuesta del adaptador](#adapter-response-info)para más información. | 
 | `loaded_adapter_response_info` (`LoadedAdapterResponseInfo`) | Devuelve el [`AdapterResponseInfo`](../reference/classes/AdapterResponseInfo.md) correspondiente al adaptador que cargó el anuncio. | 
 | `mediation_adapter_class_name` (`MediationAdapterClassName`) | Devuelve el nombre de clase del adaptador de mediación de la fuente de anuncios que cargó el anuncio. | 
 | `respuesta_id` (`RespuestaId`) | El identificador de respuesta es un identificador único para la respuesta del anuncio. Este identificador se puede utilizar para identificar y bloquear el anuncio en el Centro de revisión de anuncios (ARC). | 
 | `respuesta_extras` (`RespuestaExtras`) | Devuelve información adicional sobre la respuesta al anuncio. Los extras pueden devolver las siguientes claves: <br> - `mediation_group_name`: el nombre del grupo de mediación <br> - `mediation_ab_test_name`: el nombre de la prueba A/B de mediación, si corresponde <br> - `mediation_ab_test_variant`: la variante utilizada en la prueba A/B de mediación, si corresponde | 

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

## Información de respuesta del adaptador {: #adapter-response-info }

[`AdapterResponseInfo`](../reference/classes/AdapterResponseInfo.md) contiene información de respuesta para una fuente publicitaria individual en una respuesta publicitaria.

El siguiente ejemplo de salida `AdapterResponseInfo` muestra los metadatos de un anuncio cargado:

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

Para cada fuente publicitaria, [`AdapterResponseInfo`](../reference/classes/AdapterResponseInfo.md) proporciona las siguientes propiedades:

 | Propiedad | Descripción | 
 | -------- | ----------- | 
 | `ad_error` ([`AdError`](../reference/classes/AdError.md)) | Obtiene el error asociado con la solicitud al origen del anuncio. Devuelve "nulo" si la fuente del anuncio cargó correctamente un anuncio o si no se intentó cargar la fuente del anuncio. | 
 | `ad_source_id` (`AdSourceId`) | Obtiene el ID de la fuente de anuncios asociado con esta respuesta del adaptador. Para las campañas, se devuelve "6060308706800320801" para un tipo de objetivo de campaña de anuncios mediados y "7068401028668408324" para tipos de objetivos de impresión y clic. | 
 | `ad_source_instance_id` (`AdSourceInstanceId`) | Obtiene el ID de instancia de fuente de anuncios asociado con esta respuesta de adaptador. | 
 | `ad_source_instance_name` (`AdSourceInstanceName`) | Obtiene el nombre de la instancia de fuente de anuncios asociada con esta respuesta del adaptador. | 
 | `ad_source_name` (`AdSourceName`) | Obtiene el nombre de la fuente de anuncios asociado con esta respuesta del adaptador. Para las campañas, se devuelve "Anuncios internos mediados" para un tipo de objetivo de campaña de anuncios mediados, y "Campaña de reserva" se devuelve para tipos de objetivos de impresión y clic. | 
 | `adapter_class_name` (`AdapterClassName`) | Obtiene el nombre de clase del adaptador de fuente de anuncios que cargó el anuncio. | 
 | `ad_unit_mapping` (`AdUnitMapping`) | Obtiene las credenciales del adaptador de fuente de anuncios especificadas en la interfaz de usuario de AdMob. | 
 | `latencia_millis` (`LatenciaMillis`) | Obtiene la cantidad de tiempo que el adaptador de fuente de anuncios pasó cargando un anuncio (en milisegundos). Devuelve "0" si no se intentó acceder a la fuente del anuncio. | 

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
