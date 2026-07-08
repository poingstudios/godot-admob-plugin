# Zucks をメディエーションに統合する

このガイドは、AdMob メディエーションで Zucks を使用したいパブリッシャー向けです。現在の Godot アプリでメディエーションアダプターをセットアップし、追加のリクエストパラメータを構成する手順を説明します。

このドキュメントは以下に基づいています：

- [Google Mobile Ads SDK Android ドキュメント](https://developers.google.com/admob/android/mediation/zucks)
- [Google Mobile Ads SDK iOS ドキュメント](https://developers.google.com/admob/ios/mediation/zucks)

## Zucks のリソース

- [ドキュメント](https://ms.zucksadnetwork.com/media/sdk/manual/admob-mediation/)
- [SDK](https://ms.zucksadnetwork.com/media/sdk/manual/android/)
- [アダプター](https://ms.zucksadnetwork.com/media/sdk/manual/admob-mediation/)
- カスタマーサポート: [support@zucksadnetwork.com](mailto:support@zucksadnetwork.com)

## 前提条件

- [はじめに](../../index.md) ガイドを完了していること
- メディエーションの [はじめに](../get_started.md) ガイドを完了していること

### 役立つ基礎知識

以下のヘルプセンターの記事では、メディエーションに関する背景情報を提供しています：

- [AdMob メディエーションについて](https://support.google.com/admob/answer/1354562)
- [AdMob メディエーションを設定する](https://support.google.com/admob/answer/3124703)
- [AdMob メディエーションを最適化する](https://support.google.com/admob/answer/6162238)

## ネットワークアダプターと SDK を含める

### Android

Zucks は、SDK と AdMob メディエーションアダプターの両方を Maven 経由でのみ配布しています。Android 用のローカルな `.aar` または `.jar` ファイルをダウンロードする必要はありません。

1. Godot プロジェクトに **Android ビルドテンプレート** をインストールします（`プロジェクト > Android ビルドテンプレートのインストール`）。
2. テキストエディタで `android/build/build.gradle` を開きます。
3. `allprojects > repositories` ブロック（または `repositories` ブロック）内に Zucks Maven リポジトリを追加します：
   ```groovy
   repositories {
       // ... その他のリポジトリ
       maven { url 'https://github.com/zucks/ZucksAdNetworkSDK-Maven/raw/master/' }
   }
   ```
4. `dependencies` ブロック内に Zucks メディエーションアダプターの依存関係を追加します（これにより Zucks SDK も推移的にダウンロードされます）：
   ```groovy
   dependencies {
       // ... その他の依存関係
       implementation 'net.zucks:zucks-ad-network-admob-adapter:6.1.0.1' // 最新のアダプターバージョンに置き換えてください
   }
   ```

---

### iOS

メディエーションネットワークの SDK とアダプターファイルを、Godot プロジェクトの適切なディレクトリに含めます：

- **iOS**: Xcode プロジェクト（エクスポート後）

Godot から Xcode プロジェクトを生成した後、選択したネットワークが必要とするフレームワーク、コンパイラフラグ、またはリンカフラグを含めます。

1. [Zucks デベロッパーページ](https://developers.google.com/admob/ios/mediation/zucks) から最新の **Zucks iOS SDK** および **Zucks AdMob アダプター** フレームワークをダウンロードします。
2. Godot プロジェクトを iOS Xcode プロジェクトとしてエクスポートします。
3. エクスポートしたプロジェクトを Xcode で開きます。
4. ダウンロードした Zucks SDK およびアダプターのフレームワークファイル（`.xcframework` または `.framework`）を Xcode プロジェクトにドラッグ＆ドロップします。
5. アプリターゲットの **General** タブで、これらのフレームワークが **Frameworks, Libraries, and Embedded Content** にリストされ、**Embed & Sign** に設定されていることを確認します。

---

アプリはサードパーティの広告ネットワークコードを直接呼び出す必要はありません。Poing Godot AdMob プラグインは、メディエーションネットワークのアダプターと連携して、代わりにサードパーティの広告を取得します。
