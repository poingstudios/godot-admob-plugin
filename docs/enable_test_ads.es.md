# Habilitar anuncios de prueba
Esta guía proporciona instrucciones sobre cómo habilitar anuncios de prueba en su integración de anuncios. Es fundamental habilitar anuncios de prueba durante la fase de desarrollo para permitir hacer clic en ellos sin incurrir en cargos para los anunciantes de Google. Hacer clic en demasiados anuncios sin estar en modo de prueba puede provocar que su cuenta sea marcada por actividad no válida.

Para probar sus anuncios durante el desarrollo, puede:

1. **Vista previa de anuncios simulados en el editor**: pruebe la integración de sus anuncios y los diseños visuales directamente dentro del Editor Godot sin implementarlos en un dispositivo. Ver [Vista previa de anuncios simulados en el editor](editor_mock_ads.md).
2. **Utilice los bloques de anuncios de muestra de Google**: cargue anuncios de prueba en dispositivos físicos o simuladores/emuladores. Ver [Bloques de anuncios de muestra](#sample-ad-units).
3. **Habilitar dispositivos de prueba**: pruebe con sus propios bloques de anuncios de producción registrando sus dispositivos de prueba. Ver [Habilitar dispositivos de prueba](#enable-test-devices).

Este documento se basa en:

- [Documentación de Android del SDK de anuncios de Google para móviles](https://developers.google.com/admob/android/test-ads)
- [Documentación de iOS del SDK de anuncios de Google para móviles](https://developers.google.com/admob/ios/test-ads)

## Requisitos previos
- Completa la [Guía de introducción](index.md)

## Probando con el Editor Godot

Puede probar sus anuncios directamente dentro del editor Godot. El editor mostrará superposiciones de anuncios simulados, brindando una experiencia similar a cómo se comportarán los anuncios reales en una plataforma móvil.

<video autoplay loop muted playsinline>
  <source src="../assets/editor_test_ads.mp4" type="video/mp4">
  Su navegador no soporta la etiqueta de video.
</video>

!!! note
    Debido a que los anuncios simulados se implementan utilizando nodos Control de Godot, se renderizarán dentro de la ventana del juego en el editor. Sin embargo, cuando exporte a una plataforma móvil, el SDK oficial de Google Mobile Ads renderiza anuncios nativos sobre todas las vistas del juego.

Para obtener más información sobre el sistema de simulación, las plantillas visuales y las simulaciones de callbacks, consulte la guía [Vista previa de anuncios simulados en el editor](editor_mock_ads.md).

## Bloques de anuncios de muestra {: #sample-ad-units }

El método más conveniente para permitir las pruebas es emplear los bloques de anuncios de prueba proporcionados por Google. Estos bloques de anuncios están separados de su cuenta de AdMob, lo que garantiza que no haya riesgo de que su cuenta de generar tráfico no válido mientras los usa.

Tenga en cuenta que debe seleccionar el bloque de anuncios de prueba proporcionado por Google adecuado según la plataforma que esté probando. Utilice un bloque de anuncios de prueba de iOS para realizar solicitudes de anuncios de prueba en iOS y un bloque de anuncios de prueba de Android para realizar solicitudes en Android.

!!! warning "Advertencia"
    Antes de publicar su aplicación, asegúrese de reemplazar estos ID con su propio ID de bloque de anuncios. Si ya ha publicado su aplicación, [habilite los dispositivos de prueba](#enable-test-devices).
    A continuación se muestran bloques de anuncios de muestra para cada formato disponible tanto en Android como en iOS:

=== "Android"
=== "Android"
 | Formato de anuncio | ID de bloque de anuncios de muestra | 
 | ----------------------- | ---------------------------------------- | 
 | [App Open (Aplicación abierta)](ad_formats/app_open.md) | ca-app-pub-3940256099942544/9257395921 | 
 | [Banner adaptativo anclado](ad_formats/banner/get_started.md) | ca-app-pub-3940256099942544/9214589741 | 
 | [Banner adaptativo en línea](ad_formats/banner/get_started.md) | ca-app-pub-3940256099942544/9214589741 | 
 | [Banner de tamaño fijo](ad_formats/banner/get_started.md) | ca-app-pub-3940256099942544/6300978111 | 
 | [Intersticial](ad_formats/interstitial.md) | ca-app-pub-3940256099942544/1033173712 | 
 | [Anuncios recompensados](ad_formats/rewarded.md) | ca-app-pub-3940256099942544/5224354917 | 
 | [Intersticial Recompensado](ad_formats/rewarded_interstitial.md) | ca-app-pub-3940256099942544/5354046379 | 
 | [Nativo](ad_formats/native_overlay.md) | ca-app-pub-3940256099942544/2247696110 | 
 | [Video nativo](ad_formats/native_video.md) | ca-app-pub-3940256099942544/1044960115 | 

=== "iOS"

 | Formato de anuncio | ID de bloque de anuncios de muestra | 
 | ----------------------- | ---------------------------------------- | 
 | [App Open (Aplicación abierta)](ad_formats/app_open.md) | ca-app-pub-3940256099942544/5575463023 | 
 | [Banner adaptativo anclado](ad_formats/banner/get_started.md) | ca-app-pub-3940256099942544/2435281174 | 
 | [Banner adaptativo en línea](ad_formats/banner/get_started.md) | ca-app-pub-3940256099942544/2435281174 | 
 | [Banner de tamaño fijo](ad_formats/banner/get_started.md) | ca-app-pub-3940256099942544/2934735716 | 
 | [Intersticial](ad_formats/interstitial.md) | ca-app-pub-3940256099942544/4411468910 | 
 | [Anuncios recompensados](ad_formats/rewarded.md) | ca-app-pub-3940256099942544/1712485313 | 
 | [Intersticial Recompensado](ad_formats/rewarded_interstitial.md) | ca-app-pub-3940256099942544/6978759866 | 
 | [Nativo](ad_formats/native_overlay.md) | ca-app-pub-3940256099942544/3986624511 | 
 | [Video nativo](ad_formats/native_video.md) | ca-app-pub-3940256099942544/2521693316 | 

### Identificadores de pruebas especializados
Si bien los bloques de anuncios estándar anteriores se pueden usar agregando parámetros adicionales (como "contraíble"), los siguientes ID de bloques de anuncios especializados **garantizan** que se devuelven funciones específicas para probar su UI/UX:

 | Característica | Android | iOS | 
 | :--- | :--- | :--- | 
 | **Banners plegables** | `ca-app-pub-3940256099942544/2014213617` | `ca-app-pub-3940256099942544/8388050270` | 



## Habilitar dispositivos de prueba {: #enable-test-devices }
Para realizar pruebas más exhaustivas con anuncios similares a los de producción, puede configurar su dispositivo como dispositivo de prueba y utilizar sus propios ID de bloques de anuncios creados en la interfaz de usuario de AdMob. Puede agregar dispositivos de prueba a través de la interfaz de usuario de AdMob o mediante programación mediante el SDK de anuncios de Google para móviles.

Estos son los pasos para agregar su dispositivo como dispositivo de prueba:

!!! note

    **Nota importante**: Los emuladores de Android y los simuladores de iOS se configuran automáticamente como dispositivos de prueba. Esto significa que puede probar anuncios en estos dispositivos virtuales sin necesidad de agregarlos manualmente a su lista de dispositivos de prueba.

### Añade tu dispositivo de prueba en la interfaz de usuario de AdMob

Para utilizar un método sencillo y no programático para incluir un dispositivo de prueba y probar compilaciones de aplicaciones nuevas o existentes, puede utilizar la interfaz de usuario de AdMob. [Así es como](https://support.google.com/admob/answer/9691433).


!!! note

    **Nota importante**: Los dispositivos de prueba recién agregados generalmente comienzan a publicar anuncios de prueba en su aplicación en 15 minutos, aunque la configuración también puede demorar hasta 24 horas en surtir efecto.

### Agregue su dispositivo de prueba mediante programación

Si desea probar anuncios dentro de su aplicación durante la fase de desarrollo y desea registrar mediante programación su dispositivo de prueba, siga los pasos a continuación:


1. Abra su aplicación con anuncios integrados e inicie una solicitud de anuncio.
2. Verifique la salida de logcat para ver un mensaje similar al siguiente, que muestra la ID de su dispositivo y cómo agregarlo como dispositivo de prueba:

=== "Android"
        ```java
        I/Ads: Use RequestConfiguration.Builder.setTestDeviceIds(Arrays.asList("33BE2250B43518CCDA7DE426D04EE231")) 
        to get test ads on this device."
        ```

=== "iOS"

        ```swift
        <Google> To get test ads on this device, set:
        GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers =
        @[ @"2077ef9a63d2b398840261c8221a0c9b" ];
        ```
Copie la ID de su dispositivo de prueba en su portapapeles.

3. Actualice su código para incluir los ID de los dispositivos de prueba dentro de su matriz [`RequestConfiguration`](reference/classes/RequestConfiguration.md).test_device_ids de esta manera:

=== "GDScript"

    ```gdscript linenums="1" hl_lines="3 4"
    func _ready() -> void:
    	var request_configuration := RequestConfiguration.new()
    	request_configuration.test_device_ids = ["2077ef9a63d2b398840261c8221a0c9b"]
    	MobileAds.set_request_configuration(request_configuration)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="10 11"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    
    public partial class TestAdsExample : Node2D
    {
        public override void _Ready()
        {
            var requestConfiguration = new RequestConfiguration();
            requestConfiguration.TestDeviceIds.Add("2077ef9a63d2b398840261c8221a0c9b");
            MobileAds.SetRequestConfiguration(requestConfiguration);
        }
    }
    ```
!!! info
    Recuerde eliminar el código responsable de definir estos dispositivos de prueba antes de lanzar su aplicación.

4. Vuelva a iniciar su aplicación. Si el anuncio es de Google, observará una etiqueta **Anuncio de prueba** ubicada en la parte superior central del anuncio, ya sea un anuncio de banner, intersticial o de video recompensado:
![testad](https://developers.google.com/static/admob/images/android-testad-0-admob.png)

!!! info
    Tenga en cuenta que los anuncios mediados _NO_ muestran una etiqueta **Anuncio de prueba**. Consulte la sección siguiente para obtener más información.


### Pruebas con mediación

Los bloques de anuncios de muestra de Google muestran exclusivamente Google Ads. Para probar su configuración de mediación de manera efectiva, debe emplear el método de [habilitación de dispositivos de prueba](#enable-test-devices).

Los anuncios mediados NO exhiben una etiqueta de "Anuncio de prueba". En consecuencia, es su responsabilidad asegurarse de que los anuncios de prueba estén habilitados para cada una de sus redes de mediación para evitar que estas redes marquen su cuenta por actividad no válida. Consulte la información individual de cada red [guía de mediación](mediate/get_started.md) para obtener instrucciones detalladas.

Si no está seguro de si un adaptador de red de anuncios de mediación admite anuncios de prueba, es recomendable abstenerse de hacer clic en anuncios de esa red durante la fase de desarrollo. Puedes utilizar la propiedad [`ResponseInfo.mediation_adapter_class_name`](reference/classes/ResponseInfo.md#mediation_adapter_class_name) dentro de cualquiera de los formatos de anuncios para determinar qué red publicitaria publicó el anuncio actual.
