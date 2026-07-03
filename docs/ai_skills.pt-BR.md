# Habilidades do AI Copilot (beta)

Integre assistentes de codificação baseados em IA (como Gemini no Antigravity, Cursor, Claude ou GitHub Copilot) no fluxo de desenvolvimento do seu jogo usando as **Habilidades do AI Copilot** (AI Copilot Skills).

O plugin do AdMob vem com uma Habilidade de IA pré-configurada contendo todas as especificações, APIs e padrões de código para integrar vários formatos de anúncios (Banners, Intersticiais, Anúncios Premiados, etc.) tanto em **GDScript** quanto em **C#**.

---

## Instalação Rápida (Habilidades Embutidas)

Você pode instalar as habilidades de IA do AdMob pré-configuradas diretamente no seu projeto com apenas um clique:

1. Abra seu projeto no Godot.
2. No menu superior do editor, clique em **Project -> Tools -> AdMob Manager**.
3. Selecione o submenu **AI Copilot**.
4. Clique em **Install AI Skills to Project**.

Isso criará automaticamente uma pasta `.skills/godot-admob-copilot` no diretório raiz do seu projeto e colocará o arquivo de instruções `SKILL.md` dentro dela.

!!! note
    Arquivos ou pastas que começam com ponto (como `.skills`) são ocultados no painel FileSystem do Godot por padrão para evitar desordem, mas são totalmente visíveis para IDEs externas (como VS Code, Cursor, Antigravity, etc.).

---

## Invoque a habilidade em seu prompt

Depois de adicionar a habilidade ao seu projeto, use os seguintes exemplos de prompts para invocá-la em sua ferramenta de IA:

Para invocar a habilidade, digite `@` e selecione a habilidade `godot-admob-copilot`.

=== "Inicializar MobileAds"

    ```text
    @godot-admob-copilot Escreva o fluxo completo de inicialização incluindo a verificação do consentimento UMP antes de inicializar o MobileAds em GDScript.
    ```

=== "Adicionar Anúncio de Banner"

    ```text
    @godot-admob-copilot Mostre-me como criar e exibir um banner adaptativo padrão na parte inferior da tela em GDScript.
    ```

=== "Adicionar Anúncio Premiado"

    ```text
    @godot-admob-copilot Ajude-me a carregar um Anúncio Premiado em C# e implementar um callback para dar 100 moedas de ouro ao jogador quando ele terminar de assistir ao anúncio.
    ```

