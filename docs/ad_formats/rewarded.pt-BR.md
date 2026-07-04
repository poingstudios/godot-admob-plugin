# Anúncios Premiados (Rewarded)

!!! note "Documentação Godot 3 (v1)"
    Esta página é para **Godot 3.x**. Para **Godot 4.2+**, veja a [documentação estável](https://poingstudios.github.io/godot-admob-plugin/stable/).

Os anúncios premiados oferecem aos usuários a opção de interagir com eles em troca de recompensas no jogo (como vidas extras, moedas virtuais, etc.).

---

## Implementando Anúncios Premiados

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("rewarded_ad_loaded", self, "_on_rewarded_ad_loaded")
        MobileAds.connect("rewarded_ad_failed_to_load", self, "_on_rewarded_ad_failed_to_load")
        MobileAds.connect("rewarded_ad_closed", self, "_on_rewarded_ad_closed")
        MobileAds.connect("user_earned_rewarded", self, "_on_user_earned_rewarded")
        
        # Carrega o anúncio premiado
        MobileAds.load_rewarded()

    func _on_rewarded_ad_loaded() -> void:
        print("Anúncio premiado carregado!")
        MobileAds.show_rewarded()

    func _on_rewarded_ad_failed_to_load(error_code: int) -> void:
        print("Erro ao carregar anúncio premiado: ", error_code)

    func _on_rewarded_ad_closed() -> void:
        print("Anúncio premiado fechado.")
        # Recarrega o próximo anúncio
        MobileAds.load_rewarded()

    func _on_user_earned_rewarded(currency: String, amount: int) -> void:
        print("Usuário premiado! Tipo: ", currency, ", Quantidade: ", amount)
        # Conceda a recompensa ao jogador aqui
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Connect("rewarded_ad_loaded", this, nameof(_on_rewarded_ad_loaded));
        MobileAds.Connect("rewarded_ad_failed_to_load", this, nameof(_on_rewarded_ad_failed_to_load));
        MobileAds.Connect("rewarded_ad_closed", this, nameof(_on_rewarded_ad_closed));
        MobileAds.Connect("user_earned_rewarded", this, nameof(_on_user_earned_rewarded));
        
        MobileAds.Call("load_rewarded");
    }

    private void _on_rewarded_ad_loaded()
    {
        GD.Print("Anúncio premiado carregado!");
        MobileAds.Call("show_rewarded");
    }

    private void _on_rewarded_ad_failed_to_load(int errorCode)
    {
        GD.Print("Erro ao carregar anúncio premiado: " + errorCode);
    }

    private void _on_rewarded_ad_closed()
    {
        GD.Print("Anúncio premiado fechado.");
        MobileAds.Call("load_rewarded");
    }

    private void _on_user_earned_rewarded(string currency, int amount)
    {
        GD.Print("Usuário premiado: " + amount + " " + currency);
    }
    ```

---

## Verificação

Você pode verificar se o anúncio premiado está carregado antes de exibi-lo:

=== "GDScript"

    ```gdscript
    if MobileAds.get_is_rewarded_loaded():
        MobileAds.show_rewarded()
    ```

=== "C#"

    ```csharp
    if ((bool)MobileAds.Call("get_is_rewarded_loaded"))
    {
        MobileAds.Call("show_rewarded");
    }
    ```
