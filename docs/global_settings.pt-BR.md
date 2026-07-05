# Configurações Globais

A classe `MobileAds` fornece configurações globais para o Google Mobile Ads SDK.

## Controle de volume de anúncios

Se seu aplicativos possui controles de volume próprios, como volumes personalizados de música ou efeitos sonoros, divulgar o volume do aplicativo para o Google Mobile Ads SDK permite que os anúncios em vídeo respeitem as configurações de volume do aplicativo. Isso garante que os usuários recebam anúncios em vídeo com o volume de áudio esperado.

O volume do dispositivo, controlado pelos botões de volume ou pelo controle deslizante de volume do nível do sistema operacional, determina o volume da saída de áudio do dispositivo. No entanto, os aplicativos podem ajustar independentemente os níveis de volume em relação ao volume do dispositivo para personalizar a experiência de áudio.

Você pode reportar o volume relativo do aplicativo para o Google Mobile Ads SDK chamando o método `set_app_volume()` antes de carregar o anúncio. Os valores válidos de volume do anúncio variam de `0.0` (silencioso) a `1.0` (volume atual do dispositivo). Aqui está um exemplo de como reportar o volume relativo do aplicativo para o SDK:

=== "GDScript"

    ```gdscript
    # Definir o volume do aplicativo como metade do volume atual do dispositivo.
    MobileAds.set_app_volume(0.5)
    ```

=== "C#"

    ```csharp
    // Definir o volume do aplicativo como metade do volume atual do dispositivo.
    MobileAds.SetAppVolume(0.5f);
    ```

!!! warning
    Diminuir o volume do áudio do seu aplicativo reduz a elegibilidade dos anúncios em vídeo e pode diminuir a receita de anúncios do seu aplicativo. Você só deve utilizar este método se o seu aplicativo fornecer controles de volume personalizados ao usuário, e o volume do usuário for refletido corretamente no aplicativo.

Para informar ao SDK que o volume do aplicativo foi mutado, chame o método `set_app_muted()` antes de carregar o anúncio:

=== "GDScript"

    ```gdscript
    # Definir o aplicativo como mutado.
    MobileAds.set_app_muted(true)
    ```

=== "C#"

    ```csharp
    // Definir o aplicativo como mutado.
    MobileAds.SetAppMuted(true);
    ```

Por padrão, o volume do aplicativo é definido como `1`, o volume atual do dispositivo, e o aplicativo não está mutado.

!!! warning
    Silenciar seu aplicativo reduz a elegibilidade dos anúncios em vídeo e pode diminuir a receita de anúncios do seu aplicativo. Você só deve utilizar este método se o seu aplicativo fornecer um controle de silenciamento personalizado ao usuário, e a decisão de silenciar do usuário for refletida corretamente no aplicativo.

## Consentimento para cookies

Se seu aplicativo possui requisitos especiais, você pode definir a chave opcional `gad_has_consent_for_cookies` como zero para habilitar [anúncios limitados](https://support.google.com/admob/answer/10105530):

=== "GDScript"

    ```gdscript
    # Habilitar anúncios limitados
    MobileAds.set_gad_has_consent_for_cookies(false)
    ```

=== "C#"

    ```csharp
    // Habilitar anúncios limitados
    MobileAds.SetGadHasConsentForCookies(false);
    ```

## Desabilitar relatório de fallos

O Google Mobile Ads SDK coleta relatórios de falhas para depuração e análise. Para desabilitar o relatório de falhos, veja as seguintes seções para Android e iOS.

=== "Android"

    Adicione a tag `<meta-data>` com `DISABLE_CRASH_REPORTING` definido como `true` no arquivo `AndroidManifest.xml` do seu aplicativo:

    ```xml
    <manifest>
       <application>
           <meta-data
               android:name="com.google.android.gms.ads.flag.DISABLE_CRASH_REPORTING"
               android:value="true" />
       </application>
    </manifest>
    ```

=== "iOS"

    Chame o método `disable_sdk_crash_reporting()` para desabilitar relatórios de falhos no iOS:

    === "GDScript"

        ```gdscript
        func _ready() -> void:
            MobileAds.disable_sdk_crash_reporting()
        ```

    === "C#"

        ```csharp
        public override void _Ready()
        {
            MobileAds.DisableSdkCrashReporting();
        }
        ```

## Obter versão do plugin

Para obter a versão do plugin, execute o seguinte:

=== "GDScript"

    ```gdscript
    # Obter a versão do plugin.
    print("Versão do Plugin: " + MobileAds.get_version())
    ```

=== "C#"

    ```csharp
    // Obter a versão do plugin.
    GD.Print("Versão do Plugin: " + MobileAds.GetVersion());
    ```

## Obter versão da plataforma

O Google Mobile Ads SDK depende das SDKs de plataforma Android e iOS. Para obter a versão da SDK da plataforma, execute o seguinte:

=== "GDScript"

    ```gdscript
    # Obter a versão da SDK da plataforma subjacente.
    print("Versão da SDK da Plataforma: " + MobileAds.get_platform_version())
    ```

=== "C#"

    ```csharp
    // Obter a versão da SDK da plataforma subjacente.
    GD.Print("Versão da SDK da Plataforma: " + MobileAds.GetPlatformVersion());
    ```
