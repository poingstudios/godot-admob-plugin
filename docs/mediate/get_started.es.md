# Empezar

La mediación de AdMob es una característica valiosa que le permite entregar anuncios a sus aplicaciones desde diversas fuentes. Estas fuentes abarcan la red AdMob, redes publicitarias de terceros y [Campañas de AdMob](https://support.google.com/admob/answer/6162747). El objetivo principal de la mediación de AdMob es optimizar su tasa de cumplimiento y mejorar sus esfuerzos de monetización. Lo logra dirigiendo las solicitudes de anuncios a múltiples redes, lo que garantiza que su aplicación utilice la red más adecuada disponible para publicar anuncios. Este enfoque se ejemplifica a través de un [estudio de caso](https://admob.google.com/home/resources/cookapps-grows-ad-revenue-86-times-with-admob-rewarded-ads-and-mediation/).

Esta guía completa sirve como recurso integral para integrar la mediación en su aplicación AdMob. Abarca métodos de integración en cascada y de ofertas, lo que le proporciona una referencia completa para optimizar su estrategia de publicación de anuncios.

!!! información
    
**Nota crucial**: antes de continuar con la configuración de mediación, es esencial asegurarse de que posee los permisos de cuenta necesarios. Estos permisos abarcan el acceso a la gestión de inventario, el acceso a aplicaciones y funciones de privacidad y mensajería. Para obtener más detalles, consulte el artículo [Nuevos roles de usuario](https://support.google.com/admob/answer/2784628).
- Antes de integrar la mediación para un formato de anuncio específico, primero debe integrar ese formato de anuncio en su aplicación. Estos formatos de anuncios incluyen:
    - [Anuncios publicitarios](../ad_formats/banner/get_started.md)
    - [Anuncios intersticiales](../ad_formats/interstitial.md)
    - [Anuncios recompensados](../ad_formats/rewarded.md)
    - [Anuncios intersticiales recompensados](../ad_formats/rewarded_interstitial.md)

Si es nuevo en la mediación, es recomendable revisar la[Descripción general de la mediación de AdMob](https://support.google.com/admob/answer/13420272)para una mejor comprensión del concepto.

Este documento se basa en:

- [Documentación de Android del SDK de anuncios de Google para móviles](https://developers.google.com/admob/android/mediate)
- [Documentación de iOS del SDK de anuncios de Google para móviles](https://developers.google.com/admob/ios/mediate)

## Inicializar el SDK de anuncios para móviles

La guía de inicio rápido proporciona instrucciones sobre cómo[inicializar el SDK de anuncios para móviles](../index.md#initialize-the-google-mobile-ads-sdk). Durante este proceso de inicialización, también se inicializan los adaptadores de mediación y oferta. Es fundamental esperar a que se complete esta inicialización antes de cargar anuncios para garantizar que todas las redes publicitarias participen plenamente en la primera solicitud de anuncio.

El siguiente código de muestra demuestra cómo puede verificar el estado de inicialización de cada adaptador antes de iniciar una solicitud de anuncio.


=== "GDScript"

    ```gdscript
    extends Control
    
    func _ready() -> void:
    	var on_initialization_complete_listener := OnInitializationCompleteListener.new()
    	on_initialization_complete_listener.on_initialization_complete = _on_initialization_complete
    	MobileAds.initialize(on_initialization_complete_listener)
    	
    func _on_initialization_complete(initialization_status : InitializationStatus) -> void:
    	print("MobileAds initialization complete")
    	for key in initialization_status.adapter_status_map:
    		var adapterStatus : AdapterStatus = initialization_status.adapter_status_map[key]
    		prints(
    			"Key:", key, 
    			"Latency:", adapterStatus.latency, 
    			"Initialization Status:", adapterStatus.initialization_status, 
    			"Description:", adapterStatus.description
    		)
    		
    ```

=== "C#"

    ```csharp
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Listeners;
    using PoingStudios.AdMob.Api.Core;
    
    public partial class MediationExample : Control
    {
        public override void _Ready()
        {
            var onInitializationCompleteListener = new OnInitializationCompleteListener
            {
                OnInitializationComplete = OnInitializationComplete
            };
            MobileAds.Initialize(onInitializationCompleteListener);
        }
    
        private void OnInitializationComplete(InitializationStatus initializationStatus)
        {
            GD.Print("MobileAds initialization complete");
            foreach (var kvp in initializationStatus.AdapterStatusMap)
            {
                string key = kvp.Key;
                AdapterStatus adapterStatus = kvp.Value;
                GD.Print(
                    "Key: ", key, 
                    " Latency: ", adapterStatus.Latency, 
                    " Initialization Status: ", adapterStatus.State, 
                    " Description: ", adapterStatus.Description
                );
            }
        }
    }
    ```

## Mediación de anuncios publicitarios
Al utilizar anuncios de banner en la mediación de AdMob, es esencial inhabilitar la configuración de actualización en las interfaces de usuario de todas las redes publicitarias de terceros para los bloques de anuncios de banner que está utilizando en la mediación. Esta acción evita que se produzcan actualizaciones dobles, ya que AdMob también activa una actualización basada en la frecuencia de actualización predefinida del bloque de anuncios de banner.

## Mediación de anuncios bonificados
Le recomendamos encarecidamente que personalice todos los valores de recompensa predeterminados configurándolos en la interfaz de usuario de AdMob. Para lograr esto, seleccione la opción **Aplicar a todas las redes en grupos de mediación** para garantizar que la recompensa permanezca uniforme en todas las redes. Tenga en cuenta que es posible que determinadas redes publicitarias no proporcionen un valor o tipo de recompensa. Al anular el valor de la recompensa, garantiza una recompensa constante, independientemente de la red publicitaria responsable de publicar el anuncio.
![apply_all_networks](https://developers.google.com/static/admob/images/mediation/admob_apply_all_networks.png)

Para obtener más información sobre cómo configurar valores de recompensa en la interfaz de usuario de AdMob, consulte crear un bloque de anuncios recompensados.

Para obtener detalles completos sobre cómo establecer valores de recompensa en la interfaz de usuario de AdMob, consulte la[Crear un bloque de anuncios recompensados](https://support.google.com/admob/answer/7311747)documentación.


## CCPA y RGPD

!!! advertencia
    
**Nota fundamental**: antes de continuar con la configuración de Consentimiento de la UE, GDPR, CCPA y Plataforma de mensajería de usuario, es fundamental asegurarse de tener el permiso de administración de cuenta necesario. Estos permisos son esenciales para administrar la configuración relacionada con la privacidad. Para obtener más información, consulte el artículo [Nuevos roles de usuario](https://support.google.com/admob/answer/2784628).
Si su aplicación necesita cumplir con la [Ley de Privacidad del Consumidor de California (CCPA)](https://support.google.com/admob/answer/9561022) o el [Reglamento General de Protección de Datos (GDPR)](https://support.google.com/admob/answer/7666366), siga los pasos descritos en la configuración de CCPA o GDPR para incluir a sus socios de mediación en la lista de socios publicitarios [CCPA](https://support.google.com/admob/answer/10860309) o [RGPD](https://support.google.com/admob/answer/10113004#adding_ad_partners_to_published_gdpr_messages) de Privacidad y mensajería de AdMob. De lo contrario, es posible que sus socios no puedan publicar anuncios en su aplicación.

Para adquirir más conocimientos, explore el proceso de [permitir el procesamiento de datos restringido por la CCPA](../privacy/regulatory_solutions/us_states_privacy_laws.md) y [obtener el consentimiento del RGPD mediante el SDK de la plataforma de mensajería de usuario de Google (UMP)](../privacy/user_messaging_tools/get_started.md).
