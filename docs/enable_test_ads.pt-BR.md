# Ativar anúncios de teste
Este guia fornece instruções sobre como ativar anúncios de teste na integração do seu aplicativo. É fundamental ativar anúncios de teste durante a fase de desenvolvimento para permitir cliques neles sem gerar cobranças para os anunciantes do Google. Clicar em muitos anúncios sem estar no modo de teste pode fazer com que sua conta seja sinalizada por atividade inválida.

Para testar seus anúncios durante o desenvolvimento, você pode:

1. **Pré-visualizar Anúncios de Teste no Editor**: Teste a integração do seu anúncio e os layouts visuais diretamente dentro do Editor do Godot sem precisar exportar para um dispositivo. Veja [Pré-visualizar Anúncios de Teste no Editor](editor_mock_ads.md).
2. **Usar os Blocos de Anúncios de Exemplo do Google**: Carregue anúncios de teste em dispositivos físicos ou simuladores/emuladores. Veja [Blocos de anúncios de exemplo](#blocos-de-anuncios-de-exemplo).
3. **Ativar Dispositivos de Teste**: Teste com seus próprios blocos de anúncios de produção registrando seus dispositivos de teste. Veja [Ativar Dispositivos de Teste](#ativar-dispositivos-de-teste).

Este documento é baseado em:

- [Documentação de Anúncios de Teste do Google Mobile Ads SDK para Android](https://developers.google.com/admob/android/test-ads)
- [Documentação de Anúncios de Teste do Google Mobile Ads SDK para iOS](https://developers.google.com/admob/ios/test-ads)

## Pré-requisitos
- Concluir o [Guia de Início Rápido](index.md)

## Testando com o Editor Godot

Você pode testar seus anúncios diretamente no editor Godot. O editor exibirá sobreposições de anúncios simulados (mock ads), proporcionando uma experiência semelhante ao comportamento real dos anúncios em uma plataforma móvel.

<video autoplay loop muted playsinline width="50%">
  <source src="../assets/editor_test_ads.mp4" type="video/mp4">
  Seu navegador não suporta a tag de vídeo.
</video>

!!! note
    Como os anúncios simulados são implementados usando nós Control do Godot, eles serão renderizados dentro da janela do jogo no editor. No entanto, ao exportar para uma plataforma móvel, o SDK oficial do Google Mobile Ads renderiza anúncios nativos sobre todas as visualizações do jogo.

Para saber mais sobre o sistema de simulação, modelos visuais e simulações de callbacks, consulte o guia [Pré-visualizar Anúncios de Teste no Editor](editor_mock_ads.md).

## Blocos de anúncios de exemplo {: #blocos-de-anuncios-de-exemplo }

O método mais rápido para ativar os testes é utilizar os blocos de anúncios de teste fornecidos pelo Google. Esses blocos não estão associados à sua conta do AdMob, garantindo que não haja risco de sua conta gerar tráfego inválido ao usá-los.

Lembre-se de selecionar o bloco de anúncios de teste adequado com base na plataforma em que está testando. Use um bloco de anúncios de teste do iOS para fazer solicitações de anúncios no iOS e um bloco do Android para solicitações no Android.

!!! note

    **Nota Importante**: Antes de lançar seu aplicativo, certifique-se de substituir esses IDs de teste pelos seus próprios IDs de blocos de anúncios de produção.

Abaixo estão os blocos de anúncios de exemplo para cada formato disponível tanto no Android quanto no iOS:

=== "Android"
    | Formato do anúncio    | ID do bloco de anúncio de exemplo      |
    |-----------------------|----------------------------------------|
    | Banner                | ca-app-pub-3940256099942544/6300978111 |
    | App Open              | ca-app-pub-3940256099942544/9257395921 |
    | Intersticial          | ca-app-pub-3940256099942544/1033173712 |
    | Premiado (Rewarded)   | ca-app-pub-3940256099942544/5224354917 |
    | Intersticial Premiado | ca-app-pub-3940256099942544/5354046379 |
    | Nativo                | ca-app-pub-3940256099942544/2247696110 |

=== "iOS"

    | Formato do anúncio    | ID do bloco de anúncio de exemplo      |
    |-----------------------|----------------------------------------|
    | Banner                | ca-app-pub-3940256099942544/2934735716 |
    | App Open              | ca-app-pub-3940256099942544/5575463023 |
    | Intersticial          | ca-app-pub-3940256099942544/4411468910 |
    | Premiado (Rewarded)   | ca-app-pub-3940256099942544/1712485313 |
    | Intersticial Premiado | ca-app-pub-3940256099942544/6978759866 |
    | Nativo                | ca-app-pub-3940256099942544/3986624511 |

### Identificadores de Teste Especializados
Embora os blocos de anúncios padrão acima possam ser usados adicionando parâmetros extras (como `collapsible`), os seguintes IDs de blocos de anúncios especializados **garantem** que recursos específicos sejam retornados para testar sua interface/experiência de usuário:

| Recurso | Android | iOS |
| :--- | :--- | :--- |
| **Banners Retráteis (Collapsible)** | `ca-app-pub-3940256099942544/2014213617` | `ca-app-pub-3940256099942544/8388050270` |

## Ativar dispositivos de teste {: #ativar-dispositivos-de-teste }
Para realizar testes mais detalhados com anúncios parecidos com os de produção, você pode configurar seu dispositivo físico como um dispositivo de teste e utilizar os seus próprios IDs de blocos de anúncios criados no painel do AdMob. Você pode adicionar dispositivos de teste através do painel do AdMob ou de forma programática usando o Google Mobile Ads SDK.

Aqui estão as etapas para adicionar seu dispositivo como um dispositivo de teste:

!!! note

    **Nota Importante**: Os emuladores Android e simuladores iOS são configurados automaticamente como dispositivos de teste. Isso significa que você pode testar anúncios nesses dispositivos virtuais sem precisar adicioná-los manualmente à sua lista.

### Adicionar seu dispositivo de teste no painel do AdMob

Para um método simples e não programático de incluir um dispositivo de teste e validar builds novos ou existentes do seu app, você pode usar a interface do AdMob. [Veja como](https://support.google.com/admob/answer/9691433).

!!! note

    **Nota Importante**: Os dispositivos de teste recém-adicionados geralmente começam a receber anúncios de teste em seu aplicativo em até 15 minutos, embora possa levar até 24 horas para que a configuração tenha efeito completo.

### Adicionar seu dispositivo de teste programaticamente

Se você deseja testar anúncios dentro do seu aplicativo durante a fase de desenvolvimento e quer registrar seu dispositivo de teste via código, siga as etapas abaixo:

1. Abra seu aplicativo com os anúncios integrados e inicie uma solicitação de anúncio.
2. Verifique a saída do console/logcat para uma mensagem semelhante à mostrada abaixo, que exibe o ID do seu dispositivo e como adicioná-lo como dispositivo de teste:

    === "Android"
        ```java
        I/Ads: Use RequestConfiguration.Builder.setTestDeviceIds(Arrays.asList("33BE2250B43518CCDA7DE426D04EE231")) 
        to get test ads on this device."
        ```

    === "iOS"

        ```swift
        <Google> To get test ads on this device, set:
        GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers =
        @[ @"2077ef9a63d2b398840261c8221a0c9b" ];
        ```
Copie o ID do seu dispositivo de teste para a área de transferência.

3. Atualize seu código para incluir os IDs dos dispositivos de teste na propriedade [`RequestConfiguration`](reference/classes/RequestConfiguration.md).test_device_ids desta forma:

=== "GDScript"

    ```gdscript linenums="1" hl_lines="3 4"
    func _ready() -> void:
    	var request_configuration := RequestConfiguration.new()
    	request_configuration.test_device_ids = ["2077ef9a63d2b398840261c8221a0c9b"]
    	MobileAds.set_request_configuration(request_configuration)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="10 11"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    
    public partial class TestAdsExample : Node2D
    {
        public override void _Ready()
        {
            var requestConfiguration = new RequestConfiguration();
            requestConfiguration.TestDeviceIds.Add("2077ef9a63d2b398840261c8221a0c9b");
            MobileAds.SetRequestConfiguration(requestConfiguration);
        }
    }
    ```
!!! info

    Lembre-se de remover o código responsável por definir esses dispositivos de teste antes de publicar o seu aplicativo em produção.

4. Inicialize seu aplicativo novamente. Se o anúncio for do Google, você verá uma etiqueta **Test Ad** (Anúncio de Teste) posicionada no centro superior do anúncio, seja ele um banner, intersticial ou vídeo premiado:
![testad](https://developers.google.com/static/admob/images/android-testad-0-admob.png)

!!! info
    
    Lembre-se de que os anúncios de mediação de terceiros _NÃO_ exibem a etiqueta **Test Ad**. Consulte a seção abaixo para mais informações.

### Testando com mediação

Os blocos de anúncios de exemplo do Google exibem exclusivamente anúncios do Google Ads. Para testar sua configuração de mediação de forma eficaz, você deve empregar o método de [ativar dispositivos de teste](#ativar-dispositivos-de-teste).

Os anúncios com mediação NÃO exibem a etiqueta "Test Ad". Portanto, é de sua responsabilidade garantir que os anúncios de teste estejam habilitados para cada uma de suas redes de mediação de terceiros para evitar que essas redes sinalizem sua conta por atividade inválida. Consulte o [guia de mediação](mediate/get_started.md) individual de cada rede para instruções detalhadas.

Se você não tiver certeza sobre se o adaptador de uma rede de mediação de anúncios suporta anúncios de teste, é recomendável evitar clicar nos anúncios dessa rede durante a fase de desenvolvimento. Você pode usar a propriedade [`ResponseInfo.mediation_adapter_class_name`](reference/classes/ResponseInfo.md#mediation_adapter_class_name) em qualquer um dos formatos de anúncios para determinar qual rede de anúncios exibiu o anúncio atual.
