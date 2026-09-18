# DebugGeography

Defines the debug geography to simulate for testing consent flow behavior.

## Values

=== "GDScript"
    ```gdscript
    # Access via DebugGeography.Values
    enum Values {
        DISABLED = 0,
        EEA = 1,
        NOT_EEA = 2,
        REGULATED_US_STATE = 3,
        OTHER = 4
    }
    ```

=== "C#"
    ```csharp
    public enum DebugGeography
    {
        Disabled = 0,
        Eea = 1,
        NotEea = 2,
        RegulatedUsState = 3,
        Other = 4
    }
    ```
