# MobileAds

`MobileAds` クラスは、Google Mobile Ads SDK のグローバル設定と初期化エントリポイントを提供します。

## 静的メソッド

### `initialize` / `Initialize`

Google Mobile Ads SDK を初期化します。初期化完了時に通知を受け取るためのオプションの [`OnInitializationCompleteListener`](../listeners/OnInitializationCompleteListener.md) を受け取ります。

=== "GDScript"
    ```gdscript
    static func initialize(on_initialization_complete_listener: OnInitializationCompleteListener = null) -> void
    ```

    **使用法:**
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

    **使用法:**
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

すべての広告リクエストに適用されるグローバルリクエスト設定（テストデバイス ID やターゲティング制限など）を設定します。

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

SDK とそのメディエーションアダプターの初期化ステータスを返します。

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

*(iOS のみ)* iOS アプリケーションがバックグラウンドで動作しているときに一時停止するかどうかを設定します。

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

すべての広告のグローバルオーディオボリュームを設定します（`0.0` から `1.0`）。

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

すべての広告をグローバルにミュートまたはミュート解除します。

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

パブリッシャーのファーストパーティ ID を有効または無効にします。

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

ユーザーが Cookie の使用に同意したかどうかを SDK に通知します。

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

Cookie の同意が宣言されているかどうかを返します。

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

*(iOS のみ)* Google Mobile Ads SDK 内の組み込みクラッシュレポートを無効にします。

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

アプリ内の Ad Inspector オーバーレイを開いて広告ソースを確認し、メディエーションの問題をトラブルシューティングします。インスペクターが閉じられたときに通知を受け取るためのオプションの [`AdInspectorClosedListener`](../listeners/AdInspectorClosedListener.md) を受け取ります。

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

Godot AdMob Editor Plugin のバージョン文字列を返します。

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

基盤となるネイティブ Mobile Ads SDK のバージョン（Android/iOS）を返します。

=== "GDScript"
    ```gdscript
    static func get_platform_version() -> String
    ```

=== "C#"
    ```csharp
    public static string GetPlatformVersion()
    ```
