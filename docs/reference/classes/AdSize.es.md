# AdSize

La clase `AdSize` representa las dimensiones (ancho y alto) de un anuncio banner. Contiene tamaños predefinidos estáticos y métodos estáticos para obtener tamaños de banner adaptativos según la orientación.

## Constantes Predefinidas

Las siguientes propiedades estáticas proporcionan presets de tamaño de banner estándar:

| Propiedad (GDScript) | Propiedad (C#) | Dimensiones (AxA) | Descripción |
| :--- | :--- | :--- | :--- |
| `AdSize.FULL_WIDTH` | `AdSize.FullWidth` | `-1` | Constante que solicita que un anuncio ocupe todo el ancho disponible (usado con banners adaptativos). |
| `AdSize.BANNER` | `AdSize.Banner` | 320x50 | Banner Estándar (Teléfonos) |
| `AdSize.LARGE_BANNER` | `AdSize.LargeBanner` | 320x100 | Banner Grande |
| `AdSize.MEDIUM_RECTANGLE` | `AdSize.MediumRectangle` | 300x250 | Rectángulo Mediano IAB |
| `AdSize.FULL_BANNER` | `AdSize.FullBanner` | 468x60 | Banner Completo IAB (Tablets) |
| `AdSize.LEADERBOARD` | `AdSize.Leaderboard` | 728x90 | Leaderboard IAB (Tablets) |
| `AdSize.WIDE_SKYSCRAPER` | `AdSize.WideSkyscraper` | 160x600 | Rascacielos Ancho IAB |

---

## Constructores

### `_init` / `AdSize`

Inicializa un `AdSize` personalizado con el ancho y alto proporcionados.

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

## Propiedades

### `width` / `Width`

El ancho del tamaño del anuncio.

=== "GDScript"
    ```gdscript
    var width: int
    ```

=== "C#"
    ```csharp
    public int Width { get; set; }
    ```

### `height` / `Height`

La altura del tamaño del anuncio.

=== "GDScript"
    ```gdscript
    var height: int
    ```

=== "C#"
    ```csharp
    public int Height { get; set; }
    ```


## Métodos Estáticos

### Banners Adaptativos

Los banners adaptativos permiten especificar un ancho de anuncio y seleccionar automáticamente el tamaño óptimo.

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
