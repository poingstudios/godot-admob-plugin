# はじめに

!!! note "Godot 3 (v1) ドキュメント"
    このドキュメントは **v1** プラグイン用で、**Godot 3.x** のみをサポートしています。
    **Godot 4.2+** については、[安定版ドキュメント](https://poingstudios.github.io/godot-admob-plugin/stable/) をご覧ください。

Godot 3用のAdMobプラグインを統合すると、AndroidおよびiOSデバイスでGoogleモバイル広告を簡単に表示できます。

---

## 前提条件

- **Godot Engine 3.x Mono/Standard Edition**（v3.3以上）。
- **推奨**: 登録済みのAndroid/iOSアプリを持つアクティブな[AdMobアカウント](https://admob.google.com/)。

=== "Android"

    - Godot Androidビルドテンプレートが有効。
    - ターゲットAndroid SDKバージョンが設定済み。

=== "iOS"

    - XcodeがインストールされたmacOSマシン。
    - アクティブなApple Developerアカウント。

---

## プラグインのダウンロードとインポート

1. [GitHub Releases](https://github.com/poingstudios/godot-admob-plugin/releases)ページから最新リリースをダウンロード。
2. アーカイブを展開し、`addons/admob`フォルダをGodotプロジェクトの`res://addons/`ディレクトリにコピー。
3. Godotエディタを開き、**プロジェクト -> プロジェクト設定 -> プラグイン**に移動し、**AdMob**プラグインのステータスを**有効**に切り替え。

有効にすると、プラグインは自動的に`MobileAds`シングルトンをプロジェクトに登録します。

---

## プラットフォームテンプレートのダウンロード

Godotエディタ内でAdMobマネージャーを開きます（**プロジェクト -> ツール -> AdMobマネージャー**または**AdMob**パネルタブをクリック）。

=== "Android"

    **Androidテンプレートをダウンロード**を選択します。プラグインが自動的に必要なテンプレートファイル（`.aar`および`.gdap`）をダウンロードし、`res://android/plugins/`フォルダに直接展開します（手動でのzip解凍は不要です）。

=== "iOS"

    **iOSテンプレートをダウンロード**を選択します。プラグインが自動的に必要なテンプレート文件（`.gdip`およびライブラリファイル）をダウンロードし、`res://ios/plugins/`フォルダに直接展開します（手動でのzip解凍は不要です）。

---

## 設定

**AdMobエディタパネル**（`プロジェクト -> ツール -> AdMobマネージャー`）で、以下のオプションを設定します：

| オプション | 説明 |
|-----------|------|
| **App ID** | AdMobアプリID（例：`ca-app-pub-3940256099942544~1458002511`）。 |
| **Ad Unit IDs** | 使用する各広告フォーマットのID（バナー、インタースティシャル、リワード、リワードインタースティシャル）。 |
| **Is Enabled** | 広告の有効/無効をグローバルに切り替えます。 |
| **Banner Position** | バナーの表示位置（上部、下部、カスタム）。 |
| **Banner Size** | バナーのサイズ（バナー、大バナー、中矩形など）。 |

---

## SDKの初期化

広告を読み込む前に、Google Mobile Ads SDKを初期化する必要があります。設定で**有効**がアクティブな場合、プラグインは起動時に自動的に初期化されます。

手動で初期化したい場合、または完了を監視したい場合は、`initialization_complete`シグナルに接続：

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("initialization_complete", self, "_on_AdMob_initialization_complete")
        MobileAds.initialize()

    func _on_AdMob_initialization_complete(status: int, adapter_name: String) -> void:
        print("AdMob Initialized: ", status)
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Connect("initialization_complete", this, nameof(_on_AdMob_initialization_complete));
        MobileAds.Call("initialize");
    }

    private void _on_AdMob_initialization_complete(int status, string adapterName)
    {
        GD.Print("AdMob Initialized: " + status);
    }
    ```

---

## 広告フォーマットの選択

Google Mobile Ads SDKが正常にインポートされました。アプリに広告を統合する準備ができました。AdMobはさまざまな広告フォーマットを提供しており、アプリのユーザーエクスペリエンスに最適なものを選択できます。

### バナー
<div class="image-text-container" markdown="1">

![banner](assets/ad_formats/banner.png)

バナー広告は、画像またはテキストで構成される長方形の広告で、アプリのレイアウトに統合されます。ユーザーがアプリを操作している間、画面に表示され続け、一定時間ごとに自動的に更新されます。

</div>

[バナー広告を実装する](ad_formats/banner.ja.md){ .md-button .md-button--primary }

### インタースティシャル
<div class="image-text-container" markdown="1">

![interstitial](assets/ad_formats/interstitial.png)

インタースティシャル広告は、アプリのインターフェースを覆う全画面広告で、ユーザーが閉じるまで表示され続けます。ゲームのレベル間など、アプリの自然な区切り目に配置するのが最も効果的です。

</div>

[インタースティシャル広告を実装する](ad_formats/interstitial.ja.md){ .md-button .md-button--primary }

### リワード
<div class="image-text-container" markdown="1">

![rewarded](assets/ad_formats/rewarded.png)

リワード動画広告は、ユーザーが最後まで視聴することを選択できる没入型の全画面動画広告です。視聴の対価として、ユーザーはアプリ内で特典や報酬を受け取ります。

</div>

[リワード広告を実装する](ad_formats/rewarded.ja.md){ .md-button .md-button--primary }

### リワードインタースティシャル
<div class="image-text-container" markdown="1">

![rewarded_interstitial](assets/ad_formats/rewarded_interstitial.png)

リワードインタースティシャルは、アプリの自然な遷移中に自動的に表示される広告と引き換えに報酬を提供するインセンティブ付き広告フォーマットです。

</div>

[リワードインタースティシャル広告を実装する](ad_formats/rewarded_interstitial.ja.md){ .md-button .md-button--primary }

<style>
  .image-text-container {
    display: flex;
    align-items: center;
  }
  .image-text-container img {
    margin-right: 20px;
    max-width: 130px;
    height: auto;
  }
</style>