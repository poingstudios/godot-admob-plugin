# エディタ内でのモック広告のプレビュー

プレビューモック広告機能を使用すると、ゲームをモバイルデバイス向けにビルドする前に、Godot エディタ内で広告の統合をテストできます。

モック広告は、広告の挙動、ライフサイクルコールバック（読み込み、表示、クリック、非表示など）、および UI 表示を Godot エディタ内で直接シミュレートします。これにより、開発の初期段階で広告の統合フロー、カスタムレイアウト、および UI の配置を検証するのに役立ちます。

## 仕組み

プラグインは、ゲームが Godot エディタ内のデスクトッププラットフォーム（Windows、macOS、または Linux）で実行されているかどうかを自動的に検出します（`OS.has_feature("editor")`）。Android や iOS のネイティブのシングルトンが存在しないためにエラーを発生させる代わりに、プラグインは自動的にモックのシングルトンとノードをインスタンス化します。

モック広告を使用するために、GDScript や C# のコード、または設定を変更する必要はありません。すべての標準的な `MobileAds` および広告フォーマットの API は、まったく同じように機能します。

## モック広告を使用するメリット

モック広告は、開発中に以下の検証を行うための強力なツールです。

- **広告の統合フローの検証**: 初期化、読み込み、表示、およびその他のすべてのライフサイクルコールバックが、ゲームロジック内で正しくトリガーされることを確認します。
- **視覚的なレイアウトのプレビュー**: さまざまな広告フォーマットのレイアウトや UI 要素（`SafeArea` など）に対する配置を含め、広告がゲームの UI でどのように表示されるかを確認します。
- **迅速なイテレーション**: 基本的な広告の挙動をテストするためだけに、アプリをコンパイル、エクスポートし、実機やシミュレータにデプロイするという時間のかかるプロセスを避けることができます。

## サポートされているフォーマット

モックシステムは、主要な広告フォーマットごとに視覚的な外観とインタラクションをシミュレートします。

### バナー広告 (Banners)
- 選択した標準サイズ（標準バナー、大型バナー、中型の長方形、リーダーボードなど）またはカスタムサイズに一致するコンテナを画面上にレンダリングします。
- カスタム画面位置（`AdPosition.custom(x, y)`）をサポートします。
- **折りたたみ式バナー (Collapsible Banners)**: 広告リクエストの extras で `collapsible` を指定すると、モックバナーに折りたたみ/展開の切り替えボタン（`^`）が表示され、バナーが折りたたまれたときのレイアウト調整とコールバックをテストできます。
- 非表示（閉じる）をシミュレートするための閉じるボタン（`×`）をレンダリングします。

![Mock Banner Ad](assets/mock_ad_banner.png)

### アプリ起動時広告 (App Open)
- 起動時に全画面のアプリ起動時モック広告オーバーレイをレンダリングして、画面遷移をテストします。

![Mock App Open Ad](assets/mock_ad_app_open.png)

### インタースティシャル広告 (Interstitial)
- リアルなブランディングを施した全画面インタースティシャルカードをレンダリングします。
- 広告を非表示にしてクローズコールバックをトリガーする閉じるボタン（`X`）を備えています。

![Mock Interstitial Ad](assets/mock_ad_interstitial.png)

### リワード広告 & リワードインタースティシャル広告 (Rewarded & Rewarded Interstitial)
- 全画面のリワードオーバーレイをレンダリングします。
- シミュレートされた動画カウントダウンタイマー（通常は 8 秒）を再生します。
- カウントダウンが終了する前に広告を閉じようとすると、警告ポップアップが表示されます（「本当に閉じますか？報酬が失われます」）。
- カウントダウンが完了すると、自動的に報酬を付与します（モックの通貨詳細とともに `on_rewarded_ad_user_earned_reward` / `UserEarnedReward` コールバックをトリガーします）。
- 閉じるボタン（`X`）は、最小時間（5 秒）が経過した後、または報酬が付与された後にのみ表示/有効化されます。

![Mock Rewarded Ad](assets/mock_ad_rewarded.png)

### ネイティブオーバーレイ広告 (Native Overlay)
- Godot の Control ノードを使用して、テンプレートスタイルのモックネイティブ広告（`small` と `medium` の両方のレイアウトをサポート）をレンダリングします。
- アプリのアイコン、タイトル、コールトゥアクション（行動喚起）ボタン、本文テキストなどのモックアセットを表示します。

![Mock Native Ad](assets/mock_ad_native.png)

## ライフサイクルコールバック

モックプラグインは、実際のモバイル SDK とまったく同じ信号をトリガーするため、広告イベントに対するコードの応答をデバッグできます。

たとえば、インタースティシャル広告をリクエストすると、次のシーケンスがシミュレートされます。

=== "GDScript"

    ```gdscript
    var _interstitial_ad: InterstitialAd

    
    func _load_interstitial():
        var listener := InterstitialAdLoadListener.new()
        listener.on_ad_loaded = func(ad: InterstitialAd) -> void:
            _interstitial_ad = ad
            # シミュレートされたコールバックは 0.5 秒後にトリガーされます
            print("Ad loaded in Editor!")
            
        listener.on_ad_failed_to_load = func(error: LoadAdError) -> void:
            print("Failed to load: ", error.message)
            
        InterstitialAd.load(unit_id, AdRequest.new(), listener)
    
    func _show_interstitial():
        if _interstitial_ad:
            var full_screen_listener := FullScreenContentCallback.new()
            full_screen_listener.on_ad_showed_full_screen_content = func() -> void:
                print("Ad shown in Editor!")
                
            full_screen_listener.on_ad_dismissed_full_screen_content = func() -> void:
                print("Ad dismissed in Editor!")
                
            _interstitial_ad.full_screen_content_callback = full_screen_listener
            _interstitial_ad.show()
    ```

=== "C#"

    ```csharp
    private InterstitialAd _interstitialAd;
    
    private void LoadInterstitial()
    {
        var listener = new InterstitialAdLoadListener
        {
            OnAdLoaded = (ad) =>
            {
                _interstitialAd = ad;
                // シミュレートされたコールバックは 0.5 秒後にトリガーされます
                GD.Print("Ad loaded in Editor!");
            },
            OnAdFailedToLoad = (error) =>
            {
                GD.Print("Failed to load: " + error.Message);
            }
        };
    
        InterstitialAd.Load(unitId, new AdRequest(), listener);
    }
    
    private void ShowInterstitial()
    {
        if (_interstitialAd != null)
        {
            _interstitialAd.FullScreenContentCallback = new FullScreenContentCallback
            {
                OnAdShowedFullScreenContent = () => GD.Print("Ad shown in Editor!"),
                OnAdDismissedFullScreenContent = () => GD.Print("Ad dismissed in Editor!")
            };
            _interstitialAd.Show();
        }
    }
    ```

## 制限事項

!!! warning "実機でのテストを代替するものではありません"

    プレビューモック広告機能は、ロジックフローと UI レイアウトの検証には最適ですが、ゲームを公開する前に、物理的なモバイルデバイスまたはシミュレータ/エミュレータで最終確認を必ず実行する必要があります。

- モック広告は、ネットワーク遅延、ネットワーク障害状態、または実際のメディエーションネットワークアダプタをシミュレート**しません**。
- モック広告は、お客様の AdMob アプリ ID または広告ユニット ID が AdMob サーバー上で登録/有効であるかどうかを検証**しません**。実機での検証のためにテストデバイスを設定するには、[テスト広告の有効化](enable_test_ads.md) を参照してください。
