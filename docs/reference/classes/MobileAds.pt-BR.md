# MobileAds

A classe `MobileAds` fornece configurações globais e pontos de entrada de inicialização para o SDK Google Mobile Ads.

## Métodos Estáticos

### `initialize` / `Initialize`

Inicializa o SDK Google Mobile Ads. Aceita um [`OnInitializationCompleteListener`](../listeners/OnInitializationCompleteListener.md) opcional para ser notificado quando a inicialização terminar.

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

Define configurações globais de solicitação (como IDs de dispositivos de teste e restrições de segmentação) aplicadas a todas as solicitações de anúncio.

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

Retorna o status de inicialização do SDK e seus adaptadores de mediação.

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

*(Apenas iOS)* Define se o aplicativo iOS deve pausar quando estiver em segundo plano.

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

Define o volume de áudio global para todos os anúncios (de `0.0` a `1.0`).

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

Ativa ou desativa o som de todos os anúncios globalmente.

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

Ativa ou desativa o ID primário do editor.

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

Informa ao SDK se o usuário consentiu com o uso de cookies.

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

Retorna se o consentimento para cookies foi declarado.

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

*(Apenas iOS)* Desativa o relatório de falhas integrado no SDK Google Mobile Ads.

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

Abre a sobreposição do Ad Inspector no aplicativo para verificar fontes de anúncios e solucionar problemas de mediação. Aceita um [`AdInspectorClosedListener`](../listeners/AdInspectorClosedListener.md) opcional para ser notificado quando o inspetor for dispensado.

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

Retorna a string de versão do Godot AdMob Editor Plugin.

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

Retorna a versão subjacente do SDK Mobile Ads nativo (Android/iOS).

=== "GDScript"
    ```gdscript
    static func get_platform_version() -> String
    ```

=== "C#"
    ```csharp
    public static string GetPlatformVersion()
    ```
