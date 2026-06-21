# Integrar myTarget com Mediação

Este guia explica como usar o SDK do Google Mobile Ads para carregar e apresentar anúncios da myTarget por meio de [mediação](../get_started.md). Ele fornece instruções sobre como integrar a myTarget na configuração de mediação de um aplicativo Godot e integrar o SDK e adaptador da myTarget.

Este documento é baseado em:

- [Documentação do SDK do Google Mobile Ads para Android](https://developers.google.com/admob/android/mediation/mytarget)
- [Documentação do SDK do Google Mobile Ads para iOS](https://developers.google.com/admob/ios/mediation/mytarget)

## Integrações e formatos de anúncios suportados

O adaptador de mediação do AdMob para myTarget tem as seguintes capacidades:

| Integração |   |
|-------------|---|
| Bidding     | ✅ |
| Waterfall   | ✅ |

| Formatos              |            |
|-----------------------|------------|
| Banner                | ✅          |
| Interstitial          | ✅          |
| Rewarded              | ✅          |
| Native                |            |

## Pré-requisitos
- Conclua o [Guia de início](../../index.md)
- Conclua o [Guia de início de mediação](../get_started.md)

## Passo 1: Configurar a myTarget
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/mytarget#step_1_set_up_mytarget) ou [iOS](https://developers.google.com/admob/ios/mediation/mytarget#step_1_set_up_mytarget), pois será o mesmo para ambos.

## Passo 2: Configurar as definições de mediação para o seu bloco de anúncios do AdMob
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/mytarget#step_2) ou [iOS](https://developers.google.com/admob/ios/mediation/mytarget#step_2), pois será o mesmo para ambos.

## Passo 3: Importar o plugin do SDK da myTarget

=== "Android"
    1. Baixe o plugin para [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extraia o arquivo `.zip`. Dentro, você encontrará uma pasta `mytarget`.
    3. Copie o conteúdo da pasta `mytarget` e cole-o na pasta do plugin Android em `res://addons/admob/android/bin/`.

=== "iOS"
    O adaptador myTarget já **está incluído** no download padrão do plugin iOS. Se você seguiu o [Guia de instalação do iOS](../../index.md#download-install), você já deve ter os arquivos necessários (`poing-godot-admob-mytarget.gdip`) em seu diretório `res://ios/plugins/`.

## Passo 4: Ativar o plugin

=== "Android"
    Certifique-se de ativar **myTarget** nas **Configurações do Projeto** (em `Admob > Android > Mediation > MyTarget`).

=== "iOS"
    Certifique-se de marcar tanto `Ad Mob` com `Ad Mob MyTarget` na lista de Plugins em suas **Configurações de Exportação do iOS** (além de inserir seu ID do aplicativo AdMob na configuração do Plists).

## Passo 5: Adicionar o código necessário
Nenhuma configuração de código adicional é necessária para a integração deste parceiro.
