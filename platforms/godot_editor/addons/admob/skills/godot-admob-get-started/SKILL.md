---
name: godot-admob-get-started
description: Provides instructions to initialize the Godot AdMob SDK and configure user consent (UMP Flow) in GDScript and C#. Use when setting up AdMob for the first time or requesting user consent.
metadata:
  version: 1.0.0
  category: GodotAdMob
---
# Godot AdMob - Get Started

Assists with initializing the Google Mobile Ads SDK and requesting user consent (GDPR/CCPA) using the User Messaging Platform (UMP) SDK in Godot 4.x (GDScript and C#).

## Initialization Workflow

1.  **Configure Consent Request Parameters**: Configure consent debug settings (like EEA geography) for testing if necessary.
2.  **Request Consent Update**: Call `ConsentInformation.request_consent_info_update()`.
3.  **Load and Show Form**: If consent is required, load and show the consent form.
4.  **Initialize SDK**: Once consent is obtained or not required, configure `RequestConfiguration` and initialize `MobileAds`.

### Code Examples

=== "GDScript"

    ```gdscript
    func request_user_consent() -> void:
    	var params := ConsentRequestParameters.new()
    	# Optional debug settings:
    	# var debug_settings := ConsentDebugSettings.new()
    	# debug_settings.debug_geography = ConsentDebugSettings.DebugGeography.EEA
    	# params.consent_debug_settings = debug_settings
    	
    	var on_update_listener := OnConsentInfoUpdateListener.new()
    	on_update_listener.on_consent_info_update_success = func() -> void:
    		if ConsentInformation.is_consent_form_available():
    			load_and_show_form()
    		else:
    			initialize_ads()
    			
    	on_update_listener.on_consent_info_update_failure = func(error: FormError) -> void:
    		initialize_ads()
    		
    	ConsentInformation.request_consent_info_update(params, on_update_listener)

    func load_and_show_form() -> void:
    	var on_dismissed_listener := OnConsentFormDismissedListener.new()
    	on_dismissed_listener.on_consent_form_dismissed = func(error: FormError) -> void:
    		initialize_ads()
    		
    	ConsentForm.load_and_show_consent_form_if_required(on_dismissed_listener)

    func initialize_ads() -> void:
    	var on_init_listener := OnInitializationCompleteListener.new()
    	on_init_listener.on_initialization_complete = func(status: InitializationStatus) -> void:
    		print("AdMob initialized!")
    		
    	var request_config := RequestConfiguration.new()
    	MobileAds.set_request_configuration(request_config)
    	MobileAds.initialize(on_init_listener)
    ```

=== "C#"

    ```csharp
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Listeners;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Ump;
    using PoingStudios.AdMob.Api.Ump.Listeners;
    using PoingStudios.AdMob.Api.Ump.Core;

    public void RequestUserConsent()
    {
        var @params = new ConsentRequestParameters();
        var onUpdateListener = new OnConsentInfoUpdateListener();
        onUpdateListener.OnConsentInfoUpdateSuccess = () => {
            if (ConsentInformation.IsConsentFormAvailable()) {
                LoadAndShowForm();
            } else {
                InitializeAds();
            }
        };
        onUpdateListener.OnConsentInfoUpdateFailure = (FormError error) => InitializeAds();
        ConsentInformation.RequestConsentInfoUpdate(@params, onUpdateListener);
    }

    private void LoadAndShowForm()
    {
        var onDismissedListener = new OnConsentFormDismissedListener();
        onDismissedListener.OnConsentFormDismissed = (FormError error) => InitializeAds();
        ConsentForm.LoadAndShowConsentFormIfRequired(onDismissedListener);
    }

    private void InitializeAds()
    {
        var onInitListener = new OnInitializationCompleteListener();
        onInitListener.OnInitializationComplete = (status) => GD.Print("AdMob initialized!");
        var requestConfig = new RequestConfiguration();
        MobileAds.SetRequestConfiguration(requestConfig);
        MobileAds.Initialize(onInitListener);
    }
    ```
