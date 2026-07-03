# メディエーションによる Unity Ads の統合

このガイドでは、Google Mobile Ads SDK を使用して、[メディエーション](../get_started.md)を通じて Unity Ads から広告をロードおよび表示する方法について説明します。Unity Ads を Godot アプリのメディエーション設定に統合し、Unity Ads SDK とアダプターを Godot アプリに統合する手順について説明します。

このドキュメントは以下に基づいています：

- [Google Mobile Ads SDK Android ドキュメント (英語)](https://developers.google.com/admob/android/mediation/unity)
- [Google Mobile Ads SDK iOS ドキュメント (英語)](https://developers.google.com/admob/ios/mediation/unity)

## サポートされている統合と広告フォーマット

Unity Ads 用の AdMob メディエーション アダプターには、以下の機能があります：

| 統合 |   |
|-------------|---|
| Bidding     | ✅ |
| Waterfall   | ✅ |

| フォーマット |            |
|-----------------------|------------|
| バナー | ✅ |
| インタースティシャル | ✅ |
| リワード | ✅ |
| リワード インタースティシャル | ✅ |

## 前提条件
- [スタートガイド](../../index.md)を完了する
- [メディエーション スタートガイド](../get_started.md)を完了する

## ステップ 1: Unity Ads を設定する
[Android](https://developers.google.com/admob/android/mediation/unity#step_1_set_up_unity_ads) または [iOS](https://developers.google.com/admob/ios/mediation/unity#step_1_set_up_unity_ads) のチュートリアルに従うことをお勧めします。どちらも手順は同じです。

## ステップ 2: AdMob 広告ユニットのメディエーション設定を構成する
[Android](https://developers.google.com/admob/android/mediation/unity#step_2) または [iOS](https://developers.google.com/admob/ios/mediation/unity#step_2) のチュートリアルに従うことをお勧めします。どちらも手順は同じです。

## ステップ 3: Unity Ads SDK プラグインをインポートする

=== "Android"
    1. [Android](https://github.com/poingstudios/godot-admob-android/releases/latest) 用のプラグインをダウンロードします。
    2. `.zip` ファイルを解凍します。中に `unity_ads` フォルダがあります。
    3. `unity_ads` フォルダの内容をコピーし、`res://addons/admob/android/bin/` にある Android プラグイン フォルダに貼り付けます。

=== "iOS"
    Unity Ads アダプターは、標準の iOS プラグイン ダウンロードに**既に含まれています**。[iOS インストール ガイド](../../index.md#download-install)に従った場合、必要なファイル（`poing-godot-admob-unity_ads.gdip` と関連するフレームワーク）が `res://ios/plugins/` ディレクトリに既に存在しているはずです。

## ステップ 4: プラグインを有効にする

=== "Android"
    **プロジェクト設定**（`Admob > Android > Mediation > Unity Ads` の下）で **Unity Ads** を有効にしてください。

=== "iOS"
    **iOS エクスポート プリセット**のプラグイン リストで、`Ad Mob` と `Ad Mob Unity Ads` の両方にチェックが入っていることを確認してください（Plists 設定に AdMob アプリ ID を入力することも忘れないでください）。

## ステップ 5: 追加設定

### EU ユーザーの同意ポリシー
Unity Ads SDK に同意情報を渡すには、以下のコードを使用します：

=== "GDScript"

    ```gdscript
    UnityAds.set_consent(true)
    ```

=== "C#"

    ```csharp
    UnityAds.SetConsent(true);
    ```

### プライバシーの同意
プライバシーの同意（例：CCPA 用）を設定するには、以下のコードを使用します：

=== "GDScript"

    ```gdscript
    UnityAds.set_privacy_consent("user_privacy_data", true)
    ```

=== "C#"

    ```csharp
    UnityAds.SetPrivacyConsent("user_privacy_data", true);
    ```
