# Integrar PubMatic OpenWrap com Mediação

Este guia explica como usar o SDK do Google Mobile Ads para carregar e apresentar anúncios da PubMatic por meio de [mediação](../get_started.md). Ele fornece instruções sobre como integrar a PubMatic na configuração de mediação de um aplicativo Godot e integrar o SDK e adaptador da PubMatic.

Este documento é baseado em:

- [Documentação do SDK do Google Mobile Ads para Android](https://developers.google.com/admob/android/mediation/pubmatic)
- [Documentação do SDK do Google Mobile Ads para iOS](https://developers.google.com/admob/ios/mediation/pubmatic)

## Integrações e formatos de anúncios suportados

O adaptador de mediação do AdMob para PubMatic tem as seguintes capacidades:

| Integração |   |
|-------------|---|
| Bidding     | ✅ |
| Waterfall   | ✅ |

| Formatos              |            |
|-----------------------|------------|
| Banner                | ✅          |
| Interstitial          | ✅          |
| Rewarded              | ✅          |
| Rewarded Interstitial  | ✅          |

## Pré-requisitos
- Conclua o [Guia de início](../../index.md)
- Conclua o [Guia de início de mediação](../get_started.md)

## Passo 1: Configurar a PubMatic OpenWrap
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/pubmatic#step_1_set_up_pubmatic) ou [iOS](https://developers.google.com/admob/ios/mediation/pubmatic#step_1_set_up_pubmatic), pois será o mesmo para ambos.

## Passo 2: Configurar as definições de mediação para o seu bloco de anúncios do AdMob
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/pubmatic#step_2) ou [iOS](https://developers.google.com/admob/ios/mediation/pubmatic#step_2), pois será o mesmo para ambos.

## Passo 3: Importar o plugin do SDK da PubMatic

=== "Android"
    1. Baixe o plugin para [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extraia o arquivo `.zip`. Dentro, você encontrará uma pasta `pubmatic`.
    3. Copie o conteúdo da pasta `pubmatic` e cole-o na pasta do plugin Android em `res://addons/admob/android/bin/`.

=== "iOS"
    O adaptador PubMatic já **está incluído** no download padrão do plugin iOS. Se você seguiu o [Guia de instalação do iOS](../../index.md#download-install), você já deve ter os arquivos necessários (`poing-godot-admob-pubmatic.gdip`) em seu diretório `res://ios/plugins/`.

## Passo 4: Ativar o plugin

=== "Android"
    Certifique-se de ativar **PubMatic** nas **Configurações do Projeto** (em `Admob > Android > Mediation > Pubmatic`).

=== "iOS"
    Certifique-se de marcar tanto `Ad Mob` com `Ad Mob PubMatic` na lista de Plugins em suas **Configurações de Exportação do iOS** (além de inserir seu ID do aplicativo AdMob na configuração do Plists).

## Passo 5: Adicionar o código necessário
Nenhuma configuração de código adicional é necessária para a integração deste parceiro.
