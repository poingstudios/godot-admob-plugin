# Vpon

The Vpon mediation adapter allows you to integrate Vpon ads into your Godot game using AdMob mediation.

## Supported Integrations

| Ad Format | Bidding | Waterfall |
| :--- | :--- | :--- |
| **Banner** | ❌ | |
| **Interstitial** | ❌ | |
| **Rewarded** | ❌ | |

## Integration Steps

### Android

#### 1. Enable Vpon in Project Settings
- Enable **Vpon** under `admob/android/mediation/vpon` in your Godot Project Settings.

#### 2. Configure Mediation in AdMob Console
Configure Vpon as a mediation partner in your AdMob console:
1. Log in to your **AdMob account**.
2. Navigate to **Mediation** and create or edit a **Mediation Group**.
3. Under the ad network waterfall, add Vpon as a **Custom Event**.
4. **Class Name**: Enter `com.vpadn.mediation.VpadnAdapter`.
5. **Parameter**: Enter your Vpon License Key.

---

### iOS

As Vpon is integrated via Custom Events on iOS, developers should add the Vpon SDK and AdMob adapter framework files to their Xcode build settings during export.

#### 1. Configure Mediation in AdMob Console
1. Log in to your **AdMob account**.
2. Navigate to **Mediation** and create or edit a **Mediation Group**.
3. Under the ad network waterfall, add Vpon as a **Custom Event**.
4. **Class Name**: Enter `VponAdMobAdapter`.
5. **Parameter**: Enter your Vpon License Key / Ad Unit ID.
