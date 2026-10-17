# ApplicationPreferences

`ApplicationPreferences` 类提供了在应用程序范围读取和写入首选项（Android 上的 `SharedPreferences`，iOS 上的 `NSUserDefaults`）的静态方法。这允许读取和管理 IAB TCF v2、GPP 和 UMP 许可字符串（例如 `IABTCF_PurposeConsents`、`IABGPP_HDR_GppString`）以及 Google 特定的标志（例如 `gad_has_consent_for_cookies`）。

## 静态方法

### `set_int` / `SetInt`

为指定的键存储整数首选项值。

=== "GDScript"
    ```gdscript
    static func set_int(key: String, value: int) -> void
    ```

    **用法：**
    ```gdscript
    ApplicationPreferences.set_int("gad_has_consent_for_cookies", 1)
    ```

=== "C#"
    ```csharp
    public static void SetInt(string key, int value)
    ```

    **用法：**
    ```csharp
    ApplicationPreferences.SetInt("gad_has_consent_for_cookies", 1);
    ```

---

### `get_int` / `GetInt`

检索指定键的整数首选项值。如果键不存在，则返回 `default_value`。

=== "GDScript"
    ```gdscript
    static func get_int(key: String, default_value := 0) -> int
    ```

    **用法：**
    ```gdscript
    var consent := ApplicationPreferences.get_int("gad_has_consent_for_cookies", 1)
    ```

=== "C#"
    ```csharp
    public static int GetInt(string key, int defaultValue = 0)
    ```

    **用法：**
    ```csharp
    int consent = ApplicationPreferences.GetInt("gad_has_consent_for_cookies", 1);
    ```

---

### `set_string` / `SetString`

为指定的键存储字符串首选项值。

=== "GDScript"
    ```gdscript
    static func set_string(key: String, value: String) -> void
    ```

    **用法：**
    ```gdscript
    ApplicationPreferences.set_string("custom_pref_key", "custom_value")
    ```

=== "C#"
    ```csharp
    public static void SetString(string key, string value)
    ```

    **用法：**
    ```csharp
    ApplicationPreferences.SetString("custom_pref_key", "custom_value");
    ```

---

### `get_string` / `GetString`

检索指定键的字符串首选项值。如果键不存在，则返回 `default_value`。用于检查 IAB TCF 字符串（例如 `IABTCF_PurposeConsents`）。

=== "GDScript"
    ```gdscript
    static func get_string(key: String, default_value := "") -> String
    ```

    **用法：**
    ```gdscript
    var purpose_consents := ApplicationPreferences.get_string("IABTCF_PurposeConsents", "")
    ```

=== "C#"
    ```csharp
    public static string GetString(string key, string defaultValue = "")
    ```

    **用法：**
    ```csharp
    string purposeConsents = ApplicationPreferences.GetString("IABTCF_PurposeConsents", "");
    ```

---

### `set_boolean` / `SetBoolean`

为指定的键存储布尔首选项值。

=== "GDScript"
    ```gdscript
    static func set_boolean(key: String, value: bool) -> void
    ```

    **用法：**
    ```gdscript
    ApplicationPreferences.set_boolean("feature_enabled", true)
    ```

=== "C#"
    ```csharp
    public static void SetBoolean(string key, bool value)
    ```

    **用法：**
    ```csharp
    ApplicationPreferences.SetBoolean("feature_enabled", true);
    ```

---

### `get_boolean` / `GetBoolean`

检索指定键的布尔首选项值。如果键不存在，则返回 `default_value`。

=== "GDScript"
    ```gdscript
    static func get_boolean(key: String, default_value := false) -> bool
    ```

    **用法：**
    ```gdscript
    var is_enabled := ApplicationPreferences.get_boolean("feature_enabled", false)
    ```

=== "C#"
    ```csharp
    public static bool GetBoolean(string key, bool defaultValue = false)
    ```

    **用法：**
    ```csharp
    bool isEnabled = ApplicationPreferences.GetBoolean("feature_enabled", false);
    ```
