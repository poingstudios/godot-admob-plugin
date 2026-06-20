# Integrar LINE Ads Network com Mediação

Este guia explica como usar o SDK do Google Mobile Ads para carregar e apresentar anúncios da LINE Ads Network (FiveAd) por meio de [mediação](../get_started.md). Ele fornece instruções sobre como integrar a LINE Ads Network na configuração de mediação de um aplicativo Godot e integrar o SDK e adaptador da LINE Ads Network.

Este documento é baseado em:

- [Documentação do SDK do Google Mobile Ads para Android](https://developers.google.com/admob/android/mediation/line)
- [Documentação do SDK do Google Mobile Ads para iOS](https://developers.google.com/admob/ios/mediation/line)

## Integrações e formatos de anúncios suportados

O adaptador de mediação do AdMob para LINE Ads Network tem as seguintes capacidades:

| Integração |   |
|-------------|---|
| Bidding     | ✅ |
| Waterfall   | ✅ |

| Formatos              |            |
|-----------------------|------------|
| Banner                | ✅          |
| Interstitial          | ✅          |
| Rewarded              | ✅          |
| Rewarded Interstitial |            |
| Native                |            |

## Pré-requisitos
- Conclua o [Guia de início](../../index.md)
- Conclua o [Guia de início de mediação](../get_started.md)

## Passo 1: Configurar a LINE Ads Network
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/line#step_1_set_up_line_ads_network) ou [iOS](https://developers.google.com/admob/ios/mediation/line#step_1_set_up_line_ads_network), pois será o mesmo para ambos.

## Passo 2: Configurar as definições de mediação para o seu bloco de anúncios do AdMob
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/line#step_2) ou [iOS](https://developers.google.com/admob/ios/mediation/line#step_2), pois será o mesmo para ambos.

## Passo 3: Importar o plugin do SDK do LINE Ads Network

=== "Android"
    1. Baixe o plugin para [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extraia o arquivo `.zip`. Dentro, você encontrará uma pasta `line`.
    3. Copie o conteúdo da pasta `line` e cole-o na pasta do plugin Android em `res://addons/admob/android/bin/`.

=== "iOS"
    O adaptador LINE Ads Network já **está incluído** no download padrão do plugin iOS. Se você seguiu o [Guia de instalação do iOS](../../index.md#download-install), você já deve ter os arquivos necessários (`poing-godot-admob-line.gdip`) em seu diretório `res://ios/plugins/`.

## Passo 4: Ativar o plugin

=== "Android"
    Certifique-se de ativar **Line** nas **Configurações do Projeto** (em `Admob > Android > Mediation > Line`).

=== "iOS"
    Certifique-se de marcar tanto `Ad Mob` quanto `Ad Mob Line` na lista de Plugins em suas **Configurações de Exportação do iOS** (além de inserir seu ID do aplicativo AdMob na configuração do Plists).
