# はじめに

AdMob 插件を Godot プロジェクト（特に Godot v4.2 以降）に統合することは、広告を表示して収益を上げるための最初で最も重要なステップです。このプラグインの導入に成功すると、バナー広告やインタースティシャル広告など、さまざまな広告フォーマットを選択し、必要な実装手順を進めることができるようになります。

本文書は以下に基づいています。

- [Google Mobile Ads SDK Android 公式ドキュメント](https://developers.google.com/admob/android/quick-start)
- [Google Mobile Ads SDK iOS 公式ドキュメント](https://developers.google.com/admob/ios/quick-start)

## 前提条件

- Android への展開:
	- Godot v4.2 以上を使用
	- `minSdkVersion` が 24 以上
	- `compileSdkVersion` が 36 以上
- iOS への展開:
	- Godot v4.1 以上を使用
	- Xcode 26.2 以上を使用
	- iOS 14.0 以上をターゲット
- 推奨: [AdMob アカウントの作成](https://support.google.com/admob/answer/7356219?visit_id=638286911958663013-3847536692&rd=1) および [アプリの登録](https://support.google.com/admob/answer/9989980?visit_id=638286911964685099-3190075945&rd=1)。

## Poing Studios からの Godot AdMob プラグインのダウンロード

Poing Studios の Godot AdMob プラグインを使用すると、Godot 開発者は Java/Kotlin や Objective-C++ コードを書くことなく、Google モバイル広告を Android および iOS アプリに簡単に組み込むことができます。このプラグインは、広告リクエストのための GDScript および C# ベースのインターフェースを提供し、プロジェクトにシームレスに統合できます。

プラグインにアクセスするには、提供されている Godot パッケージをダウンロードするか、以下のリンクから GitHub 上のソースコードを参照してください。

[GitHub からダウンロード](https://github.com/poingstudios/godot-admob-plugin/releases/latest){ .md-button .md-button--primary } [アセットストアからダウンロード](https://store.godotengine.org/asset/poingstudios/admob/){ .md-button .md-button--primary } [ソースコード](https://github.com/poingstudios/godot-admob-plugin){ .md-button .md-button--primary }

### プロジェクトへの Godot AdMob プラグインのインポート

Godot 用の AdMob プラグインは、Godot アセットストアから便利に入手できます。プラグインをプロジェクトにインポートするには、次の手順を実行します。

1. Godot プロジェクトを開きます。
2. Godot エディタ内の「アセットストア（AssetLib）」に移動します。
3. 検索バーに「AdMob」と入力し、パブリッシャーが「Poing Studios」に設定されていることを確認します。
![activate_plugin](assets/asset_store.png)
4. AdMob プラグインを見つけ、「ダウンロード」ボタンをクリックします。
5. ダウンロードが完了したら、Godot エディタ内で「プロジェクト → プロジェクト設定」に移動します。
6. 「プラグイン」セクションで「AdMob」プラグインを見つけて有効にします。
![activate_plugin](assets/activate_plugin.png)
7. Android および iOS のライブラリが自動的にダウンロードおよびインストールされます。
8. 以上の手順により、追加の手動インポートを行うことなく、AdMob プラグインのプロジェクトへの統合が成功します。

## ダウンロードとインストール {: #download-install }
!!! info

    このセクションは通常**不要**です。プラグインはライブラリを自動的に処理するためです。自動ダウンロードが失敗した場合のみ、これらの手順に従ってください。

=== "Android"

	Godot で AdMob に必要な Android ライブラリを統合するには、次の手順に従います。

	1. Godot で、「プロジェクト → ツール → AdMob Manager → Android → Download & Install」に移動します。
	2. この操作により、適切な Android ライブラリがダウンロードされ、プロジェクトの `res://addons/admob/android/bin/` にインストールされます。

	ダウンロードで問題が発生した場合は、[こちら](https://github.com/poingstudios/godot-admob-android/releases/latest)をクリックしてライブラリを手動でダウンロードしてみてください。

=== "iOS"

	Godot で AdMob に必要な iOS ライブラリを統合するには、次の手順に従います。

	1. Godot で、「プロジェクト → ツール → AdMob Manager → iOS → Download & Install」に移動します。
	2. この操作により、必要な iOS ライブラリが自動的にダウンロードされ、プロジェクトの `res://ios/plugins/` にインストールされます。

	ダウンロードで問題が発生した場合は、[こちら](https://github.com/poingstudios/godot-admob-ios/releases/latest)をクリックしてライブラリを手動でダウンロードしてみてください。

### エクスポート 

=== "Android"

	1. 「プロジェクト → Android ビルドテンプレートのインストール」に移動して、[Android ビルドテンプレート](https://docs.godotengine.org/ja/stable/tutorials/export/android_gradle_build.html)をインストールします。
	2. 「プロジェクト → プロジェクト設定... → 一般」で Android プリセットのオプションを設定します。
	    - 左側のサイドバーで **Admob** セクションを見つけ、**Android** をクリックします。
	    - `App Id` フィールドに自身の [AdMob アプリ ID](https://support.google.com/admob/answer/7356431) を追加します。
	    - それぞれのチェックボックスを切り替えることで、`Enabled` およびメディエーションプラグイン（`Mediation/Meta`、`Mediation/Vungle`）を有効または無効にします。
	
	    !!! tip "アプリ ID と広告ユニット ID の違い"
	        - **アプリ ID**（`~` を含む）: アプリの登録と内部設定に使用されます。
	        - **広告ユニット ID**（`/` を含む）: コード内で特定の広告フォーマットをロードするために使用されます。
	
	3. プロジェクトをエクスポートする際、`Use Gradle Build` を選択します。
	
	    ![export](assets/android/export.png)

=== "iOS"
    
    1. プロジェクトをエクスポートする際、`GADApplicationIdentifier` を自身の [AdMob アプリ ID](https://support.google.com/admob/answer/7356431) で更新し、エクスポートダイアログのプラグインセクションで `Ad Mob` が有効になっていることを確認します。メディエーションを使用している場合は、`Ad Mob Meta` などもマークしてください。
    
        ![gadapplicationidentifier](assets/ios/gadapplicationidentifier.png)
    
        !!! tip "アプリ ID と 広告ユニット ID の違い"
            - **アプリ ID**（`~` を含む）: アプリの登録と内部設定に使用されます。
            - **広告ユニット ID**（`/` を含む）: コード内で特定の広告フォーマットをロードするために使用されます。
    
    2. **これで完了です！** このプラグインは `.xcframework` バンドルを使用しているため、Godot 4.2+ は必要なすべてのライブラリとフレームワークを Xcode プロジェクトに自動的に統合します。手動でのターミナルコマンド、CocoaPods、または Xcode 設定手順は必要ありません。
    
    3. [「__swift_FORCE_LOAD_」エラーが発生している場合は、こちらをお読みください](https://github.com/poingstudios/godot-admob-ios/issues/127)。
    
        1. Xcode プロジェクトに `Untitled.swift` ファイルを作成します。
        2. Xcode は `Create Bridge Header`（ブリッジングヘッダーを作成するか）と尋ねてくるので、`Accept`（同意）します。
        3. プロジェクトは正常にビルドできるようになります。
            ![untitled.swift](assets/ios/untitled.swift.png)
    
    4. ゲームを実行します。
    
    5. [シミュレータで実行しようとして動作しない場合は、こちらをお読みください](https://github.com/godotengine/godot/issues/44681#issuecomment-751399783)。

## Google Mobile Ads SDK の初期化 {: #initialize-the-google-mobile-ads-sdk }
広告を読み込む前に、アプリケーションが Google Mobile Ads SDK を初期化していることを確認してください。これは `MobileAds.initialize()` を呼び出すことで実行できます。この関数は SDK を初期化し、初期化プロセスが完了するか、30 秒のタイムアウトを超えると完了リスナーをトリガーします。この初期化は、アプリの起動時に 1 回だけ行う必要がある点に注意してください。

=== "GDScript"

    ```gdscript
    func _ready() -> void:
    	MobileAds.initialize()
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
    	MobileAds.Initialize();
    }
    ```

メディエーションを使用している場合は、広告の読み込みを進める前に完了ハンドラーが呼び出されるのを待つことが重要です。これにより、広告リクエストが行われる前に、すべてのメディエーションアダプタが適切に初期化されます。

## 広告フォーマットの選択
Google Mobile Ads SDK が正常にインポートされたので、アプリに広告を統合する準備が整いました。AdMob はさまざまな広告フォーマットを提供しており、アプリのユーザー体験に最も適したものを選択できます。

### アプリ起動時広告 (App Open)
<div class="image-text-container" markdown="1">

![app_open](https://developers.google.com/static/admob/images/format-app-open.svg)

アプリ起動時広告は、ユーザーがアプリを開いたとき、またはアプリに戻ったときに表示される広告フォーマットです。広告はロード画面をオーバーレイします。

</div>

[アプリ起動時広告を実装する](ad_formats/app_open.md){ .md-button .md-button--primary }

### バナー広告 (Banner)
<div class="image-text-container" markdown="1">

![banner](assets/ad_formats/banner.png)

バナー広告は、アプリのレイアウトに統合される、画像またはテキストで構成される長方形の広告です。ユーザーがアプリを操作している間も画面上に残り、指定した時間間隔で自動的に更新されます。モバイル広告を初めて利用する場合は、バナー広告から始めるのが最適です。

</div>

[バナー広告を実装する](ad_formats/banner/get_started.md){ .md-button .md-button--primary }

### インタースティシャル広告 (Interstitial)
<div class="image-text-container" markdown="1">

![interstitial](assets/ad_formats/interstitial.png)

インタースティシャル広告は、アプリのインターフェースを覆い、ユーザーによって閉じられるまで表示される全画面広告です。ゲームのステージ間やタスク完了直後など、アプリの実行中の自然な一時停止のタイミングで戦略的に配置すると最も効果的です。

</div>

[インタースティシャル広告を実装する](ad_formats/interstitial.md){ .md-button .md-button--primary }

### ネイティブオーバーレイ広告 (Native Overlay)
<div class="image-text-container" markdown="1">

![native_overlay](https://developers.google.com/static/admob/images/format-native.svg)

ネイティブオーバーレイ広告を使用すると、事前設計されたテンプレートを使用して、アプリのコンテンツの上にアプリのルック＆フィールに合わせたスタイルの広告を表示できます。簡単な統合を維持しながら、色、フォント、レイアウトオプションのカスタマイズをサポートします。

</div>

[ネイティブオーバーレイ広告を実装する](ad_formats/native_overlay.md){ .md-button .md-button--primary }

### リワード広告 (Rewarded)
<div class="image-text-container" markdown="1">

![rewarded](assets/ad_formats/rewarded.png)

リワード動画広告は、ユーザーがそれを完全に視聴することを選択できる、没入型の全画面動画広告です。視聴時間と引き換えに、ユーザーはアプリ内報酬や特典を受け取ります。

</div>

[リワード広告を実装する](ad_formats/rewarded.md){ .md-button .md-button--primary }

### リワードインタースティシャル広告 (Rewarded Interstitial)
<div class="image-text-container" markdown="1">

![rewarded_interstitial](assets/ad_formats/rewarded_interstitial.png)

リワードインタースティシャル広告は、アプリの自然な切り替え時に自動的に表示される広告と引き換えに報酬を提供できる、インセンティブ付き広告フォーマットの一種です。通常のユーザーの選択によるリワード広告とは異なり、ユーザーは視聴を明示的に選択する義務はなく、アプリの体験にシームレスに統合されます。

</div>

[リワードインタースティシャル広告を実装する](ad_formats/rewarded_interstitial.md){ .md-button .md-button--primary }

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
