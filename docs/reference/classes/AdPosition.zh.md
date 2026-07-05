# AdPosition

`AdPosition` 类表示横幅广告在屏幕上的布局对齐方式。支持标准对齐预设或自定义绝对屏幕坐标偏移。

## 预定义常量

以下静态属性提供了标准位置对齐预设：

| 属性 (GDScript) | 属性 (C#) | 位置描述 |
| :--- | :--- | :--- |
| `AdPosition.TOP` | `AdPosition.Top` | 屏幕顶部居中 |
| `AdPosition.BOTTOM` | `AdPosition.Bottom` | 屏幕底部居中 |
| `AdPosition.LEFT` | `AdPosition.Left` | 屏幕中间靠左 |
| `AdPosition.RIGHT` | `AdPosition.Right` | 屏幕中间靠右 |
| `AdPosition.TOP_LEFT` | `AdPosition.TopLeft` | 屏幕左上角 |
| `AdPosition.TOP_RIGHT` | `AdPosition.TopRight` | 屏幕右上角 |
| `AdPosition.BOTTOM_LEFT` | `AdPosition.BottomLeft` | 屏幕左下角 |
| `AdPosition.BOTTOM_RIGHT` | `AdPosition.BottomRight` | 屏幕右下角 |
| `AdPosition.CENTER` | `AdPosition.Center` | 屏幕正中央 |

!!! 提示
    在定位广告时，始终使用上面列出的静态预设（例如 `AdPosition.Bottom` 或 `AdPosition.Custom(x, y)`）。内部的 `Values` 枚举由插件内部用于原生序列化。

---

## 静态方法

### `custom` / `Custom`

在给定的屏幕坐标 (x, y) 像素处创建绝对定位的对齐方式。

=== "GDScript"
    ```gdscript
    static func custom(x: int, y: int) -> AdPosition
    ```

    **用法:**
    ```gdscript
    var custom_pos = AdPosition.custom(50, 100)
    ```

=== "C#"
    ```csharp
    public static AdPosition Custom(int x, int y)
    ```

    **用法:**
    ```csharp
    AdPosition customPos = AdPosition.Custom(50, 100);
    ```

---

## 属性

### `value` / `Value`

表示所选对齐位置的底层枚举值。

=== "GDScript"
    ```gdscript
    var value: int
    ```

=== "C#"
    ```csharp
    public readonly Values Value;
    ```

### `offset` / `Offset`

如果选择了自定义位置，则为自定义向量偏移坐标 (x, y)。

=== "GDScript"
    ```gdscript
    var offset: Vector2i
    ```

=== "C#"
    ```csharp
    public readonly Vector2I Offset;
    ```
