# Visão geral

O inspecionador de anúncios é uma sobreposição no aplicativo que permite realizar análises em tempo real de solicitações de anúncios de teste diretamente no seu aplicativo.

!!! warning "Aviso"
    Ativar o inspecionador de anúncios aumenta o uso de memória do SDK do Google Mobile Ads para dispositivos de teste. O inspecionador de anúncios só é iniciado em **dispositivos de teste**.

## Pré-requisitos

Antes de usar o inspecionador de anúncios, você deve concluir as seguintes tarefas:

1. Criar uma conta do AdMob.
2. Configurar um aplicativo no AdMob.
3. [Configurar o SDK do Google Mobile Ads](../../index.md).
4. Adicionar seu dispositivo como um [dispositivo de teste](../../enable_test_ads.md).

## Tratamento de erros

Quando o inspecionador de anúncios é fechado, o callback recebe um `Dictionary` contendo informações de erro. Se o inspecionador de anúncios foi fechado com sucesso, o dicionário estará vazio.

| Campo | Tipo | Descrição |
|-------|------|-------------|
| `code` | `int` | O código do erro |
| `message` | `string` | Uma mensagem de erro legível por humanos |
| `domain` | `string` | O domínio do erro |

## Referências

- [Android Ad Inspector](https://developers.google.com/admob/android/ad-inspector)
- [iOS Ad Inspector](https://developers.google.com/admob/ios/ad-inspector)
