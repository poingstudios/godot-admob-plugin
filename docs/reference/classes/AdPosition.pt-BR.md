# AdPosition

A classe `AdPosition` representa o alinhamento de layout de um anúncio banner na tela. Suporta presets de alinhamento padrão ou deslocamentos de coordenadas absolutas personalizadas.

## Constantes Predefinidas

As seguintes propriedades estáticas fornecem presets de posicionamento padrão:

| Propriedade (GDScript) | Propriedade (C#) | Descrição do Posicionamento |
| :--- | :--- | :--- |
| `AdPosition.TOP` | `AdPosition.Top` | Topo Centralizado da tela |
| `AdPosition.BOTTOM` | `AdPosition.Bottom` | Base Centralizada da tela |
| `AdPosition.LEFT` | `AdPosition.Left` | Meio Esquerdo da tela |
| `AdPosition.RIGHT` | `AdPosition.Right` | Meio Direito da tela |
| `AdPosition.TOP_LEFT` | `AdPosition.TopLeft` | Canto Superior Esquerdo da tela |
| `AdPosition.TOP_RIGHT` | `AdPosition.TopRight` | Canto Superior Direito da tela |
| `AdPosition.BOTTOM_LEFT` | `AdPosition.BottomLeft` | Canto Inferior Esquerdo da tela |
| `AdPosition.BOTTOM_RIGHT` | `AdPosition.BottomRight` | Canto Inferior Direito da tela |
| `AdPosition.CENTER` | `AdPosition.Center` | Centro Perfeito da tela |

!!! dica
    Sempre use os presets estáticos listados acima (ex.: `AdPosition.Bottom` ou `AdPosition.Custom(x, y)`) ao posicionar anúncios. O enum interno `Values` é usado internamente pelo plugin para serialização nativa.

---

## Métodos Estáticos

### `custom` / `Custom`

Cria um alinhamento posicionado absoluto nas coordenadas de tela fornecidas (x, y) em pixels.

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

## Propriedades

### `value` / `Value`

O valor enum subjacente representando a posição de alinhamento escolhida.

=== "GDScript"
    ```gdscript
    var value: int
    ```

=== "C#"
    ```csharp
    public readonly Values Value;
    ```

### `offset` / `Offset`

As coordenadas de deslocamento do vetor personalizado (x, y) se uma posição personalizada for escolhida.

=== "GDScript"
    ```gdscript
    var offset: Vector2i
    ```

=== "C#"
    ```csharp
    public readonly Vector2I Offset;
    ```
