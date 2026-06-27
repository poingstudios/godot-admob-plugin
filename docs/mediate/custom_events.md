# Create custom events

Custom events allow you to integrate ad sources that are not directly supported by AdMob Mediation. You can create custom events to integrate any ad source that provides an SDK.

## Custom event types

AdMob Mediation supports custom events for the following ad formats:

- [Banner](integrate_partner_networks/applovin.md)
- [Interstitial](integrate_partner_networks/applovin.md)
- [Rewarded](integrate_partner_networks/applovin.md)
- [Native](integrate_partner_networks/applovin.md)

## Creating a custom event

To create a custom event:

1. Go to the **AdMob UI** → **Mediation** → **Custom events**
2. Click **Add custom event**
3. Configure the custom event:
   - **Label**: A descriptive name for the custom event
   - **Class name**: The class name of your custom event handler
   - **Parameter**: Any parameters to pass to the custom event

## Implementation guide

For detailed instructions on implementing custom events, see the official documentation:

- [Android custom events](https://developers.google.com/admob/android/custom-events)
- [iOS custom events](https://developers.google.com/admob/ios/custom-events/setup)

## Best practices

- **Test thoroughly**: Always test custom events with test ads before publishing
- **Handle errors gracefully**: Implement proper error handling in your custom event
- **Log performance metrics**: Monitor fill rate and latency for your custom events
- **Follow ad source policies**: Ensure compliance with the ad source's policies
