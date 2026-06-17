# 折りたたみ式バナー広告

折りたたみ式バナー広告は、最初は大きめのオーバーレイとして表示され、ユーザーがボタンで本来リクエストしたバナーサイズに折りたたむことができるバナー広告です。折りたたみ式バナー広告は、通常は小さめのサイズで表示されるアンカー広告のパフォーマンスを向上させることを目的としています。このガイドでは、既存のバナー配置で折りたたみ式バナー広告を有効にする方法を説明します。

本文書は以下に基づいています。

- [Google Mobile Ads SDK Android 公式ドキュメント](https://developers.google.com/admob/android/banner/collapsible)
- [Google Mobile Ads SDK iOS 公式ドキュメント](https://developers.google.com/admob/ios/banner/collapsible)

## 前提条件
- [バナー広告の開始ガイド](get_started.ja.md)を完了していること。

## 実装

通常の（折りたたまれた）バナーステートでユーザーに見せたいサイズで `AdView` が定義されていることを確認してください。`AdRequest` の extras パラメータに、キーを `collapsible`、値を広告の配置（位置）としたデータを追加します。

折りたたみの配置値（位置）は、展開された領域がバナー広告に対してどのようにアンカーされるかを定義します。

| 配置値 | 挙動 | 想定されるユースケース |
|---|---|---|
| `top` | 展開された広告の上部が、折りたたまれた広告の上部に合わせられます。 | 広告が画面上部に配置されている場合。 |
| `bottom` | 展開された広告の下部が、折りたたまれた広告の下部に合わせられます。 | 広告が画面下部に配置されている場合。 |

ロードされた広告が折りたたみ式バナーである場合、バナーがビュー階層に配置されると、すぐに折りたたみ式オーバーレイが表示されます。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="2"
    var ad_request := AdRequest.new()
    ad_request.extras["collapsible"] = "bottom"
    
    _ad_view.load_ad(ad_request)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="2"
    var adRequest = new AdRequest();
    adRequest.Extras["collapsible"] = "bottom";
    
    _adView.LoadAd(adRequest);
    ```

!!! info "重要"
    折りたたみ式バナー機能は、大型のアンカー付きアダプティブバナーでは利用できません。アプリに折りたたみ機能が必要な場合は、[標準のアンカー付きアダプティブバナー](sizes/anchored_adaptive.md)を使用してください。

## 広告の更新（リフレッシュ）時の挙動

AdMob 管理画面でバナー広告の自動更新を設定しているアプリの場合、バナースロットに対して折りたたみ式バナー広告がリクエストされると、その後の自動更新では折りたたみ式バナー広告はリクエストされません。これは、更新のたびに折りたたみ式バナーを表示すると、ユーザー体験に悪影響を与える可能性があるためです。

セッションの後半で別の折りたたみ式バナー広告をロードしたい場合は、`collapsible` パラメータを含むリクエストを使用して手動で広告をロードできます。

## ロードされた広告が折りたたみ式かどうかを確認する

パフォーマンスを最大化するため、折りたたみ式バナーのリクエストに対して、折りたたみ式ではない通常のバナー広告が返される場合もあります。最後にロードされたバナーが折りたたみ式かどうかを確認するには、`is_collapsible()`（C# では `IsCollapsible()`）を呼び出します。

=== "GDScript"
    ```gdscript linenums="1" hl_lines="6"
    func _ready() -> void:
    	# ...
    	_ad_view.ad_listener.on_ad_loaded = _on_ad_loaded
    
    func _on_ad_loaded() -> void:
    	var is_collapsible: bool = _ad_view.is_collapsible()
    	print("Ad loaded. Collapsible: %s" % is_collapsible)
    ```

=== "C#"
    ```csharp linenums="1" hl_lines="7"
    private void RegisterAdListener()
    {
    	_adView.AdListener = new AdListener
    	{
    		OnAdLoaded = () => 
    		{
    			bool isCollapsible = _adView.IsCollapsible();
    			GD.Print($"Ad loaded. Collapsible: {isCollapsible}");
    		}
    	};
    }
    ```

## メディエーション（仲介）

折りたたみ式バナー広告は、Google の配信に対してのみ利用可能です。メディエーションを通じて配信される広告は、通常の折りたたみ式ではないバナー広告として表示されます。
