# Empezar

Bajo Google[Política de consentimiento del usuario de la UE](https://www.google.com/about/company/user-consent-policy/), debe hacer ciertas divulgaciones a sus usuarios en el Espacio Económico Europeo (EEE) junto con el Reino Unido y obtener su consentimiento para usar cookies u otro almacenamiento local, cuando sea legalmente necesario, y para usar datos personales (como AdID) para publicar anuncios. Esta política refleja los requisitos de la Directiva de privacidad electrónica de la UE y el Reglamento general de protección de datos (GDPR).

Para ayudar a los editores a cumplir con sus obligaciones según esta política, Google ofrece el SDK de la plataforma de mensajería para el usuario (UMP). El SDK de UMP se ha actualizado para admitir los últimos estándares de IAB. Todas estas configuraciones ahora se pueden manejar cómodamente en privacidad y mensajería de AdMob.

Este documento se basa en:

- [Documentación de Android del SDK de anuncios de Google para móviles](https://developers.google.com/admob/android/privacy)
- [Documentación de iOS del SDK de anuncios de Google para móviles](https://developers.google.com/admob/ios/privacy)

## Requisitos previos

- Completa el[Guía de introducción](../../index.md)
- Si está trabajando en requisitos relacionados con GDPR, lea[Cómo afectan los requisitos de la IAB a los mensajes de consentimiento de la UE](https://support.google.com/admob/answer/10207733).

## Crear un tipo de mensaje
Cree mensajes de usuario con uno de los[tipos de mensajes de usuario disponibles](https://support.google.com/admob/answer/10114020)en la pestaña **Privacidad y mensajes** de tu cuenta de AdMob. El SDK de UMP intenta mostrar un mensaje de usuario creado a partir del ID de aplicación de AdMob establecido en su proyecto. Si no se configura ningún mensaje para su aplicación, el SDK devuelve un error.

Para más detalles, ver[Acerca de la privacidad y la mensajería](https://support.google.com/admob/answer/10107561).

## Determinar si es necesario mostrar un mensaje
Debe solicitar una actualización de la información de consentimiento del usuario en cada inicio de la aplicación, usando `update()` antes de cargar un formulario. Esto puede determinar si su usuario necesita o no dar su consentimiento si aún no lo ha hecho o si su consentimiento ha caducado.

Utilice la información almacenada en el objeto de información de consentimiento cuando[presentar el formulario](#present-form)cuando hace falta.

!!! advertencia
Se desaconseja encarecidamente el uso de formas alternativas de verificar el estado del consentimiento, como verificar el caché que utiliza su aplicación o buscar una cadena de consentimiento en el almacenamiento, ya que el conjunto de socios de tecnología publicitaria podría haber cambiado desde la última vez que el usuario dio su consentimiento.

A continuación se muestra un ejemplo de cómo verificar el estado al iniciar la aplicación:

=== "GDScript"

    ```gdscript
    extends Node
    
    func _ready():
    	var request := ConsentRequestParameters.new()
        # Set tag for underage of consent. false means users are not underage.
    	request.tag_for_under_age_of_consent = false
    	UserMessagingPlatform.consent_information.update(request, _on_consent_info_updated_success, _on_consent_info_updated_failure)
    
    func _on_consent_info_updated_success():
    	# The consent information state was updated.
    	# You are now ready to check if a form is available.
    	pass
    
    func _on_consent_info_updated_failure(form_error : FormError):
    	# Handle the error.
    	pass
    ```

=== "C#"

    ```csharp
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Ump.Api;
    using PoingStudios.AdMob.Ump.Core;
    
    public partial class UmpExample : Node
    {
        public override void _Ready()
        {
            var request = new ConsentRequestParameters();
            // Set tag for underage of consent. false means users are not underage.
            request.TagForUnderAgeOfConsent = false;
            UserMessagingPlatform.ConsentInformation.Update(request, OnConsentInfoUpdatedSuccess, OnConsentInfoUpdatedFailure);
        }
    
        private void OnConsentInfoUpdatedSuccess()
        {
            // The consent information state was updated.
            // You are now ready to check if a form is available.
        }
    
        private void OnConsentInfoUpdatedFailure(FormError formError)
        {
            // Handle the error.
        }
    }
    ```

<span id="load-a-form-if-available"></span>
## Cargar un formulario si está disponible

Antes de mostrar un formulario, primero debe determinar si hay uno disponible. Los formularios no disponibles pueden deberse a que el usuario ha habilitado el seguimiento de anuncios limitado o si lo ha etiquetado como menor de edad de consentimiento.

Para verificar la disponibilidad de un formulario, use la función `get_is_consent_form_available()` en la instancia estática `consent_information` de la clase `UserMessagingPlatform`.

Luego, agregue una función contenedora para cargar el formulario:

=== "GDScript"

    ```gdscript
    #...
    func _on_consent_info_updated_success():
    	# The consent information state was updated.
    	# You are now ready to check if a form is available.
    	if UserMessagingPlatform.consent_information.get_is_consent_form_available():
    		load_form()
    
    func _on_consent_info_updated_failure(form_error : FormError):
    	# Handle the error.
    	pass
    
    func load_form():
    	pass
    ```

=== "C#"

    ```csharp
    //...
    private void OnConsentInfoUpdatedSuccess()
    {
        // The consent information state was updated.
        // You are now ready to check if a form is available.
        if (UserMessagingPlatform.ConsentInformation.GetIsConsentFormAvailable())
            LoadForm();
    }
    
    private void OnConsentInfoUpdatedFailure(FormError formError)
    {
        // Handle the error.
    }
    
    private void LoadForm()
    {
    }
    ```

Para cargar el formulario, utilice la función estática `load_consent_form()` en la clase `UserMessagingPlatform`.

=== "GDScript"

    ```gdscript
    var _consent_form : ConsentForm
    
    func load_form():
    	UserMessagingPlatform.load_consent_form(_on_consent_form_load_success, _on_consent_form_load_failure)
    
    func _on_consent_form_load_success(consent_form : ConsentForm):
    	_consent_form = consent_form
    
    func _on_consent_form_load_failure(form_error : FormError):
    	# Handle the error.
    	pass
    ```

=== "C#"

    ```csharp
    private ConsentForm _consentForm;
    
    private void LoadForm()
    {
        UserMessagingPlatform.LoadConsentForm(OnConsentFormLoadSuccess, OnConsentFormLoadFailure);
    }
    
    private void OnConsentFormLoadSuccess(ConsentForm consentForm)
    {
        _consentForm = consentForm;
    }
    
    private void OnConsentFormLoadFailure(FormError formError)
    {
        // Handle the error.
    }
    ```

<span id="present-the-form-if-required"></span><span id="present-form"></span>
## Presentar el formulario si es necesario.
Una vez que haya determinado la disponibilidad del formulario y lo haya cargado, use la función `show()` en la instancia de ConsentForm para presentar el formulario.

Utilice la instancia estática `consent_information` de la clase `UserMessagingPlatform` para verificar el estado del consentimiento y actualizar su función `load_form()`:

=== "GDScript"

    ```gdscript
    var _consent_form : ConsentForm
    
    func load_form():
    	UserMessagingPlatform.load_consent_form(_on_consent_form_load_success, _on_consent_form_load_failure)
    
    func _on_consent_form_load_success(consent_form : ConsentForm):
    	_consent_form = consent_form
    	if UserMessagingPlatform.consent_information.get_consent_status() == UserMessagingPlatform.consent_information.ConsentStatus.REQUIRED:
    		consent_form.show(_on_consent_form_dismissed)
    
    func _on_consent_form_load_failure(form_error : FormError):
    	# Handle the error.
    	pass
    
    func _on_consent_form_dismissed(form_error : FormError):
    	if UserMessagingPlatform.consent_information.get_consent_status() == UserMessagingPlatform.consent_information.ConsentStatus.OBTAINED:
    		# App can start requesting ads.
    		pass
    	# Handle dismissal by reloading form
    	load_form()
    ```

=== "C#"

    ```csharp
    private ConsentForm _consentForm;
    
    private void LoadForm()
    {
        UserMessagingPlatform.LoadConsentForm(OnConsentFormLoadSuccess, OnConsentFormLoadFailure);
    }
    
    private void OnConsentFormLoadSuccess(ConsentForm consentForm)
    {
        _consentForm = consentForm;
        if (UserMessagingPlatform.ConsentInformation.GetConsentStatus() == ConsentStatus.Values.Required)
            consentForm.Show(OnConsentFormDismissed);
    }
    
    private void OnConsentFormLoadFailure(FormError formError)
    {
        // Handle the error.
    }
    
    private void OnConsentFormDismissed(FormError formError)
    {
        if (UserMessagingPlatform.ConsentInformation.GetConsentStatus() == ConsentStatus.Values.Obtained)
        {
            // App can start requesting ads.
        }
        // Handle dismissal by reloading form
        LoadForm();
    }
    ```

Si necesita realizar alguna acción después de que el usuario haya elegido o haya descartado el formulario, coloque esa lógica en el controlador de finalización o devolución de llamada de su formulario.

## Pruebas

### Forzar una geografía

El SDK de UMP proporciona una manera de probar el comportamiento de su aplicación como si el dispositivo estuviera ubicado en el EEE o el Reino Unido usando la propiedad `debug_geography` en `ConsentDebugSettings`.

Debes proporcionar el ID hash de tu dispositivo de prueba en la configuración de depuración de tu aplicación para utilizar la funcionalidad de depuración. Si llama a `UserMessagingPlatform.consent_information.update()` sin establecer este valor, su aplicación registra el hash de ID requerido cuando se ejecuta.

=== "GDScript"

    ```gdscript
    extends Node
    
    func _ready():
    	var request := ConsentRequestParameters.new()
    	var consent_debug_settings := ConsentDebugSettings.new()
    	consent_debug_settings.debug_geography = DebugGeography.Values.EEA
    	consent_debug_settings.test_device_hashed_ids.append("test_device_hashed_id")
    	request.consent_debug_settings = consent_debug_settings
    	
    	UserMessagingPlatform.consent_information.update(request, _on_consent_info_updated_success, _on_consent_info_updated_failure)
    
    func _on_consent_info_updated_success():
    	# The consent information state was updated.
    	# You are now ready to check if a form is available.
    	pass
    
    func _on_consent_info_updated_failure(form_error : FormError):
    	# Handle the error.
    	pass
    ```

=== "C#"

    ```csharp
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Ump.Api;
    using PoingStudios.AdMob.Ump.Core;
    
    public partial class UmpExample : Node
    {
        public override void _Ready()
        {
            var request = new ConsentRequestParameters();
            var consentDebugSettings = new ConsentDebugSettings();
            consentDebugSettings.DebugGeography = DebugGeography.Eea;
            consentDebugSettings.TestDeviceHashedIds.Add("test_device_hashed_id");
            request.ConsentDebugSettings = consentDebugSettings;
            
            UserMessagingPlatform.ConsentInformation.Update(request, OnConsentInfoUpdatedSuccess, OnConsentInfoUpdatedFailure);
        }
    
        private void OnConsentInfoUpdatedSuccess()
        {
            // The consent information state was updated.
            // You are now ready to check if a form is available.
        }
    
        private void OnConsentInfoUpdatedFailure(FormError formError)
        {
            // Handle the error.
        }
    }
    ```

Con la enumeración `DebugGeography.Values`, tiene la opción de forzar la geografía a una de estas opciones:

 | DepuraciónGeografía | Descripción | 
 | ---------------- | -------------------------------------------------------- | 
 | DESACTIVADO | Geografía de depuración deshabilitada. | 
 | EEE | La geografía aparece como en EEE para los dispositivos de depuración. | 
 | NOT_EEA | La geografía aparece como no incluida en el EEE para los dispositivos de depuración. | 

Tenga en cuenta que la configuración de depuración solo funciona en dispositivos de prueba. No es necesario agregar los emuladores a la lista de ID de su dispositivo, ya que ya tienen las pruebas habilitadas de forma predeterminada.


### Restablecer el estado de consentimiento

Al probar su aplicación con el SDK de UMP, puede resultarle útil restablecer el estado del SDK para poder simular la primera experiencia de instalación de un usuario. El SDK proporciona la función `reset()` para hacer esto.

=== "GDScript"

    ```gdscript
    UserMessagingPlatform.consent_information.reset()
    ```

=== "C#"

    ```csharp
    UserMessagingPlatform.ConsentInformation.Reset();
    ```

También debe llamar a `reset()` si decide eliminar completamente el SDK de UMP de su proyecto.

!!! advertencia
Esta función está destinada a utilizarse únicamente con fines de prueba. No deberías llamar a `reset()` en el código de producción.
