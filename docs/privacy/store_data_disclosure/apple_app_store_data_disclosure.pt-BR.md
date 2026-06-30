# Divulgação de dados da Apple App Store

A Apple exige que os desenvolvedores que publicam aplicativos na App Store forneçam [certas informações](https://developer.apple.com/app-store/app-privacy-details/) sobre o uso de dados de seus aplicativos. Este guia explica as práticas de coleta de dados do SDK do Google Mobile Ads para facilitar os desenvolvedores AdMob a responderem às perguntas no App Store Connect.

!!! note
    **Importante**: Como desenvolvedor do aplicativo, você é o único responsável por decidir como responder às perguntas de privacidade do App Store Connect em relação às práticas de coleta e uso de dados do seu aplicativo.

Este documento é baseado em:

- [SDK do Google Mobile Ads para iOS - Divulgação de Dados da Apple App Store](https://developers.google.com/admob/ios/privacy/data-disclosure)

## Dados coletados pelo SDK do Google Mobile Ads

Para melhorar o desempenho do AdMob, o SDK do Google Mobile Ads pode coletar certas informações dos aplicativos, incluindo:

| Tipo de Dados | Finalidade |
|---------------|------------|
| **Endereço IP** | Pode ser usado para estimar a localização geral de um dispositivo. |
| **Logs de falha não relacionados ao usuário** | Podem ser usados para diagnosticar problemas e melhorar o SDK. Informações de diagnóstico também podem ser usadas para fins de publicidade e análise. |
| **Dados de desempenho associados ao usuário** | Como tempo de inicialização, taxa de travamento ou uso de energia, que podem ser usados para avaliar o comportamento do usuário, entender a eficácia dos recursos existentes e planejar novos recursos. Dados de desempenho também podem ser usados para exibir anúncios, incluindo compartilhamento com outras entidades que exibem anúncios. |
| **Um ID do dispositivo** | Como o identificador de publicidade do dispositivo ou outros identificadores de dispositivo vinculados ao aplicativo ou desenvolvedor, que podem ser usados para fins de publicidade e análise de terceiros. |
| **Dados de publicidade** | Como anúncios que o usuário viu, podem ser usados para alimentar recursos de análise e publicidade. |
| **Outras interações do produto do usuário** | Como toques de abertura do aplicativo e informações de interação, como visualizações de vídeo, podem ser usados para melhorar o desempenho da publicidade. |

Todos os dados do usuário coletados pelo SDK do Google Mobile Ads são criptografados em trânsito usando o protocolo Transport Layer Security (TLS).

## Arquivos de manifesto de privacidade da Apple

O SDK do Google Mobile Ads versão 11.2.0 e superior suporta declarações de manifesto de privacidade. Você é responsável por verificar o manifesto de privacidade e garantir que as divulgações de dados do seu aplicativo estejam atualizadas.

Consulte a [documentação da Apple](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests) para detalhes sobre como interpretar um relatório de privacidade e sua [atualização de aplicação](https://developer.apple.com/news/?id=pvszzano) para os requisitos de envio de aplicativos.

## Divulgações de dados adicionais

Se você estiver usando quaisquer recursos opcionais do produto que envolvam dados adicionais (como relatórios avançados) ou participando de quaisquer testes de novos recursos do produto que envolvam dados adicionais, verifique se esses recursos ou testes requerem divulgações de dados adicionais.

Se você estiver usando uma versão anterior do SDK do Google Mobile Ads, considere atualizar para a versão mais recente para garantir que as divulgações do seu aplicativo estejam precisas. O SDK do Google Mobile Ads continuará sendo atualizado ao longo do tempo. Certifique-se de verificar e atualizar suas divulgações conforme necessário.
