# Integrar DT Exchange com Mediação

Este guia explica como utilizar o SDK do Google Mobile Ads para carregar e apresentar anúncios da DT Exchange (anteriormente Fyber) por meio de [mediação](../get_started.md). Ele fornece instruções sobre como integrar a DT Exchange na configuração de mediação de um aplicativo Godot e como integrar o SDK e o adaptador da DT Exchange.

Este documento é baseado em:

- [Documentação do SDK do Google Mobile Ads para Android (Inglês)](https://developers.google.com/admob/android/mediation/dt-exchange)
- [Documentação do SDK do Google Mobile Ads para iOS (Inglês)](https://developers.google.com/admob/ios/mediation/dt-exchange)

## Integrações e formatos de anúncios suportados

O adaptador de mediação da AdMob para DT Exchange possui as seguintes capacidades:

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

## Passo 1: Configurar DT Exchange
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/dt-exchange#step_1_set_up_dt_exchange) ou [iOS](https://developers.google.com/admob/ios/mediation/dt-exchange#step_1_set_up_dt_exchange), pois será o mesmo para ambos.

## Passo 2: Configurar as definições de mediação para o seu bloco de anúncios da AdMob
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/dt-exchange#step_2) ou [iOS](https://developers.google.com/admob/ios/mediation/dt-exchange#step_2), pois será o mesmo para ambos.

## Passo 3: Importar o plugin do SDK da DT Exchange

=== "Android"
    1. Baixe o plugin para [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extraia o arquivo `.zip`. Dentro, você encontrará uma pasta `dtexchange`.
    3. Copie o conteúdo da pasta `dtexchange` e cole-o na pasta de plugins do Android em `res://addons/admob/android/bin/`.

=== "iOS"
    O adaptador da DT Exchange **já está incluído** no download padrão do plugin para iOS. Se você seguiu o [Guia de Instalação para iOS](../../index.md#download-install), você já deve ter os arquivos necessários (`poing-godot-admob-dtexchange.gdip` e frameworks relacionados) em seu diretório `res://ios/plugins/`.

## Passo 4: Ativar o plugin

=== "Android"
    Certifique-se de ativar **Dtexchange** nas **Configurações do Projeto** (em `Admob > Android > Mediation > Dtexchange`).

=== "iOS"
    Certifique-se de marcar tanto `Ad Mob` quanto `Ad Mob Dt Exchange` na lista de Plugins em seus **Export Presets de iOS** (além de inserir seu AdMob App ID na configuração de Plists).

## Passo 5: Passos opcionais (Configurações regulatórias)

### Consentimento do GDPR
A DT Exchange permite passar opções de consentimento do GDPR para o seu SDK por meio de uma flag de consentimento booleana ou uma string de consentimento do IAB.

Para passar o consentimento booleano do GDPR, use o seguinte código:

=== "GDScript"

    ```gdscript
    DTExchange.set_gdpr_consent(true)
    ```

=== "C#"

    ```csharp
    DTExchange.SetGDPRConsent(true);
    ```

Para passar a string de consentimento do GDPR IAB, use o seguinte código:

=== "GDScript"

    ```gdscript
    DTExchange.set_gdpr_consent_string("sua_string_de_consentimento_iab")
    ```

=== "C#"

    ```csharp
    DTExchange.SetGDPRConsentString("sua_string_de_consentimento_iab");
    ```

### CCPA (String de Privacidade dos EUA)
Para estar em conformidade com a CCPA, você pode definir a string de privacidade do IAB US. O código de exemplo a seguir mostra como passar essa informação para o SDK da DT Exchange:

=== "GDScript"

    ```gdscript
    DTExchange.set_ccpa_string("1---")
    ```

=== "C#"

    ```csharp
    DTExchange.SetCCPAString("1---");
    ```
