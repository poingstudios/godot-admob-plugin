# Integrar Vpon com Mediação

Este guia é destinado a editores que estejam interessados em usar a mediação do AdMob com a Vpon. Ele orienta você na configuração de um adaptador de mediação com seu aplicativo Godot atual e na configuração de parâmetros de solicitação adicionais.

## Recursos da Vpon

- [Documentação](https://wiki.vpon.com/android/mediation/admob/)
- [SDK](https://wiki.vpon.com/android/download/index.html)
- [Adaptador](https://wiki.vpon.com/android/download/#admob)
- Suporte ao cliente: [fae@vpon.com](mailto:fae@vpon.com)

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

1. Instale o **Modelo de Build do Android** no seu projeto Godot (em `Projeto > Instalar Modelo de Build do Android`).
2. Baixe o **SDK Android da Vpon** e o **Adaptador AdMob da Vpon** mais recentes (arquivos `.aar` ou `.jar`) dos links na seção de Recursos da Vpon.
3. Copie os arquivos baixados para o seguinte diretório dentro do seu projeto Godot:
   - `android/build/libs/`
4. Abra `android/build/build.gradle` em um editor de texto.
5. Adicione os arquivos baixados como dependências dentro do bloco `dependencies`:
   ```groovy
   dependencies {
       // ... outras dependências
       implementation files('libs/admob-adapter-2.3.0.aar') // Substitua pelo nome exato do arquivo do adaptador baixado
       implementation files('libs/vpon-sdk-5.8.0.aar') // Substitua pelo nome exato do arquivo do SDK baixado
   }
   ```

---

### iOS

Inclua os SDKs das redes de mediação e os arquivos do adaptador no diretório apropriado do seu projeto Godot:

- **iOS**: projeto Xcode (após a exportação)

Após gerar um projeto Xcode a partir do Godot, inclua quaisquer frameworks, flags de compilador ou flags de linker que suas redes escolhidas exigirem.

1. Baixe os frameworks mais recentes do **SDK iOS da Vpon** e do **Adaptador AdMob da Vpon** da [Página do desenvolvedor Vpon](https://developers.google.com/admob/ios/mediation/vpon).
2. Exporte seu projeto Godot como um projeto Xcode para iOS.
3. Abra o projeto exportado no Xcode.
4. Arraste e solte os arquivos de framework do SDK e Adaptador da Vpon baixados (`.xcframework` ou `.framework`) no seu projeto Xcode.
5. Na guia **General** do seu destino de aplicativo, certifique-se de que esses frameworks estejam listados em **Frameworks, Libraries, and Embedded Content** e configurados como **Embed & Sign**.

---

Seu aplicativo não precisa chamar diretamente o código de nenhuma rede de anúncio de terceiros; o Plugin Godot AdMob da Poing interage com o adaptador da rede de mediação para buscar anúncios de terceiros em seu nome.
