# AdPosition

`AdPosition` クラスは、画面上のバナー広告のレイアウト配置を表します。標準の配置プリセットまたはカスタムの絶対画面座標オフセットをサポートします。

## 定義済み定数

以下の静的プロパティは、標準的な配置プリセットを提供します：

| プロパティ (GDScript) | プロパティ (C#) | 配置の説明 |
| :--- | :--- | :--- |
| `AdPosition.TOP` | `AdPosition.Top` | 画面上部中央 |
| `AdPosition.BOTTOM` | `AdPosition.Bottom` | 画面下部中央 |
| `AdPosition.LEFT` | `AdPosition.Left` | 画面中央左 |
| `AdPosition.RIGHT` | `AdPosition.Right` | 画面中央右 |
| `AdPosition.TOP_LEFT` | `AdPosition.TopLeft` | 画面左上 |
| `AdPosition.TOP_RIGHT` | `AdPosition.TopRight` | 画面右上 |
| `AdPosition.BOTTOM_LEFT` | `AdPosition.BottomLeft` | 画面左下 |
| `AdPosition.BOTTOM_RIGHT` | `AdPosition.BottomRight` | 画面右下 |
| `AdPosition.CENTER` | `AdPosition.Center` | 画面中央 |

!!! ヒント
    広告を配置する際は、常に上記の静的プリセット（例：`AdPosition.Bottom` または `AdPosition.Custom(x, y)`）を使用してください。内部の `Values` 列挙型は、プラグインがネイティブシリアライゼーションのために内部的に使用します。

---

## 静的メソッド

### `custom` / `Custom`

指定された画面座標 (x, y) ピクセルに絶対配置を作成します。

=== "GDScript"
    ```gdscript
    static func custom(x: int, y: int) -> AdPosition
    ```

    **使用法:**
    ```gdscript
    var custom_pos = AdPosition.custom(50, 100)
    ```

=== "C#"
    ```csharp
    public static AdPosition Custom(int x, int y)
    ```

    **使用法:**
    ```csharp
    AdPosition customPos = AdPosition.Custom(50, 100);
    ```

---

## プロパティ

### `value` / `Value`

選択された配置位置を表す基礎となる列挙値。

=== "GDScript"
    ```gdscript
    var value: int
    ```

=== "C#"
    ```csharp
    public readonly Values Value;
    ```

### `offset` / `Offset`

カスタム位置が選択された場合のカスタムベクトルオフセット座標 (x, y)。

=== "GDScript"
    ```gdscript
    var offset: Vector2i
    ```

=== "C#"
    ```csharp
    public readonly Vector2I Offset;
    ```
