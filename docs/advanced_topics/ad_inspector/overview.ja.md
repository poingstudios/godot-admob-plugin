# 概要

広告インスペクターは、テスト広告リクエストのリアルタイム分析をアプリ内で直接実行できるアプリ内オーバーレイです。

!!! warning "警告"
    広告インスペクターを有効にすると、テストデバイスでの Google Mobile Ads SDK のメモリ使用量が増加します。広告インスペクターは**テストデバイス**でのみ起動します。

## 前提条件

広告インスペクターを使用する前に、以下のタスクを完了する必要があります。

1. AdMob アカウントの作成。
2. AdMob でのアプリの設定。
3. [Google Mobile Ads SDK の設定](../../index.md)。
4. デバイスを[テストデバイス](../../enable_test_ads.md)として追加。

## エラー処理

広告インスペクターが閉じると、コールバックはエラー情報を含む `Dictionary` を受信します。広告インスペクターが正常に終了した場合、ディクショナリは空になります。

| フィールド | 型 | 説明 |
|-------|------|-------------|
| `code` | `int` | エラーコード |
| `message` | `string` | 人間が読める形式のエラーメッセージ |
| `domain` | `string` | エラーのドメイン |

## 参照

- [Android Ad Inspector](https://developers.google.com/admob/android/ad-inspector)
- [iOS Ad Inspector](https://developers.google.com/admob/ios/ad-inspector)
