# Anúncios de Banner

Os anúncios de banner ocupam um espaço no layout do aplicativo, geralmente na parte superior ou inferior da tela. Eles permanecem na tela enquanto os usuários interagem com o aplicativo.

---

## Carregando um Banner

Para carregar um anúncio de banner, chame `MobileAds.load_banner()`.

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("banner_loaded", self, "_on_banner_loaded")
        MobileAds.connect("banner_failed_to_load", self, "_on_banner_failed_to_load")
        
        # Carrega o banner utilizando o Ad Unit ID configurado
        MobileAds.load_banner()

    func _on_banner_loaded() -> void:
        print("Banner carregado com sucesso!")

    func _on_banner_failed_to_load(error_code: int) -> void:
        print("Erro ao carregar banner: ", error_code)
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Connect("banner_loaded", this, nameof(_on_banner_loaded));
        MobileAds.Connect("banner_failed_to_load", this, nameof(_on_banner_failed_to_load));
        
        MobileAds.Call("load_banner");
    }

    private void _on_banner_loaded()
    {
        GD.Print("Banner carregado com sucesso!");
    }

    private void _on_banner_failed_to_load(int errorCode)
    {
        GD.Print("Erro ao carregar banner: " + errorCode);
    }
    ```

---

## Exibindo e Ocultando Banners

Se você configurou o banner para não ser exibido instantaneamente (`show_instantly` como falso), você pode controlar sua visibilidade manualmente:

=== "GDScript"

    ```gdscript
    # Exibe o banner carregado
    MobileAds.show_banner()

    # Oculta o banner da tela
    MobileAds.hide_banner()

    # Destrói o banner para liberar memória
    MobileAds.destroy_banner()
    ```

=== "C#"

    ```csharp
    // Exibe o banner carregado
    MobileAds.Call("show_banner");

    // Oculta o banner da tela
    MobileAds.Call("hide_banner");

    // Destrói o banner para liberar memória
    MobileAds.Call("destroy_banner");
    ```

---

## Obtendo as Dimensões do Banner

Você pode verificar a largura e altura do banner usando os seguintes métodos:

=== "GDScript"

    ```gdscript
    var width = MobileAds.get_banner_width()
    var height = MobileAds.get_banner_height()
    var width_px = MobileAds.get_banner_width_in_pixels()
    var height_px = MobileAds.get_banner_height_in_pixels()
    ```

=== "C#"

    ```csharp
    // Use Convert.ToInt32 para obter tamanhos de forma segura no iOS/Android Mono:
    int width = System.Convert.ToInt32(MobileAds.Call("get_banner_width"));
    int height = System.Convert.ToInt32(MobileAds.Call("get_banner_height"));
    ```
