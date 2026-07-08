# Integrar Zucks com Mediação

Este guia é destinado a editores que estejam interessados em usar a mediação do AdMob com a Zucks. Ele orienta você na configuração de um adaptador de mediação com seu aplicativo Godot atual e na configuração de parâmetros de solicitação adicionais.

Este documento é baseado em:

- [Documentação do SDK do Google Mobile Ads para Android](https://developers.google.com/admob/android/mediation/zucks)
- [Documentação do SDK do Google Mobile Ads para iOS](https://developers.google.com/admob/ios/mediation/zucks)

## Recursos da Zucks

- [Documentação](https://ms.zucksadnetwork.com/media/sdk/manual/admob-mediation/)
- [SDK](https://ms.zucksadnetwork.com/media/sdk/manual/android/)
- [Adaptador](https://ms.zucksadnetwork.com/media/sdk/manual/admob-mediation/)
- Suporte ao cliente: [support@zucksadnetwork.com](mailto:support@zucksadnetwork.com)

## Pré-requisitos

- Conclua o [Guia de Primeiros Passos](../../index.md)
- Conclua o [Guia de Primeiros Passos de Mediação](../get_started.md)

### Conceitos úteis

Os seguintes artigos da Central de Ajuda fornecem informações básicas sobre mediação:

- [Sobre a mediação do AdMob](https://support.google.com/admob/answer/1354562)
- [Configurar a mediação do AdMob](https://support.google.com/admob/answer/3124703)
- [Otimizar a mediação do AdMob](https://support.google.com/admob/answer/6162238)

## Incluir o adaptador de rede e o SDK

### Android

A Zucks distribui tanto seu SDK quanto o Adaptador de Mediação do AdMob exclusivamente via Maven. Você não precisa baixar nenhum arquivo `.aar` ou `.jar` local para Android.

1. Instale o **Modelo de Build do Android** no seu projeto Godot (em `Projeto > Instalar Modelo de Build do Android`).
2. Abra `android/build/build.gradle` em um editor de texto.
3. Adicione o repositório Maven da Zucks dentro do bloco `allprojects > repositories` (ou bloco `repositories`):
   ```groovy
   repositories {
       // ... outros repositórios
       maven { url 'https://github.com/zucks/ZucksAdNetworkSDK-Maven/raw/master/' }
   }
   ```
4. Adicione a dependência do adaptador de mediação da Zucks dentro do bloco `dependencies` (isso também fará o download transitivo do SDK da Zucks):
   ```groovy
   dependencies {
       // ... outras dependências
       implementation 'net.zucks:zucks-ad-network-admob-adapter:6.1.0.1' // Substitua pela versão mais recente do adaptador
   }
   ```

---

### iOS

Inclua os SDKs das redes de mediação e os arquivos do adaptador no diretório apropriado do seu projeto Godot:

- **iOS**: projeto Xcode (após a exportação)

Após gerar um projeto Xcode a partir do Godot, inclua quaisquer frameworks, flags de compilador ou flags de linker que suas redes escolhidas exigirem.

1. Baixe os frameworks mais recentes do **SDK iOS da Zucks** e do **Adaptador AdMob da Zucks** da [Página do desenvolvedor Zucks](https://developers.google.com/admob/ios/mediation/zucks).
2. Exporte seu projeto Godot como um projeto Xcode para iOS.
3. Abra o projeto exportado no Xcode.
4. Arraste e solte os arquivos de framework do SDK e Adaptador da Zucks baixados (`.xcframework` ou `.framework`) no seu projeto Xcode.
5. Na guia **General** do seu destino de aplicativo, certifique-se de que esses frameworks estejam listados em **Frameworks, Libraries, and Embedded Content** e configurados como **Embed & Sign**.

---

Seu aplicativo não precisa chamar diretamente o código de nenhuma rede de anúncio de terceiros; o Plugin Godot AdMob da Poing interage com o adaptador da rede de mediação para buscar anúncios de terceiros em seu nome.
