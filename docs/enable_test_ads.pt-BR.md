# Habilitar Anúncios de Teste

!!! note "Documentação Godot 3 (v1)"
    Esta página é para **Godot 3.x**. Para **Godot 4.2+**, veja a [documentação estável](https://poingstudios.github.io/godot-admob-plugin/stable/).

Durante o desenvolvimento, é fundamental usar anúncios de teste para evitar a geração de tráfego inválido e o risco de suspensão da sua conta do AdMob.

---

## 1. Visualizar Anúncios Mock no Editor

O plugin possui um sistema de anúncios Mock integrado. Você pode testar a integração e os layouts visuais dos seus anúncios diretamente no Editor do Godot, sem precisar compilar para um dispositivo físico.

Para mais detalhes, consulte [Visualizar Anúncios Mock no Editor](editor_mock_ads.md).

---

## 2. Usando os Blocos de Anúncio de Teste do Google

A maneira mais rápida de habilitar testes em dispositivos físicos ou emuladores é usando os blocos de anúncios de teste públicos fornecidos pelo Google.

Use um bloco de anúncios de teste iOS para testar no iOS e um bloco Android para testar no Android:

=== "Android"

    | Formato de Anúncio     | ID do Bloco de Anúncio de Teste         |
    |-----------------------|----------------------------------------|
    | Banner                | `ca-app-pub-3940256099942544/6300978111` |
    | Intersticial          | `ca-app-pub-3940256099942544/1033173712` |
    | Premiado              | `ca-app-pub-3940256099942544/5224354917` |
    | Intersticial Premiado | `ca-app-pub-3940256099942544/5354046379` |

=== "iOS"

    | Formato de Anúncio     | ID do Bloco de Anúncio de Teste         |
    |-----------------------|----------------------------------------|
    | Banner                | `ca-app-pub-3940256099942544/2934735716` |
    | Intersticial          | `ca-app-pub-3940256099942544/4411468910` |
    | Premiado              | `ca-app-pub-3940256099942544/1712485313` |
    | Intersticial Premiado | `ca-app-pub-3940256099942544/6978759866` |

!!! warning "Atenção"

    Lembre-se de substituir esses IDs de teste pelos seus IDs de Blocos de Anúncios de produção antes de publicar seu jogo nas lojas de aplicativos.

---

## 3. Registrando Dispositivos de Teste

Emuladores Android e simuladores iOS são configurados automaticamente como dispositivos de teste.

Se deseja testar em seu próprio dispositivo físico, você pode registrá-lo como um dispositivo de teste no painel do AdMob:
1. Abra o painel do AdMob.
2. Navegue até **Configurações -> Dispositivos de teste**.
3. Clique em **Adicionar dispositivo de teste** e insira os detalhes do seu dispositivo.
