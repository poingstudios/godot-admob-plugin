# 列挙型 (Enums)

このページでは、Godot AdMob プラグインで使用されるパブリックな列挙型（Enums）を示します。

## AdPosition

画面上におけるバナー広告の表示位置を定義します。

=== "GDScript"
    ```gdscript
    enum AdPosition {
        TOP = 0,
        BOTTOM = 1,
        LEFT = 2,
        RIGHT = 3,
        TOP_LEFT = 4,
        TOP_RIGHT = 5,
        BOTTOM_LEFT = 6,
        BOTTOM_RIGHT = 7,
        CENTER = 8
    }
    ```

=== "C#"
    ```csharp
    public enum AdPosition
    {
        Top = 0,
        Bottom = 1,
        Left = 2,
        Right = 3,
        TopLeft = 4,
        TopRight = 5,
        BottomLeft = 6,
        BottomRight = 7,
        Center = 8
    }
    ```
