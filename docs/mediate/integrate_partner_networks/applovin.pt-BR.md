# Integrar AppLovin com Mediação

Este guia explica como utilizar o SDK do Google Mobile Ads para carregar e apresentar anúncios do AppLovin por meio de [mediação](../get_started.md). Ele fornece instruções sobre como integrar o AppLovin na configuração de mediação de um aplicativo Godot e integrar o SDK e adaptador do AppLovin ao seu aplicativo Godot.

Este documento é baseado em:

- [Documentação do SDK do Google Mobile Ads para Android (Inglês)](https://developers.google.com/admob/android/mediation/applovin)
- [Documentação do SDK do Google Mobile Ads para iOS (Inglês)](https://developers.google.com/admob/ios/mediation/applovin)

## Integrações e formatos de anúncios suportados

O adaptador de mediação do AdMob para AppLovin tem as seguintes capacidades:

| Integração |   |
|-------------|---|
| Bidding     | ✅ |
| Waterfall   | ✅ |

| Formats               |            |
|-----------------------|------------|
| Banner                | ✅          |
| Interstitial          | ✅          |
| Rewarded              | ✅          |
| Rewarded Interstitial |            |
| Native                |            |

## Pré-requisitos
- Complete o [Guia de Primeiros Passos](../../index.md)
- Complete o [Guia de Primeiros Passos da mediação](../get_started.md)

## Etapa 1: Configurar o AppLovin
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/applovin#step_1_set_up_applovin) ou [iOS](https://developers.google.com/admob/ios/mediation/applovin#step_1_set_up_applovin), pois será o mesmo para ambos.

## Etapa 2: Configurar as definições de mediação para o seu bloco de anúncios do AdMob
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/applovin#step_2) ou [iOS](https://developers.google.com/admob/ios/mediation/applovin#step_2), pois será o mesmo para ambos.

## Etapa 3: Importar o plugin do SDK do AppLovin

=== "Android"
    1. Baixe o plugin para [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extraia o arquivo `.zip`. Dentro dele, você encontrará uma pasta `applovin`.
    3. Copie o conteúdo da pasta `applovin` e cole-o na pasta do plugin Android em `res://addons/admob/android/bin/`.

=== "iOS"
    O adaptador do AppLovin **já está incluso** no download padrão do plugin iOS. Se você seguiu o [Guia de Instalação do iOS](../../index.md#download-instalacao), você já deve ter os arquivos necessários (`poing-godot-admob-applovin.gdip` e frameworks relacionados) no diretório `res://ios/plugins/`.

## Etapa 4: Habilitar o plugin

=== "Android"
    Certifique-se de habilitar o **Applovin** nas **Configurações do Projeto** (em `Admob > Android > Mediation > Applovin`).

=== "iOS"
    Certifique-se de marcar tanto o `Ad Mob` quanto o `Ad Mob App Lovin` na lista de Plugins em seus **Presets de Exportação do iOS** (além de inserir o ID do seu Aplicativo AdMob nas configurações do Plist).

## Etapa 5: Etapas opcionais (Configurações Regulatórias)

### Consentimento da UE e GDPR
Sob a [Política de Consentimento de Usuários da UE](https://www.google.com/about/company/consentstaging.html) do Google, você deve fazer certas divulgações aos usuários no Espaço Econômico Europeu (EEE) e obter seu consentimento para o uso de cookies ou outros armazenamentos locais, e para o uso de dados pessoais.

Para passar as informações de consentimento do GDPR para o SDK do AppLovin, use o seguinte código:

=== "GDScript"

    ```gdscript
    AppLovin.set_has_user_consent(true)
    ```

=== "C#"

    ```csharp
    AppLovin.SetHasUserConsent(true);
    ```

### CCPA
Para cumprir com a CCPA, você pode definir as configurações de "não vender". O exemplo de código a seguir mostra como passar essas informações para o SDK do AppLovin:

=== "GDScript"

    ```gdscript
    AppLovin.set_do_not_sell(false)
    ```

=== "C#"

    ```csharp
    AppLovin.SetDoNotSell(false);
    ```

### Controle de Áudio
Para ativar/desativar o áudio dos anúncios do AppLovin, use o seguinte código:

=== "GDScript"

    ```gdscript
    AppLovin.set_muted(true)
    ```

=== "C#"

    ```csharp
    AppLovin.SetMuted(true);
    ```
