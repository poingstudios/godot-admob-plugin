# Verificación del lado del servidor (SSV)

Las devoluciones de llamada de verificación del lado del servidor (SSV) confirman las recompensas a los usuarios por interactuar con los anuncios. Son solicitudes enviadas por Google directamente a su servidor cuando un usuario termina de ver un anuncio bonificado.

!!! note
    La verificación del lado del servidor es una función opcional. Aún puede utilizar la devolución de llamada estándar del lado del cliente (`on_user_earned_reward`) para otorgar recompensas.

## Requisitos previos

*   Habilite la [verificación del lado del servidor para anuncios bonificados](https://support.google.com/admob/answer/7665911) en su bloque de anuncios en la consola de AdMob.

## Configuración en el cliente

Para pasar datos personalizados o un identificador de usuario a su devolución de llamada del servidor, debe configurar las opciones de verificación en el anuncio bonificado cargado antes de mostrarlo.

=== "GDScript"

    ```gdscript
    # Crear las opciones de verificación
    var ssv_options := ServerSideVerificationOptions.new()
    ssv_options.custom_data = "SAMPLE_CUSTOM_DATA_STRING"
    ssv_options.user_id = "USER_ID_TO_REWARD"
    
    # Establecer las opciones en el RewardedAd o RewardedInterstitialAd cargado
    rewarded_ad.set_server_side_verification_options(ssv_options)
    ```

=== "C#"

    ```csharp
    // Crear las opciones de verificación
    var ssvOptions = new ServerSideVerificationOptions
    {
        CustomData = "SAMPLE_CUSTOM_DATA_STRING",
        UserId = "USER_ID_TO_REWARD"
    };

    // Establecer las opciones en el RewardedAd o RewardedInterstitialAd cargado
    rewardedAd.SetServerSideVerificationOptions(ssvOptions);
    ```

!!! tip
    La cadena de datos personalizados tiene formato de escape porcentual (percent-escaped) en la URL y puede requerir descodificación cuando su servidor la analice.

---

## Parámetros de la devolución de llamada SSV

Las devoluciones de llamada de verificación del lado del servidor contienen parámetros de consulta que describen la interacción con el anuncio. A continuación se enumeran los nombres de los parámetros, las descripciones y los valores de ejemplo (enviados en orden alfabético):

| Nombre del parámetro | Descripción | Valor de ejemplo |
| :--- | :--- | :--- |
| `ad_network` | Identificador del origen del anuncio que completó este anuncio. | `5450213213286189855` |
| `ad_unit` | ID del bloque de anuncios de AdMob que se utilizó para solicitar el anuncio bonificado. | `ca-app-pub-3940256099942544/5224354917` |
| `custom_data` | Cadena de datos personalizados proporcionada por su aplicación (si está configurada). | `SAMPLE_CUSTOM_DATA_STRING` |
| `key_id` | Clave que se utilizará para verificar la devolución de llamada SSV. Este valor se asigna a una clave pública proporcionada por el servidor de claves de AdMob. | `1234567890` |
| `reward_amount` | Cantidad de recompensa especificada en la configuración del bloque de anuncios. | `10` |
| `reward_item` | Elemento de recompensa especificado en la configuración del bloque de anuncios. | `coins` |
| `signature` | Firma para la devolución de llamada SSV generada por AdMob. | `MEUCIQCLJS_s4ia...` |
| `timestamp` | Marca de tiempo de cuándo se recompensó al usuario en formato Epoch time en ms. | `1507770365237823` |
| `transaction_id` | Identificador único codificado en hexadecimal para cada evento de concesión de recompensa. | `18fa792de1bca816048293fc71035638` |
| `user_id` | Identificador de usuario proporcionado por su aplicación (si está configurado). | `1234567` |

---

## Verificación de la devolución de llamada en su servidor

Para verificar que la devolución de llamada es auténtica y realmente enviada por Google, debe verificar la firma utilizando las claves públicas de AdMob.

### 1. Obtener las claves públicas de Google
Descargue el JSON de las claves públicas de confianza desde el servidor de claves de AdMob:
[https://gstatic.com/admob/reward/verifier-keys.json](https://gstatic.com/admob/reward/verifier-keys.json)

### 2. Preparar el contenido a verificar
Los parámetros de consulta de la URL de devolución de llamada especifican el contenido que se va a verificar. Los parámetros `signature` y `key_id` siempre son los últimos parámetros en la cadena de consulta, en ese orden.

Extraiga la subcadena desde el principio de la cadena de consulta hasta (pero sin incluir) `&signature=`. El orden de los parámetros de consulta no debe modificarse.

Por ejemplo, si su URL de devolución de llamada es:
`https://www.myserver.com/path?ad_network=54...&ad_unit=...&user_id=123&signature=ME...&key_id=1268`

El contenido a verificar es:
`ad_network=54...&ad_unit=...&user_id=123`

### 3. Realizar la verificación de la firma
1.  Analice el JSON de claves públicas obtenido en el paso 1.
2.  Busque la clave pública que coincida con el valor del parámetro de consulta `key_id`.
3.  Verifique la firma (ECDSA SHA256 DER) con la cadena de contenido preparada utilizando la clave pública.

---

## Preguntas frecuentes (FAQ)

#### ¿Puedo almacenar en caché las claves públicas proporcionadas por el servidor de claves de AdMob?
Sí, recomendamos almacenar en caché las claves públicas para reducir las solicitudes de red. Sin embargo, tenga en cuenta que las claves públicas se rotan con regularidad y no deben almacenarse en caché durante más de 24 horas.

#### ¿Qué sucede si no se puede establecer comunicación con mi servidor?
Google espera un código de estado de respuesta de éxito `HTTP 200 OK`. Si no se puede establecer comunicación con su servidor o este no devuelve un código de éxito, Google reintentará enviar la devolución de llamada hasta 5 veces en intervalos de 1 segundo.

#### ¿Cómo puedo verificar que las devoluciones de llamada de SSV provienen de Google?
Además de verificar la firma, puede utilizar la búsqueda inversa de DNS en la dirección IP entrante para verificar que la solicitud proviene de Google.
