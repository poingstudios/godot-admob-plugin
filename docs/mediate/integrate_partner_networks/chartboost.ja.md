# メディエーションによる Chartboost の統合

このガイドでは、Google Mobile Ads SDK を使用して、[メディエーション](../get_started.md)を通じて Chartboost から広告をロードおよび表示する方法について説明します。Chartboost を Godot アプリのメディエーション設定に統合し、Chartboost SDK とアダプターを Godot アプリに統合する手順について説明します。

このドキュメントは以下に基づいています：

- [Google Mobile Ads SDK Android ドキュメント (英語)](https://developers.google.com/admob/android/mediation/chartboost)
- [Google Mobile Ads SDK iOS ドキュメント (英語)](https://developers.google.com/admob/ios/mediation/chartboost)

## サポートされている統合と広告フォーマット

Chartboost 用の AdMob メディエーション アダプターには、以下の機能があります：

| 統合 |   |
|-------------|---|
| Bidding     | ✅ |
| Waterfall   | ✅ |

| フォーマット |            |
|-----------------------|------------|
| バナー | ✅ |
| インタースティシャル | ✅ |
| リワード | ✅ |
| リワード インタースティシャル | |
| ネイティブ | |

## 前提条件
- [スタートガイド](../../index.md)を完了する
- [メディエーション スタートガイド](../get_started.md)を完了する

## ステップ 1: Chartboost を設定する
[Android](https://developers.google.com/admob/android/mediation/chartboost#step_1_set_up_chartboost) または [iOS](https://developers.google.com/admob/ios/mediation/chartboost#step_1_set_up_chartboost) の チュートリアルに従うことをお勧めします。どちらも手順は同じです。

## ステップ 2: AdMob 広告ユニットのメディエーション設定を構成する
[Android](https://developers.google.com/admob/android/mediation/chartboost#step_2) または [iOS](https://developers.google.com/admob/ios/mediation/chartboost#step_2) のチュートリアルに従うことをお勧めします。どちらも手順は同じです。

## ステップ 3: Chartboost SDK プラグインをインポートする

=== "Android"
    1. [Android](https://github.com/poingstudios/godot-admob-android/releases/latest) 用のプラグインをダウンロードします。
    2. `.zip` ファイルを解凍します。中に `chartboost` フォルダがあります。
    3. `chartboost` フォルダの内容をコピーし、`res://addons/admob/android/bin/` にある Android プラグイン フォルダに貼り付けます。

=== "iOS"
    Chartboost アダプターは、標準の iOS プラグイン ダウンロードに**既に含まれています**。[iOS インストール ガイド](../../index.md#download-install)に従った場合、必要なファイル（`poing-godot-admob-chartboost.gdip` と関連するフレームワーク）が `res://ios/plugins/` ディレクトリに既に存在しているはずです。

## ステップ 4: プラグインを有効にする

=== "Android"
    **プロジェクト設定**（`Admob > Android > Mediation > Chartboost` の下）で **Chartboost** を有効にしてください。

=== "iOS"
    **iOS エクスポート プリセット**のプラグイン リストで、`Ad Mob` と `Ad Mob Chartboost` の両方にチェックが入っていることを確認してください（Plists 設定に AdMob アプリ ID を入力することも忘れないでください）。

## ステップ 5: オプションの手順（規制設定）

### EU の同意と GDPR
Google の [EU ユーザーの同意ポリシー](https://www.google.com/about/company/consentstaging.html)に基づき、欧州経済領域（EEA）のユーザーに対して特定の開示を行い、Cookie やその他のローカル ストレージの使用、および個人データの使用に対する同意を得る必要があります。

GDPR の同意情報を Chartboost SDK に渡すには、以下のコードを使用します：

=== "GDScript"

    ```gdscript
    Chartboost.set_consent(true)
    ```

=== "C#"

    ```csharp
    Chartboost.SetConsent(true);
    ```

### CCPA
CCPA に準拠するために、「販売しない（do not sell）」設定を行うことができます。同意情報を Chartboost SDK に渡す方法を以下のコードサンプルに示します：

=== "GDScript"

    ```gdscript
    Chartboost.set_ccpa_consent(true)
    ```

=== "C#"

    ```csharp
    Chartboost.SetCCPAConsent(true);
    ```
