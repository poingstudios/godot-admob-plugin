# MobileAds

The `MobileAds` class provides global configurations and initialization entry points for the Google Mobile Ads SDK.

## Static Methods

### `initialize` / `Initialize`

Initializes the Google Mobile Ads SDK. Takes an optional [`OnInitializationCompleteListener`](../listeners/OnInitializationCompleteListener.md) to be notified when initialization finishes.

=== "GDScript"
    ```gdscript
    static func initialize(on_initialization_complete_listener: OnInitializationCompleteListener = null) -> void
    ```

    **Usage:**
    ```gdscript
    func _ready() -> void:
        var listener := OnInitializationCompleteListener.new()
        listener.on_initialization_complete = func(status: InitializationStatus):
            print("SDK Initialized!")
        MobileAds.initialize(listener)
    ```

=== "C#"
    ```csharp
    public static void Initialize(OnInitializationCompleteListener listener = null)
    ```

    **Usage:**
    ```csharp
    public override void _Ready()
    {
        OnInitializationCompleteListener listener = new OnInitializationCompleteListener();
        listener.OnInitializationComplete = (status) => {
            GD.Print("SDK Initialized!");
        };
        MobileAds.Initialize(listener);
    }
    ```

---

### `set_request_configuration` / `SetRequestConfiguration`

Sets global request configurations (such as test device IDs and targeting restrictions) applied to every ad request.

=== "GDScript"
    ```gdscript
    static func set_request_configuration(request_configuration: RequestConfiguration) -> void
    ```

=== "C#"
    ```csharp
    public static void SetRequestConfiguration(RequestConfiguration config)
    ```

---

### `get_initialization_status` / `GetInitializationStatus`

Returns the initialization status of the SDK and its mediation adapters.

=== "GDScript"
    ```gdscript
    static func get_initialization_status() -> InitializationStatus
    ```

=== "C#"
    ```csharp
    public static InitializationStatus GetInitializationStatus()
    ```

---

### `set_ios_app_pause_on_background` / `SetIosAppPauseOnBackground`

*(iOS Only)* Sets whether the iOS application should pause when running in the background.

=== "GDScript"
    ```gdscript
    static func set_ios_app_pause_on_background(pause: bool) -> void
    ```

=== "C#"
    ```csharp
    public static void SetIosAppPauseOnBackground(bool pause)
    ```

---

### `set_app_volume` / `SetAppVolume`

Sets the global audio volume for all ads (from `0.0` to `1.0`).

=== "GDScript"
    ```gdscript
    static func set_app_volume(volume: float) -> void
    ```

=== "C#"
    ```csharp
    public static void SetAppVolume(float volume)
    ```

---

### `set_app_muted` / `SetAppMuted`

Mutes or unmutes all ads globally.

=== "GDScript"
    ```gdscript
    static func set_app_muted(muted: bool) -> void
    ```

=== "C#"
    ```csharp
    public static void SetAppMuted(bool muted)
    ```

---

### `set_publisher_first_party_id_enabled` / `SetPublisherFirstPartyIDEnabled`

Enables or disables publisher first-party ID.

=== "GDScript"
    ```gdscript
    static func set_publisher_first_party_id_enabled(enabled: bool) -> void
    ```

=== "C#"
    ```csharp
    public static void SetPublisherFirstPartyIDEnabled(bool enabled)
    ```

---

### `set_gad_has_consent_for_cookies` / `SetGadHasConsentForCookies`

Informs the SDK whether the user has consented to cookies usage.

=== "GDScript"
    ```gdscript
    static func set_gad_has_consent_for_cookies(enabled: bool) -> void
    ```

=== "C#"
    ```csharp
    public static void SetGadHasConsentForCookies(bool enabled)
    ```

---

### `get_gad_has_consent_for_cookies` / `GetGadHasConsentForCookies`

Returns whether consent for cookies has been declared.

=== "GDScript"
    ```gdscript
    static func get_gad_has_consent_for_cookies() -> bool
    ```

=== "C#"
    ```csharp
    public static bool GetGadHasConsentForCookies()
    ```

---

### `disable_sdk_crash_reporting` / `DisableSdkCrashReporting`

*(iOS Only)* Disables the built-in crash reporting within the Google Mobile Ads SDK.

=== "GDScript"
    ```gdscript
    static func disable_sdk_crash_reporting() -> void
    ```

=== "C#"
    ```csharp
    public static void DisableSdkCrashReporting()
    ```

---

### `open_ad_inspector` / `OpenAdInspector`

Opens the in-app Ad Inspector overlay to verify ad sources and troubleshoot mediation. Takes an optional [`AdInspectorClosedListener`](../listeners/AdInspectorClosedListener.md) to be notified when the inspector is dismissed.

=== "GDScript"
    ```gdscript
    static func open_ad_inspector(ad_inspector_closed_listener: AdInspectorClosedListener = null) -> void
    ```

=== "C#"
    ```csharp
    public static void OpenAdInspector(AdInspectorClosedListener listener = null)
    ```

---

### `get_version` / `GetVersion`

Returns the Godot AdMob Editor Plugin version string.

=== "GDScript"
    ```gdscript
    static func get_version() -> String
    ```

=== "C#"
    ```csharp
    public static string GetVersion()
    ```

---

### `get_platform_version` / `GetPlatformVersion`

Returns the underlying native Mobile Ads SDK version (Android/iOS).

=== "GDScript"
    ```gdscript
    static func get_platform_version() -> String
    ```

=== "C#"
    ```csharp
    public static string GetPlatformVersion()
    ```
