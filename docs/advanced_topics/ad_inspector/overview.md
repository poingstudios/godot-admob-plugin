# Overview

Ad inspector is an in-app overlay that lets you perform real-time analysis of test ad requests directly within your app.

!!! warning
    Enabling ad inspector increases memory usage of the Google Mobile Ads SDK for test devices. Ad inspector only launches on **test devices**.

## Prerequisites

Before you can use ad inspector, you must complete the following tasks:

1. Create an AdMob account.
2. Set up an app in AdMob.
3. [Set up Google Mobile Ads SDK](../../index.md).
4. Add your device as a [test device](../../enable_test_ads.md).

## Error handling

When ad inspector closes, the callback receives a `Dictionary` containing error information. If ad inspector closed successfully, the dictionary will be empty.

| Field | Type | Description |
|-------|------|-------------|
| `code` | `int` | The error code |
| `message` | `string` | A human-readable error message |
| `domain` | `string` | The error domain |

## References

- [Android Ad Inspector](https://developers.google.com/admob/android/ad-inspector)
- [iOS Ad Inspector](https://developers.google.com/admob/ios/ad-inspector)
