# MobileAds

La clase `MobileAds` proporciona configuraciones globales y puntos de entrada de inicialización para el SDK de Google Mobile Ads.

## Métodos Estáticos

### `initialize` / `Initialize`

Inicializa el SDK de Google Mobile Ads. Toma un [`OnInitializationCompleteListener`](../listeners/OnInitializationCompleteListener.md) opcional para ser notificado cuando finalice la inicialización.

=== "GDScript"
    ```gdscript
    static func initialize(on_initialization_complete_listener: OnInitializationCompleteListener = null) -> void
    ```

    **Uso:**
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

    **Uso:**
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

Establece configuraciones globales de solicitud (como IDs de dispositivos de prueba y restricciones de segmentación) aplicadas a cada solicitud de anuncio.

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

Devuelve el estado de inicialización del SDK y sus adaptadores de mediación.

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

*(Solo iOS)* Establece si la aplicación iOS debe pausarse cuando se ejecuta en segundo plano.

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

Establece el volumen de audio global para todos los anuncios (de `0.0` a `1.0`).

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

Silencia o activa el sonido de todos los anuncios globalmente.

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

Habilita o deshabilita el ID de primera parte del editor.

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

Informa al SDK si el usuario ha dado consentimiento para el uso de cookies.

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

Devuelve si se ha declarado el consentimiento para cookies.

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

*(Solo iOS)* Desactiva el informe de fallos integrado dentro del SDK de Google Mobile Ads.

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

Abre la superposición del Ad Inspector en la aplicación para verificar fuentes de anuncios y solucionar problemas de mediación. Toma un [`AdInspectorClosedListener`](../listeners/AdInspectorClosedListener.md) opcional para ser notificado cuando se descarte el inspector.

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

Devuelve la cadena de versión del Godot AdMob Editor Plugin.

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

Devuelve la versión subyacente del SDK de Mobile Ads nativo (Android/iOS).

=== "GDScript"
    ```gdscript
    static func get_platform_version() -> String
    ```

=== "C#"
    ```csharp
    public static string GetPlatformVersion()
    ```
