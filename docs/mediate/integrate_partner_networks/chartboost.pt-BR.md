# Integrar Chartboost com Mediação

Este guia explica como utilizar o SDK do Google Mobile Ads para carregar e apresentar anúncios da Chartboost por meio de [mediação](../get_started.md). Ele fornece instruções sobre como integrar a Chartboost na configuração de mediação de um aplicativo Godot e como integrar o SDK e o adaptador da Chartboost em seu aplicativo Godot.

Este documento é baseado em:

- [Documentação do SDK do Google Mobile Ads para Android (Inglês)](https://developers.google.com/admob/android/mediation/chartboost)
- [Documentação do SDK do Google Mobile Ads para iOS (Inglês)](https://developers.google.com/admob/ios/mediation/chartboost)

## Integrações e formatos de anúncios suportados

O adaptador de mediação da AdMob para Chartboost possui as seguintes capacidades:

| Integração |   |
|-------------|---|
| Bidding     | ✅ |
| Waterfall   | ✅ |

| Formatos               |            |
|-----------------------|------------|
| Banner                | ✅          |
| Intersticial          | ✅          |
| Premiado (Rewarded)   | ✅          |
| Intersticial Premiado |            |
| Nativo                |            |

## Pré-requisitos
- Conclua o [Guia de Primeiros Passos](../../index.md)
- Conclua o [Guia de Primeiros Passos de Mediação](../get_started.md)

## Passo 1: Configurar Chartboost
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/chartboost#step_1_set_up_chartboost) ou [iOS](https://developers.google.com/admob/ios/mediation/chartboost#step_1_set_up_chartboost), pois será o mesmo para ambos.

## Passo 2: Configurar as definições de mediação para o seu bloco de anúncios da AdMob
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/chartboost#step_2) ou [iOS](https://developers.google.com/admob/ios/mediation/chartboost#step_2), pois será o mesmo para ambos.

## Passo 3: Importar o plugin do SDK da Chartboost

=== "Android"
    1. Baixe o plugin para [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extraia o arquivo `.zip`. Dentro, você encontrará uma pasta `chartboost`.
    3. Copie o conteúdo da pasta `chartboost` e cole-o na pasta de plugins do Android em `res://addons/admob/android/bin/`.

=== "iOS"
    O adaptador da Chartboost **já está incluído** no download padrão do plugin para iOS. Se você seguiu o [Guia de Instalação para iOS](../../index.md#download-install), você já deve ter os arquivos necessários (`poing-godot-admob-chartboost.gdip` e frameworks relacionados) em seu diretório `res://ios/plugins/`.

## Passo 4: Ativar o plugin

=== "Android"
    Certifique-se de ativar **Chartboost** nas **Configurações do Projeto** (em `Admob > Android > Mediation > Chartboost`).

=== "iOS"
    Certifique-se de marcar tanto `Ad Mob` quanto `Ad Mob Chartboost` na lista de Plugins em seus **Export Presets de iOS** (além de inserir seu AdMob App ID na configuração de Plists).

## Passo 5: Passos opcionais (Configurações regulatórias)

### Consentimento da UE e GDPR
Sob a [Política de Consentimento de Usuários da UE](https://www.google.com/about/company/consentstaging.html) do Google, você deve fazer certas divulgações aos usuários no Espaço Econômico Europeu (EEE) e obter seu consentimento para o uso de cookies ou outro armazenamento local, e para o uso de dados pessoais.

Para passar informações de consentimento do GDPR para o SDK da Chartboost, use o seguinte código:

=== "GDScript"

    ```gdscript
    Chartboost.set_consent(true)
    ```

=== "C#"

    ```csharp
    Chartboost.SetConsent(true);
    ```

### CCPA
Para estar em conformidade com a CCPA, você pode definir as configurações de "não vender" (do not sell). O código de exemplo a seguir mostra como passar essa informação para o SDK da Chartboost:

=== "GDScript"

    ```gdscript
    Chartboost.set_ccpa_consent(true)
    ```

=== "C#"

    ```csharp
    Chartboost.SetCCPAConsent(true);
    ```
