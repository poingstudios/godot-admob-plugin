# Habilitar Anuncios de Prueba

!!! note "Documentación Godot 3 (v1)"
    Esta página es para **Godot 3.x**. Para **Godot 4.2+**, consulte la [documentación estable](https://poingstudios.github.io/godot-admob-plugin/stable/).

Durante el desarrollo, es crucial usar anuncios de prueba para evitar generar tráfico inválido y arriesgar la suspensión de tu cuenta de AdMob.

---

## 1. Vista Previa de Anuncios Mock en el Editor

El complemento incluye un sistema de Anuncios Mock integrado. Puedes probar los diseños visuales de tu integración de anuncios directamente dentro del Editor de Godot sin desplegar en un dispositivo físico.

Para más detalles, consulta [Vista Previa de Anuncios Mock en el Editor](editor_mock_ads.es.md).

---

## 2. Usar Unidades de Anuncio de Ejemplo de Google

La forma más fácil de habilitar la prueba en dispositivos físicos o emuladores es usando las unidades de anuncio de prueba públicas de Google.

Usa una unidad de anuncio de prueba de iOS para probar en iOS y una unidad de anuncio de prueba de Android para probar en Android:

=== "Android"

    | Formato de anuncio   | ID de unidad de ejemplo          |
    |----------------------|----------------------------------|
    | Banner               | `ca-app-pub-3940256099942544/6300978111` |
    | Intersticial         | `ca-app-pub-3940256099942544/1033173712` |
    | Recompensado         | `ca-app-pub-3940256099942544/5224354917` |
    | Intersticial Recompensado | `ca-app-pub-3940256099942544/5354046379` |

=== "iOS"

    | Formato de anuncio   | ID de unidad de ejemplo          |
    |----------------------|----------------------------------|
    | Banner               | `ca-app-pub-3940256099942544/2934735716` |
    | Intersticial         | `ca-app-pub-3940256099942544/4411468910` |
    | Recompensado         | `ca-app-pub-3940256099942544/1712485313` |
    | Intersticial Recompensado | `ca-app-pub-3940256099942544/6978759866` |

!!! warning "Importante"

    Recuerda reemplazar estos IDs de prueba con tus propios IDs de Unidad de Anuncio de producción antes de publicar tu juego en las tiendas de aplicaciones.

---

## 3. Registrar Dispositivos de Prueba

Los emuladores de Android y simuladores de iOS se configuran automáticamente como dispositivos de prueba.

Si quieres probar en tu propio dispositivo físico, puedes registrarlo como dispositivo de prueba en tu consola de AdMob:
1. Abre tu panel de AdMob.
2. Navega a **Configuración -> Dispositivos de prueba**.
3. Haz clic en **Agregar dispositivo de prueba** e ingresa los detalles de tu dispositivo.