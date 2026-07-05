# Enums

This page lists the public enums used by the Godot AdMob Plugin.

## AdPosition

Defines the screen alignment for banner and native overlay ads.

=== "GDScript"
    ```gdscript
    # Access via AdPosition.Values
    enum Values {
        TOP = 0,
        BOTTOM = 1,
        LEFT = 2,
        RIGHT = 3,
        TOP_LEFT = 4,
        TOP_RIGHT = 5,
        BOTTOM_LEFT = 6,
        BOTTOM_RIGHT = 7,
        CENTER = 8,
        CUSTOM = -1
    }
    ```

=== "C#"
    ```csharp
    public enum Values
    {
        Top = 0,
        Bottom = 1,
        Left = 2,
        Right = 3,
        TopLeft = 4,
        TopRight = 5,
        BottomLeft = 6,
        BottomRight = 7,
        Center = 8,
        Custom = -1
    }
    ```

---

## AdChoicesPlacement

Defines the corner placement of the AdChoices overlay icon on native ads.

=== "GDScript"
    ```gdscript
    # Access via AdChoicesPlacement.Values
    enum Values {
        TOP_RIGHT = 0,
        TOP_LEFT = 1,
        BOTTOM_RIGHT = 2,
        BOTTOM_LEFT = 3
    }
    ```

=== "C#"
    ```csharp
    public enum AdChoicesPlacement
    {
        TopRight = 0,
        TopLeft = 1,
        BottomRight = 2,
        BottomLeft = 3
    }
    ```

---

## NativeMediaAspectRatio

Configures the aspect ratio preference for media content in native ads.

=== "GDScript"
    ```gdscript
    # Access via NativeMediaAspectRatio.Values
    enum Values {
        UNKNOWN = 0,
        ANY = 1,
        LANDSCAPE = 2,
        PORTRAIT = 3,
        SQUARE = 4
    }
    ```

=== "C#"
    ```csharp
    public enum NativeMediaAspectRatio
    {
        Unknown = 0,
        Any = 1,
        Landscape = 2,
        Portrait = 3,
        Square = 4
    }
    ```
