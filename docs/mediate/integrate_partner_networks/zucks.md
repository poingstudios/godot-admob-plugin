# Integrate Zucks with Mediation

This guide is intended for publishers who are interested in using AdMob Mediation with Zucks. It walks you through getting a mediation adapter set up with your current Godot app and setting up additional request parameters.

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/mediation/zucks)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/mediation/zucks)

## Zucks Resources

- [Documentation](https://ms.zucksadnetwork.com/media/sdk/manual/admob-mediation/)
- [SDK](https://ms.zucksadnetwork.com/media/sdk/manual/android/)
- [Adapter](https://ms.zucksadnetwork.com/media/sdk/manual/admob-mediation/)
- Customer support: support@zucksadnetwork.com

## Prerequisites

- Complete the [Get started guide](../../index.md)
- Complete the mediation [Get started guide](../get_started.md)

### Helpful primers

The following Help Center articles provide background information on mediation:

- [About AdMob Mediation](https://support.google.com/admob/answer/1354562)
- [Set up AdMob Mediation](https://support.google.com/admob/answer/3124703)
- [Optimize AdMob Mediation](https://support.google.com/admob/answer/6162238)

## Include network adapter and SDK

### Android

Zucks distributes both its SDK and AdMob Mediation Adapter exclusively via Maven. You do not need to download any local `.aar` or `.jar` files for Android.

1. Install the **Android Build Template** in your Godot project (under `Project > Install Android Build Template`).
2. Open `android/build/build.gradle` in a text editor.
3. Add the Zucks Maven repository inside the `allprojects > repositories` block (or `repositories` block):
   ```groovy
   repositories {
       // ... other repositories
       maven { url 'https://github.com/zucks/ZucksAdNetworkSDK-Maven/raw/master/' }
   }
   ```
4. Add the Zucks mediation adapter dependency inside the `dependencies` block (this will transitively download the Zucks SDK as well):
   ```groovy
   dependencies {
       // ... other dependencies
       implementation 'net.zucks:zucks-ad-network-admob-adapter:6.1.0.1' // Replace with the latest adapter version
   }
   ```

---

### iOS

Include the mediated networks' SDKs and adapter files within the appropriate directory of your Godot project:

- **iOS**: Xcode project (after export)

After generating an Xcode project from Godot, include any frameworks, compiler flags, or linker flags that your chosen networks require.

1. Download the latest **Zucks iOS SDK** and **Zucks AdMob Adapter** frameworks from the [Zucks Developer Page](https://developers.google.com/admob/ios/mediation/zucks).
2. Export your Godot project as an iOS Xcode project.
3. Open the exported project in Xcode.
4. Drag and drop the downloaded Zucks SDK and Adapter framework files (`.xcframework` or `.framework`) into your Xcode project.
5. Under the **General** tab of your app target, ensure these frameworks are listed under **Frameworks, Libraries, and Embedded Content** and set to **Embed & Sign**.

---

Your app need not call any third-party ad network code directly; Poing Godot AdMob Plugin interacts with the mediated network's adapter to fetch third-party ads on your behalf.
