# Anúncios Intersticiais

Anúncios intersticiais são anúncios em tela cheia que cobrem a interface do aplicativo. Eles geralmente são exibidos em pontos de transição natural no fluxo do jogo, como entre fases ou após a conclusão de uma tarefa.

---

## Implementando Anúncios Intersticiais

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("interstitial_loaded", self, "_on_interstitial_loaded")
        MobileAds.connect("interstitial_failed_to_load", self, "_on_interstitial_failed_to_load")
        MobileAds.connect("interstitial_closed", self, "_on_interstitial_closed")
        
        # Carrega o anúncio intersticial
        MobileAds.load_interstitial()

    func _on_interstitial_loaded() -> void:
        print("Intersticial carregado! Pronto para exibir.")
        # Exibe imediatamente ou salva para depois
        MobileAds.show_interstitial()

    func _on_interstitial_failed_to_load(error_code: int) -> void:
        print("Erro ao carregar intersticial: ", error_code)

    func _on_interstitial_closed() -> void:
        print("Anúncio intersticial fechado pelo usuário.")
        # Carrega o próximo anúncio
        MobileAds.load_interstitial()
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Connect("interstitial_loaded", this, nameof(_on_interstitial_loaded));
        MobileAds.Connect("interstitial_failed_to_load", this, nameof(_on_interstitial_failed_to_load));
        MobileAds.Connect("interstitial_closed", this, nameof(_on_interstitial_closed));
        
        MobileAds.Call("load_interstitial");
    }

    private void _on_interstitial_loaded()
    {
        GD.Print("Intersticial carregado!");
        MobileAds.Call("show_interstitial");
    }

    private void _on_interstitial_failed_to_load(int errorCode)
    {
        GD.Print("Erro ao carregar intersticial: " + errorCode);
    }

    private void _on_interstitial_closed()
    {
        GD.Print("Intersticial fechado.");
        MobileAds.Call("load_interstitial");
    }
    ```

---

## Verificação

Você pode verificar se o anúncio intersticial terminou de carregar antes de apresentá-lo:

=== "GDScript"

    ```gdscript
    if MobileAds.get_is_interstitial_loaded():
        MobileAds.show_interstitial()
    ```

=== "C#"

    ```csharp
    if ((bool)MobileAds.Call("get_is_interstitial_loaded"))
    {
        MobileAds.Call("show_interstitial");
    }
    ```
