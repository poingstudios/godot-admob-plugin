# Integrar Vpon con Mediación

Esta guía está destinada a editores que estén interesados en usar la mediación de AdMob con Vpon. Le guía a través de la configuración de un adaptador de mediación con su aplicación Godot actual y la configuración de parámetros de solicitud adicionales.

## Recursos de Vpon

- [Documentación](https://wiki.vpon.com/android/mediation/admob/)
- [SDK](https://wiki.vpon.com/android/download/index.html)
- [Adaptador](https://wiki.vpon.com/android/download/#admob)
- Soporte al cliente: [fae@vpon.com](mailto:fae@vpon.com)

## Requisitos previos

- Complete la [Guía de inicio](../../index.md)
- Complete la [Guía de inicio de mediación](../get_started.md)

### Conceptos básicos útiles

Los siguientes artículos del Centro de ayuda proporcionan información general sobre la mediación:

- [Acerca de la mediación de AdMob](https://support.google.com/admob/answer/1354562)
- [Configurar la mediación de AdMob](https://support.google.com/admob/answer/3124703)
- [Optimizar la mediación de AdMob](https://support.google.com/admob/answer/6162238)

## Incluir el adaptador de red y el SDK

### Android

1. Instale la **Plantilla de compilación de Android** en su proyecto de Godot (en `Proyecto > Instalar plantilla de compilación de Android`).
2. Descargue el **SDK de Android de Vpon** y el **Adaptador de AdMob de Vpon** más recientes (archivos `.aar` o `.jar`) desde los enlaces en la sección de Recursos de Vpon.
3. Copie los archivos descargados en el siguiente directorio dentro de su proyecto de Godot:
   - `android/build/libs/`
4. Abra `android/build/build.gradle` en un editor de texto.
5. Agregue los archivos descargados como dependencias dentro del bloque `dependencies`:
   ```groovy
   dependencies {
       // ... otras dependencias
       implementation files('libs/admob-adapter-2.3.0.aar') // Reemplazar con el nombre exacto del archivo del adaptador descargado
       implementation files('libs/vpon-sdk-5.8.0.aar') // Reemplazar con el nombre exacto del archivo del SDK descargado
   }
   ```

---

### iOS

Incluya los SDKs de las redes de mediación y los archivos del adaptador en el directorio apropiado de su proyecto de Godot:

- **iOS**: proyecto de Xcode (después de la exportación)

Después de generar un proyecto de Xcode desde Godot, incluya cualquier framework, bandera de compilación o bandera de enlazador que requieran las redes seleccionadas.

1. Descargue los frameworks más recientes del **SDK de iOS de Vpon** y del **Adaptador de AdMob de Vpon** desde la [Página de desarrollador de Vpon](https://developers.google.com/admob/ios/mediation/vpon).
2. Exporte su proyecto de Godot como un proyecto de Xcode para iOS.
3. Abra el proyecto exportado en Xcode.
4. Arrastre y suelte los archivos de framework del SDK y Adaptador de Vpon descargados (`.xcframework` o `.framework`) en su proyecto de Xcode.
5. En la pestaña **General** de su destino de aplicación, asegúrese de que estos frameworks estén listados en **Frameworks, Libraries, and Embedded Content** y configurados como **Embed & Sign**.

---

Su aplicación no necesita llamar directamente al código de ninguna red de anuncios de terceros; el Plugin de Godot AdMob de Poing interactúa con el adaptador de la red de mediación para obtener anuncios de terceros en su nombre.
