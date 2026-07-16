# Erros de carregamento de anúncios

Nos casos em que um anúncio falha ao carregar, um callback é chamado fornecendo um objeto `LoadAdError`.

O exemplo a seguir mostra as informações disponíveis quando um anúncio falha ao carregar:

=== "GDScript"

    ```gdscript
    load_callback.on_ad_failed_to_load = func(error: LoadAdError) -> void:
        # Obtém o código de erro. Consulte a lista de códigos comuns abaixo.
        var error_code := error.code
        
        # Obtém uma mensagem de erro. Por exemplo, "Account not approved yet".
        var error_message := error.message
        
        # Obtém informações de resposta adicionais sobre a solicitação.
        var response_info := error.response_info
        
        # Todas essas informações estão disponíveis usando o método to_string() do erro.
        print("Falha ao carregar o anúncio: " + error.to_string())
    ```

=== "C#"

    ```csharp
    loadCallback.OnAdFailedToLoad = (error) =>
    {
        // Obtém o código de erro. Consulte a lista de códigos comuns abaixo.
        int errorCode = error.Code;
        
        // Obtém uma mensagem de erro. Por exemplo, "Account not approved yet".
        string errorMessage = error.Message;
        
        // Obtém informações de resposta adicionais sobre a solicitação.
        ResponseInfo responseInfo = error.ResponseInfo;
        
        // Todas essas informações estão disponíveis usando o método ToString() do erro.
        GD.Print("Falha ao carregar o anúncio: " + error.ToString());
    };
    ```

## Códigos de Erro Comuns

| Código de erro | Nome da constante | Descrição |
| :--- | :--- | :--- |
| **0** | `ERROR_CODE_INTERNAL_ERROR` | Ocorreu um erro interno; por exemplo, uma resposta inválida foi recebida do servidor de anúncios. |
| **1** | `ERROR_CODE_INVALID_REQUEST` | A solicitação de anúncio é inválida; por exemplo, o ID do bloco de anúncios está incorreto. |
| **2** | `ERROR_CODE_NETWORK_ERROR` | A solicitação de anúncio não teve sucesso devido a problemas de conectividade de rede. |
| **3** | `ERROR_CODE_NO_FILL` | A solicitação de anúncio foi bem-sucedida, mas nenhum anúncio foi retornado por falta de inventário de anúncios. |
| **8** | `ERROR_CODE_APP_ID_MISSING` | O ID do aplicativo está ausente nas configurações. |
| **9** | `ERROR_CODE_MEDIATION_NO_FILL` | O adaptador de mediação falhou em preencher a solicitação de anúncio. |
