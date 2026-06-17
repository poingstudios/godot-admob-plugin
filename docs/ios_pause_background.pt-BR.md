# iOS Pausar em Segundo Plano (Pause Background)

Esta etapa é apenas para o iOS. Ela serve para indicar se o seu jogo no Godot deve ser pausado ou não quando um anúncio em tela cheia for exibido, como Intersticial, Premiado e Intersticial Premiado.

No Android, seu jogo é pausado automaticamente quando um anúncio em tela cheia é exibido (o Google não permite configurar isso). Chamar este método passando o parâmetro `true` duplicará esse comportamento no iOS.

No iOS, o valor padrão é `false`.

# Pré-requisitos

- Concluir o [Guia de Início Rápido](index.md)
- Usar Godot v4.2 ou superior

# Como usar
Você pode usar esse método quando desejar, antes, durante ou após a inicialização, como por exemplo:

=== "GDScript"

    ```gdscript linenums="1" hl_lines="2"
    func _on_set_ios_app_pause_on_background_button_pressed() -> void:
    	MobileAds.set_ios_app_pause_on_background(true)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="3"
    private void OnSetIosAppPauseOnBackgroundButtonPressed()
    {
        MobileAds.SetIosAppPauseOnBackground(true);
    }
    ```

# Notas importantes

Se o seu jogo for multiplayer, provavelmente você precisará manter esse valor como `false` devido a possíveis problemas de conexão.
[Leia mais sobre isso aqui (em inglês)](https://github.com/poingstudios/godot-admob-ios/issues/70).
