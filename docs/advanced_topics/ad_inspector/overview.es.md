# Información general

El inspector de anuncios es una superposición en la aplicación que le permite realizar análisis en tiempo real de las solicitudes de anuncios de prueba directamente dentro de su aplicación.

!!! warning "Advertencia"
    Habilitar el inspector de anuncios aumenta el uso de memoria de Google Mobile Ads SDK para los dispositivos de prueba. El inspector de anuncios solo se inicia en **dispositivos de prueba**.

## Requisitos previos

Antes de poder utilizar el inspector de anuncios, debe completar las siguientes tareas:

1. Crear una cuenta de AdMob.
2. Configurar una aplicación en AdMob.
3. [Configurar Google Mobile Ads SDK](../../index.md).
4. Agregar su dispositivo como un [dispositivo de prueba](../../enable_test_ads.md).

## Manejo de errores

Cuando el inspector de anuncios se cierra, la devolución de llamada (callback) recibe un `Dictionary` que contiene información del error. Si el inspector de anuncios se cerró correctamente, el diccionario estará vacío.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `code` | `int` | El código de error |
| `message` | `string` | Un mensaje de error legible por humanos |
| `domain` | `string` | El dominio del error |

## Referencias

- [Android Ad Inspector](https://developers.google.com/admob/android/ad-inspector)
- [iOS Ad Inspector](https://developers.google.com/admob/ios/ad-inspector)
