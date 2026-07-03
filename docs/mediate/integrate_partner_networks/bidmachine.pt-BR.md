# Integrar BidMachine com Mediação

Este guia explica como utilizar o SDK do Google Mobile Ads para carregar e apresentar anúncios do BidMachine por meio de [mediação](../get_started.md). Ele fornece instruções sobre como integrar o BidMachine na configuração de mediação de um aplicativo Godot e integrar o SDK e adaptador do BidMachine ao seu aplicativo Godot.

Este documento é baseado em:

- [Documentação do SDK do Google Mobile Ads para Android (Inglês)](https://developers.google.com/admob/android/mediation/bidmachine)
- [Documentação do SDK do Google Mobile Ads para iOS (Inglês)](https://developers.google.com/admob/ios/mediation/bidmachine)

## Integrações e formatos de anúncios suportados

O adaptador de mediação do AdMob para BidMachine tem as seguintes capacidades:

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

## Etapa 1: Configurar o BidMachine
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/bidmachine#step_1_set_up_bidmachine) ou [iOS](https://developers.google.com/admob/ios/mediation/bidmachine#step_1_set_up_bidmachine), pois será o mesmo para ambos.

## Etapa 2: Configurar as definições de mediação para o seu bloco de anúncios do AdMob
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/bidmachine#step_2) ou [iOS](https://developers.google.com/admob/ios/mediation/bidmachine#step_2), pois será o mesmo para ambos.

## Etapa 3: Importar o plugin do SDK do BidMachine

=== "Android"
    1. Baixe o plugin para [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extraia o arquivo `.zip`. Dentro dele, você encontrará uma pasta `bidmachine`.
    3. Copie o conteúdo da pasta `bidmachine` e cole-o na pasta do plugin Android em `res://addons/admob/android/bin/`.

=== "iOS"
    O adaptador do BidMachine **já está incluso** no download padrão do plugin iOS. Se você seguiu o [Guia de Instalação do iOS](../../index.md#download-instalacao), você já deve ter os arquivos necessários (`poing-godot-admob-bidmachine.gdip` e frameworks relacionados) no diretório `res://ios/plugins/`.

## Etapa 4: Habilitar o plugin

=== "Android"
    Certifique-se de habilitar o **Bidmachine** nas **Configurações do Projeto** (em `Admob > Android > Mediation > Bidmachine`).

=== "iOS"
    Certifique-se de marcar tanto o `Ad Mob` quanto o `Ad Mob Bid Machine` na lista de Plugins em seus **Presets de Exportação do iOS** (além de inserir o ID do seu Aplicativo AdMob nas configurações do Plist).

## Etapa 5: Etapas opcionais (Configurações Regulatórias)

### Consentimento da UE e GDPR
Sob a [Política de Consentimento de Usuários da UE](https://www.google.com/about/company/consentstaging.html) do Google, você deve fazer certas divulgações aos usuários no Espaço Econômico Europeu (EEE) e obter seu consentimento para o uso de cookies ou outros armazenamentos locais, e para o uso de dados pessoais.

Para passar as informações de consentimento do GDPR para o SDK do BidMachine, use o seguinte código:

=== "GDScript"

    ```gdscript
    # Set whether user is subject to GDPR
    BidMachine.set_subject_to_gdpr(true)
    
    # Set the consent status
    BidMachine.set_consent_status(true)
    ```

=== "C#"

    ```csharp
    // Set whether user is subject to GDPR
    BidMachine.SetSubjectToGdpr(true);
    
    // Set the consent status
    BidMachine.SetConsentStatus(true);
    ```

### CCPA
Para cumprir com a CCPA, você pode definir a String de Privacidade dos EUA (U.S. Privacy String). O exemplo de código a seguir mostra como passar essas informações para o SDK do BidMachine:

=== "GDScript"

    ```gdscript
    BidMachine.set_us_privacy_string("1YNN")
    ```

=== "C#"

    ```csharp
    BidMachine.SetUsPrivacyString("1YNN");
    ```
