# Migrar versões do SDK

Esta página abrange migrações para versões atuais e anteriores.

## Migrar da v4 para a v5

As subseções a seguir descrevem alterações de quebra e diferenças de comportamento entre as versões principais 4 e 5 do Godot AdMob Editor Plugin.

### Remoção do Smart Banner

O formato legado `Smart Banner` foi descontinuado pelo Google e foi completamente removido do plugin na v5.

| Linguagem | Propriedade Removida | Substituição |
| :--- | :--- | :--- |
| **GDScript** | `AdSize.SMART_BANNER` | [`AdSize.get_current_orientation_anchored_adaptive_banner_ad_size()`](reference/classes/AdSize.md#adaptive-banners) |
| **C#** | `AdSize.SmartBanner` | [`AdSize.GetCurrentOrientationAnchoredAdaptiveBannerAdSize()`](reference/classes/AdSize.md#adaptive-banners) |

!!! danger "Alteração de Quebra (Breaking Change)"
    A propriedade estática `AdSize.SMART_BANNER` (GDScript) e `AdSize.SmartBanner` (C#) foram completamente removidas. Você deve atualizar seus scripts para utilizar os métodos de tamanho adaptativo.

#### Como Migrar
Use **Banners Adaptativos Ancorados** no lugar. Eles são a substituição moderna oficial, calculando dinamicamente a altura ideal com base na largura do dispositivo e na densidade da tela.

!!! note "Fallback de Compatibilidade Retroativo"
    Por segurança, tanto o plugin nativo do Android quanto o do iOS implementam um fallback automático: se uma cena ou layout antigo ainda enviar um tamanho de largura `-1` e altura `-1`, a ponte nativa intercepta e retorna um tamanho padrão de Banner Adaptativo Ancorado correspondente à largura da tela.

=== "v4"

    === "GDScript"

        ```gdscript
        var ad_view := AdView.new(unit_id, AdSize.SMART_BANNER, AdPosition.TOP)
        ```

    === "C#"

        ```csharp
        var adView = new AdView(unitId, AdSize.SmartBanner, AdPosition.Top);
        ```

=== "v5"

    === "GDScript"

        ```gdscript
        var ad_size := AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)
        var ad_view := AdView.new(unit_id, ad_size, AdPosition.TOP)
        ```

    === "C#"

        ```csharp
        var adSize = AdSize.GetCurrentOrientationAnchoredAdaptiveBannerAdSize(AdSize.FullWidth);
        var adView = new AdView(unitId, adSize, AdPosition.Top);
        ```

### Alterações na Dependência do Gradle

O plugin nativo do Android agora incorpora o novo SDK Next-Gen:

* **Dependência antiga:** `com.google.android.gms:play-services-ads`
* **Nova dependência:** `com.google.android.libraries.ads.mobile.sdk:ads-mobile-sdk`

!!! info "Exclusões Automáticas de Mediação"
    Para evitar símbolos duplicados e conflitos ao usar Adaptadores de Mediação (que podem trazer transitivamente o SDK legado), o plugin de exportação do Godot corrige automaticamente o `build.gradle` da sua exportação Android para excluir `play-services-ads` e `play-services-ads-lite`. Nenhuma exclusão manual é necessária em sua configuração de exportação.
