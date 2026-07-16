# Ad load errors

In cases where an ad fails to load, a callback is called which provides a `LoadAdError` object.

The following example shows the information available when an ad fails to load:

=== "GDScript"

    ```gdscript
    load_callback.on_ad_failed_to_load = func(error: LoadAdError) -> void:
        # Gets the error code. Refer to the list of common codes below.
        var error_code := error.code
        
        # Gets an error message. For example "Account not approved yet".
        var error_message := error.message
        
        # Gets additional response information about the request.
        var response_info := error.response_info
        
        # All of this information is available using the error's to_string() method.
        print("Ad failed to load: " + error.to_string())
    ```

=== "C#"

    ```csharp
    loadCallback.OnAdFailedToLoad = (error) =>
    {
        // Gets the error code. Refer to the list of common codes below.
        int errorCode = error.Code;
        
        // Gets an error message. For example "Account not approved yet".
        string errorMessage = error.Message;
        
        // Gets additional response information about the request.
        ResponseInfo responseInfo = error.ResponseInfo;
        
        // All of this information is available using the error's ToString() method.
        GD.Print("Ad failed to load: " + error.ToString());
    };
    ```

## Common Error Codes

| Error Code | Constant Name | Description |
| :--- | :--- | :--- |
| **0** | `ERROR_CODE_INTERNAL_ERROR` | Something happened internally; for instance, an invalid response was received from the ad server. |
| **1** | `ERROR_CODE_INVALID_REQUEST` | The ad request was invalid; for instance, the ad unit ID was incorrect. |
| **2** | `ERROR_CODE_NETWORK_ERROR` | The ad request was unsuccessful due to network connectivity. |
| **3** | `ERROR_CODE_NO_FILL` | The ad request was successful, but no ad was returned due to lack of ad inventory. |
| **8** | `ERROR_CODE_APP_ID_MISSING` | The app ID is missing from the configuration. |
| **9** | `ERROR_CODE_MEDIATION_NO_FILL` | The mediation adapter failed to fill the ad request. |
