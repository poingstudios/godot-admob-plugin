---
name: godot-admob-privacy
description: Provides instructions to configure user consent (UMP Flow), GDPR compliance, COPPA (child-directed treatment), CCPA, and request targeting options in GDScript and C#. Use when handling regulatory privacy or user targeting settings.
metadata:
  version: 1.0.0
  category: GodotAdMob
---
# Godot AdMob - Privacy & Targeting

Assists with configuring user consent (UMP SDK), GDPR, child-directed settings (COPPA), and ad content filtering in Godot 4.x.

## Privacy Workflows

1.  **Configure Request Targeting (COPPA/CCPA)**:
    *   Set `tag_for_child_directed_treatment` to indicate whether the request is child-directed.
    *   Set `tag_for_under_age_of_consent` for users under the age of consent.
    *   Filter ads by content rating using `max_ad_content_rating`.
2.  **Request User Consent (UMP SDK)**:
    *   Configure `ConsentRequestParameters` (with optional debugging geography).
    *   Call `ConsentInformation.request_consent_info_update()`.
    *   If required, call `ConsentForm.load_and_show_consent_form_if_required()`.

### Code Examples

=== "GDScript"

    ```gdscript
    func configure_privacy_and_targeting() -> void:
    	var request_config := RequestConfiguration.new()
    	
    	# COPPA compliance
    	request_config.tag_for_child_directed_treatment = RequestConfiguration.TAG_FOR_CHILD_DIRECTED_TREATMENT_TRUE
    	
    	# GDPR compliance for under-age of consent
    	request_config.tag_for_under_age_of_consent = RequestConfiguration.TAG_FOR_UNDER_AGE_OF_CONSENT_TRUE
    	
    	# Limit ad content ratings (G, PG, T, MA)
    	request_config.max_ad_content_rating = RequestConfiguration.MAX_AD_CONTENT_RATING_G
    	
    	MobileAds.set_request_configuration(request_config)
    ```

=== "C#"

    ```csharp
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api;

    public void ConfigurePrivacyAndTargeting()
    {
        var requestConfig = new RequestConfiguration();
        
        // COPPA compliance
        requestConfig.TagForChildDirectedTreatment = RequestConfiguration.TagForChildDirectedTreatmentTrue;
        
        // GDPR compliance for under-age of consent
        requestConfig.TagForUnderAgeOfConsent = RequestConfiguration.TagForUnderAgeOfConsentTrue;
        
        // Limit ad content ratings
        requestConfig.MaxAdContentRating = RequestConfiguration.MAX_AD_CONTENT_RATING_G;
        
        MobileAds.SetRequestConfiguration(requestConfig);
    }
    ```
