# 広告配信モード

Google の [EU ユーザー同意ポリシー](https://www.google.com/about/company/user-consent-policy.html)に基づき、欧州経済領域 (EEA) および英国のユーザーに対して特定の開示を行い、法律で要件とされる場合には Cookie またはその他のローカル ストレージの使用について、また広告のパーソナライズ用途での個人データの収集、共有、使用について同意を得る必要があります。このポリシーは、EU ePrivacy 指令および一般データ保護規則 (GDPR) の要件を反映しています。このポリシーを遵守するため、パブリッシャーは [User Messaging Platform SDK](../user_messaging_tools/get_started.md) など、[TCF フレームワーク](https://iabeurope.eu/transparency-consent-framework/)と統合された [Google 認定の同意管理プラットフォーム](https://support.google.com/admob/answer/13554116) (CMP) を導入する必要があります。導入後、CMP はモバイルアプリ内に同意の選択肢（目的として知られるもの）を表示します。

このドキュメントは以下に基づきます:

- [Google Mobile Ads SDK Android - 広告配信モード](https://developers.google.com/admob/android/privacy/ad-serving-modes)
- [Google Mobile Ads SDK iOS - 広告配信モード](https://developers.google.com/admob/ios/privacy/ad-serving-modes)

同意の選択肢の正確な UI は Google によって最新の状態に保たれますが、参考として以前のバージョンを以下に示します:

![同意の選択肢のサンプル画像](https://developers.google.com/static/admob/images/privacy/consent-form-purposes.png)

!!! note
    **重要:** 目的の同意を収集するだけでなく、ベンダーの同意も収集する必要があります。Google などのベンダーが適切な広告を配信するには、目的の同意とベンダーの同意の両方が必要です。

配信可能な広告の種類は以下のとおりです:

- [パーソナライズド広告](#personalized-ads)
- [非パーソナライズド広告](#non-personalized-ads)
- [リミテッド広告](#limited-ads)

## パーソナライズド広告 {#personalized-ads}

[パーソナライズド広告](https://support.google.com/admob/answer/7676680) は、ユーザーが訪れるサイトや使用するアプリに基づいてユーザーの興味を推測する広告です。Google は、広告の選択を決定または影響させるために、以前に収集されたデータや過去のデータに基づく広告をパーソナライズされたものと見なします。

以下の基準がすべて満たされている場合、Google はパーソナライズド広告を配信します。詳しくは、[パーソナライズド広告の要件](https://support.google.com/admob/answer/9760862#consent-policies) をお読みください。

**凡例:** ✅ 同意 &nbsp;&nbsp;&nbsp;&nbsp; ✔ 正当な利益

| 目的 | ユーザーの同意の選択 |
| --- | --- |
| 目的 1 | ✅ |
| 目的 2 | ✔ または ✅ |
| 目的 3 | ✅ |
| 目的 4 | ✅ |
| 目的 7 | ✔ または ✅ |
| 目的 9 | ✔ または ✅ |
| 目的 10 | ✔ または ✅ |

## 非パーソナライズド広告 {#non-personalized-ads}

[非パーソナライズド広告](https://support.google.com/admob/answer/7676680) は、ユーザーの過去の行動に基づきません。非パーソナライズド広告は広告のターゲティングに Cookie やモバイル広告 ID を使用しませんが、フリークエンシー キャップや集計広告レポートには Cookie やモバイル広告 ID を引き続き使用します。

以下の基準がすべて満たされている場合、Google は非パーソナライズド広告を配信します。詳しくは、[非パーソナライズド広告の要件](https://support.google.com/admob/answer/9760862#consent-policies) を参照してください。

**凡例:** ✅ 同意 &nbsp;&nbsp;&nbsp;&nbsp; ✔ 正当な利益 &nbsp;&nbsp;&nbsp;&nbsp; 🚫 同意なし

| 目的 | ユーザーの同意の選択 |
| --- | --- |
| 目的 1 | ✅ |
| 目的 2 | ✔ または ✅ |
| 目的 7 | ✔ または ✅ |
| 目的 9 | ✔ または ✅ |
| 目的 10 | ✔ または ✅ |

## リミテッド広告 {#limited-ads}

[リミテッド広告 (LTD)](https://support.google.com/admob/answer/10105530) は、すべてのパーソナライズと、ローカル識別子の使用を必要とする機能を無効にします。

以下の基準がすべて満たされている場合、Google はリミテッド広告を配信します。詳しくは、[公開開始: リミテッド広告 2.0](https://support.google.com/admob/answer/10105530#limited-ads-update) をお読みください。

- 特別な目的: 1、2
- 正当な利益: 7 (オプションのみ)
