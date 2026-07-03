# Troubleshoot bidding

Bidding allows ad sources to compete in real-time for your ad inventory. This page provides troubleshooting steps for common bidding issues.

## Common bidding issues

### Ads not loading

If ads are not loading with bidding:

1. **Check adapter version**: Ensure you're using the latest version of the bidding adapter
2. **Verify initialization**: Check that the SDK and bidding adapters are properly initialized
3. **Check ad unit configuration**: Verify your ad unit is configured for bidding in the AdMob UI

### Low fill rate

If you're experiencing low fill rate with bidding:

1. **Check ad source status**: Verify the ad source is active and properly configured
2. **Review floor pricing**: Check if your floor prices are too high
3. **Geographic coverage**: Some ad sources have limited geographic coverage

### Latency issues

If bidding is causing latency:

1. **Check network conditions**: Poor network conditions can increase bidding latency
2. **Monitor adapter latency**: Use the initialization status to check adapter latency
3. **Optimize timeout settings**: Adjust timeout settings if available

## Debugging tools

### Ad Inspector

Use the Ad Inspector to debug bidding issues:

1. Enable Ad Inspector in your app
2. Launch Ad Inspector when an ad loads
3. Check the bidding status and response info

### Logs

Enable logging to see detailed bidding information:

=== "GDScript"

    ```gdscript
    # Enable debug logging
    MobileAds.set_debug(true)
    ```

=== "C#"

    ```csharp
    // Enable debug logging
    MobileAds.SetDebug(true);
    ```

## Further assistance

If you continue to experience issues, contact [Google Mobile Ads SDK support](https://support.google.com/admob/contact/contact_us_gma_sdk).
