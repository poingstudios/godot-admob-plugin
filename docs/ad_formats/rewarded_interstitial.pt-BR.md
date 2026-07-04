# Anúncios Intersticiais Premiados

!!! note "Documentação Godot 3 (v1)"
    Esta página é para **Godot 3.x**. Para **Godot 4.2+**, veja a [documentação estável](https://poingstudios.github.io/godot-admob-plugin/stable/).

O intersticial premiado é um formato de anúncio incentivado que permite oferecer recompensas para anúncios que aparecem automaticamente durante transições naturais do aplicativo. Diferente dos anúncios premiados tradicionais, os usuários não precisam aceitar explicitamente para visualizar.

---

## Implementando Intersticiais Premiados

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("rewarded_interstitial_ad_loaded", self, "_on_rewarded_interstitial_ad_loaded")
        MobileAds.connect("rewarded_interstitial_ad_failed_to_load", self, "_on_rewarded_interstitial_ad_failed_to_load")
        MobileAds.connect("rewarded_interstitial_ad_closed", self, "_on_rewarded_interstitial_ad_closed")
        MobileAds.connect("user_earned_rewarded", self, "_on_user_earned_rewarded")
        
        # Carrega o anúncio intersticial premiado
        MobileAds.load_rewarded_interstitial()

    func _on_rewarded_interstitial_ad_loaded() -> void:
        print("Intersticial Premiado carregado!")
        MobileAds.show_rewarded_interstitial()

    func _on_rewarded_interstitial_ad_failed_to_load(error_code: int) -> void:
        print("Erro ao carregar Intersticial Premiado: ", error_code)

    func _on_rewarded_interstitial_ad_closed() -> void:
        print("Intersticial Premiado fechado.")
        # Recarrega o próximo anúncio
        MobileAds.load_rewarded_interstitial()

    func _on_user_earned_rewarded(currency: String, amount: int) -> void:
        print("Usuário premiado! Tipo: ", currency, ", Quantidade: ", amount)
        # Conceda a recompensa ao jogador aqui
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Connect("rewarded_interstitial_ad_loaded", this, nameof(_on_rewarded_interstitial_ad_loaded));
        MobileAds.Connect("rewarded_interstitial_ad_failed_to_load", this, nameof(_on_rewarded_interstitial_ad_failed_to_load));
        MobileAds.Connect("rewarded_interstitial_ad_closed", this, nameof(_on_rewarded_interstitial_ad_closed));
        MobileAds.Connect("user_earned_rewarded", this, nameof(_on_user_earned_rewarded));
        
        MobileAds.Call("load_rewarded_interstitial");
    }

    private void _on_rewarded_interstitial_ad_loaded()
    {
        GD.Print("Intersticial Premiado carregado!");
        MobileAds.Call("show_rewarded_interstitial");
    }

    private void _on_rewarded_interstitial_ad_failed_to_load(int errorCode)
    {
        GD.Print("Erro ao carregar Intersticial Premiado: " + errorCode);
    }

    private void _on_rewarded_interstitial_ad_closed()
    {
        GD.Print("Intersticial Premiado fechado.");
        MobileAds.Call("load_rewarded_interstitial");
    }

    private void _on_user_earned_rewarded(string currency, int amount)
    {
        GD.Print("Usuário premiado: " + amount + " " + currency);
    }
    ```

---

## Verificação

Você pode verificar se o anúncio está carregado antes de exibi-lo:

=== "GDScript"

    ```gdscript
    if MobileAds.get_is_rewarded_interstitial_loaded():
        MobileAds.show_rewarded_interstitial()
    ```

=== "C#"

    ```csharp
    if ((bool)MobileAds.Call("get_is_rewarded_interstitial_loaded"))
    {
        MobileAds.Call("show_rewarded_interstitial");
    }
    ```
