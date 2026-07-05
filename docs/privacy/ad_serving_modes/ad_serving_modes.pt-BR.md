# Modos de veiculação de anúncios

De acordo com a [Política de Consentimento do Usuário da UE](https://www.google.com/about/company/user-consent-policy.html) do Google, você deve fazer certas divulgações aos seus usuários no Espaço Econômico Europeu (EEE) e no Reino Unido, e obter o consentimento deles para o uso de cookies ou outro armazenamento local quando exigido por lei, bem como para a coleta, o compartilhamento e o uso de dados pessoais para personalização de anúncios. Esta política reflete os requisitos da Diretiva ePrivacy da UE e do Regulamento Geral de Proteção de Dados (GDPR). Para cumprir esta política, os editores precisam adotar uma [plataforma de gerenciamento de consentimento certificada pelo Google](https://support.google.com/admob/answer/13554116) (CMP) que tenha se integrado à [estrutura TCF](https://iabeurope.eu/transparency-consent-framework/), como o [SDK da User Messaging Platform](../user_messaging_tools/get_started.md). Uma vez adotada, a CMP apresenta opções de consentimento, conhecidas como finalidades, no seu aplicativo móvel.

Este documento é baseado em:

- [SDK do Google Mobile Ads para Android - Modos de veiculação de anúncios](https://developers.google.com/admob/android/privacy/ad-serving-modes)
- [SDK do Google Mobile Ads para iOS - Modos de veiculação de anúncios](https://developers.google.com/admob/ios/privacy/ad-serving-modes)

A interface exata das opções de consentimento é mantida atualizada pelo Google, mas aqui está uma versão anterior para referência:

![Exemplo de opções de consentimento](https://developers.google.com/static/admob/images/privacy/consent-form-purposes.png)

!!! note
    **Importante:** Além de coletar o consentimento de finalidades, você também precisa coletar o consentimento do fornecedor. Tanto o consentimento de finalidades quanto o consentimento do fornecedor são necessários para que qualquer fornecedor, como o Google, veicule os anúncios apropriados.

Os diferentes tipos de anúncios que podem ser veiculados são:

- [Anúncios personalizados](#anuncios-personalizados)
- [Anúncios não personalizados](#anuncios-nao-personalizados)
- [Anúncios limitados](#anuncios-limitados)

## Anúncios personalizados

Os [anúncios personalizados](https://support.google.com/admob/answer/7676680) são anúncios que fazem inferências sobre os interesses de um usuário com base nos sites que ele visita ou nos aplicativos que ele usa. O Google considera os anúncios como personalizados quando eles se baseiam em dados coletados anteriormente ou em dados históricos para determinar ou influenciar a seleção de anúncios.

O Google veiculará anúncios personalizados quando todos os critérios a seguir forem atendidos. Para mais informações, leia [requisitos para anúncios personalizados](https://support.google.com/admob/answer/9760862#consent-policies).

**Legenda:** ✅ Consentimento &nbsp;&nbsp;&nbsp;&nbsp; ✔ Interesse legítimo

| Finalidade | Escolha de consentimento do usuário |
| --- | --- |
| Finalidade 1 | ✅ |
| Finalidade 2 | ✔ ou ✅ |
| Finalidade 3 | ✅ |
| Finalidade 4 | ✅ |
| Finalidade 7 | ✔ ou ✅ |
| Finalidade 9 | ✔ ou ✅ |
| Finalidade 10 | ✔ ou ✅ |

## Anúncios não personalizados

Os [anúncios não personalizados](https://support.google.com/admob/answer/7676680) não são baseados no comportamento passado do usuário. Embora os anúncios não personalizados não usem cookies ou identificadores de anúncios móveis para segmentação de anúncios, eles ainda usam cookies ou identificadores de anúncios móveis para limitação de frequência e relatórios agregados de anúncios.

O Google veiculará anúncios não personalizados quando todos os critérios a seguir forem atendidos. Para mais informações, consulte [Requisitos para anúncios não personalizados](https://support.google.com/admob/answer/9760862#consent-policies).

**Legenda:** ✅ Consentimento &nbsp;&nbsp;&nbsp;&nbsp; ✔ Interesse legítimo &nbsp;&nbsp;&nbsp;&nbsp; 🚫 Sem consentimento

| Finalidade | Escolha de consentimento do usuário |
| --- | --- |
| Finalidade 1 | ✅ |
| Finalidade 2 | ✔ ou ✅ |
| Finalidade 7 | ✔ ou ✅ |
| Finalidade 9 | ✔ ou ✅ |
| Finalidade 10 | ✔ ou ✅ |

## Anúncios limitados

Os [anúncios limitados (LTD)](https://support.google.com/admob/answer/10105530) desativam toda a personalização e os recursos que exigem o uso de um identificador local.

O Google veicula anúncios limitados quando todos os critérios a seguir são atendidos. Para mais informações, leia [Lançamento: Anúncios limitados 2.0](https://support.google.com/admob/answer/10105530#limited-ads-update).

- Finalidades especiais: 1, 2
- Interesse legítimo: 7 (opcional apenas)
