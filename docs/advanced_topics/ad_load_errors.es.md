# Errores de carga de anuncios

En los casos en que un anuncio no se carga, se llama a un callback que proporciona un objeto `LoadAdError`.

El siguiente ejemplo muestra la información disponible cuando un anuncio no se carga:

=== "GDScript"

    ```gdscript
    load_callback.on_ad_failed_to_load = func(error: LoadAdError) -> void:
        # Obtiene el código de error. Consulte la lista de códigos comunes a continuación.
        var error_code := error.code
        
        # Obtiene un mensaje de error. Por ejemplo, "Cuenta no aprobada todavía".
        var error_message := error.message
        
        # Obtiene información de respuesta adicional sobre la solicitud.
        var response_info := error.response_info
        
        # Toda esta información está disponible utilizando el método to_string() del error.
        print("El anuncio no se pudo cargar: " + error.to_string())
    ```

=== "C#"

    ```csharp
    loadCallback.OnAdFailedToLoad = (error) =>
    {
        // Obtiene el código de error. Consulte la lista de códigos comunes a continuación.
        int errorCode = error.Code;
        
        // Obtiene un mensaje de error. Por ejemplo, "Cuenta no aprobada todavía".
        string errorMessage = error.Message;
        
        // Obtiene información de respuesta adicional sobre la solicitud.
        ResponseInfo responseInfo = error.ResponseInfo;
        
        // Toda esta información está disponible utilizando el método ToString() del error.
        GD.Print("El anuncio no se pudo cargar: " + error.ToString());
    };
    ```

## Códigos de Error Comunes

| Código de error | Nombre de la constante | Descripción |
| :--- | :--- | :--- |
| **0** | `ERROR_CODE_INTERNAL_ERROR` | Ocurrió un error interno; por ejemplo, se recibió una respuesta no válida del servidor de anuncios. |
| **1** | `ERROR_CODE_INVALID_REQUEST` | La solicitud de anuncio no era válida; por ejemplo, el ID del bloque de anuncios era incorrecto. |
| **2** | `ERROR_CODE_NETWORK_ERROR` | La solicitud de anuncio no tuvo éxito debido a problemas de conectividad de red. |
| **3** | `ERROR_CODE_NO_FILL` | La solicitud de anuncio se realizó correctamente, pero no se devolvió ningún anuncio debido a la falta de inventario de anuncios. |
| **8** | `ERROR_CODE_APP_ID_MISSING` | Falta el ID de la aplicación en la configuración. |
| **9** | `ERROR_CODE_MEDIATION_NO_FILL` | El adaptador de mediación no pudo completar la solicitud de anuncio. |
