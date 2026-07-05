# Integrar i-mobile com Mediação

Este guia explica como utilizar o SDK do Google Mobile Ads para carregar e apresentar anúncios da i-mobile por meio de [mediação](../get_started.md). Ele fornece instruções sobre como integrar a i-mobile na configuração de mediação de um aplicativo Godot e como integrar o SDK e o adaptador da i-mobile.

Este documento é baseado em:

- [Documentação do SDK do Google Mobile Ads para Android (Inglês)](https://developers.google.com/admob/android/mediation/imobile)
- [Documentação do SDK do Google Mobile Ads para iOS (Inglês)](https://developers.google.com/admob/ios/mediation/imobile)

## Integrações e formatos de anúncios suportados

O adaptador de mediação da AdMob para i-mobile possui as seguintes capacidades:

| Integração |   |
|-------------|---|
| Bidding     |   |
| Waterfall   | ✅ |

| Formatos               |            |
|-----------------------|------------|
| Banner                | ✅          |
| Intersticial          | ✅          |
| Premiado (Rewarded)   |            |
| Intersticial Premiado |            |
| Nativo                |            |

## Pré-requisitos
- Conclua o [Guia de Primeiros Passos](../../index.md)
- Conclua o [Guia de Primeiros Passos de Mediação](../get_started.md)

## Passo 1: Configurar i-mobile
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/imobile#step_1_set_up_i-mobile) ou [iOS](https://developers.google.com/admob/ios/mediation/imobile#step_1_set_up_i-mobile), pois será o mesmo para ambos.

## Passo 2: Configurar as definições de mediação para o seu bloco de anúncios da AdMob
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/imobile#step_2) ou [iOS](https://developers.google.com/admob/ios/mediation/imobile#step_2), pois será o mesmo para ambos.

## Passo 3: Importar o plugin do SDK da i-mobile

=== "Android"
    1. Baixe o plugin para [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extraia o arquivo `.zip`. Dentro, você encontrará uma pasta `imobile`.
    3. Copie o conteúdo da pasta `imobile` e cole-o na pasta de plugins do Android em `res://addons/admob/android/bin/`.

=== "iOS"
    O adaptador da i-mobile **já está incluído** no download padrão do plugin para iOS. Se você seguiu o [Guia de Instalação para iOS](../../index.md#download-install), você já deve ter os arquivos necessários (`poing-godot-admob-imobile.gdip` e frameworks relacionados) em seu diretório `res://ios/plugins/`.

## Passo 4: Ativar o plugin

=== "Android"
    Certifique-se de ativar **Imobile** nas **Configurações do Projeto** (em `Admob > Android > Mediation > Imobile`).

=== "iOS"
    Certifique-se de marcar tanto `Ad Mob` quanto `Ad Mob iMobile` na lista de Plugins em seus **Export Presets de iOS** (além de inserir seu AdMob App ID na configuração de Plists).

## Passo 5: Passos opcionais (Configurações regulatórias)
A i-mobile não requer nenhuma configuração de código personalizada adicional para as definições de GDPR ou CCPA por meio da API do adaptador do Google Mobile Ads. As configurações de consentimento e privacidade são gerenciadas por meio da configuração padrão do painel da AdMob ou das opções em nível de plataforma.
