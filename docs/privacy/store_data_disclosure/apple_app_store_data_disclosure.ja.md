# Apple App Store データ開示

Appleは、App Storeでアプリを公開する開発者に対して、アプリのデータ使用に関する[ certain information](https://developer.apple.com/app-store/app-privacy-details/)の提供を要求しています。このガイドは、Google Mobile Ads SDKのデータ収集慣行を説明し、AdMob開発者がApp Store Connectの質問に答えることを容易にします。

!!! note
    **重要**: アプリ開発者として、App Store Connectのプライバシー質問に対し、アプリのデータ収集および使用慣行に関して回答方法を決定する全責任を負います。

このドキュメントは以下に基づいています：

- [Google Mobile Ads SDK for iOS - Apple App Store データ開示](https://developers.google.com/admob/ios/privacy/data-disclosure)

## Google Mobile Ads SDKによって収集されるデータ

AdMobのパフォーマンスを改善するために、Google Mobile Ads SDKはアプリから certain information を収集する場合があります：

| データタイプ | 目的 |
|-------------|------|
| **IPアドレス** | デバイスの一般的な位置を推定するために使用される場合があります。 |
| **ユーザーに関連しないクラッシュログ** | 問題を診断し、SDKを改善するために使用される場合があります。診断情報は広告および分析目的でも使用される場合があります。 |
| **ユーザー関連のパフォーマンスデータ** | アプリの起動時間、ハングレート、エネルギー使用量など。これらはユーザーの行動を評価し、既存の製品機能の有効性を理解し、新しい機能を計画するために使用される場合があります。パフォーマンスデータは広告の表示にも使用される場合があり、広告を表示する他のエンティティと共有される場合があります。 |
| **デバイスID** | デバイスの広識別子またはアプリまたは開発者に紐づくその他のデバイス識別子など。これらは第三者の広告および分析の目的で使用される場合があります。 |
| **広告データ** | ユーザーが見た広告など。分析および広告広告機能を駆動するために使用される場合があります。 |
| **その他のユーザープロダクトインタラクション** | アプリの起動タップやビデオの視聴などのインタラクション情報。広告パフォーマンスの改善に使用される場合があります。 |

Google Mobile Ads SDKによって収集されたすべてのユーザーデータは、Transport Layer Security（TLS）プロトコルを使用して暗号化されて送信されます。

## Appleのプライバシーマニフェストファイル

Google Mobile Ads SDKバージョン11.2.0以降は、プライバシーマニフェストの宣言をサポートしています。プライバシーマニフェストを確認し、アプリのデータ開示が最新であることを確認する責任があります。

プライバシーレポートの解釈方法の詳細については、[Appleドキュメント](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests)を参照してください。アプリ送信要件の[適用更新](https://developer.apple.com/news/?id=pvszzano)も参照してください。

## 追加のデータ開示

追加データを含むオプションの製品機能（高度なレポートなど）を使用している場合、または追加データを含む新しい製品機能のテストに参加している場合は、それらの機能やテストに追加のデータ開示が必要かどうかを確認してください。

以前のバージョンのGoogle Mobile Ads SDKを使用している場合は、アプリの開示が正確であることを確認するために最新バージョンへの更新を検討してください。Google Mobile Ads SDKは時間とともに更新され続けます。必要に応じて、開示を確認および更新してください。
