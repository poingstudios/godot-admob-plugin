# MobileAds API 参考

!!! note "Godot 3 (v1) 文档"
    本页面适用于 **Godot 3.x**。如需 **Godot 4.2+**，请查看[稳定文档](https://poingstudios.github.io/godot-admob-plugin/stable/)。

本页介绍 `MobileAds` 单例，这是在 Godot 3 中与 Google Mobile Ads SDK 交互的主要接口。所有广告操作都通过此单例（自动加载）执行。

---

## 概述

`MobileAds` 单例在插件启用时自动注册。使用它可以加载、显示和管理所有支持的广告格式。

```gdscript
# 直接访问单例
MobileAds.initialize()
MobileAds.load_banner()
MobileAds.show_interstitial()
```

---

---

## 方法

```gdscript
void initialize()
void load_banner(ad_unit_name = "standard")
void load_interstitial(ad_unit_name = "standard")
void load_rewarded(ad_unit_name = "standard")
void load_rewarded_interstitial(ad_unit_name = "standard")

void destroy_banner()
void show_banner()
void hide_banner()
void show_interstitial()
void show_rewarded()
void show_rewarded_interstitial()

void request_user_consent()
void reset_consent_state(will_request_user_consent = false)

int get_banner_width()
int get_banner_width_in_pixels()
int get_banner_height()
int get_banner_height_in_pixels()
bool get_is_banner_loaded()
bool get_is_interstitial_loaded()
bool get_is_rewarded_loaded()
bool get_is_rewarded_interstitial_loaded()
bool get_is_initialized()
```

---

## 信号

```gdscript
initialization_complete(status, adapter_name)

consent_form_dismissed()
consent_status_changed(consent_status_message)
consent_form_load_failure(error_code, error_message)
consent_info_update_success(consent_status_message)
consent_info_update_failure(error_code, error_message)

banner_loaded()
banner_failed_to_load(error_code)
banner_opened()
banner_clicked()
banner_closed()
banner_recorded_impression()
banner_destroyed()

interstitial_failed_to_load(error_code)
interstitial_loaded()
interstitial_failed_to_show(error_code)
interstitial_opened()
interstitial_clicked()
interstitial_closed()
interstitial_recorded_impression()

rewarded_ad_failed_to_load(error_code)
rewarded_ad_loaded()
rewarded_ad_failed_to_show(error_code)
rewarded_ad_opened()
rewarded_ad_clicked()
rewarded_ad_closed()
rewarded_ad_recorded_impression()

rewarded_interstitial_ad_failed_to_load(error_code)
rewarded_interstitial_ad_loaded()
rewarded_interstitial_ad_failed_to_show(error_code)
rewarded_interstitial_ad_opened()
rewarded_interstitial_ad_clicked()
rewarded_interstitial_ad_closed()
rewarded_interstitial_ad_recorded_impression()

user_earned_rewarded(currency, amount)
```