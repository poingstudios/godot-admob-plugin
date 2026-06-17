# Primeiros Passos

A mediação do AdMob é um recurso valioso que permite entregar anúncios para seus aplicativos a partir de várias fontes. Essas fontes abrangem a Rede AdMob, redes de anúncios de terceiros e [campanhas do AdMob](https://support.google.com/admob/answer/6162747). O principal objetivo da mediação do AdMob é otimizar sua taxa de preenchimento (fill rate) e aprimorar seus esforços de monetização. Ela consegue isso direcionando solicitações de anúncios para várias redes, garantindo que seu aplicativo utilize a rede mais adequada disponível para veicular anúncios. Essa abordagem é exemplificada por meio de um [estudo de caso](https://admob.google.com/home/resources/cookapps-grows-ad-revenue-86-times-with-admob-rewarded-ads-and-mediation/).

Este guia abrangente serve como seu recurso completo para integrar a mediação ao seu aplicativo AdMob. Ele abrange os métodos de integração de lances (bidding) e cascata (waterfall), fornecendo uma referência completa para otimizar sua estratégia de veiculação de anúncios.

!!! info
    
    **Nota Crucial**: Antes de prosseguir com a configuração da mediação, é essencial garantir que você possui as permissões de conta necessárias. Essas permissões abrangem acesso ao gerenciamento de inventário, acesso ao aplicativo e recursos de privacidade e mensagens. Para obter mais detalhes, consulte o artigo sobre [Novas Funções de Usuário](https://support.google.com/admob/answer/2784628).

- Antes de integrar a mediação para um formato de anúncio específico, você deve primeiro integrar esse formato de anúncio em seu aplicativo. Esses formatos de anúncios incluem:
    - [Anúncios de Banner](../ad_formats/banner/get_started.md)
    - [Anúncios Intersticiais](../ad_formats/interstitial.md)
    - [Anúncios Premiados](../ad_formats/rewarded.md)
    - [Anúncios Intersticiais Premiados](../ad_formats/rewarded_interstitial.md)

Se você é novo em mediação, é recomendável revisar a [Visão geral da mediação do AdMob](https://support.google.com/admob/answer/13420272) para entender melhor o conceito.

Este documento é baseado em:

- [Documentação do SDK do Google Mobile Ads para Android (Inglês)](https://developers.google.com/admob/android/mediate)
- [Documentação do SDK do Google Mobile Ads para iOS (Inglês)](https://developers.google.com/admob/ios/mediate)

## Inicializar o SDK do Mobile Ads

O guia de início rápido fornece instruções sobre como [inicializar o SDK do Mobile Ads](../index.md#inicializar-o-google-mobile-ads-sdk). Durante esse processo de inicialização, os adaptadores de mediação e lances também são inicializados. É crucial aguardar a conclusão dessa inicialização antes de carregar anúncios para garantir que cada rede de anúncios participe totalmente da primeira solicitação de anúncio.

O exemplo de código a seguir demonstra como você pode verificar o status de inicialização de cada adaptador antes de iniciar uma solicitação de anúncio.


=== "GDScript"

    ```gdscript
    extends Control
    
    func _ready() -> void:
    	var on_initialization_complete_listener := OnInitializationCompleteListener.new()
    	on_initialization_complete_listener.on_initialization_complete = _on_initialization_complete
    	MobileAds.initialize(on_initialization_complete_listener)
    	
    func _on_initialization_complete(initialization_status : InitializationStatus) -> void:
    	print("MobileAds initialization complete")
    	for key in initialization_status.adapter_status_map:
    		var adapterStatus : AdapterStatus = initialization_status.adapter_status_map[key]
    		prints(
    			"Key:", key, 
    			"Latency:", adapterStatus.latency, 
    			"Initialization Status:", adapterStatus.initialization_status, 
    			"Description:", adapterStatus.description
    		)
    		
    ```

=== "C#"

    ```csharp
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Listeners;
    using PoingStudios.AdMob.Api.Core;
    
    public partial class MediationExample : Control
    {
        public override void _Ready()
        {
            var onInitializationCompleteListener = new OnInitializationCompleteListener
            {
                OnInitializationComplete = OnInitializationComplete
            };
            MobileAds.Initialize(onInitializationCompleteListener);
        }
    
        private void OnInitializationComplete(InitializationStatus initializationStatus)
        {
            GD.Print("MobileAds initialization complete");
            foreach (var kvp in initializationStatus.AdapterStatusMap)
            {
                string key = kvp.Key;
                AdapterStatus adapterStatus = kvp.Value;
                GD.Print(
                    "Key: ", key, 
                    " Latency: ", adapterStatus.Latency, 
                    " Initialization Status: ", adapterStatus.State, 
                    " Description: ", adapterStatus.Description
                );
            }
        }
    }
    ```

## Mediação de anúncios de banner
Ao utilizar anúncios de banner na mediação do AdMob, é essencial desativar as configurações de atualização (refresh) nas interfaces de usuário de todas as redes de anúncios de terceiros para os blocos de anúncios de banner que você está usando na mediação. Essa ação evita a ocorrência de atualizações duplas, já que o AdMob também aciona uma atualização com base na taxa de atualização predefinida do seu bloco de anúncios de banner.

## Mediação de anúncios premiados
Recomendamos fortemente que você personalize todos os valores de recompensa padrão configurando os valores de recompensa na interface do AdMob. Para isso, selecione a opção **Aplicar a todas as redes nos grupos de mediação** para garantir que a recompensa permaneça uniforme em todas as redes. Lembre-se de que certas redes de anúncios podem não fornecer um valor ou tipo de recompensa. Ao substituir o valor da recompensa, você garante uma recompensa consistente, independentemente da rede de anúncios responsável por veicular o anúncio.
![apply_all_networks](https://developers.google.com/static/admob/images/mediation/admob_apply_all_networks.png)

Para detalhes completos sobre como definir valores de recompensa na interface do AdMob, consulte a documentação [Criar um Bloco de Anúncios Premiados](https://support.google.com/admob/answer/7311747).


## CCPA e GDPR

!!! warning
    
    **Nota Crítica**: Antes de prosseguir com a configuração para Consentimento da UE, GDPR, CCPA e UMP (User Messaging Platform), é crucial garantir que você tenha a permissão necessária de Gerenciamento de Conta. Essas permissões são essenciais para gerenciar configurações relacionadas à privacidade. Para obter mais informações, consulte o artigo sobre [Novas Funções de Usuário](https://support.google.com/admob/answer/2784628).

Se o seu aplicativo precisa aderir à Lei de Privacidade do Consumidor da Califórnia (CCPA) ou ao Regulamento Geral sobre a Proteção de Dados (GDPR), siga as etapas descritas nas configurações da CCPA ou GDPR para incluir seus parceiros de mediação na lista de parceiros de anúncios de CCPA ou GDPR do recurso Privacidade e Mensagens do AdMob. Caso contrário, seus parceiros poderão não conseguir veicular anúncios no seu aplicativo.

Para obter mais informações, explore o processo de [ativar o processamento de dados restrito da CCPA](../privacy/regulatory_solutions/us_states_privacy_laws.md) e [obter consentimento do GDPR usando o SDK da UMP (User Messaging Platform) do Google](../privacy/user_messaging_tools/get_started.md).
