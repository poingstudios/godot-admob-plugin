# Anúncios de Banner Retráteis (Collapsible Banners)

Os anúncios de banner retráteis são anúncios de banner inicialmente apresentados como uma sobreposição maior, com um botão para recolhê-los ao tamanho do banner originalmente solicitado. Os anúncios de banner retráteis destinam-se a melhorar o desempenho de anúncios ancorados que, de outra forma, teriam um tamanho menor. Este guia mostra como ativar anúncios de banner retráteis para posicionamentos de banners existentes.

Este documento é baseado em:

- [Documentação de Banners Retráteis do Google Mobile Ads SDK para Android](https://developers.google.com/admob/android/banner/collapsible)
- [Documentação de Banners Retráteis do Google Mobile Ads SDK para iOS](https://developers.google.com/admob/ios/banner/collapsible)

## Pré-requisitos
- Concluir o [Guia de Início Rápido do Banner](get_started.md).

## Implementação

Certifique-se de que seu `AdView` esteja definido com o tamanho que você gostaria que os usuários vissem no estado normal (recolhido) do banner. Inclua um parâmetro extra na `AdRequest` com a chave `collapsible` e a posição do anúncio como o valor.

A posição retrátil define como a região expandida se ancora ao anúncio de banner.

| Valor do posicionamento | Comportamento | Caso de uso pretendido |
|---|---|---|
| `top` | A parte superior do anúncio expandido alinha-se ao topo do anúncio recolhido. | O anúncio é colocado no topo da tela. |
| `bottom` | A parte inferior do anúncio expandido alinha-se à parte inferior do anúncio recolhido. | O anúncio é colocado na parte inferior da tela. |

Se o anúncio carregado for um banner retrátil, o banner exibirá a sobreposição retrátil imediatamente assim que for inserido na hierarquia de visualização.

=== "GDScript"

    ```gdscript linenums="1" hl_lines="2"
    var ad_request := AdRequest.new()
    ad_request.extras["collapsible"] = "bottom"
 
    _ad_view.load_ad(ad_request)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="2"
    var adRequest = new AdRequest();
    adRequest.Extras["collapsible"] = "bottom";
     
    _adView.LoadAd(adRequest);
    ```

!!! info "Importante"
    O recurso de banner retrátil não está disponível para banners adaptativos ancorados grandes. Se o seu aplicativo precisar da funcionalidade retrátil, use os [banners adaptativos ancorados padrão](sizes/anchored_adaptive.md).

## Comportamento de atualização de anúncios

Para aplicativos que configuram a atualização automática de anúncios de banner na interface web do AdMob, quando um anúncio de banner retrátil for solicitado para um espaço de banner, as atualizações subsequentes do anúncio não solicitarão anúncios de banner retráteis. Isso ocorre porque exibir um banner retrátil a cada atualização pode ter um impacto negativo na experiência do usuário.

Se você deseja carregar outro anúncio de banner retrátil mais tarde na sessão, você pode carregar um anúncio manualmente com uma solicitação contendo o parâmetro `collapsible`.

## Verificar se um anúncio carregado é retrátil

Anúncios de banner não retráteis qualificam-se para retornar em solicitações de banners retráteis para maximizar o desempenho. Chame `is_collapsible()` (ou `IsCollapsible()` no C#) para verificar se o último banner carregado é retrátil.

=== "GDScript"
    ```gdscript linenums="1" hl_lines="6"
    func _ready() -> void:
    	# ...
    	_ad_view.ad_listener.on_ad_loaded = _on_ad_loaded
 
    func _on_ad_loaded() -> void:
    	var is_collapsible: bool = _ad_view.is_collapsible()
    	print("Anúncio carregado. Retrátil: %s" % is_collapsible)
    ```

=== "C#"
    ```csharp linenums="1" hl_lines="7"
    private void RegisterAdListener()
    {
    	_adView.AdListener = new AdListener
    	{
    		OnAdLoaded = () => 
    		{
    			bool isCollapsible = _adView.IsCollapsible();
    			GD.Print($"Anúncio carregado. Retrátil: {isCollapsible}");
    		}
    	};
    }
    ```

## Mediação

Os anúncios de banner retráteis estão disponíveis apenas para a demanda do Google. Anúncios exibidos via mediação aparecem como anúncios de banner normais, não retráteis.
