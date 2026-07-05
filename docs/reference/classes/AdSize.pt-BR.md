# AdSize

A classe `AdSize` representa as dimensões (largura e altura) de um anúncio banner. Contém tamanhos predefinidos estáticos e métodos estáticos para obter tamanhos de banner adaptativos dependentes da orientação.

## Constantes Predefinidas

As seguintes propriedades estáticas fornecem presets de tamanho de banner padrão:

| Propriedade (GDScript) | Propriedade (C#) | Dimensões (LxA) | Descrição |
| :--- | :--- | :--- | :--- |
| `AdSize.FULL_WIDTH` | `AdSize.FullWidth` | `-1` | Constante que solicita que um anúncio preencha toda a largura disponível (usado com banners adaptativos). |
| `AdSize.BANNER` | `AdSize.Banner` | 320x50 | Banner Padrão (Telefones) |
| `AdSize.LARGE_BANNER` | `AdSize.LargeBanner` | 320x100 | Banner Grande |
| `AdSize.MEDIUM_RECTANGLE` | `AdSize.MediumRectangle` | 300x250 | Retângulo Médio IAB |
| `AdSize.FULL_BANNER` | `AdSize.FullBanner` | 468x60 | Banner Completo IAB (Tablets) |
| `AdSize.LEADERBOARD` | `AdSize.Leaderboard` | 728x90 | Leaderboard IAB (Tablets) |
| `AdSize.WIDE_SKYSCRAPER` | `AdSize.WideSkyscraper` | 160x600 | Arranha-céu Largo IAB |

---

## Construtores

### `_init` / `AdSize`

Inicializa um `AdSize` personalizado com a largura e altura fornecidas.

=== "GDScript"
    ```gdscript
    func _init(width: int, height: int)
    ```

    **Uso:**
    ```gdscript
    var custom_size := AdSize.new(300, 50)
    ```

=== "C#"
    ```csharp
    public AdSize(int width, int height)
    ```

    **Uso:**
    ```csharp
    AdSize customSize = new AdSize(300, 50);
    ```

---

## Propriedades

### `width` / `Width`

A largura do tamanho do anúncio.

=== "GDScript"
    ```gdscript
    var width: int
    ```

=== "C#"
    ```csharp
    public int Width { get; set; }
    ```

### `height` / `Height`

A altura do tamanho do anúncio.

=== "GDScript"
    ```gdscript
    var height: int
    ```

=== "C#"
    ```csharp
    public int Height { get; set; }
    ```

### `SMART_BANNER` / `SmartBanner`

Retorna o tamanho do smart banner correspondente à largura do dispositivo.

=== "GDScript"
    ```gdscript
    static var SMART_BANNER: AdSize # read-only
    ```

=== "C#"
    ```csharp
    public static AdSize SmartBanner { get; }
    ```

---

## Métodos Estáticos

### Banners Adaptativos

Banners adaptativos permitem especificar uma largura de anúncio e selecionar automaticamente o tamanho ideal.

#### GDScript
```gdscript
static func get_current_orientation_anchored_adaptive_banner_ad_size(width: int) -> AdSize
static func get_portrait_anchored_adaptive_banner_ad_size(width: int) -> AdSize
static func get_landscape_anchored_adaptive_banner_ad_size(width: int) -> AdSize
```

#### C#
```csharp
public static AdSize GetCurrentOrientationAnchoredAdaptiveBannerAdSize(int width)
public static AdSize GetPortraitAnchoredAdaptiveBannerAdSize(int width)
public static AdSize GetLandscapeAnchoredAdaptiveBannerAdSize(int width)
```
