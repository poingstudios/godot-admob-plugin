# Google Play データ開示

2021年5月、Google Playは[新しいデータセクションの安全性を発表](https://android-developers.googleblog.com/2021/05/new-safety-section-in-google-play-will.html)しました。これは、アプリのデータ収集、共有、およびセキュリティ慣行に関する開発者による開示です。

このページは、Godot AdMob Pluginの使用に関するこのデータ開示の要件を完了するのに役立ちます。このページでは、Google Mobile Ads SDKがエンドユーザーデータを処理する方法についての情報、およびアプリ開発者として制御できる適用可能な設定や構成を見つけることができます。

!!! note
    **重要**: アプリ開発者として、アプリのデータ収集、共有、およびセキュリティ慣行に関するGoogle Playのデータセクションの安全性フォームへの対応方法を決定する全責任を負います。

このドキュメントは以下に基づいています：

- [Google Mobile Ads SDK for Android - Google Play データ開示](https://developers.google.com/admob/android/privacy/play-data-disclosure)

## このページの情報の使い方

このページでは、Google Mobile Ads SDKの最新バージョンによって収集されるエンドユーザーデータをリストアップしています。以前のバージョンを使用している場合は、アプリの開示が正確であることを確認するために最新バージョンへの更新を検討してください。

データ開示を完了するには、Androidの[データタイプに関するガイド](https://developer.android.com/guide/topics/data/collect-share)を使用して、収集されたデータを最も適切に説明するデータタイプと目的を判断できます。データ開示では、特定のアプリが収集されたデータをどのように共有し使用するかについても考慮してください。

## 自動的に収集および共有されるデータ

Google Mobile Ads SDKは、広告、分析、および不正防止の目的で、以下のデータタイプを*自動的*に収集および共有します。

| データ | デフォルトでは、Google Mobile Ads SDKは... |
|--------|-------------------------------------------|
| **IPアドレス** | デバイスのIPアドレスを収集し、デバイスの一般的な位置を推定するために使用される場合があります。 |
| **ユーザープロDUCTインタラクション** | アプリの起動、タップ、ビデオの視聴など、ユーザープロダクトインタラクションとインタラクション情報を収集します。 |
| **診断情報** | アプリの起動時間、ハングレート、エネルギー使用量など、アプリとSDKのパフォーマンスに関連情報を収集します。 |
| **デバイスとアカウントの識別子** | [Android広告ID](https://support.google.com/googleplay/android-developer/answer/6048248)、[アプリセットID](https://developer.android.com/training/articles/app-set-id)、および該当する場合、デバイスにサインインされたアカウントに関連するその他の識別子を収集します。 |

Google Mobile Ads SDKによって収集されたすべてのユーザーデータは、Transport Layer Security（TLS）プロトコルを使用して暗号化されて送信されます。

## データの取扱い

Android広告IDの収集はオプションです。広告IDは、Androidの設定メニューの広告IDコントロールを使用して、ユーザーがリセットまたは削除できます。アプリ開発者として、[アプリのマニフェストファイルを更新](https://support.google.com/googleplay/android-developer/answer/6048248)することで、広告IDの収集を防ぐことができます。

Google Mobile Ads SDKの他の特定の機能（[Limited Ads](https://support.google.com/admob/answer/10105530)機能など）では、広告IDやその他のデータの送信が無効になる場合もあります。

## 使用内容に応じて収集および共有されるデータ

追加データを含むオプションの製品機能（高度なレポートなど）を使用している場合、または追加データを含む新しい製品機能のテストに参加している場合は、それらの機能やテストに追加のデータ開示が必要かどうかを確認してください。

## その他の有用的なリソース

- Google Play Consoleのデータセクションの安全性フォームを発表する[ブログ記事](https://android-developers.googleblog.com/2021/10/launching-data-safety-in-play-console.html)。
- Play Consoleのデータセクションの安全性フォームは、[アプリコンテンツ](https://play.google.com/console/developers/app/app-content/summary)ページで確認できます。
