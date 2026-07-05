# Integrar DT Exchange com Mediación

Este guía explica cómo utilizar el SDK de Google Mobile Ads para cargar y presentar anuncios de DT Exchange (anteriormente Fyber) a través de [mediación](../get_started.md). Proporciona instrucciones sobre cómo integrar DT Exchange en la configuración de mediación de una aplicación de Godot y cómo integrar el SDK y el adaptador de DT Exchange.

Este documento está basado en:

- [Documentación del SDK de Google Mobile Ads para Android (Inglés)](https://developers.google.com/admob/android/mediation/dt-exchange)
- [Documentación del SDK de Google Mobile Ads para iOS (Inglés)](https://developers.google.com/admob/ios/mediation/dt-exchange)

## Integraciones y formatos de anuncios compatibles

El adaptador de mediación de AdMob para DT Exchange tiene las siguientes capacidades:

| Integración |   |
|-------------|---|
| Bidding     | ✅ |
| Waterfall   | ✅ |

| Formatos               |            |
|-----------------------|------------|
| Banner                | ✅          |
| Intersticial          | ✅          |
| Bonificado (Rewarded) | ✅          |
| Intersticial Bonificado|            |
| Nativo                |            |

## Requisitos previos
- Complete la [Guía de inicio](../../index.md)
- Complete la [Guía de inicio de mediación](../get_started.md)

## Paso 1: Configurar DT Exchange
Recomendamos seguir el tutorial para [Android](https://developers.google.com/admob/android/mediation/dt-exchange#step_1_set_up_dt_exchange) o [iOS](https://developers.google.com/admob/ios/mediation/dt-exchange#step_1_set_up_dt_exchange), ya que será el mismo para ambos.

## Paso 2: Configurar los ajustes de mediación para su bloque de anuncios de AdMob
Recomendamos seguir el tutorial para [Android](https://developers.google.com/admob/android/mediation/dt-exchange#step_2) o [iOS](https://developers.google.com/admob/ios/mediation/dt-exchange#step_2), ya que será el mismo para ambos.

## Paso 3: Importar el plugin del SDK de DT Exchange

=== "Android"
    1. Descargue el plugin para [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extraiga el archivo `.zip`. Adentro, encontrará una carpeta `dtexchange`.
    3. Copie el contenido de la carpeta `dtexchange` y péguelo en la carpeta de plugins de Android en `res://addons/admob/android/bin/`.

=== "iOS"
    El adaptador de DT Exchange **ya está incluido** en la descarga estándar del plugin para iOS. Si siguió la [Guía de instalación para iOS](../../index.md#download-install), ya debería tener los archivos necesarios (`poing-godot-admob-dtexchange.gdip` y frameworks relacionados) en su directorio `res://ios/plugins/`.

## Paso 4: Habilitar el plugin

=== "Android"
    Asegúrese de habilitar **Dtexchange** en la **Configuración del Proyecto** (bajo `Admob > Android > Mediation > Dtexchange`).

=== "iOS"
    Asegúrese de marcar tanto `Ad Mob` como `Ad Mob Dt Exchange` en la lista de Plugins en sus **iOS Export Presets** (así como ingresar su AdMob App ID en la configuración de Plists).

## Paso 5: Pasos opcionales (Configuración regulatoria)

### Consentimiento GDPR
DT Exchange permite pasar opciones de consentimiento GDPR a su SDK mediante una bandera de consentimiento booleana o una cadena de consentimiento IAB.

Para pasar el consentimiento booleano de GDPR, use el siguiente código:

=== "GDScript"

    ```gdscript
    DTExchange.set_gdpr_consent(true)
    ```

=== "C#"

    ```csharp
    DTExchange.SetGDPRConsent(true);
    ```

Para pasar la cadena de consentimiento GDPR IAB, use el siguiente código:

=== "GDScript"

    ```gdscript
    DTExchange.set_gdpr_consent_string("su_cadena_de_consentimiento_iab")
    ```

=== "C#"

    ```csharp
    DTExchange.SetGDPRConsentString("su_cadena_de_consentimiento_iab");
    ```

### CCPA (Cadena de Privacidad de EE. UU.)
Para cumplir con la CCPA, puede configurar la cadena de privacidad de IAB US. El siguiente código de ejemplo muestra cómo pasar esta información al SDK de DT Exchange:

=== "GDScript"

    ```gdscript
    DTExchange.set_ccpa_string("1---")
    ```

=== "C#"

    ```csharp
    DTExchange.SetCCPAString("1---");
    ```
