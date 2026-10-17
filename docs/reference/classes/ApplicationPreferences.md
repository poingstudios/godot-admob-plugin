# ApplicationPreferences

The `ApplicationPreferences` class provides static methods to read and write application-scoped preferences (`SharedPreferences` on Android, `NSUserDefaults` on iOS). This allows reading and managing IAB TCF v2, GPP, and UMP consent strings (such as `IABTCF_PurposeConsents`, `IABGPP_HDR_GppString`) as well as Google-specific flags (such as `gad_has_consent_for_cookies`).

## Static Methods

### `set_int` / `SetInt`

Stores an integer preference value for the specified key.

=== "GDScript"
    ```gdscript
    static func set_int(key: String, value: int) -> void
    ```

    **Usage:**
    ```gdscript
    ApplicationPreferences.set_int("gad_has_consent_for_cookies", 1)
    ```

=== "C#"
    ```csharp
    public static void SetInt(string key, int value)
    ```

    **Usage:**
    ```csharp
    ApplicationPreferences.SetInt("gad_has_consent_for_cookies", 1);
    ```

---

### `get_int` / `GetInt`

Retrieves an integer preference value for the specified key. Returns `default_value` if the key does not exist.

=== "GDScript"
    ```gdscript
    static func get_int(key: String, default_value := 0) -> int
    ```

    **Usage:**
    ```gdscript
    var consent := ApplicationPreferences.get_int("gad_has_consent_for_cookies", 1)
    ```

=== "C#"
    ```csharp
    public static int GetInt(string key, int defaultValue = 0)
    ```

    **Usage:**
    ```csharp
    int consent = ApplicationPreferences.GetInt("gad_has_consent_for_cookies", 1);
    ```

---

### `set_string` / `SetString`

Stores a string preference value for the specified key.

=== "GDScript"
    ```gdscript
    static func set_string(key: String, value: String) -> void
    ```

    **Usage:**
    ```gdscript
    ApplicationPreferences.set_string("custom_pref_key", "custom_value")
    ```

=== "C#"
    ```csharp
    public static void SetString(string key, string value)
    ```

    **Usage:**
    ```csharp
    ApplicationPreferences.SetString("custom_pref_key", "custom_value");
    ```

---

### `get_string` / `GetString`

Retrieves a string preference value for the specified key. Returns `default_value` if the key does not exist. Useful for inspecting IAB TCF strings (e.g., `IABTCF_PurposeConsents`).

=== "GDScript"
    ```gdscript
    static func get_string(key: String, default_value := "") -> String
    ```

    **Usage:**
    ```gdscript
    var purpose_consents := ApplicationPreferences.get_string("IABTCF_PurposeConsents", "")
    ```

=== "C#"
    ```csharp
    public static string GetString(string key, string defaultValue = "")
    ```

    **Usage:**
    ```csharp
    string purposeConsents = ApplicationPreferences.GetString("IABTCF_PurposeConsents", "");
    ```

---

### `set_boolean` / `SetBoolean`

Stores a boolean preference value for the specified key.

=== "GDScript"
    ```gdscript
    static func set_boolean(key: String, value: bool) -> void
    ```

    **Usage:**
    ```gdscript
    ApplicationPreferences.set_boolean("feature_enabled", true)
    ```

=== "C#"
    ```csharp
    public static void SetBoolean(string key, bool value)
    ```

    **Usage:**
    ```csharp
    ApplicationPreferences.SetBoolean("feature_enabled", true);
    ```

---

### `get_boolean` / `GetBoolean`

Retrieves a boolean preference value for the specified key. Returns `default_value` if the key does not exist.

=== "GDScript"
    ```gdscript
    static func get_boolean(key: String, default_value := false) -> bool
    ```

    **Usage:**
    ```gdscript
    var is_enabled := ApplicationPreferences.get_boolean("feature_enabled", false)
    ```

=== "C#"
    ```csharp
    public static bool GetBoolean(string key, bool defaultValue = false)
    ```

    **Usage:**
    ```csharp
    bool isEnabled = ApplicationPreferences.GetBoolean("feature_enabled", false);
    ```
