# RewardedInterstitialAd

A classe `RewardedInterstitialAd` representa um formato de anúncio interstitial recompensado em tela cheia que exibe anúncios sem exigir aceitação, mas ainda recompensa usuários que completam a visualização.

## Propriedades

### `full_screen_content_callback` / `FullScreenContentCallback`

O listener de callback para receber eventos sobre apresentação, dispensa ou falha na exibição. Veja [`FullScreenContentCallback`](../listeners/FullScreenContentCallback.md).

=== "GDScript"
    ```gdscript
    var full_screen_content_callback: FullScreenContentCallback
    ```

=== "C#"
    ```csharp
    public FullScreenContentCallback FullScreenContentCallback { get; set; }
    ```

### `on_ad_paid` / `OnAdPaid`

Acionado quando uma impressão de anúncio é registrada e a receita foi gerada. Recebe um [`AdValue`](AdValue.md).

=== "GDScript"
    ```gdscript
    var on_ad_paid: Callable # Receives AdValue
    ```

=== "C#"
    ```csharp
    public Action<AdValue> OnAdPaid { get; set; }
    ```

---

## Métodos

### `show` / `Show`

Apresenta a sobreposição de anúncio interstitial recompensado em tela cheia.

=== "GDScript"
    ```gdscript
    func show(on_user_earned_reward_listener := OnUserEarnedRewardListener.new()) -> void
    ```

    **Uso:**
    ```gdscript
    var reward_listener := OnUserEarnedRewardListener.new()
    reward_listener.on_user_earned_reward = func(reward_item: RewardItem):
        print("Rewarded: ", reward_item.amount, " ", reward_item.type)
        
    rewarded_interstitial_ad.show(reward_listener)
    ```

=== "C#"
    ```csharp
    public void Show(OnUserEarnedRewardListener listener = null)
    ```

    **Uso:**
    ```csharp
    OnUserEarnedRewardListener listener = new OnUserEarnedRewardListener();
    listener.OnUserEarnedReward = (rewardItem) => {
        GD.Print($"Rewarded: {rewardItem.Amount} {rewardItem.Type}");
    };
    
    rewardedInterstitialAd.Show(listener);
    ```

---

### `destroy` / `Destroy`

Destrói o objeto de anúncio nativo e libera recursos.

=== "GDScript"
    ```gdscript
    func destroy() -> void
    ```

=== "C#"
    ```csharp
    public void Destroy()
    ```

---

### `get_response_info` / `GetResponseInfo`

Retorna as informações de resposta de mediação contendo o histórico de adaptadores para o anúncio carregado.

=== "GDScript"
    ```gdscript
    func get_response_info() -> ResponseInfo
    ```

=== "C#"
    ```csharp
    public ResponseInfo GetResponseInfo()
    ```

---

### `set_server_side_verification_options` / `SetServerSideVerificationOptions`

Configura os parâmetros de verificação usados para callbacks de recompensa no lado do servidor.

=== "GDScript"
    ```gdscript
    func set_server_side_verification_options(server_side_verification_options: ServerSideVerificationOptions) -> void
    ```

=== "C#"
    ```csharp
    public void SetServerSideVerificationOptions(ServerSideVerificationOptions options)
    ```
