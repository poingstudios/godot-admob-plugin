# RewardedInterstitialAd

La clase `RewardedInterstitialAd` representa un formato de anuncio intersticial recompensado a pantalla completa que sirve anuncios sin requerir aceptación, pero aún recompensa a los usuarios que completan la visualización.

## Propiedades

### `full_screen_content_callback` / `FullScreenContentCallback`

El listener de callback para recibir eventos sobre presentación, descarte o fallo al mostrar. Véase [`FullScreenContentCallback`](../listeners/FullScreenContentCallback.md).

=== "GDScript"
    ```gdscript
    var full_screen_content_callback: FullScreenContentCallback
    ```

=== "C#"
    ```csharp
    public FullScreenContentCallback FullScreenContentCallback { get; set; }
    ```

### `on_ad_paid` / `OnAdPaid`

Se activa cuando se registra una impresión de anuncio y se han generado ingresos. Recibe un [`AdValue`](AdValue.md).

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

Presenta la superposición de anuncio intersticial recompensado a pantalla completa.

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

Destruye el objeto de anuncio nativo y libera recursos.

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

Devuelve la información de respuesta de mediación que contiene el historial de adaptadores para el anuncio cargado.

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

Configura los parámetros de verificación utilizados para las devoluciones de llamada de recompensa del lado del servidor.

=== "GDScript"
    ```gdscript
    func set_server_side_verification_options(server_side_verification_options: ServerSideVerificationOptions) -> void
    ```

=== "C#"
    ```csharp
    public void SetServerSideVerificationOptions(ServerSideVerificationOptions options)
    ```
