# Vpon をメディエーションに統合する

このガイドは、AdMob メディエーションで Vpon を使用したいパブリッシャー向けです。現在の Godot アプリでメディエーションアダプターをセットアップし、追加のリクエストパラメータを構成する手順を説明します。

## Vpon のリソース

- [ドキュメント](https://wiki.vpon.com/android/mediation/admob/)
- [SDK](https://wiki.vpon.com/android/download/index.html)
- [アダプター](https://wiki.vpon.com/android/download/#admob)
- カスタマーサポート: [fae@vpon.com](mailto:fae@vpon.com)

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

1. Godot プロジェクトに **Android ビルドテンプレート** をインストールします（`プロジェクト > Android ビルドテンプレートのインストール`）。
2. Vpon のリソースセクションのリンクから、最新の **Vpon Android SDK** および **Vpon AdMob アダプター**（`.aar` または `.jar` ファイル）をダウンロードします。
3. ダウンロードしたファイルを、Godot プロジェクト内の次のディレクトリにコピーします：
   - `android/build/libs/`
4. テキストエディタで `android/build/build.gradle` を開きます。
5. ダウンロードしたファイルを `dependencies` ブロック内に依存関係として追加します：
   ```groovy
   dependencies {
       // ... その他の依存関係
       implementation files('libs/admob-adapter-2.3.0.aar') // ダウンロードしたアダプターの実際のファイル名に置き換えてください
       implementation files('libs/vpon-sdk-5.8.0.aar') // ダウンロードした SDK の実際のファイル名に置き換えてください
   }
   ```

---

### iOS

メディエーションネットワークの SDK とアダプターファイルを、Godot プロジェクトの適切なディレクトリに含めます：

- **iOS**: Xcode プロジェクト（エクスポート後）

Godot から Xcode プロジェクトを生成した後、選択したネットワークが必要とするフレームワーク、コンパイラフラグ、またはリンカフラグを含めます。

1. [Vpon デベロッパーページ](https://developers.google.com/admob/ios/mediation/vpon) から最新の **Vpon iOS SDK** および **Vpon AdMob アダプター** フレームワークをダウンロードします。
2. Godot プロジェクトを iOS Xcode プロジェクトとしてエクスポートします。
3. エクスポートしたプロジェクトを Xcode で開きます。
4. ダウンロードした Vpon SDK およびアダプターのフレームワークファイル（`.xcframework` または `.framework`）を Xcode プロジェクトにドラッグ＆ドロップします。
5. アプリターゲットの **General** タブで、これらのフレームワークが **Frameworks, Libraries, and Embedded Content** にリストされ、**Embed & Sign** に設定されていることを確認します。

---

アプリはサードパーティの広告ネットワークコードを直接呼び出す必要はありません。Poing Godot AdMob プラグインは、メディエーションネットワークのアダプターと連携して、代わりにサードパーティの広告を取得します。
