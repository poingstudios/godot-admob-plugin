# MobileAds

`MobileAds` 类为 Google Mobile Ads SDK 提供全局配置和初始化入口点。

## 静态方法

### `initialize` / `Initialize`

初始化 Google Mobile Ads SDK。接受一个可选的 [`OnInitializationCompleteListener`](../listeners/OnInitializationCompleteListener.md) 以在初始化完成时收到通知。

=== "GDScript"
    ```gdscript
    static func initialize(on_initialization_complete_listener: OnInitializationCompleteListener = null) -> void
    ```

    **用法:**
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

    **用法:**
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

设置应用于每个广告请求的全局请求配置（例如测试设备 ID 和定位限制）。

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

返回 SDK 及其 mediation 适配器的初始化状态。

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

*(仅 iOS)* 设置 iOS 应用在后台运行时是否应暂停。

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

设置所有广告的全局音频音量（从 `0.0` 到 `1.0`）。

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

全局静音或取消静音所有广告。

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

启用或禁用发布商第一方 ID。

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

通知 SDK 用户是否已同意使用 Cookie。

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

返回是否已声明了 Cookie 同意。

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

*(仅 iOS)* 禁用 Google Mobile Ads SDK 内置的崩溃报告功能。

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

打开应用内 Ad Inspector 叠加层以验证广告来源并排查中介问题。接受一个可选的 [`AdInspectorClosedListener`](../listeners/AdInspectorClosedListener.md) 以在检查器关闭时收到通知。

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

返回 Godot AdMob Editor Plugin 版本字符串。

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

返回底层原生 Mobile Ads SDK 版本（Android/iOS）。

=== "GDScript"
    ```gdscript
    static func get_platform_version() -> String
    ```

=== "C#"
    ```csharp
    public static string GetPlatformVersion()
    ```
