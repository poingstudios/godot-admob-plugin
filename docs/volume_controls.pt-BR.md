# Controles de Volume

Controle o volume dos anúncios em vídeo do AdMob para que você possa integrá-los às configurações de áudio do seu aplicativo. Os controles de volume funcionam tanto no Android quanto no iOS.

Use `set_app_volume()` para definir o volume relativo (0.0 a 1.0) e `set_app_muted()` para silenciar ou reativar o áudio do anúncio.

# Pré-requisitos

- Concluir o [Guia de Início Rápido](index.md)
- Usar Godot v4.2 ou superior

# Como usar

=== "GDScript"

    ```gdscript
    # Define o volume do anúncio (0.0 = silencioso, 1.0 = volume máximo)
    MobileAds.set_app_volume(0.5)
    
    # Silencia ou ativa o áudio dos anúncios
    MobileAds.set_app_muted(true)
    ```

=== "C#"

    ```csharp
    // Define o volume do anúncio (0.0 = silencioso, 1.0 = volume máximo)
    MobileAds.SetAppVolume(0.5f);
    
    // Silencia ou ativa o áudio dos anúncios
    MobileAds.SetAppMuted(true);
    ```

# Referência da API

**set_app_volume(volume: float)**

Define o volume relativo para a reprodução do anúncio. Os valores são limitados ao intervalo entre 0.0 (silencioso) e 1.0 (volume atual do dispositivo).

**set_app_muted(muted: bool)**

Informa ao AdMob SDK quando o áudio do aplicativo está silenciado. Quando definido como `true`, o áudio do anúncio é silenciado.

# Notas importantes

- Essas configurações se aplicam a anúncios em vídeo (Intersticial, Premiado, Intersticial Premiado, App Open). Anúncios de banner e nativos podem não oferecer suporte ao controle de volume personalizado.
- As configurações de volume podem ser alteradas a qualquer momento, antes ou depois do carregamento do anúncio.
- Sincronize essas chamadas com a barra de volume do seu jogo ou tela de configurações para obter uma experiência de usuário consistente.
