# Integrate AdColony with Mediation

This guide demonstrates how to employ the Google Mobile Ads SDK to load and showcase ads from AdColony through [mediation](../get_started.md), encompassing both bidding and waterfall integration approaches. It elucidates the process of incorporating AdColony into an ad unit's mediation configuration and integrating the AdColony SDK and adapter into a Godot app.

## Supported integrations and ad formats

The AdMob mediation adapter for AdColony has the following capabilities:

| Integration |   |
|-------------|---|
| Bidding     | ✅ |
| Waterfall   | ✅ |

| Formats      |   |
|--------------|---|
| Banner       | ✅ |
| Interstitial | ✅ |
| Rewarded     | ✅ |


## Prerequisites
- Godot 4.1+
- Latest [Godot AdMob Plugin](https://github.com/Poing-Studios/godot-admob-plugin/releases/latest) 
- Android deploy:
    - Android API level 19 or higher
    - Latest [Godot AdMob Android Plugin](https://github.com/Poing-Studios/godot-admob-android/releases/latest)
- iOS deploy:
    - iOS deployment target of 11.0 or higher
    - Latest [Godot AdMob iOS Plugin](https://github.com/Poing-Studios/godot-admob-ios/releases/latest)
- Complete the [Get started guide](../../README.md)
- Complete the mediation [Get started guide](../get_started.md)

## Step 1: Set up AdColony:
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/adcolony#step_1_set_up_adcolony) or [iOS](https://developers.google.com/admob/ios/mediation/adcolony#step_1_set_up_adcolony), as it will be the same for both.


## Step 2: Configure mediation settings for your AdMob ad unit
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/adcolony#configure-mediation) or [iOS](https://developers.google.com/admob/ios/mediation/adcolony#configure-mediation), as it will be the same for both.

## Step 3: Import the AdColony SDK and adapter
