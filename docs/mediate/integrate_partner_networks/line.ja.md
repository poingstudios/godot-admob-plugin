# メディエーションでの LINE Ads Network の統合

このガイドでは、Google Mobile Ads SDK を使用して、[メディエーション](../get_started.md)を通じて LINE Ads Network (FiveAd) から広告を読み込んで表示する方法を説明します。LINE Ads Network を Godot アプリのメディエーション設定に統合し、LINE Ads Network SDK とアダプターを統合する手順を提供します。

このドキュメントは以下に基づいています：

- [Google Mobile Ads SDK Android ドキュメント](https://developers.google.com/admob/android/mediation/line)
- [Google Mobile Ads SDK iOS ドキュメント](https://developers.google.com/admob/ios/mediation/line)

## サポートされている統合と広告フォーマット

LINE Ads Network 用の AdMob メディエーション アダプターには、次の機能があります：

| 統合 |   |
|-------------|---|
| ビッディング (Bidding)     | ✅ |
| ウォーターフォール (Waterfall)   | ✅ |

| フォーマット               |            |
|-----------------------|------------|
| バナー (Banner)                | ✅          |
| インタースティシャル (Interstitial)          | ✅          |
| リワード (Rewarded)              | ✅          |
| リワード インタースティシャル (Rewarded Interstitial) |            |
| ネイティブ (Native)                |            |

## 前提条件
- [スタートガイド](../../index.md)を完了する
- [メディエーション スタートガイド](../get_started.md)を完了する

## ステップ 1: LINE Ads Network のセットアップ
Android 用のチュートリアル [Android](https://developers.google.com/admob/android/mediation/line#step_1_set_up_line_ads_network) または iOS 用のチュートリアル [iOS](https://developers.google.com/admob/ios/mediation/line#step_1_set_up_line_ads_network) に従うことをお勧めします。これは両方のプラットフォームで共通です。

## ステップ 2: AdMob 広告ユニットのメディエーション設定を構成する
Android 用のチュートリアル [Android](https://developers.google.com/admob/android/mediation/line#step_2) または iOS 用のチュートリアル [iOS](https://developers.google.com/admob/ios/mediation/line#step_2) に従うことをお勧めします。これは両方のプラットフォームで共通です。

## ステップ 3: LINE Ads Network SDK プラグインをインポートする

=== "Android"
    1. [Android](https://github.com/poingstudios/godot-admob-android/releases/latest) 用のプラグインをダウンロードします。
    2. `.zip` ファイルを展開します。内部に `line` フォルダがあります。
    3. `line` フォルダのコンテンツをコピーし、`res://addons/admob/android/bin/` の Android プラグイン フォルダに貼り付けます。

=== "iOS"
    LINE Ads Network アダプターは、標準の iOS プラグイン ダウンロードに**すでに含まれています**。[iOS インストール ガイド](../../index.md#download-install)に従った場合、必要なファイル (`poing-godot-admob-line.gdip`) がすでに `res://ios/plugins/` ディレクトリに存在しているはずです。

## ステップ 4: プラグインを有効にする

=== "Android"
    **プロジェクト設定**（`Admob > Android > Mediation > Line`）で **Line** を有効にしてください。

=== "iOS"
    **iOS エクスポート プリセット**のプラグイン リストで `Ad Mob` と `Ad Mob Line` の両方にチェックが入っていることを確認してください（Plists 設定に AdMob App ID を入力することも必要です）。
