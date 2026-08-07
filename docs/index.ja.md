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

=== "アセットライブラリ（推奨）"

    1. Godot エディタでプロジェクトを開き、上部の **AssetLib** タブをクリックします。
    2. **AdMob**（作成者：`poing.studios`）を検索します。
    3. **ダウンロード** をクリックし、次に **インストール** をクリックしてプラグインファイルをプロジェクトに追加します。
    4. **プロジェクト -> プロジェクト設定 -> プラグイン** に移動し、**AdMob** プラグインのステータスを **有効** に切り替えます。

=== "GitHub Releases（手動）"

    1. [GitHub Releases](https://github.com/poingstudios/godot-admob-plugin/releases) ページから最新リリースをダウンロードします。
    2. アーカイブを解凍し、`addons/admob` フォルダを Godot プロジェクトの `res://addons/` ディレクトリにコピーします。
    3. Godot エディタを開き、**プロジェクト -> プロジェクト設定 -> プラグイン** に移動して、**AdMob** プラグインのステータスを **有効** に切り替えます。

有効にすると、プラグインは `MobileAds` 自動読み込みシングルトンをプロジェクトに自動的に登録します。

---

## プラグインテンプレートのダウンロード

プラグインは、モバイルエクスポートをビルドするためにネイティブバイナリテンプレート（Android 用の `.aar`/`.gdap`、iOS 用の `.gdip`/`.xcframework`）を必要とします。取得方法は3つあります：

=== "自動（デフォルト）"

    プラグインを有効にすると、お使いの Godot バージョンに対応する必要なネイティブプラットフォームテンプレートをプロジェクト（`res://android/plugins/` または `res://ios/plugins/`）に自動的にダウンロードして展開します。

=== "AdMob エディタタブ（手動）"

    プラグイン有効化時に自動ダウンロードが失敗した場合、エディタ内で手動実行できます：

    1. エディタ上部の **AdMob** タブを開きます。
    2. **Downloads** サブタブに移動します。
    3. 対象プラットフォーム（**Android** または **iOS**）を選択し、**Download Android Template** または **Download iOS Template** をクリックします。

=== "GitHub Releases（直接 Zip）"

    [GitHub Releases (v1.3.6-godot3)](https://github.com/poingstudios/godot-admob-plugin/releases/tag/v1.3.6-godot3) からテンプレートアーカイブを直接ダウンロードすることもできます：

    1. Godot 3 用のリリースライブラリ（例：`v1.3.6-godot3`）を見つけ、お使いの Godot バージョンに対応する zip アセット（`android-template-v<godot_version>.zip` または `ios-template-v<godot_version>.zip`）をダウンロードします。
    2. アーカイブの内容をプロジェクトのプラットフォームプラグインディレクトリ（Android の場合は `res://android/plugins/`、iOS の場合は `res://ios/plugins/`）に直接展開します。

---

## 設定

**AdMobエディタパネル**（`プロジェクト -> ツール -> AdMobマネージャー`）で、以下のオプションを設定します：

![AdMobエディタ](assets/editor.png)

| オプション | タブ | 説明 |
|-----------|------|------|
| **Enabled** | General | エディタ内のモック広告/プラグイン機能をグローバルに有効/無効化します。 |
| **Child Directed Treatment** | General | 子供向け配信（COPPA）適合設定を行います。 |
| **MaxAdContentRating** | General | 配信される広告の最高コンテンツレーティング（`G`, `PG`, `T`, `MA`）を設定します。 |
| **Banner Size** | Banner | バナーのサイズ（標準、大バナー、中矩形など）を選択します。 |
| **Position** | Banner | バナーの表示位置（上部または下部）を選択します。 |
| **Show Instantly** | Banner | 読み込み時にバナーを自動表示します。 |
| **Respect Safe Area** | Banner | ノッチや画面カットアウトなどのセーフエリアを考慮して配置を調整します。 |

### App ID の設定

実機にエクスポートする前に、対象の各プラットフォームの [AdMob アプリ ID](https://support.google.com/admob/answer/7356431)（`ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY`）を設定してください：

=== "Android"

    `res://android/build/AndroidManifest.xml` の `<application>` タグ内に App ID の `<meta-data>` タグを追加します：

    ```xml
    <!-- AdMob アプリ ID 例: ca-app-pub-3940256099942544~3347511713 -->
    <meta-data
        tools:replace="android:value"
        android:name="com.google.android.gms.ads.APPLICATION_ID"
        android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
    ```

=== "iOS"

    設定ファイルを直接編集することなく、Godot エディタ内で直接 AdMob アプリ ID を設定できます：

    1. **プロジェクト -> エクスポート...** からエクスポートウィンドウを開きます。
    2. **iOS** エクスポートプリセットを選択します。
    3. **オプション** タブで **Plugins Plist** セクションまでスクロールします。
    4. **Gad Application Identifier** フィールドに AdMob アプリ ID（例：`ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy`）を入力します。

    !!! tip "代替設定"
        `res://ios/plugins/admob.gdip` 内の `[plist]` セクションに `GADApplicationIdentifier="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"` を直接事前設定することもできます。

---

## プロジェクトのエクスポート

モバイルプラットフォーム向けにゲームをビルドする場合は、**プロジェクト -> エクスポート...** でエクスポートプリセットを設定します：

=== "Android"

    1. **Android** エクスポートプリセットを選択（または追加）します。
    2. **オプション** タブで：
       - **Custom Build** 内の **Use Custom Build** を **オン** にします（**プロジェクト -> Android ビルドテンプレートのインストール...** が必要です）。
       - **Plugins** 内の **Ad Mob** を **オン** にします。

=== "iOS"

    1. **iOS** エクスポートプリセットを選択（または追加）します。
    2. **オプション** タブで：
       - **Plugins** 内の **Ad Mob** を **オン** にします。

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