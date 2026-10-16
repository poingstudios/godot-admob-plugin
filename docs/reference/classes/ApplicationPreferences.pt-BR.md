# ApplicationPreferences

A classe `ApplicationPreferences` fornece métodos estáticos para ler e gravar preferências no escopo do aplicativo (`SharedPreferences` no Android, `NSUserDefaults` no iOS). Isso permite ler e gerenciar strings de consentimento do IAB TCF v2, GPP e UMP (como `IABTCF_PurposeConsents`, `IABGPP_HDR_GppString`), bem como sinalizadores específicos do Google (como `gad_has_consent_for_cookies`).

## Métodos Estáticos

### `set_int` / `SetInt`

Armazena um valor inteiro de preferência para a chave especificada.

=== "GDScript"
    ```gdscript
    static func set_int(key: String, value: int) -> void
    ```

    **Uso:**
    ```gdscript
    ApplicationPreferences.set_int("gad_has_consent_for_cookies", 1)
    ```

=== "C#"
    ```csharp
    public static void SetInt(string key, int value)
    ```

    **Uso:**
    ```csharp
    ApplicationPreferences.SetInt("gad_has_consent_for_cookies", 1);
    ```

---

### `get_int` / `GetInt`

Recupera um valor inteiro de preferência para a chave especificada. Retorna `default_value` se a chave não existir.

=== "GDScript"
    ```gdscript
    static func get_int(key: String, default_value := 0) -> int
    ```

    **Uso:**
    ```gdscript
    var consent := ApplicationPreferences.get_int("gad_has_consent_for_cookies", 1)
    ```

=== "C#"
    ```csharp
    public static int GetInt(string key, int defaultValue = 0)
    ```

    **Uso:**
    ```csharp
    int consent = ApplicationPreferences.GetInt("gad_has_consent_for_cookies", 1);
    ```

---

### `set_string` / `SetString`

Armazena um valor de string de preferência para a chave especificada.

=== "GDScript"
    ```gdscript
    static func set_string(key: String, value: String) -> void
    ```

    **Uso:**
    ```gdscript
    ApplicationPreferences.set_string("custom_pref_key", "custom_value")
    ```

=== "C#"
    ```csharp
    public static void SetString(string key, string value)
    ```

    **Uso:**
    ```csharp
    ApplicationPreferences.SetString("custom_pref_key", "custom_value");
    ```

---

### `get_string` / `GetString`

Recupera um valor de string de preferência para a chave especificada. Retorna `default_value` se a chave não existir. Útil para inspecionar strings do IAB TCF (por exemplo, `IABTCF_PurposeConsents`).

=== "GDScript"
    ```gdscript
    static func get_string(key: String, default_value := "") -> String
    ```

    **Uso:**
    ```gdscript
    var purpose_consents := ApplicationPreferences.get_string("IABTCF_PurposeConsents", "")
    ```

=== "C#"
    ```csharp
    public static string GetString(string key, string defaultValue = "")
    ```

    **Uso:**
    ```csharp
    string purposeConsents = ApplicationPreferences.GetString("IABTCF_PurposeConsents", "");
    ```

---

### `set_boolean` / `SetBoolean`

Armazena um valor booleano de preferência para a chave especificada.

=== "GDScript"
    ```gdscript
    static func set_boolean(key: String, value: bool) -> void
    ```

    **Uso:**
    ```gdscript
    ApplicationPreferences.set_boolean("feature_enabled", true)
    ```

=== "C#"
    ```csharp
    public static void SetBoolean(string key, bool value)
    ```

    **Uso:**
    ```csharp
    ApplicationPreferences.SetBoolean("feature_enabled", true);
    ```

---

### `get_boolean` / `GetBoolean`

Recupera um valor booleano de preferência para a chave especificada. Retorna `default_value` se a chave não existir.

=== "GDScript"
    ```gdscript
    static func get_boolean(key: String, default_value := false) -> bool
    ```

    **Uso:**
    ```gdscript
    var is_enabled := ApplicationPreferences.get_boolean("feature_enabled", false)
    ```

=== "C#"
    ```csharp
    public static bool GetBoolean(string key, bool defaultValue = false)
    ```

    **Uso:**
    ```csharp
    bool isEnabled = ApplicationPreferences.GetBoolean("feature_enabled", false);
    ```
