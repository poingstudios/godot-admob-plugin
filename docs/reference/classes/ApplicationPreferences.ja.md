# ApplicationPreferences

`ApplicationPreferences` クラスは、アプリケーションスコープの設定（Android の `SharedPreferences`、iOS の `NSUserDefaults`）を読み書きするための静的メソッドを提供します。これにより、IAB TCF v2、GPP、UMP の同意文字列（`IABTCF_PurposeConsents`、`IABGPP_HDR_GppString` など）や Google 固有のフラグ（`gad_has_consent_for_cookies` など）を読み取って管理できます。

## 静的メソッド

### `set_int` / `SetInt`

指定されたキーの整数設定値を保存します。

=== "GDScript"
    ```gdscript
    static func set_int(key: String, value: int) -> void
    ```

    **使用方法:**
    ```gdscript
    ApplicationPreferences.set_int("gad_has_consent_for_cookies", 1)
    ```

=== "C#"
    ```csharp
    public static void SetInt(string key, int value)
    ```

    **使用方法:**
    ```csharp
    ApplicationPreferences.SetInt("gad_has_consent_for_cookies", 1);
    ```

---

### `get_int` / `GetInt`

指定されたキーの整数設定値を取得します。キーが存在しない場合は `default_value` を返します。

=== "GDScript"
    ```gdscript
    static func get_int(key: String, default_value := 0) -> int
    ```

    **使用方法:**
    ```gdscript
    var consent := ApplicationPreferences.get_int("gad_has_consent_for_cookies", 1)
    ```

=== "C#"
    ```csharp
    public static int GetInt(string key, int defaultValue = 0)
    ```

    **使用方法:**
    ```csharp
    int consent = ApplicationPreferences.GetInt("gad_has_consent_for_cookies", 1);
    ```

---

### `set_string` / `SetString`

指定されたキーの文字列設定値を保存します。

=== "GDScript"
    ```gdscript
    static func set_string(key: String, value: String) -> void
    ```

    **使用方法:**
    ```gdscript
    ApplicationPreferences.set_string("custom_pref_key", "custom_value")
    ```

=== "C#"
    ```csharp
    public static void SetString(string key, string value)
    ```

    **使用方法:**
    ```csharp
    ApplicationPreferences.SetString("custom_pref_key", "custom_value");
    ```

---

### `get_string` / `GetString`

指定されたキーの文字列設定値を取得します。キーが存在しない場合は `default_value` を返します。IAB TCF 文字列（例: `IABTCF_PurposeConsents`）の確認に便利です。

=== "GDScript"
    ```gdscript
    static func get_string(key: String, default_value := "") -> String
    ```

    **使用方法:**
    ```gdscript
    var purpose_consents := ApplicationPreferences.get_string("IABTCF_PurposeConsents", "")
    ```

=== "C#"
    ```csharp
    public static string GetString(string key, string defaultValue = "")
    ```

    **使用方法:**
    ```csharp
    string purposeConsents = ApplicationPreferences.GetString("IABTCF_PurposeConsents", "");
    ```

---

### `set_boolean` / `SetBoolean`

指定されたキーのブール設定値を保存します。

=== "GDScript"
    ```gdscript
    static func set_boolean(key: String, value: bool) -> void
    ```

    **使用方法:**
    ```gdscript
    ApplicationPreferences.set_boolean("feature_enabled", true)
    ```

=== "C#"
    ```csharp
    public static void SetBoolean(string key, bool value)
    ```

    **使用方法:**
    ```csharp
    ApplicationPreferences.SetBoolean("feature_enabled", true);
    ```

---

### `get_boolean` / `GetBoolean`

指定されたキーのブール設定値を取得します。キーが存在しない場合は `default_value` を返します。

=== "GDScript"
    ```gdscript
    static func get_boolean(key: String, default_value := false) -> bool
    ```

    **使用方法:**
    ```gdscript
    var is_enabled := ApplicationPreferences.get_boolean("feature_enabled", false)
    ```

=== "C#"
    ```csharp
    public static bool GetBoolean(string key, bool defaultValue = false)
    ```

    **使用方法:**
    ```csharp
    bool isEnabled = ApplicationPreferences.GetBoolean("feature_enabled", false);
    ```
