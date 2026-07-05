# DT Exchange をメディエーションに統合する

このガイドでは、Google Mobile Ads SDK を使用して、[メディエーション](../get_started.md)を通じて DT Exchange（旧 Fyber）から広告をロードして表示する方法について説明します。DT Exchange を Godot アプリのメディエーション設定に統合する方法、および DT Exchange SDK とアダプターを統合する手順を説明します。

このドキュメントは以下に基づいています：

- [Google Mobile Ads SDK Android ドキュメント（英語）](https://developers.google.com/admob/android/mediation/dt-exchange)
- [Google Mobile Ads SDK iOS ドキュメント（英語）](https://developers.google.com/admob/ios/mediation/dt-exchange)

## サポートされている統合と広告フォーマット

AdMob の DT Exchange メディエーションアダプターには、次の機能があります：

| 統合 |   |
|-------------|---|
| ビッディング（Bidding） | ✅ |
| ウォーターフォール（Waterfall） | ✅ |

| 広告フォーマット |            |
|-----------------------|------------|
| バナー（Banner） | ✅          |
| インタースティシャル（Interstitial） | ✅          |
| リワード（Rewarded） | ✅          |
| リワードインタースティシャル |            |
| ネイティブ（Native） |            |

## 前提条件
- [はじめに](../../index.md) ガイドを完了していること
- メディエーション [はじめに](../get_started.md) ガイドを完了していること

## ステップ 1: DT Exchange の設定
[Android](https://developers.google.com/admob/android/mediation/dt-exchange#step_1_set_up_dt_exchange) または [iOS](https://developers.google.com/admob/ios/mediation/dt-exchange#step_1_set_up_dt_exchange) 用のチュートリアルに従うことをお勧めします。手順は両プラットフォームで共通です。

## ステップ 2: AdMob 広告ユニットのメディエーション設定を行う
[Android](https://developers.google.com/admob/android/mediation/dt-exchange#step_2) または [iOS](https://developers.google.com/admob/ios/mediation/dt-exchange#step_2) 用のチュートリアルに従うことをお勧めします。手順は両プラットフォームで共通です。

## ステップ 3: DT Exchange SDK プラグインのインポート

=== "Android"
    1. [Android](https://github.com/poingstudios/godot-admob-android/releases/latest) 用のプラグインをダウンロードします。
    2. `.zip` ファイルを展開します。中に `dtexchange` フォルダがあります。
    3. `dtexchange` フォルダの内容をコピーし、Android プラグインフォルダの `res://addons/admob/android/bin/` に貼り付けます。

=== "iOS"
    DT Exchange アダプターは、標準の iOS プラグインのダウンロードに**すでに含まれています**。[iOS インストールガイド](../../index.md#download-install)に従っていれば、必要なファイル（`poing-godot-admob-dtexchange.gdip` および関連するフレームワーク）がすでに `res://ios/plugins/` ディレクトリにあるはずです。

## ステップ 4: プラグインの有効化

=== "Android"
    **プロジェクト設定**（`Admob > Android > Mediation > Dtexchange` の下）で **Dtexchange** を必ず有効にしてください。

=== "iOS"
    **iOS エクスポートプリセット**のプラグインリストで、`Ad Mob` と `Ad Mob Dt Exchange` の両方にチェックが入っていることを確認してください（Plists 設定で AdMob アプリ ID を入力するのも忘れないでください）。

## ステップ 5: オプション手順（規制設定）

### GDPR 同意
DT Exchange では、ブール値の同意フラグまたは IAB 同意文字列を介して、GDPR 同意の選択肢を SDK に渡すことができます。

ブール値の GDPR 同意を渡すには、次のコードを使用します：

=== "GDScript"

    ```gdscript
    DTExchange.set_gdpr_consent(true)
    ```

=== "C#"

    ```csharp
    DTExchange.SetGDPRConsent(true);
    ```

GDPR IAB 同意文字列を渡すには、次のコードを使用します：

=== "GDScript"

    ```gdscript
    DTExchange.set_gdpr_consent_string("your_iab_consent_string")
    ```

=== "C#"

    ```csharp
    DTExchange.SetGDPRConsentString("your_iab_consent_string");
    ```

### CCPA（米国州のプライバシー文字列）
CCPA に準拠するため、IAB US プライバシー文字列を設定できます。次のサンプルコードは、この情報を DT Exchange SDK に渡す方法を示しています：

=== "GDScript"

    ```gdscript
    DTExchange.set_ccpa_string("1---")
    ```

=== "C#"

    ```csharp
    DTExchange.SetCCPAString("1---");
    ```
