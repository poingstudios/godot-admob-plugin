# メディエーションでの maio の統合

このガイドでは、Google Mobile Ads SDK を使用して、[メディエーション](../get_started.md)を通じて maio から広告を読み込んで表示する方法を説明します。maio を Godot アプリのメディエーション設定に統合し、maio SDK とアダプターを統合する手順を提供します。

このドキュメントは以下に基づいています：

- [Google Mobile Ads SDK Android ドキュメント](https://developers.google.com/admob/android/mediation/maio)
- [Google Mobile Ads SDK iOS ドキュメント](https://developers.google.com/admob/ios/mediation/maio)

## サポートされている統合と広告フォーマット

maio 用の AdMob メディエーション アダプターには、次の機能があります：

| 統合 |   |
|-------------|---|
| ビッディング (Bidding)     |   |
| ウォーターフォール (Waterfall)   | ✅ |

| フォーマット               |            |
|-----------------------|------------|
| バナー (Banner)                |            |
| インタースティシャル (Interstitial)          | ✅          |
| リワード (Rewarded)              | ✅          |
| リワード インタースティシャル (Rewarded Interstitial) |            |
| ネイティブ (Native)                |            |

## 前提条件
- [スタートガイド](../../index.md)を完了する
- [メディエーション スタートガイド](../get_started.md)を完了する

## ステップ 1: maio のセットアップ
Android 用のチュートリアル [Android](https://developers.google.com/admob/android/mediation/maio#step_1_set_up_maio) または iOS 用のチュートリアル [iOS](https://developers.google.com/admob/ios/mediation/maio#step_1_set_up_maio) に従うことをお勧めします。これは両方のプラットフォームで共通です。

## ステップ 2: AdMob 広告ユニットのメディエーション設定を構成する
Android 用のチュートリアル [Android](https://developers.google.com/admob/android/mediation/maio#step_2) または iOS 用のチュートリアル [iOS](https://developers.google.com/admob/ios/mediation/maio#step_2) に従うことをお勧めします。これは両方のプラットフォームで共通です。

## ステップ 3: maio SDK プラグインをインポートする

=== "Android"
    1. [Android](https://github.com/poingstudios/godot-admob-android/releases/latest) 用のプラグインをダウンロードします。
    2. `.zip` ファイルを展開します。内部に `maio` フォルダがあります。
    3. `maio` フォルダのコンテンツをコピーし、`res://addons/admob/android/bin/` の Android プラグイン フォルダに貼り付けます。

=== "iOS"
    maio アダプターは、標準の iOS プラグイン ダウンロードに**すでに含まれています**。[iOS インストール ガイド](../../index.md#download-install)に従った場合、必要なファイル (`poing-godot-admob-maio.gdip`) がすでに `res://ios/plugins/` ディレクトリに存在しているはずです。

## ステップ 4: プラグインを有効にする

=== "Android"
    **プロジェクト設定**（`Admob > Android > Mediation > Maio`）で **Maio** を有効にしてください。

=== "iOS"
    **iOS エクスポート プリセット**のプラグイン リストで `Ad Mob` と `Ad Mob Maio` の両方にチェックが入っていることを確認してください（Plists 設定に AdMob App ID を入力することも必要です）。

## ステップ 5: 必要なコードを追加する
このパートナー統合では、追加のコード構成は不要です。
