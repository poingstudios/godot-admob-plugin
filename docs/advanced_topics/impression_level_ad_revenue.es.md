# Ingresos publicitarios a nivel de impresión

Cuando se produce una impresión, el complemento Godot AdMob proporciona datos de ingresos publicitarios asociados con esa impresión. Puede utilizar los datos para calcular el valor de vida de un usuario o reenviar los datos a otros sistemas relevantes.

Esta guía está destinada a ayudarle a implementar la captura de datos de ingresos publicitarios a nivel de impresiones en su proyecto Godot.

## Requisitos previos
- Asegúrese de haber [activado la función de ingresos por publicidad a nivel de impresión](https://support.google.com/admob/answer/11322405) en la interfaz de usuario de AdMob.
- Completa la [Guía de introducción](../index.md). Su proyecto Godot ya debería tener el complemento AdMob de Poing Studios importado y configurado.
- Antes de poder recibir datos de ingresos publicitarios a nivel de impresiones, debe implementar al menos un formato de anuncio:
    - [App Open](../ad_formats/app_open.md)
    - [Banner](../ad_formats/banner/get_started.md)
    - [Intersticial](../ad_formats/interstitial.md)
    - [Recompensado](../ad_formats/rewarded.md)
    - [Intersticial Recompensado](../ad_formats/rewarded_interstitial.md)
    - [Native Overlay](../ad_formats/native_overlay.md)

## Implementación de un controlador de eventos pago

Cada formato de anuncio tiene un evento `on_ad_paid` (`OnAdPaid` en C#). Durante el ciclo de vida de un evento publicitario, el complemento Godot AdMob monitorea los eventos de impresión e invoca al controlador con un `AdValue` que representa el valor ganado.

El siguiente ejemplo maneja eventos pagos para un anuncio recompensado:

=== "GDScript"

    ```gdscript
    var _rewarded_ad: RewardedAd

    func _load_rewarded_ad() -> void:
        # Envía la solicitud para cargar el anuncio.
        var ad_request := AdRequest.new()
        RewardedAdLoader.new().load("AD_UNIT_ID", ad_request, func(rewarded_ad: RewardedAd, error: LoadAdError):
            # Si la operación falló con una razón.
            if error != null:
                push_error("Rewarded ad failed to load an ad with error: %s" % error.message)
                return
            
            _rewarded_ad = rewarded_ad
            _rewarded_ad.on_ad_paid = _handle_ad_paid_event
        )

    func _handle_ad_paid_event(ad_value: AdValue) -> void:
        # TODO: Envíe la información de ingresos publicitarios a nivel de impresión a su
        # servidor de análisis preferido directamente dentro de esta devolución de llamada.

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
        // Envía la solicitud para cargar el anuncio.
        AdRequest adRequest = new AdRequest();
        RewardedAdLoader.Load("AD_UNIT_ID", adRequest, (rewardedAd, error) =>
        {
            // Si la operación falló con una razón.
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
        // TODO: Envíe la información de ingresos publicitarios a nivel de impresión a su
        // servidor de análisis preferido directamente dentro de esta devolución de llamada.

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

## Identificar el nombre de una fuente de anuncio de evento personalizado

Para fuentes de anuncios de eventos personalizados, la propiedad `ad_source_name` (`AdSourceName`) le proporciona el nombre de la fuente de anuncios Evento personalizado. Si utiliza varios eventos personalizados, el nombre de la fuente de anuncios no es lo suficientemente detallado para distinguir entre varios eventos personalizados. Para localizar un evento personalizado específico, realice los siguientes pasos:

1. Obtenga la propiedad `adapter_class_name` (`AdapterClassName`).
2. Establezca un nombre de fuente de anuncios único.

El siguiente ejemplo establece un nombre de fuente de anuncios único para un evento personalizado:

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

Para obtener más información sobre la fuente publicitaria ganadora, consulte [Recuperar información sobre la respuesta al anuncio](response_info.md).

## Integre con socios de atribución de aplicaciones (AAP)

Para obtener detalles completos sobre cómo reenviar datos de ingresos publicitarios a plataformas de análisis, consulte la guía para socios:

- [Adjust](https://dev.adjust.com/en/sdk/android/integrations/admob)
- [AppsFlyer](https://support.appsflyer.com/hc/en-us/articles/4416353506833-Integrate-the-ROI360-ad-revenue-SDK-API)
- [Singular](https://support.singular.net/hc/en-us/articles/360037635452-Unity-SDK-Basic-Integration#42_Adding_Ad_Revenue_Attribution_Support)
- [Tenjin](https://tenjin.com/docs/en/send-events/android.html#impression-level-ad-revenue-integration)

## Mejores prácticas de implementación

- Configure el evento `on_ad_paid` (`OnAdPaid`) inmediatamente una vez que cree u obtenga acceso al objeto publicitario, y definitivamente antes de mostrar el anuncio. Esto asegura que no se pierda ninguna devolución de llamada.
- Envíe la información de ingresos publicitarios a nivel de impresión a su servidor de análisis preferido inmediatamente en su controlador `on_ad_paid`. Esto garantiza que no se pierda ninguna devolución de llamada accidentalmente y evita discrepancias en los datos.

## Valor publicitario

!!! tip "Punto clave"
    El valor de `AdValue` es un microvalor que representa el valor de cada anuncio. Por ejemplo, un valor de 5,000 indica que se estima que este anuncio vale $0.005.

| `AdValue.PrecisionType` | Descripción |
|---|---|
| `UNKNOWN` | Un valor publicitario con precisión desconocida. |
| `ESTIMATED` | Un valor de anuncio estimado a partir de datos agregados. |
| `PUBLISHER_PROVIDED` | Un valor de anuncio proporcionado por el editor, como CPM manuales en un grupo de mediación. |
| `PRECISE` | El valor exacto pagado por este anuncio. |

En caso de mediación, AdMob intenta proporcionar un valor `ESTIMATED` para las fuentes publicitarias que son [optimizadas](https://support.google.com/admob/answer/7374110). Para fuentes de anuncios no optimizadas, o en los casos en los que no hay suficientes datos agregados para informar una estimación significativa, se devuelve el valor `PUBLISHER_PROVIDED`.

## Impresiones de prueba de fuentes publicitarias ofertantes

Después de que se produzca un evento de ingresos publicitarios a nivel de impresión para una fuente publicitaria postora a través de una solicitud de prueba, recibirá solo los siguientes valores:

- `UNKNOWN`: indica el tipo de precisión.
- `0`: indica el valor del anuncio.

Anteriormente, es posible que haya visto el tipo de precisión como un valor distinto de `UNKNOWN` y un valor de anuncio superior a 0.

Para obtener detalles sobre cómo enviar una solicitud de anuncio de prueba, consulte [Habilitar dispositivos de prueba](../enable_test_ads.md).
