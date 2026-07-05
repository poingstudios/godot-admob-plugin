# Integrar InMobi com Mediação

Este guia explica como utilizar o SDK do Google Mobile Ads para carregar e apresentar anúncios da InMobi por meio de [mediação](../get_started.md). Ele fornece instruções sobre como integrar a InMobi na configuração de mediação de um aplicativo Godot e como integrar o SDK e o adaptador da InMobi.

Este documento é baseado em:

- [Documentação do SDK do Google Mobile Ads para Android (Inglês)](https://developers.google.com/admob/android/mediation/inmobi)
- [Documentação do SDK do Google Mobile Ads para iOS (Inglês)](https://developers.google.com/admob/ios/mediation/inmobi)

## Integrações e formatos de anúncios suportados

O adaptador de mediação da AdMob para InMobi possui as seguintes capacidades:

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
| Nativo                | ✅          |

## Pré-requisitos
- Conclua o [Guia de Primeiros Passos](../../index.md)
- Conclua o [Guia de Primeiros Passos de Mediação](../get_started.md)

## Passo 1: Configurar InMobi
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/inmobi#step_1_set_up_inmobi) ou [iOS](https://developers.google.com/admob/ios/mediation/inmobi#step_1_set_up_inmobi), pois será o mesmo para ambos.

## Passo 2: Configurar as definições de mediação para o seu bloco de anúncios da AdMob
Recomendamos seguir o tutorial para [Android](https://developers.google.com/admob/android/mediation/inmobi#step_2) ou [iOS](https://developers.google.com/admob/ios/mediation/inmobi#step_2), pois será o mesmo para ambos.

## Passo 3: Importar o plugin do SDK da InMobi

=== "Android"
    1. Baixe o plugin para [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extraia o arquivo `.zip`. Dentro, você encontrará uma pasta `inmobi`.
    3. Copie o conteúdo da pasta `inmobi` e cole-o na pasta de plugins do Android em `res://addons/admob/android/bin/`.

=== "iOS"
    O adaptador da InMobi **já está incluído** no download padrão do plugin para iOS. Se você seguiu o [Guia de Instalação para iOS](../../index.md#download-install), você já deve ter os arquivos necessários (`poing-godot-admob-inmobi.gdip` e frameworks relacionados) em seu diretório `res://ios/plugins/`.

## Passo 4: Ativar o plugin

=== "Android"
    Certifique-se de ativar **Inmobi** nas **Configurações do Projeto** (em `Admob > Android > Mediation > Inmobi`).

=== "iOS"
    Certifique-se de marcar tanto `Ad Mob` quanto `Ad Mob InMobi` na lista de Plugins em seus **Export Presets de iOS** (além de inserir seu AdMob App ID na configuração de Plists).

## Passo 5: Passos opcionais (Configurações regulatórias)
A InMobi não requer nenhuma configuração de código personalizada adicional para as definições de GDPR ou CCPA por meio da API do adaptador do Google Mobile Ads. As configurações de consentimento e privacidade são gerenciadas automaticamente ao usar uma CMP certificada pelo Google (como o UMP SDK) e adicionar a InMobi como um parceiro de anúncios personalizado nas configurações do painel da AdMob/Ad Manager.
