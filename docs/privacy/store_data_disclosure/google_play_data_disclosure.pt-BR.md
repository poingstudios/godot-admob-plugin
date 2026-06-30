# Divulgação de dados do Google Play

Em maio de 2021, o Google Play [anunciou a nova seção de Segurança de dados](https://android-developers.googleblog.com/2021/05/new-safety-section-in-google-play-will.html), que é uma divulgação fornecida pelo desenvolvedor sobre as práticas de coleta, compartilhamento e segurança de dados do aplicativo.

Esta página pode ajudá-lo a completar os requisitos para essa divulgação de dados em relação ao seu uso do Plugin Godot AdMob. Nesta página, você pode encontrar informações sobre se e como o SDK do Google Mobile Ads lida com dados do usuário final, incluindo quaisquer configurações ou opções aplicáveis que você pode controlar como desenvolvedor do aplicativo.

!!! note
    **Importante**: Como desenvolvedor do aplicativo, você é o único responsável por decidir como responder ao formulário de Segurança de dados do Google Play regarding as práticas de coleta, compartilhamento e segurança de dados do seu aplicativo.

Este documento é baseado em:

- [SDK do Google Mobile Ads para Android - Divulgação de Dados do Google Play](https://developers.google.com/admob/android/privacy/play-data-disclosure)

## Como usar as informações nesta página

Esta página lista os dados do usuário final coletados pela versão mais recente do SDK do Google Mobile Ads. Se você estiver usando uma versão anterior, considere atualizar para a versão mais recente para garantir que as divulgações do seu aplicativo estejam precisas.

Para completar sua divulgação de dados, você pode usar o [guia sobre tipos de dados](https://developer.android.com/guide/topics/data/collect-share) do Android para ajudá-lo a determinar quais tipos de dados e propósitos melhor descrevem os dados coletados. Na sua divulgação de dados, certifique-se também de considerar como seu aplicativo específico compartilha e usa os dados coletados.

## Dados coletados e compartilhados automaticamente

O SDK do Google Mobile Ads coleta e compartilha os seguintes tipos de dados *automaticamente* para fins de publicidade, análise e prevenção de fraudes.

| Dados | Por padrão, o SDK do Google Mobile Ads... |
|-------|---------------------------------------------|
| **Endereço IP** | Coleta o endereço IP do dispositivo, que pode ser usado para estimar a localização geral de um dispositivo. |
| **Interações do produto do usuário** | Coleta interações do produto do usuário e informações de interação, incluindo abertura do aplicativo, toques e visualizações de vídeo. |
| **Informações de diagnóstico** | Coleta informações relacionadas ao desempenho do seu aplicativo e do SDK, incluindo tempo de inicialização, taxa de travamento e uso de energia. |
| **Identificadores de dispositivo e conta** | Coleta o [ID de publicidade do Android](https://support.google.com/googleplay/android-developer/answer/6048248), o [ID definido pelo aplicativo](https://developer.android.com/training/articles/app-set-id) e, se aplicável, outros identificadores relacionados a contas conectadas no dispositivo. |

Todos os dados do usuário coletados pelo SDK do Google Mobile Ads são criptografados em trânsito usando o protocolo Transport Layer Security (TLS).

## Tratamento de dados

A coleta do ID de publicidade do Android é opcional. O ID de publicidade pode ser redefinido ou excluído pelos usuários usando os controles de ID de publicidade no menu de configurações do Android. Como desenvolvedor do aplicativo, você pode impedir a coleta de IDs de publicidade [atualizando o arquivo de manifesto do aplicativo](https://support.google.com/googleplay/android-developer/answer/6048248).

Certos outros recursos no SDK do Google Mobile Ads, como o recurso [Limited Ads](https://support.google.com/admob/answer/10105530), também podem desativar a transmissão do ID de publicidade e outros dados.

## Dados coletados e compartilhados dependendo do seu uso

Se você estiver usando quaisquer recursos opcionais do produto que envolvam dados adicionais (como relatórios avançados) ou participando de quaisquer testes de novos recursos do produto que envolvam dados adicionais, verifique se esses recursos ou testes requerem divulgações de dados adicionais.

## Outros recursos úteis

- [Post do blog](https://android-developers.googleblog.com/2021/10/launching-data-safety-in-play-console.html) anunciando o formulário de Segurança de dados no Google Play Console.
- O formulário de Segurança de dados do Play Console está disponível na página [Conteúdo do aplicativo](https://play.google.com/console/developers/app/app-content/summary).
