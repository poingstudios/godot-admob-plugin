# はじめに

Godot 3用のAdMobプラグインを統合すると、AndroidおよびiOSデバイスでGoogleモバイル広告を簡単に表示できます。

---

## 前提条件

- **Godot Engine 3.x Mono/Standard Edition**（v3.3以上）。
- **Android エクスポートの場合**:
  - Godot Androidビルドテンプレートが有効。
  - ターゲットAndroid SDKバージョンが設定済み。
- **iOS エクスポートの場合**:
  - XcodeがインストールされたmacOSマシン。
  - アクティブなApple Developerアカウント。
- **推奨**: 登録済みのAndroid/iOSアプリを持つアクティブな[AdMobアカウント](https://admob.google.com/)。

---

## プラグインのダウンロードとインポート

1. [GitHub Releases](https://github.com/poingstudios/godot-admob-plugin/releases)ページから最新リリースをダウンロード。
2. アーカイブを展開し、`addons/admob`フォルダをGodotプロジェクトの`res://addons/`ディレクトリにコピー。
3. Godotエディタを開き、**プロジェクト -> プロジェクト設定 -> プラグイン**に移動し、**AdMob**プラグインのステータスを**有効**に切り替え。

有効にすると、プラグインは自動的に`MobileAds`シングルトンをプロジェクトに登録します。

---

## プラットフォームテンプレートのダウンロード

Godotエディタ内でAdMobマネージャーを開きます（**プロジェクト -> ツール -> AdMobマネージャー**または**AdMob**パネルタブをクリック）。

* **Android**: **Androidテンプレートをダウンロード**を選択し、`.aar`ファイルと`.gdap`ファイルを`res://android/plugins/`フォルダに取得・展開。
* **iOS**: **iOSテンプレートをダウンロード**を選択し、`.gdip`ファイルとライブラリファイルを`res://ios/plugins/`フォルダに取得・展開。

---

## 設定

AdMobエディタパネルで：
1. **AdMobアプリID**を設定（例：`ca-app-pub-3940256099942544~1458002511`）。
2. 使用するフォーマット（バナー、インタースティシャル、リワード、リワードインタースティシャル）の**広告ユニットID**を入力。
3. 広告の有効/無効を切り替え、バナーの位置やサイズなどのデフォルト動作を設定。

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

SDKが初期化されたら、ゲームのレイアウトに最適な広告フォーマットを選択して実装できます：

* [バナー広告](ad_formats/banner.ja.md)
* [インタースティシャル広告](ad_formats/interstitial.ja.md)
* [リワード動画広告](ad_formats/rewarded.ja.md)
* [リワードインタースティシャル広告](ad_formats/rewarded_interstitial.ja.md)