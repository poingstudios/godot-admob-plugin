# Integrate Vpon with Mediation

This guide is intended for publishers who are interested in using AdMob Mediation with Vpon. It walks you through getting a mediation adapter set up with your current Godot app and setting up additional request parameters.

## Vpon Resources

- [Documentation](https://wiki.vpon.com/android/mediation/admob/)
- [SDK](https://wiki.vpon.com/android/download/index.html)
- [Adapter](https://wiki.vpon.com/android/download/#admob)
- Customer support: fae@vpon.com

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

1. Install the **Android Build Template** in your Godot project (under `Project > Install Android Build Template`).
2. Download the latest **Vpon Android SDK** and **Vpon AdMob Adapter** (`.aar` or `.jar` files) from the links in the Vpon Resources section.
3. Copy the downloaded files into the following directory inside your Godot project:
   - `android/build/libs/`
4. Open `android/build/build.gradle` in a text editor.
5. Add the downloaded files as dependencies inside the `dependencies` block:
   ```groovy
   dependencies {
       // ... other dependencies
       implementation files('libs/admob-adapter-2.3.0.aar') // Replace with the exact filename of the downloaded adapter
       implementation files('libs/vpon-sdk-5.8.0.aar') // Replace with the exact filename of the downloaded SDK
   }
   ```

---

### iOS

Include the mediated networks' SDKs and adapter files within the appropriate directory of your Godot project:

- **iOS**: Xcode project (after export)

After generating an Xcode project from Godot, include any frameworks, compiler flags, or linker flags that your chosen networks require.

1. Download the latest **Vpon iOS SDK** and **Vpon AdMob Adapter** frameworks from the [Vpon Developer Page](https://developers.google.com/admob/ios/mediation/vpon).
2. Export your Godot project as an iOS Xcode project.
3. Open the exported project in Xcode.
4. Drag and drop the downloaded Vpon SDK and Adapter framework files (`.xcframework` or `.framework`) into your Xcode project.
5. Under the **General** tab of your app target, ensure these frameworks are listed under **Frameworks, Libraries, and Embedded Content** and set to **Embed & Sign**.

---

Your app need not call any third-party ad network code directly; Poing Godot AdMob Plugin interacts with the mediated network's adapter to fetch third-party ads on your behalf.
