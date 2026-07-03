# 概览

广告检查器是一个应用内叠加层，可让您直接在应用内对测试广告请求进行实时 analysis。

!!! warning "警告"
    启用广告检查器会增加测试设备上 Google Mobile Ads SDK 的内存使用量。广告检查器仅在**测试设备**上启动。

## 前提条件

在使用广告检查器之前，您必须完成以下任务：

1. 创建 AdMob 账号。
2. 在 AdMob 中设置应用。
3. [设置 Google Mobile Ads SDK](../../index.md)。
4. 将您的设备添加为[测试设备](../../enable_test_ads.md)。

## 错误处理

当广告检查器关闭时，回调会收到一个包含错误信息的 `Dictionary`。如果广告检查器成功关闭，该字典将为空。

| 字段 | 类型 | 描述 |
|-------|------|-------------|
| `code` | `int` | 错误代码 |
| `message` | `string` | 人类可读的错误消息 |
| `domain` | `string` | 错误域 |

## 参考资料

- [Android Ad Inspector](https://developers.google.com/admob/android/ad-inspector)
- [iOS Ad Inspector](https://developers.google.com/admob/ios/ad-inspector)
