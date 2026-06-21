# Integrar Mintegral com Mediação

Este guia explica como usar o SDK do Google Mobile Ads para carregar e apresentar anúncios da Mintegral por meio de [mediação](../get_started.md). Ele fornece instruções sobre como integrar a Mintegral na configuração de mediação de um aplicativo Godot e integrar o SDK e adaptador da Mintegral.

Este documento é baseado em:

- [Documentação do SDK do Google Mobile Ads para Android](https://developers.google.com/admob/android/mediation/mintegral)
- [Documentação do SDK do Google Mobile Ads para iOS](https://developers.google.com/admob/ios/mediation/mintegral)

## Integrações e formatos de anúncios suportados

O adaptador de mediação do AdMob para Mintegral tem as seguintes capacidades:

| Integração |   |
|-------------|---|
| Bidding     | ✅ |
| Waterfall   | ✅ |

| Formatos              |            |
|-----------------------|------------|
| App Open              | ✅          |
| Banner                | ✅          |
| Interstitial          | ✅          |
| Rewarded              | ✅          |
| Rewarded Interstitial | ✅          |
| Native                |            |

## Pré-requisitos
- Conclua o [Guia de início](../../index.md)
- Conclua o [Guia de início de mediação](../get_started.md)

## Passo 1: Configurar a Mintegral
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/mintegral#step_1_set_up_mintegral) ou [iOS](https://developers.google.com/admob/ios/mediation/mintegral#step_1_set_up_mintegral), pois será o mesmo para ambos.

## Passo 2: Configurar as definições de mediação para o seu bloco de anúncios do AdMob
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/mintegral#step_2) ou [iOS](https://developers.google.com/admob/ios/mediation/mintegral#step_2), pois será o mesmo para ambos.

## Passo 3: Importar o plugin do SDK da Mintegral

=== "Android"
    1. Baixe o plugin para [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extraia o arquivo `.zip`. Dentro, você encontrará uma pasta `mintegral`.
    3. Copie o conteúdo da pasta `mintegral` e cole-o na pasta do plugin Android em `res://addons/admob/android/bin/`.

=== "iOS"
    O adaptador Mintegral já **está incluído** no download padrão do plugin iOS. Se você seguiu o [Guia de instalação do iOS](../../index.md#download-install), você já deve ter os arquivos necessários (`poing-godot-admob-mintegral.gdip`) em seu diretório `res://ios/plugins/`.

## Passo 4: Ativar o plugin

=== "Android"
    Certifique-se de ativar **Mintegral** nas **Configurações do Projeto** (em `Admob > Android > Mediation > Mintegral`).

=== "iOS"
    Certifique-se de marcar tanto `Ad Mob` quanto `Ad Mob Mintegral` na lista de Plugins em suas **Configurações de Exportação do iOS** (além de inserir seu ID do aplicativo AdMob na configuração do Plists).

## Passo 5: Adicionar o código necessário
Nenhuma configuração de código adicional é necessária para a integração deste parceiro.
