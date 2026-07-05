# 广告投放模式

根据 Google 的[欧盟用户同意政策](https://www.google.com/about/company/user-consent-policy.html)，您必须向欧洲经济区 (EEA) 和英国的用户作出某些披露，并在法律要求时就使用 Cookie 或其他本地存储获取他们的同意，以及就出于广告个性化目的收集、共享和使用个人数据获取他们的同意。此政策反映了欧盟 ePrivacy 指令和《通用数据保护条例》(GDPR) 的要求。为遵守此政策，发布者必须采用已与 [TCF 框架](https://iabeurope.eu/transparency-consent-framework/)集成且经 Google 认证的[同意管理平台](https://support.google.com/admob/answer/13554116) (CMP)，例如 [User Messaging Platform SDK](../user_messaging_tools/get_started.md)。采用后，CMP 会在您的移动应用中提供称为“目的”的同意选项。

本文档基于：

- [Google Mobile Ads SDK Android - 广告投放模式](https://developers.google.com/admob/android/privacy/ad-serving-modes)
- [Google Mobile Ads SDK iOS - 广告投放模式](https://developers.google.com/admob/ios/privacy/ad-serving-modes)

同意选项的确切界面由 Google 保持更新，但此处提供一个早期版本供参考：

![同意选项示例图](https://developers.google.com/static/admob/images/privacy/consent-form-purposes.png)

!!! note
    **重要提示：** 除了收集“目的”同意外，您还需要收集供应商同意。任何供应商（例如 Google）都需要同时具备“目的”同意和供应商同意才能投放合适的广告。

可以投放的不同类型的广告包括：

- [个性化广告](#personalized-ads)
- [非个性化广告](#non-personalized-ads)
- [有限广告](#limited-ads)

## 个性化广告 {#personalized-ads}

[个性化广告](https://support.google.com/admob/answer/7676680) 是根据用户访问的网站或使用的应用推断其兴趣的广告。当广告基于先前收集的数据或历史数据来确定或影响广告选择时，Google 会将其视为个性化广告。

当满足以下所有条件时，Google 将投放个性化广告。有关更多信息，请阅读[个性化广告要求](https://support.google.com/admob/answer/9760862#consent-policies)。

**图例：** ✅ 同意 &nbsp;&nbsp;&nbsp;&nbsp; ✔ 合法权益

| 目的 | 用户同意选择 |
| --- | --- |
| 目的 1 | ✅ |
| 目的 2 | ✔ 或 ✅ |
| 目的 3 | ✅ |
| 目的 4 | ✅ |
| 目的 7 | ✔ 或 ✅ |
| 目的 9 | ✔ 或 ✅ |
| 目的 10 | ✔ 或 ✅ |

## 非个性化广告 {#non-personalized-ads}

[非个性化广告](https://support.google.com/admob/answer/7676680) 不基于用户过去的行为。尽管非个性化广告不使用 Cookie 或移动广告标识符进行广告定位，但这些广告仍会使用 Cookie 或移动广告标识符进行频次控制和汇总广告报告。

当满足以下所有条件时，Google 将投放非个性化广告。有关更多信息，请参阅[非个性化广告要求](https://support.google.com/admob/answer/9760862#consent-policies)。

**图例：** ✅ 同意 &nbsp;&nbsp;&nbsp;&nbsp; ✔ 合法权益 &nbsp;&nbsp;&nbsp;&nbsp; 🚫 无同意

| 目的 | 用户同意选择 |
| --- | --- |
| 目的 1 | ✅ |
| 目的 2 | ✔ 或 ✅ |
| 目的 7 | ✔ 或 ✅ |
| 目的 9 | ✔ 或 ✅ |
| 目的 10 | ✔ 或 ✅ |

## 有限广告 {#limited-ads}

[有限广告 (LTD)](https://support.google.com/admob/answer/10105530) 会停用所有个性化以及需要使用本地标识符的功能。

当满足以下所有条件时，Google 会投放有限广告。有关更多信息，请阅读[已推出：有限广告 2.0](https://support.google.com/admob/answer/10105530#limited-ads-update)。

- 特殊目的：1、2
- 合法权益：7（仅可选）
