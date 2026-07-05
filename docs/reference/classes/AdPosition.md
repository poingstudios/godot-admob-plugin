# AdPosition

The `AdPosition` class represents the layout alignment of a banner ad on the screen. It supports standard alignment presets or custom absolute screen coordinate offsets.

## Predefined Constants

The following static properties provide standard placement alignment presets:

| Property (GDScript) | Property (C#) | Placement Description |
| :--- | :--- | :--- |
| `AdPosition.TOP` | `AdPosition.Top` | Top Center of the screen |
| `AdPosition.BOTTOM` | `AdPosition.Bottom` | Bottom Center of the screen |
| `AdPosition.LEFT` | `AdPosition.Left` | Middle Left of the screen |
| `AdPosition.RIGHT` | `AdPosition.Right` | Middle Right of the screen |
| `AdPosition.TOP_LEFT` | `AdPosition.TopLeft` | Top Left corner of the screen |
| `AdPosition.TOP_RIGHT` | `AdPosition.TopRight` | Top Right corner of the screen |
| `AdPosition.BOTTOM_LEFT` | `AdPosition.BottomLeft` | Bottom Left corner of the screen |
| `AdPosition.BOTTOM_RIGHT` | `AdPosition.BottomRight` | Bottom Right corner of the screen |
| `AdPosition.CENTER` | `AdPosition.Center` | Perfect Center of the screen |

!!! tip
    Always use the static presets listed above (e.g., `AdPosition.Bottom` or `AdPosition.Custom(x, y)`) when positioning ads. The inner `Values` enum is used internally by the plugin for native serialization.

---

## Static Methods

### `custom` / `Custom`

Creates an absolute positioned alignment at the given screen coordinates (x, y) in pixels.

=== "GDScript"
    ```gdscript
    static func custom(x: int, y: int) -> AdPosition
    ```

    **Usage:**
    ```gdscript
    var custom_pos = AdPosition.custom(50, 100)
    ```

=== "C#"
    ```csharp
    public static AdPosition Custom(int x, int y)
    ```

    **Usage:**
    ```csharp
    AdPosition customPos = AdPosition.Custom(50, 100);
    ```

---

## Properties

### `value` / `Value`

The underlying enum value representing the chosen alignment position.

=== "GDScript"
    ```gdscript
    var value: int
    ```

=== "C#"
    ```csharp
    public readonly Values Value;
    ```

### `offset` / `Offset`

The customized vector offset coordinates (x, y) if a custom position is chosen.

=== "GDScript"
    ```gdscript
    var offset: Vector2i
    ```

=== "C#"
    ```csharp
    public readonly Vector2I Offset;
    ```
