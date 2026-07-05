# テスト広告の有効化

このガイドでは、広告の統合においてテスト広告を有効にする手順について説明します。開発フェーズ中にテスト広告を有効にすることは極めて重要です。これにより、Google の広告主に費用を発生させることなく広告をクリックしてテストできるようになります。テストモードに設定せずに広告を何度もクリックすると、アカウントが無効なトラフィックとしてフラグを立てられる原因になります。

開発中に広告をテストするには、次の方法があります。

1. **エディタ内でのモック広告のプレビュー**: デバイスにデプロイすることなく、Godot エディタ内で直接、広告の統合と視覚的なレイアウトをテストします。[エディタ内でのモック広告のプレビュー](editor_mock_ads.ja.md)を参照してください。
2. **Google 提供のサンプル広告ユニットの使用**: 実機またはシミュレータ/エミュレータにテスト広告を読み込みます。[サンプル広告ユニット](#sample-ad-units)を参照してください。
3. **テストデバイスの有効化**: 自身のテストデバイスを登録することで、本番用の広告ユニットを使用してテストを行います。[テストデバイスの有効化](#enable-test-devices)を参照してください。

本文書は以下に基づいています。

- [Google Mobile Ads SDK Android 公式ドキュメント](https://developers.google.com/admob/android/test-ads)
- [Google Mobile Ads SDK iOS 公式ドキュメント](https://developers.google.com/admob/ios/test-ads)

## 前提条件
- 完成 [開始使用指南](index.ja.md)

## サンプル広告ユニット {: #sample-ad-units }

テストを有効にする最も迅速な方法は、Google が提供するテスト用広告ユニットを採用することです。これらの広告ユニットはご自身の AdMob アカウントとは切り離されているため、使用中にアカウントが無効なトラフィックを生成するリスクはありません。

テスト対象のプラットフォームに基づいて、Google が提供する適切なテスト用広告ユニットを選択する必要がある点に注意してください。iOS でテスト広告リクエストを行うには iOS 用のテスト広告ユニットを使用し、Android でリクエストを行うには Android 用のテスト広告ユニットを使用します。

!!! note

    **重要事項**: アプリをリリースする前に、これらのテスト用 ID を必ずご自身の広告ユニット ID に置き換えてください。

以下は、Android と iOS の両方で利用可能な各フォーマットのサンプル広告ユニットです。

=== "Android"
    | 広告フォーマット       | サンプル広告ユニット ID                 |
    |-----------------------|----------------------------------------|
    | Banner                | ca-app-pub-3940256099942544/6300978111 |
    | App Open              | ca-app-pub-3940256099942544/9257395921 |
    | Interstitial          | ca-app-pub-3940256099942544/1033173712 |
    | Rewarded              | ca-app-pub-3940256099942544/5224354917 |
    | Rewarded Interstitial | ca-app-pub-3940256099942544/5354046379 |
    | Native                | ca-app-pub-3940256099942544/2247696110 |

=== "iOS"

    | 広告フォーマット       | サンプル広告ユニット ID                 |
    |-----------------------|----------------------------------------|
    | Banner                | ca-app-pub-3940256099942544/2934735716 |
    | App Open              | ca-app-pub-3940256099942544/5575463023 |
    | Interstitial          | ca-app-pub-3940256099942544/4411468910 |
    | Rewarded              | ca-app-pub-3940256099942544/1712485313 |
    | Rewarded Interstitial | ca-app-pub-3940256099942544/6978759866 |
    | Native                | ca-app-pub-3940256099942544/3986624511 |

### 特殊なテスト用識別子
上記の標準広告ユニットは追加のパラメータ（`collapsible` など）を追加して使用できますが、以下の特殊な広告ユニット ID は、UI/UX のテスト用に特定の機能が返されることを**保証**します。

| 機能 | Android | iOS |
| :--- | :--- | :--- |
| **折りたたみ式バナー (Collapsible Banners)** | `ca-app-pub-3940256099942544/2014213617` | `ca-app-pub-3940256099942544/8388050270` |



## テストデバイスの有効化 {: #enable-test-devices }
本番に近い広告でより詳細なテストを実施するために、ご自身のデバイスをテストデバイスとして設定し、AdMob UI で作成した独自の広告ユニット ID を使用できます。テストデバイスの追加は、AdMob UI または Google Mobile Ads SDK を使用してプログラムで行うことができます。

デバイスをテストデバイスとして追加する手順は次のとおりです。

!!! note

    **重要事項**: Android エミュレータおよび iOS シミュレータは、自動的にテストデバイスとして設定されます。つまり、これらの仮想デバイス上の広告テストでは、手動でテストデバイス一覧に追加する必要はありません。


### AdMob UI でのテストデバイスの追加

テストデバイスを含めて新規または既存のアプリビルドをテストする、プログラミングを伴わない簡単な方法として、AdMob UI を使用できます。[手順はこちら](https://support.google.com/admob/answer/9691433)。


!!! note

    **重要事項**: 新しく追加されたテストデバイスがアプリでテスト広告の配信を開始するまでに通常 15 分ほどかかりますが、設定が反映されるまでに最大 24 時間かかる場合もあります。


### プログラムによるテストデバイスの追加

開発フェーズ中にアプリ内の広告をテストし、プログラムでテストデバイスを登録する場合は、以下の手順に従ってください。

1. 広告が統合されたアプリを開き、広告リクエストを開始します。
2. デバイス ID とそれをテストデバイスとして追加する方法を示す、以下のようなメッセージが logcat 出力にあるか確認します。

    === "Android"
        ```java
        I/Ads: Use RequestConfiguration.Builder.setTestDeviceIds(Arrays.asList("33BE2250B43518CCDA7DE426D04EE231")) 
        to get test ads on this device."
        ```

    === "iOS"

        ```swift
        <Google> To get test ads on this device, set:
        GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers =
        @[ @"2077ef9a63d2b398840261c8221a0c9b" ];
        ```
テストデバイスの ID をクリップボードにコピーします。

3. 以下のように、[`RequestConfiguration`](reference/classes/RequestConfiguration.md).test_device_ids 配列にテストデバイス ID を含めるようにコードを更新します。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="3 4"
    func _ready() -> void:
    	var request_configuration := RequestConfiguration.new()
    	request_configuration.test_device_ids = ["2077ef9a63d2b398840261c8221a0c9b"]
    	MobileAds.set_request_configuration(request_configuration)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="10 11"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    
    public partial class TestAdsExample : Node2D
    {
        public override void _Ready()
        {
            var requestConfiguration = new RequestConfiguration();
            requestConfiguration.TestDeviceIds.Add("2077ef9a63d2b398840261c8221a0c9b");
            MobileAds.SetRequestConfiguration(requestConfiguration);
        }
    }
    ```
!!! info

    アプリをリリースする前に、これらのテストデバイスを定義するコードを削除することを忘れないでください。

4. アプリを再起動します。広告が Google の広告である場合、バナー、インタースティシャル、リワード動画広告のいずれであっても、広告の上部中央に **Test Ad**（テスト広告）というラベルが表示されます。
![testad](https://developers.google.com/static/admob/images/android-testad-0-admob.png)

!!! info

    メディエーション（仲介）広告には **Test Ad** ラベルが表示されない点に注意してください。詳細については、以下のセクションを参照してください。


### メディエーションでのテスト

Google のサンプル広告ユニットは Google 広告のみを表示します。メディエーションの設定を効果的にテストするには、[テストデバイスの有効化](#enable-test-devices)の方法を使用する必要があります。

メディエーション広告には「Test Ad」のラベルは表示されません。したがって、これらのメディエーションネットワークがご自身のアカウントを無効なアクティビティとしてフラグを立てるのを防ぐために、各メディエーションネットワークでテスト広告が有効になっていることを確認する責任は開発者にあります。詳細な手順については、各ネットワークの個別の[メディエーションガイド](mediate/get_started.md)を参照してください。

メディエーション広告ネットワークのアダプタがテスト広告をサポートしているか不明な場合は、開発フェーズ中にそのネットワークの広告をクリックしないことをお勧めします。広告フォーマット内の [`ResponseInfo.mediation_adapter_class_name`](reference/classes/ResponseInfo.md#mediation_adapter_class_name) 属性を使用して、現在の広告を配信した広告ネットワークを特定できます。
