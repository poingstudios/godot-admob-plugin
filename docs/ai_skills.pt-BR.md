# Habilidades de agente (Beta)

Habilidades de agente são conjuntos de instruções portáteis e autossuficientes que ajudam assistentes de codificação por IA (como Antigravity, Claude Code e Cursor) a entender as APIs, convenções e padrões do Godot AdMob Editor Plugin com maior precisão.

Em vez de sobrecarregar o prompt de sistema da IA com informações sobre cada plataforma, as habilidades de agente utilizam a revelação progressiva (progressive disclosure). Isso permite que o assistente de IA carregue apenas as instruções e recursos necessários para executar sua tarefa específica.

---

## Instalar as habilidades

Você pode instalar as habilidades de agente do AdMob pré-construídas diretamente no seu projeto Godot usando o editor:

1. Abra seu projeto Godot.
2. No menu superior do editor, clique em **Project > Tools > AdMob Manager**.
3. Selecione a aba **AI Copilot**.
4. Clique em **Install AI Skills to Project**.

Isso criará automaticamente uma pasta `.skills/` no diretório raiz do seu projeto e colocará as habilidades disponíveis dentro dela.

!!! note
    Arquivos ou pastas que começam com ponto (como `.skills`) são ocultados no painel FileSystem do Godot por padrão, mas são totalmente visíveis para IDEs externas e assistentes de codificação por IA.

### Atualizar as habilidades
Para garantir que seu assistente de IA tenha acesso aos recursos e às melhores práticas mais recentes, mantenha suas habilidades atualizadas. Para atualizar, abra o AdMob Manager no Editor do Godot e clique novamente em **Install AI Skills to Project** para sobrescrever a pasta com os arquivos mais recentes.

---

## Invocar as habilidades
Após as habilidades serem instaladas no repositório do seu projeto, seu assistente de IA vai indexá-las e detectá-las automaticamente. Não é necessário usar explicitamente o símbolo `@` no seu prompt; o assistente referenciará o contexto da habilidade automaticamente quando você fizer perguntas sobre o AdMob.

Se você quiser forçar manualmente o assistente a usar uma habilidade específica, você pode referenciá-la digitando `@` seguido do nome, por exemplo:
`@godot-admob-banner`

---

## Ver as habilidades disponíveis

A tabela a seguir descreve todas as habilidades disponíveis para os recursos do Godot AdMob Editor Plugin:

| Habilidade | Descrição |
| :--- | :--- |
| `godot-admob-get-started` | Auxilia na inicialização do SDK do Google Mobile Ads, na definição das configurações de solicitação e na configuração do fluxo de consentimento da User Messaging Platform (UMP). |
| `godot-admob-banner` | Auxilia na implementação de anúncios de banner (`AdView`), na escolha dos tamanhos de anúncio e na configuração de banners colapsáveis. |
| `godot-admob-interstitial` | Auxilia na implementação de anúncios intersticiais em tela cheia, no carregamento de anúncios e na configuração de callbacks de fechamento. |
| `godot-admob-rewarded` | Auxilia na implementação de anúncios premiados e intersticiais premiados, na escuta de eventos de recompensa ganha pelo usuário e na limpeza das referências de anúncio. |
| `godot-admob-app-open` | Auxilia na implementação de anúncios App Open exibidos durante a inicialização do app ou nas transições do app. |
| `godot-admob-native-overlay` | Auxilia na implementação de anúncios Native Overlay usando modelos de nós Control pequenos ou médios customizados. |
| `godot-admob-migrate` | Auxilia na migração do seu projeto entre diferentes versões do plugin (ex.: de v4.x para v5.x). |
| `godot-admob-mediation` | Auxilia na configuração, integração e verificação de redes de mediação de terceiros (AppLovin, Meta Audience Network, Unity Ads, etc.). |
| `godot-admob-troubleshoot` | Auxilia no diagnóstico de erros de carregamento de anúncios, no tratamento de códigos de erro, na abertura do Ad Inspector e na resolução de problemas de integração. |
| `godot-admob-privacy` | Auxilia na configuração do consentimento do usuário (Fluxo UMP), conformidade com GDPR, COPPA (tratamento direcionado a crianças), CCPA e opções de segmentação de solicitações. |

Você pode implementar habilidades de agente para o Godot AdMob Editor Plugin solicitando ao seu assistente de IA preferido. As habilidades de agente podem guiar seu assistente de IA para executar as seguintes tarefas de exemplo:

* *Ajude-me a inicializar o Godot AdMob Editor Plugin.*
* *Adicione um anúncio de banner ao meu jogo.*
* *Implemente um anúncio premiado.*
* *Migre meu projeto da v4 para a v5.*
* *Configure a conformidade com GDPR e COPPA em relação à privacidade.*
* *Solucione o motivo pelo qual meus anúncios não estão carregando.*
