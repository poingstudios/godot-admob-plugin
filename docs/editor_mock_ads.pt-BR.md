# Visualizar Anúncios Mock no Editor

O plugin vem com um sistema integrado de Anúncios Mock. Isso permite testar o fluxo lógico e o layout visual da sua integração de anúncios diretamente no Editor do Godot, sem precisar exportar para um dispositivo físico.

Os anúncios mock simulam o comportamento dos anúncios reais e disparam os mesmos sinais/callbacks de ciclo de vida (como carregamento, exibição, cliques e fechamento) dos SDKs mobile reais.

---

## Como Funciona

O plugin detecta automaticamente quando o jogo está rodando em uma plataforma desktop (Windows, macOS ou Linux) dentro do Editor do Godot. Em vez de falhar devido à ausência de singletons nativos de Android ou iOS, o plugin instancia singletons e nós mock automaticamente.

Você não precisa alterar nenhuma linha de código em C# ou GDScript. Todas as APIs do singleton `MobileAds` funcionam exatamente da mesma forma.

---

## Formatos Suportados

O sistema mock simula a aparência visual e as interações para os seguintes formatos de anúncios:

### Banners
- Renderiza um container de banner mock na tela combinando com a posição e o tamanho configurados (Standard, Large, Medium Rectangle ou Leaderboard).
- Apresenta um botão de fechar (`×`) para simular o encerramento do anúncio.

### Intersticiais
- Renderiza uma sobreposição intersticial em tela cheia.
- Apresenta um botão de fechar (`X`) que oculta o anúncio e dispara o callback `interstitial_closed`.

### Premiados (Rewarded) & Intersticiais Premiados
- Renderiza uma simulação de vídeo premiado em tela cheia.
- Exibe um temporizador de contagem regressiva.
- Dispara automaticamente o callback `user_earned_rewarded` assim que a contagem termina.
- Apresenta um botão de fechar (`X`) para retornar ao jogo.

---

## Sinais de Ciclo de Vida

Os plugins mock disparam os mesmos sinais dos SDKs reais:

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("interstitial_loaded", self, "_on_interstitial_loaded")
        MobileAds.connect("interstitial_closed", self, "_on_interstitial_closed")
        MobileAds.load_interstitial()

    func _on_interstitial_loaded() -> void:
        print("Anúncio carregado no Editor!")
        MobileAds.show_interstitial()

    func _on_interstitial_closed() -> void:
        print("Anúncio fechado no Editor!")
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Connect("interstitial_loaded", this, nameof(_on_interstitial_loaded));
        MobileAds.Connect("interstitial_closed", this, nameof(_on_interstitial_closed));
        MobileAds.Call("load_interstitial");
    }

    private void _on_interstitial_loaded()
    {
        GD.Print("Anúncio carregado no Editor!");
        MobileAds.Call("show_interstitial");
    }

    private void _on_interstitial_closed()
    {
        GD.Print("Anúncio fechado no Editor!");
    }
    ```
