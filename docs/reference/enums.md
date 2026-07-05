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

---

## NativeTemplateFontStyle

Defines the font weight styles for native overlay text fields.

=== "GDScript"
    ```gdscript
    # Access via NativeTemplateFontStyle.Values
    enum Values {
        NORMAL = 0,
        BOLD = 1,
        ITALIC = 2,
        MONOSPACE = 3
    }
    ```

=== "C#"
    ```csharp
    public enum NativeTemplateFontStyle
    {
        Normal = 0,
        Bold = 1,
        Italic = 2,
        Monospace = 3
    }
    ```

---

## AdValue.PrecisionType

Specifies the precision of the monetary value reported for an ad impression. Defined inside the [`AdValue`](classes/AdValue.md) class.

=== "GDScript"
    ```gdscript
    # Access via AdValue.PrecisionType
    enum PrecisionType {
        UNKNOWN = 0,
        ESTIMATED = 1,
        PUBLISHER_PROVIDED = 2,
        PRECISE = 3
    }
    ```

=== "C#"
    ```csharp
    public enum PrecisionType
    {
        Unknown = 0,
        Estimated = 1,
        PublisherProvided = 2,
        Precise = 3
    }
    ```

---

## AdapterStatus.InitializationState

Indicates whether a mediation adapter is ready to serve ads. Defined inside the [`AdapterStatus`](classes/AdapterStatus.md) class.

=== "GDScript"
    ```gdscript
    # Access via AdapterStatus.InitializationState
    enum InitializationState {
        NOT_READY = 0,
        READY = 1
    }
    ```

=== "C#"
    ```csharp
    public enum InitializationState
    {
        NotReady = 0,
        Ready = 1
    }
    ```

---

## RequestConfiguration.TagForChildDirectedTreatment

Indicates whether ad requests should be treated as child-directed for COPPA compliance. Defined inside the [`RequestConfiguration`](classes/RequestConfiguration.md) class.

=== "GDScript"
    ```gdscript
    # Access via RequestConfiguration.TagForChildDirectedTreatment
    enum TagForChildDirectedTreatment {
        UNSPECIFIED = -1,
        FALSE = 0,
        TRUE = 1
    }
    ```

=== "C#"
    ```csharp
    public enum TagForChildDirectedTreatment
    {
        Unspecified = -1,
        False = 0,
        True = 1
    }
    ```

---

## RequestConfiguration.TagForUnderAgeOfConsent

Indicates whether ad requests should be treated as targeting users under the age of consent for GDPR compliance. Defined inside the [`RequestConfiguration`](classes/RequestConfiguration.md) class.

=== "GDScript"
    ```gdscript
    # Access via RequestConfiguration.TagForUnderAgeOfConsent
    enum TagForUnderAgeOfConsent {
        UNSPECIFIED = -1,
        FALSE = 0,
        TRUE = 1
    }
    ```

=== "C#"
    ```csharp
    public enum TagForUnderAgeOfConsent
    {
        Unspecified = -1,
        False = 0,
        True = 1
    }
    ```
