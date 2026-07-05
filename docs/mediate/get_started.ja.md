# AdMob メディエーションを設定する

AdMob メディエーションは、さまざまなソースからアプリに広告を配信できるようにする便利な機能です。これらのソースには、AdMob ネットワーク、サードパーティの広告ネットワーク、および [AdMob キャンペーン](https://support.google.com/admob/answer/6162747)が含まれます。AdMob メディエーションの主な目的は、広告リクエストを複数のネットワークに誘導することにより、フィルレート（広告の充填率）を最適化し、収益化の取り組みを強化することです。これにより、アプリは広告を表示するために利用可能な最も適したネットワークを確実に利用できるようになります。このアプローチの実例については、[ケーススタディ](https://admob.google.com/home/resources/cookapps-grows-ad-revenue-86-times-with-admob-rewarded-ads-and-mediation/)を参照してください。

この包括的なガイドは、AdMob アプリにメディエーションを統合するためのオールインワンのリソースとして機能します。入札（Bidding）とウォーターフォール（Waterfall）の両方の統合方法を網羅しており、広告配信戦略を最適化するための完全なリファレンスを提供します。

!!! info

    **重要な注意点**: メディエーションの設定を進める前に、必要なアカウント権限を所有していることを確認することが不可欠です。これらの権限には、在庫管理、アプリへのアクセス、プライバシーとメッセージング機能へのアクセスが含まれます。詳細については、[新しいユーザー役割](https://support.google.com/admob/answer/2784628)の記事を参照してください。

- 特定の広告フォーマットのメディエーションを統合する前に、まずその広告フォーマットをアプリに統合しておく必要があります。これらの広告フォーマットには以下が含まれます。
    - [バナー広告](../ad_formats/banner/get_started.md)
    - [インタースティシャル広告](../ad_formats/interstitial.md)
    - [リワード広告](../ad_formats/rewarded.md)
    - [リワード インタースティシャル広告](../ad_formats/rewarded_interstitial.md)

メディエーションを初めて利用する場合は、概念をより深く理解するために [AdMob メディエーションの概要](https://support.google.com/admob/answer/13420272)を確認することをお勧めします。

このドキュメントは以下に基づいています。

- [Google Mobile Ads SDK Android ドキュメント](https://developers.google.com/admob/android/mediate)
- [Google Mobile Ads SDK iOS ドキュメント](https://developers.google.com/admob/ios/mediate)

## Mobile Ads SDK の初期化

クイックスタートガイドでは、[Mobile Ads SDK の初期化方法](../index.md#initialize-the-google-mobile-ads-sdk)についての説明を提供しています。この初期化プロセス中に、メディエーションおよび入札のアダプターも初期化されます。最初の広告リクエストにすべての広告ネットワークが完全に参加できるようにするため、広告をロードする前にこの初期化が完了するのを待つことが極めて重要です。

以下のサンプルコードは、広告リクエストを開始する前に、各アダプターの初期化ステータスを確認する方法を示しています。


=== "GDScript"

    ```gdscript
    extends Control
    
    func _ready() -> void:
    	var on_initialization_complete_listener := OnInitializationCompleteListener.new()
    	on_initialization_complete_listener.on_initialization_complete = _on_initialization_complete
    	MobileAds.initialize(on_initialization_complete_listener)
    	
    func _on_initialization_complete(initialization_status : InitializationStatus) -> void:
    	print("MobileAds initialization complete")
    	for key in initialization_status.adapter_status_map:
    		var adapterStatus : AdapterStatus = initialization_status.adapter_status_map[key]
    		prints(
    			"Key:", key, 
    			"Latency:", adapterStatus.latency, 
    			"Initialization Status:", adapterStatus.initialization_status, 
    			"Description:", adapterStatus.description
    		)
    		
    ```

=== "C#"

    ```csharp
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Listeners;
    using PoingStudios.AdMob.Api.Core;
    
    public partial class MediationExample : Control
    {
        public override void _Ready()
        {
            var onInitializationCompleteListener = new OnInitializationCompleteListener
            {
                OnInitializationComplete = OnInitializationComplete
            };
            MobileAds.Initialize(onInitializationCompleteListener);
        }
    
        private void OnInitializationComplete(InitializationStatus initializationStatus)
        {
            GD.Print("MobileAds initialization complete");
            foreach (var kvp in initializationStatus.AdapterStatusMap)
            {
                string key = kvp.Key;
                AdapterStatus adapterStatus = kvp.Value;
                GD.Print(
                    "Key: ", key, 
                    " Latency: ", adapterStatus.Latency, 
                    " Initialization Status: ", adapterStatus.State, 
                    " Description: ", adapterStatus.Description
                );
            }
        }
    }
    ```

## バナー広告のメディエーション
AdMob メディエーションでバナー広告を使用する場合、メディエーションで使用しているバナー広告ユニットのすべてのサードパーティ広告ネットワークのユーザーインターフェースで、更新（リフレッシュ）設定を無効にすることが不可欠です。AdMob もバナー広告ユニットの事前定義された更新頻度に基づいて更新をトリガーするため、設定を有効にしたままだと二重に更新（ダブルリフレッシュ）が発生する原因となります。

## リワード広告のメディエーション
AdMob UI 内で報酬値を設定して、すべてのデフォルトの報酬値をカスタマイズすることを強くお勧めします。これを実現するには、**[メディエーション グループのすべてのネットワークに適用]** オプションを選択して、すべてのネットワークで報酬が一律になるようにします。一部の広告ネットワークでは、報酬値またはタイプが提供されない場合があることに注意してください。報酬値を上書きすることで、広告配信を担当する広告ネットワークに関係なく、一貫した報酬が提供されることが保証されます。
![apply_all_networks](https://developers.google.com/static/admob/images/mediation/admob_apply_all_networks.png)

AdMob UI での報酬値の設定に関する詳細については、[リワード広告ユニットの作成](https://support.google.com/admob/answer/7311747)のドキュメントを参照してください。


## CCPA と GDPR

!!! warning

    **重要な注意点**: EU ユーザーの同意、GDPR、CCPA、およびユーザーメッセージングプラットフォーム（UMP）の設定を進める前に、必要なアカウント管理権限を持っていることを確認することが重要です。これらの権限は、プライバシー関連の設定を管理するために不可欠です。詳細については、[新しいユーザー役割](https://support.google.com/admob/answer/2784628)の記事を参照してください。

アプリが [カリフォルニア州消費者プライバシー法 (CCPA)](https://support.google.com/admob/answer/9561022) または [一般データ保護規則 (GDPR)](https://support.google.com/admob/answer/7666366) を遵守する必要がある場合は、CCPA 設定または GDPR 設定の手順に従って、AdMob の [プライバシーとメッセージング] の [CCPA 広告パートナー](https://support.google.com/admob/answer/10860309) または [GDPR 広告パートナー](https://support.google.com/admob/answer/10113004#adding_ad_partners_to_published_gdpr_messages) リストにメディエーションパートナーを追加してください。これを怠ると、パートナーがアプリ内で広告を配信できなくなる可能性があります。

さらに詳細な情報を得るには、[CCPA 制限付きデータ処理の有効化](../privacy/regulatory_solutions/us_states_privacy_laws.md)および [Google ユーザーメッセージングプラットフォーム (UMP) SDK を使用した GDPR 同意の取得](../privacy/user_messaging_tools/get_started.md)のプロセスを確認してください。
