# Integrar Unity Ads com Mediação

Este guia explica como utilizar o SDK do Google Mobile Ads para carregar e apresentar anúncios da Unity Ads por meio de [mediação](../get_started.md). Ele fornece instruções sobre como integrar a Unity Ads na configuração de mediação de um aplicativo Godot e como integrar o SDK e o adaptador da Unity Ads em seu aplicativo Godot.

Este documento é baseado em:

- [Documentação do SDK do Google Mobile Ads para Android (Inglês)](https://developers.google.com/admob/android/mediation/unity)
- [Documentação do SDK do Google Mobile Ads para iOS (Inglês)](https://developers.google.com/admob/ios/mediation/unity)

## Integrações e formatos de anúncios suportados

O adaptador de mediação da AdMob para Unity Ads possui as seguintes capacidades:

| Integração |   |
|-------------|---|
| Bidding     | ✅ |
| Waterfall   | ✅ |

| Formatos               |            |
|-----------------------|------------|
| Banner                | ✅          |
| Intersticial          | ✅          |
| Premiado (Rewarded)   | ✅          |
| Intersticial Premiado | ✅          |

## Pré-requisitos
- Conclua o [Guia de Primeiros Passos](../../index.md)
- Conclua o [Guia de Primeiros Passos de Mediação](../get_started.md)

## Passo 1: Configurar Unity Ads
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/unity#step_1_set_up_unity_ads) ou [iOS](https://developers.google.com/admob/ios/mediation/unity#step_1_set_up_unity_ads), pois será o mesmo para ambos.

## Passo 2: Configurar as definições de mediação para o seu bloco de anúncios da AdMob
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/unity#step_2) ou [iOS](https://developers.google.com/admob/ios/mediation/unity#step_2), pois será o mesmo para ambos.

## Passo 3: Importar o plugin do SDK da Unity Ads

=== "Android"
    1. Baixe o plugin para [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extraia o arquivo `.zip`. Dentro, você encontrará uma pasta `unity_ads`.
    3. Copie o conteúdo da pasta `unity_ads` e cole-o na pasta de plugins do Android em `res://addons/admob/android/bin/`.

=== "iOS"
    O adaptador da Unity Ads **já está incluído** no download padrão do plugin para iOS. Se você seguiu o [Guia de Instalação para iOS](../../index.md#download-install), você já deve ter os arquivos necessários (`poing-godot-admob-unity_ads.gdip` e frameworks relacionados) em seu diretório `res://ios/plugins/`.

## Passo 4: Ativar o plugin

=== "Android"
    Certifique-se de ativar **Unity Ads** nas **Configurações do Projeto** (em `Admob > Android > Mediation > Unity Ads`).

=== "iOS"
    Certifique-se de marcar tanto `Ad Mob` quanto `Ad Mob Unity Ads` na lista de Plugins em seus **Export Presets de iOS** (além de inserir seu AdMob App ID na configuração de Plists).

## Passo 5: Configurações adicionais

### Política de Consentimento de Usuários da UE
Para passar informações de consentimento para o SDK da Unity Ads, use o seguinte código:

=== "GDScript"

    ```gdscript
    UnityAds.set_consent(true)
    ```

=== "C#"

    ```csharp
    UnityAds.SetConsent(true);
    ```

### Consentimento de Privacidade
Para definir o consentimento de privacidade (por exemplo, para CCPA), use o seguinte código:

=== "GDScript"

    ```gdscript
    UnityAds.set_privacy_consent("user_privacy_data", true)
    ```

=== "C#"

    ```csharp
    UnityAds.SetPrivacyConsent("user_privacy_data", true);
    ```
