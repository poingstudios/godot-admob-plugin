# スタートガイド

Google の [EU ユーザーの同意ポリシー](https://www.google.com/about/company/user-consent-policy/)に基づき、欧州経済領域（EEA）および英国のユーザーに対して特定の情報を開示し、法律で義務付けられている場合は、Cookie またはその他のローカル ストレージの使用、および広告を配信するための個人データ（広告 ID / AdID など）の使用について同意を得る必要があります。このポリシーは、EU の ePrivacy 指令および一般データ保護規則（GDPR）の要件を反映しています。

パブリッシャーがこのポリシーに基づく義務を果たすのを支援するため、Google はユーザーメッセージングプラットフォーム（UMP）SDK を提供しています。UMP SDK は、最新の IAB 標準をサポートするように更新されています。これらの設定はすべて、AdMob の [プライバシーとメッセージング] で便利に処理できるようになりました。

このドキュメントは以下に基づいています。

- [Google Mobile Ads SDK Android ドキュメント](https://developers.google.com/admob/android/privacy)
- [Google Mobile Ads SDK iOS ドキュメント](https://developers.google.com/admob/ios/privacy)

## 前提条件

- [スタートガイド](../../index.md)を完了していること
- GDPR 関連の要件に取り組んでいる場合は、[IAB の要件が EU ユーザーの同意メッセージに与える影響](https://support.google.com/admob/answer/10207733)をお読みください。

## メッセージタイプの作成
AdMob アカウントの **[プライバシーとメッセージング]** タブで、[利用可能なメッセージタイプ](https://support.google.com/admob/answer/10114020)のいずれかを使用してユーザーメッセージを作成します。UMP SDK は、プロジェクトに設定された AdMob アプリ ID から作成されたユーザーメッセージを表示しようとします。アプリケーションにメッセージが構成されていない場合、SDK はエラーを返します。

詳細については、[プライバシーとメッセージングについて](https://support.google.com/admob/answer/10107561)を参照してください。

## メッセージを表示する必要があるかどうかの判定
フォームをロードする前に、アプリの起動ごとに `update()` を使用して、ユーザーの同意情報の更新をリクエストする必要があります。これにより、ユーザーがまだ同意していない場合や、同意の有効期限が切れている場合に、同意を提供する必要があるかどうかを判定できます。

必要に応じて[フォームを表示](#present-form)（または[フォームの提示](#present-the-form-if-required)）する際は、`consentInformation` オブジェクトに保存されている情報を使用します。

!!! warning

    ユーザーが最後に同意してから広告テクノロジーパートナーのセットが変更されている可能性があるため、アプリが使用するキャッシュの確認やストレージ内の同意文字列の検索など、代替の方法で同意ステータスを確認することは強く推奨されません。

以下は、アプリ起動時にステータスを確認する方法の例です。

=== "GDScript"

    ```gdscript
    extends Node
    
    func _ready():
    	var request := ConsentRequestParameters.new()
        # 同意年齢に達していないユーザー向けのタグを設定します。false はユーザーが同意年齢未満ではないことを表します。
    	request.tag_for_under_age_of_consent = false
    	UserMessagingPlatform.consent_information.update(request, _on_consent_info_updated_success, _on_consent_info_updated_failure)
    
    func _on_consent_info_updated_success():
    	# 同意情報の状態が更新されました。
    	# これで、フォームが利用可能かどうかを確認する準備が整いました。
    	pass
    
    func _on_consent_info_updated_failure(form_error : FormError):
    	# エラーを処理します。
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
            // 同意年齢に達していないユーザー向けのタグを設定します。false はユーザーが同意年齢未満ではないことを表します。
            request.TagForUnderAgeOfConsent = false;
            UserMessagingPlatform.ConsentInformation.Update(request, OnConsentInfoUpdatedSuccess, OnConsentInfoUpdatedFailure);
        }
    
        private void OnConsentInfoUpdatedSuccess()
        {
            // 同意情報の状態が更新されました。
            // これで、フォームが利用可能かどうかを確認する準備が整いました。
        }
    
        private void OnConsentInfoUpdatedFailure(FormError formError)
        {
            // エラーを処理します。
        }
    }
    ```

<span id="load-a-form-if-available"></span>
## 利用可能な場合はフォームをロードする

フォームを表示する前に、まずフォームが利用可能かどうかを確認する必要があります。ユーザーが制限付き広告トラッキングを有効にしている場合や、同意年齢未満としてタグ付けしている場合は、フォームを利用できないことがあります。

フォームの利用可能性を確認するには、`UserMessagingPlatform` クラスの静的な `consent_information` インスタンスで `get_is_consent_form_available()` 関数を使用します。

次に、フォームをロードするためのラッパー関数を追加します。

=== "GDScript"

    ```gdscript
    #...
    func _on_consent_info_updated_success():
    	# 同意情報の状態が更新されました。
    	# これで、フォームが利用可能かどうかを確認する準備が整いました。
    	if UserMessagingPlatform.consent_information.get_is_consent_form_available():
    		load_form()
    
    func _on_consent_info_updated_failure(form_error : FormError):
    	# エラーを処理します。
    	pass
    
    func load_form():
    	pass
    ```

=== "C#"

    ```csharp
    //...
    private void OnConsentInfoUpdatedSuccess()
    {
        // 同意情報の状態が更新されました。
        // これで、フォームが利用可能かどうかを確認する準備が整いました。
        if (UserMessagingPlatform.ConsentInformation.GetIsConsentFormAvailable())
            LoadForm();
    }
    
    private void OnConsentInfoUpdatedFailure(FormError formError)
    {
        // エラーを処理します。
    }
    
    private void LoadForm()
    {
    }
    ```

フォームをロードするには、`UserMessagingPlatform` クラスの静的な `load_consent_form()` 関数を使用します。

=== "GDScript"

    ```gdscript
    var _consent_form : ConsentForm
    
    func load_form():
    	UserMessagingPlatform.load_consent_form(_on_consent_form_load_success, _on_consent_form_load_failure)
    
    func _on_consent_form_load_success(consent_form : ConsentForm):
    	_consent_form = consent_form
    
    func _on_consent_form_load_failure(form_error : FormError):
    	# エラーを処理します。
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
        // エラーを処理します。
    }
    ```

<span id="present-form"></span>
<span id="present-the-form-if-required"></span>
## 必要に応じてフォームを表示する
フォームの利用可能性を確認し、ロードが完了したら、ConsentForm インスタンスの `show()` 関数を使用してフォームを表示します。

`UserMessagingPlatform` クラスの静的な `consent_information` インスタンスを使用して同意ステータスを確認し、`load_form()` 関数を更新します。

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
    	# エラーを処理します。
    	pass
    
    func _on_consent_form_dismissed(form_error : FormError):
    	if UserMessagingPlatform.consent_information.get_consent_status() == UserMessagingPlatform.consent_information.ConsentStatus.OBTAINED:
    		# アプリは広告のリクエストを開始できます。
    		pass
    	# 閉じられた場合はフォームを再ロードして処理します
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
        // エラーを処理します。
    }
    
    private void OnConsentFormDismissed(FormError formError)
    {
        if (UserMessagingPlatform.ConsentInformation.GetConsentStatus() == ConsentStatus.Values.Obtained)
        {
            // アプリは広告のリクエストを開始できます。
        }
        // 閉じられた場合はフォームを再ロードして処理します
        LoadForm();
    }
    ```

ユーザーが選択を行った後、またはフォームを閉じた後に何らかのアクションを実行する必要がある場合は、そのロジックをフォームの完了ハンドラまたはコールバック内に配置します。

## テスト

### 地理位置情報の強制

UMP SDK では、`ConsentDebugSettings` の `debug_geography` プロパティを使用して、デバイスが EEA または英国にあるかのようにアプリの動作をテストする方法を提供しています。

デバッグ機能を使用するには、アプリのデバッグ設定にテストデバイスのハッシュ ID を提供する必要があります。この値を設定せずに `UserMessagingPlatform.consent_information.update()` を呼び出すと、アプリの実行時に必要な ID ハッシュがログに出力されます。

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
    	# 同意情報の状態が更新されました。
    	# これで、フォームが利用可能かどうかを確認する準備が整いました。
    	pass
    
    func _on_consent_info_updated_failure(form_error : FormError):
    	# エラーを処理します。
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
            // 同意情報の状態が更新されました。
            // これで、フォームが利用可能かどうかを確認する準備が整いました。
        }
    
        private void OnConsentInfoUpdatedFailure(FormError formError)
        {
            // エラーを処理します。
        }
    }
    ```

`DebugGeography.Values` 枚举を使用すると、地理位置情報を次のいずれかのオプションに強制的に設定できます。

| DebugGeography | 説明                                            |
|----------------|--------------------------------------------------------|
| DISABLED       | デバッグ地理位置情報が無効です。                              |
| EEA            | デバッグデバイスの地理位置情報が EEA 内として表示されます。         |
| NOT_EEA        | デバッグデバイスの地理位置情報が EEA 外として表示されます。 |

デバッグ設定はテストデバイスでのみ機能することに注意してください。エミュレーターはデフォルトでテストが有効になっているため、デバイス ID リストに追加する必要はありません。


### 同意ステータスのリセット

UMP SDK を使用してアプリをテストする際、ユーザーの初回インストール時の体験をシミュレートできるように、SDK の状態をリセットすると便利な場合があります。SDK は、これを実行するための `reset()` 関数を提供しています。

=== "GDScript"

    ```gdscript
    UserMessagingPlatform.consent_information.reset()
    ```

=== "C#"

    ```csharp
    UserMessagingPlatform.ConsentInformation.Reset();
    ```

プロジェクトから UMP SDK を完全に削除する場合も、`reset()` を呼び出す必要があります。

!!! warning

    この関数はテスト目的のみを意図しています。本番環境のコードで `reset()` を呼び出さないでください。
