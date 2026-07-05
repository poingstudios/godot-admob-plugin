# AdPosition

La clase `AdPosition` representa la alineación de diseño de un anuncio banner en la pantalla. Admite presets de alineación estándar o desplazamientos de coordenadas absolutas personalizadas.

## Constantes Predefinidas

Las siguientes propiedades estáticas proporcionan presets de posicionamiento estándar:

| Propiedad (GDScript) | Propiedad (C#) | Descripción del Posicionamiento |
| :--- | :--- | :--- |
| `AdPosition.TOP` | `AdPosition.Top` | Centro Superior de la pantalla |
| `AdPosition.BOTTOM` | `AdPosition.Bottom` | Centro Inferior de la pantalla |
| `AdPosition.LEFT` | `AdPosition.Left` | Medio Izquierdo de la pantalla |
| `AdPosition.RIGHT` | `AdPosition.Right` | Medio Derecho de la pantalla |
| `AdPosition.TOP_LEFT` | `AdPosition.TopLeft` | Esquina Superior Izquierda de la pantalla |
| `AdPosition.TOP_RIGHT` | `AdPosition.TopRight` | Esquina Superior Derecha de la pantalla |
| `AdPosition.BOTTOM_LEFT` | `AdPosition.BottomLeft` | Esquina Inferior Izquierda de la pantalla |
| `AdPosition.BOTTOM_RIGHT` | `AdPosition.BottomRight` | Esquina Inferior Derecha de la pantalla |
| `AdPosition.CENTER` | `AdPosition.Center` | Centro Perfecto de la pantalla |

!!! consejo
    Utilice siempre los presets estáticos listados arriba (ej.: `AdPosition.Bottom` o `AdPosition.Custom(x, y)`) al posicionar anuncios. La enumeración interna `Values` se usa internamente por el plugin para la serialización nativa.

---

## Métodos Estáticos

### `custom` / `Custom`

Crea una alineación posicionada absoluta en las coordenadas de pantalla proporcionadas (x, y) en píxeles.

=== "GDScript"
    ```gdscript
    static func custom(x: int, y: int) -> AdPosition
    ```

    **Uso:**
    ```gdscript
    var custom_pos = AdPosition.custom(50, 100)
    ```

=== "C#"
    ```csharp
    public static AdPosition Custom(int x, int y)
    ```

    **Uso:**
    ```csharp
    AdPosition customPos = AdPosition.Custom(50, 100);
    ```

---

## Propiedades

### `value` / `Value`

El valor de enumeración subyacente que representa la posición de alineación elegida.

=== "GDScript"
    ```gdscript
    var value: int
    ```

=== "C#"
    ```csharp
    public readonly Values Value;
    ```

### `offset` / `Offset`

Las coordenadas de desplazamiento del vector personalizado (x, y) si se elige una posición personalizada.

=== "GDScript"
    ```gdscript
    var offset: Vector2i
    ```

=== "C#"
    ```csharp
    public readonly Vector2I Offset;
    ```
