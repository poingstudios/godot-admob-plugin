# Pausar em Segundo Plano no iOS

Esta etapa é apenas para iOS. Ela indica se o seu jogo em Godot deve ser pausado ou não quando um anúncio em tela cheia (como Intersticial, Premiado ou Intersticial Premiado) estiver sendo exibido.

No Android, seu jogo é pausado automaticamente quando um anúncio em tela cheia é exibido (comportamento controlado pelo sistema operacional e que não pode ser alterado). Passar `true` para este método replica esse comportamento no iOS. No iOS, o valor padrão é `false`.

---

## Pré-requisitos

- Concluir o guia [Começar](index.md)
- Utilizar o Godot v3.3 ou superior.

---

## Como Usar

Você pode chamar este método a qualquer momento:

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.set_ios_app_pause_on_background(true)
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Call("set_ios_app_pause_on_background", true);
    }
    ```
