# Verificação do Servidor (SSV)

Os callbacks de verificação do servidor (SSV) confirmam as recompensas aos usuários por engajamento com anúncios. Eles são requisições enviadas pelo Google diretamente para o seu servidor quando um usuário termina de assistir a um anúncio premiado.

!!! note
    A verificação do servidor é um recurso opcional. Você ainda pode usar o callback padrão do lado do cliente (`on_user_earned_reward`) para conceder recompensas.

## Pré-requisitos

*   Ative a [verificação de servidor de anúncios premiados](https://support.google.com/admob/answer/7665911) no seu bloco de anúncios no console do AdMob.

## Configuração no Cliente

Para passar dados personalizados ou um identificador de usuário para o callback do servidor, você deve configurar as opções de verificação no anúncio premiado carregado antes de exibi-lo.

=== "GDScript"

    ```gdscript
    # Cria as opções de verificação
    var ssv_options := ServerSideVerificationOptions.new()
    ssv_options.custom_data = "SAMPLE_CUSTOM_DATA_STRING"
    ssv_options.user_id = "USER_ID_TO_REWARD"
    
    # Define as opções no RewardedAd ou RewardedInterstitialAd carregado
    rewarded_ad.set_server_side_verification_options(ssv_options)
    ```

=== "C#"

    ```csharp
    // Cria as opções de verificação
    var ssvOptions = new ServerSideVerificationOptions
    {
        CustomData = "SAMPLE_CUSTOM_DATA_STRING",
        UserId = "USER_ID_TO_REWARD"
    };

    // Define as opções no RewardedAd ou RewardedInterstitialAd carregado
    rewardedAd.SetServerSideVerificationOptions(ssvOptions);
    ```

!!! tip
    A string de dados personalizados é escapada em formato percent (percent-escaped) na URL e pode precisar de decodificação ao ser analisada pelo seu servidor.

---

## Parâmetros de Callback do SSV

Os callbacks de verificação do servidor contêm parâmetros de consulta que descrevem a interação com o anúncio. Os nomes dos parâmetros, descrições e exemplos de valores são listados abaixo (enviados em ordem alfabética):

| Nome do Parâmetro | Descrição | Exemplo de valor |
| :--- | :--- | :--- |
| `ad_network` | Identificador da origem do anúncio que preencheu este anúncio. | `5450213213286189855` |
| `ad_unit` | ID do bloco de anúncios do AdMob usado para solicitar o anúncio premiado. | `ca-app-pub-3940256099942544/5224354917` |
| `custom_data` | String de dados personalizados fornecida pelo seu aplicativo (se configurada). | `SAMPLE_CUSTOM_DATA_STRING` |
| `key_id` | Chave a ser usada para verificar o callback do SSV. Esse valor mapeia para uma chave pública fornecida pelo servidor de chaves do AdMob. | `1234567890` |
| `reward_amount` | Quantidade de recompensa conforme especificado nas configurações do bloco de anúncios. | `10` |
| `reward_item` | Item de recompensa conforme especificado nas configurações do bloco de anúncios. | `coins` |
| `signature` | Assinatura do callback do SSV gerada pelo AdMob. | `MEUCIQCLJS_s4ia...` |
| `timestamp` | Carimbo de data/hora de quando o usuário foi recompensado em Epoch time em ms. | `1507770365237823` |
| `transaction_id` | Identificador único codificado em hexadecimal para cada evento de concessão de recompensa. | `18fa792de1bca816048293fc71035638` |
| `user_id` | Identificador de usuário conforme fornecido pelo seu aplicativo (se configurado). | `1234567` |

---

## Verificando o Callback no seu Servidor

Para verificar se o callback é autêntico e foi realmente enviado pelo Google, você deve checar a assinatura usando as chaves públicas do AdMob.

### 1. Obter as Chaves Públicas do Google
Baixe o JSON das chaves públicas confiáveis no servidor de chaves do AdMob:
[https://gstatic.com/admob/reward/verifier-keys.json](https://gstatic.com/admob/reward/verifier-keys.json)

### 2. Preparar o Conteúdo para Verificar
Os parâmetros de consulta da URL de callback especificam o conteúdo a ser verificado. Os parâmetros `signature` e `key_id` são sempre os últimos na string de consulta, nessa ordem.

Extraia a substring do início da query string até (mas não incluindo) `&signature=`. A ordem dos parâmetros de consulta não deve ser alterada.

Por exemplo, se a sua URL de callback for:
`https://www.myserver.com/path?ad_network=54...&ad_unit=...&user_id=123&signature=ME...&key_id=1268`

O conteúdo a ser verificado é:
`ad_network=54...&ad_unit=...&user_id=123`

### 3. Executar a Verificação de Assinatura
1.  Analise o JSON de chaves públicas obtido no passo 1.
2.  Encontre a chave pública correspondente ao valor do parâmetro `key_id`.
3.  Verifique a assinatura (ECDSA SHA256 DER) em relação à string de conteúdo preparada usando a chave pública.

---

## Perguntas Frequentes (FAQ)

#### Posso armazenar em cache as chaves públicas fornecidas pelo servidor de chaves do AdMob?
Sim, recomendamos armazenar em cache as chaves públicas para reduzir as requisições de rede. No entanto, observe que as chaves públicas são rotacionadas regularmente e não devem ser armazenadas em cache por mais de 24 horas.

#### O que acontece se meu servidor não puder ser alcançado?
O Google espera um código de resposta `HTTP 200 OK`. Se o seu servidor não puder ser alcançado ou falhar em retornar um código de sucesso, o Google tentará reenviar o callback em até 5 vezes em intervalos de 1 segundo.

#### Como posso verificar se os callbacks do SSV realmente se originam do Google?
Além de verificar a assinatura, você pode usar a pesquisa de DNS reverso no endereço IP de origem para verificar se a requisição se origina do Google.
