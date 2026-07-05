# メディエーションで IronSource を統合する

このガイドでは、[メディエーション](../get_started.md)を通じて IronSource から広告をロードして表示するために、Google Mobile Ads SDK を利用する方法について説明します。Godot アプリのメディエーション構成に IronSource を統合する方法、および IronSource SDK とアダプターを Godot アプリに統合する方法を示します。

このドキュメントは以下に基づいています。

- [Google Mobile Ads SDK Android ドキュメント](https://developers.google.com/admob/android/mediation/ironsource)
- [Google Mobile Ads SDK iOS ドキュメント](https://developers.google.com/admob/ios/mediation/ironsource)

## サポートされている統合と広告フォーマット

IronSource 用の AdMob メディエーション アダプターは、以下の機能を備えています。

| 統合方法 |   |
|-------------|---|
| 入札 (Bidding) | ✅ |
| ウォーターフォール | ✅ |

| 広告フォーマット |            |
|-----------------------|------------|
| バナー                | ✅          |
| インタースティシャル          | ✅          |
| リワード              | ✅          |
| リワード インタースティシャル | ✅ [^1]    |
| ネイティブ                |            |

[^1]: このフォーマットは、ウォーターフォール統合のみでサポートされています。

## 前提条件
- [スタートガイド](../../index.md)を完了していること
- メディエーションの[スタートガイド](../get_started.md)を完了していること

## ステップ 1: IronSource のセットアップ
Android および iOS で共通の手順となるため、[Android](https://developers.google.com/admob/android/mediation/ironsource#step_1_set_up_ironsource) または [iOS](https://developers.google.com/admob/ios/mediation/ironsource#step_1_set_up_ironsource) のチュートリアルに従うことをお勧めします。

## ステップ 2: AdMob 広告ユニットのメディエーション設定を構成する
Android および iOS で共通の手順となるため、[Android](https://developers.google.com/admob/android/mediation/ironsource#step_2) または [iOS](https://developers.google.com/admob/ios/mediation/ironsource#step_2) のチュートリアルに従うことをお勧めします。

## ステップ 3: IronSource SDK プラグインをインポートする

=== "Android"
    1. [Android](https://github.com/poingstudios/godot-admob-android/releases/latest) 用のプラグインをダウンロードします。
    2. `.zip` ファイルを展開します。内部に `ironsource` フォルダがあります。
    3. `ironsource` フォルダの内容をコピーし、Godot プロジェクトの Android プラグインフォルダである `res://addons/admob/android/bin/` に貼り付けます。

=== "iOS"
    IronSource アダプターは、標準の iOS プラグインのダウンロードに**すでに含まれています**。[iOS インストール ガイド](../../index.md#download-install)に従っていれば、必要なファイル（`poing-godot-admob-ironsource.gdip` および関連するフレームワーク）はすでに `res://ios/plugins/` ディレクトリに存在しているはずです。

## ステップ 4: プラグインを有効にする

=== "Android"
    **プロジェクト設定**（`Admob > Android > Mediation > Ironsource` の下）で **IronSource** が有効になっていることを確認してください。

=== "iOS"
    **iOS エクスポート プリセット**のプラグイン リストで `Ad Mob` と `Ad Mob Iron Source` の両方にチェックが入れられており、Plist 構成に AdMob App ID が入力されていることを確認してください。

## ステップ 5: 任意のステップ (規制設定)

### EU ユーザーの同意と GDPR
Google の [EU ユーザーの同意ポリシー](https://www.google.com/about/company/consentstaging.html)に基づき、欧州経済領域（EEA）のユーザーに対して特定の情報を開示し、Cookie またはその他のローカル ストレージの使用、および個人データの使用について同意を得る必要があります。

IronSource SDK に GDPR 同意情報を渡すには、次のコードを使用します。

=== "GDScript"

    ```gdscript
    IronSource.set_consent(true)
    ```

=== "C#"

    ```csharp
    IronSource.SetConsent(true);
    ```

### CCPA
CCPA を遵守するために、メタデータの設定を行うことができます。以下のサンプルコードは、この情報を IronSource SDK に渡す方法を示しています。

=== "GDScript"

    ```gdscript
    IronSource.set_metadata("do_not_sell", "false")
    ```

=== "C#"

    ```csharp
    IronSource.SetMetaData("do_not_sell", "false");
    ```

### ユーザー ID
リワード広告の統合で IronSource ユーザー ID を設定するには、次のコードを使用します。

=== "GDScript"

    ```gdscript
    IronSource.set_user_id("unique_user_id_123")
    ```

=== "C#"

    ```csharp
    IronSource.SetUserId("unique_user_id_123");
    ```
