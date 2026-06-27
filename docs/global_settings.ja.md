# グローバル設定

`MobileAds` クラスは、Google Mobile Ads SDK のグローバル設定を提供します。

## 動画広告の音量制御

アプリに独自の音量制御（カスタム音楽や効果音の音量など）がある場合、アプリの音量を Google Mobile Ads SDK に報告すると、動画広告がアプリの音量設定を尊重できます。これにより、ユーザーは期待されるオーディオ音量で動画広告を受け取ることができます。

デバイスの音量は、音量ボタンやOSレベルの音量スライダーで制御され、デバイスのオーディオ出力の音量を決定します。ただし、アプリはデバイスの音量に対して相対的に音量レベルを独立して調整し、オーディオ体験をカスタマイズできます。

`set_app_volume()` メソッドを呼び出して、相対的なアプリ音量を Google Mobile Ads SDK に報告できます。有効な広告音量の値は `0.0`（ミュート）から `1.0`（現在のデバイス音量）の範囲です。以下は、SDK に相対的なアプリ音量を報告する方法の例です：

=== "GDScript"

    ```gdscript
    # アプリの音量を現在のデバイス音量の半分に設定する。
    MobileAds.set_app_volume(0.5)
    ```

=== "C#"

    ```csharp
    // アプリの音量を現在のデバイス音量の半分に設定する。
    MobileAds.SetAppVolume(0.5f);
    ```

!!! warning
    アプリのオーディオ音量を下げると、動画広告の表示資格が低下し、アプリの広告収益が減少する可能性があります。この方法は、アプリがユーザーにカスタム音量コントロールを提供し、ユーザーの音量がアプリに適切に反映されている場合にのみ使用してください。

アプリの音量がミュートされたことを SDK に通知するには、広告を読み込む前に `set_app_muted()` メソッドを呼びます：

=== "GDScript"

    ```gdscript
    # アプリをミュートに設定する。
    MobileAds.set_app_muted(true)
    ```

=== "C#"

    ```csharp
    // アプリをミュートに設定する。
    MobileAds.SetAppMuted(true);
    ```

デフォルトでは、アプリの音量は `1`（現在のデバイス音量）に設定され、アプリはミュートされていません。

!!! warning
    アプリをミュートすると、動画広告の表示資格が低下し、アプリの広告収益が減少する可能性があります。この方法は、アプリがユーザーにカスタムミュートコントロールを提供し、ユーザーのミュート決定がアプリに適切に反映されている場合にのみ使用してください。

## Cookie の同意

アプリに特別な要件がある場合、オプションの `gad_has_consent_for_cookies` キーをゼロに設定して、[制限付き広告](https://support.google.com/admob/answer/10105530) を有効にできます：

=== "GDScript"

    ```gdscript
    # 制限付き広告を有効にする
    MobileAds.set_gad_has_consent_for_cookies(false)
    ```

=== "C#"

    ```csharp
    // 制限付き広告を有効にする
    MobileAds.SetGadHasConsentForCookies(false);
    ```

## クラッシュレポートの無効化

Google Mobile Ads SDK は、デバッグと分析のためにクラッシュレポートを収集します。クラッシュレポートを無効にするには、Android と iOS の以下のセクションを参照してください。

=== "Android"

    アプリの `AndroidManifest.xml` ファイルに、`DISABLE_CRASH_REPORTING` を `true` に設定した `<meta-data>` タグを追加します：

    ```xml
    <manifest>
       <application>
           <meta-data
               android:name="com.google.android.gms.ads.flag.DISABLE_CRASH_REPORTING"
               android:value="true" />
       </application>
    </manifest>
    ```

=== "iOS"

    `disable_sdk_crash_reporting()` メソッドを呼び出して、iOS でクラッシュレポートを無効にします：

    === "GDScript"

        ```gdscript
        func _ready() -> void:
            MobileAds.disable_sdk_crash_reporting()
        ```

    === "C#"

        ```csharp
        public override void _Ready()
        {
            MobileAds.DisableSdkCrashReporting();
        }
        ```

## プラグインバージョンの取得

プラグインバージョンを取得するには、以下を実行します：

=== "GDScript"

    ```gdscript
    # プラグインバージョンを取得する。
    print("プラグインバージョン: " + MobileAds.get_version())
    ```

=== "C#"

    ```csharp
    // プラグインバージョンを取得する。
    GD.Print("プラグインバージョン: " + MobileAds.GetVersion());
    ```

## プラットフォームバージョンの取得

Google Mobile Ads SDK は、Android および iOS プラットフォーム SDK に依存しています。プラットフォーム SDK のバージョンを取得するには、以下を実行します：

=== "GDScript"

    ```gdscript
    # ベースプラットフォーム SDK バージョンを取得する。
    print("プラットフォーム SDK バージョン: " + MobileAds.get_platform_version())
    ```

=== "C#"

    ```csharp
    // ベースプラットフォーム SDK バージョンを取得する。
    GD.Print("プラットフォーム SDK バージョン: " + MobileAds.GetPlatformVersion());
    ```
