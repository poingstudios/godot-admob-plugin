# Integrar Zucks con Mediación

Esta guía está destinada a editores que estén interesados en usar la mediación de AdMob con Zucks. Le guía a través de la configuración de un adaptador de mediación con su aplicación Godot actual y la configuración de parámetros de solicitud adicionales.

Este documento se basa en:

- [Documentación del SDK de Google Mobile Ads para Android](https://developers.google.com/admob/android/mediation/zucks)
- [Documentación del SDK de Google Mobile Ads para iOS](https://developers.google.com/admob/ios/mediation/zucks)

## Recursos de Zucks

- [Documentación](https://ms.zucksadnetwork.com/media/sdk/manual/admob-mediation/)
- [SDK](https://ms.zucksadnetwork.com/media/sdk/manual/android/)
- [Adaptador](https://ms.zucksadnetwork.com/media/sdk/manual/admob-mediation/)
- Soporte al cliente: [support@zucksadnetwork.com](mailto:support@zucksadnetwork.com)

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

Zucks distribuye tanto su SDK como su Adaptador de Mediación de AdMob exclusivamente a través de Maven. No es necesario descargar archivos `.aar` o `.jar` locales para Android.

1. Instale la **Plantilla de compilación de Android** en su proyecto de Godot (en `Proyecto > Instalar plantilla de compilación de Android`).
2. Abra `android/build/build.gradle` en un editor de texto.
3. Agregue el repositorio Maven de Zucks dentro del bloque `allprojects > repositories` (o bloque `repositories`):
   ```groovy
   repositories {
       // ... otros repositorios
       maven { url 'https://github.com/zucks/ZucksAdNetworkSDK-Maven/raw/master/' }
   }
   ```
4. Agregue la dependencia del adaptador de mediación de Zucks dentro del bloque `dependencies` (esto descargará también transitivamente el SDK de Zucks):
   ```groovy
   dependencies {
       // ... otras dependencias
       implementation 'net.zucks:zucks-ad-network-admob-adapter:6.1.0.1' // Reemplazar con la última versión del adaptador
   }
   ```

---

### iOS

Incluya los SDKs de las redes de mediación y los archivos del adaptador en el directorio apropiado de su proyecto de Godot:

- **iOS**: proyecto de Xcode (después de la exportación)

Después de generar un proyecto de Xcode desde Godot, incluya cualquier framework, bandera de compilación o bandera de enlazador que requieran las redes seleccionadas.

1. Descargue los frameworks más recientes del **SDK de iOS de Zucks** y del **Adaptador de AdMob de Zucks** desde la [Página de desarrollador de Zucks](https://developers.google.com/admob/ios/mediation/zucks).
2. Exporte su proyecto de Godot como un proyecto de Xcode para iOS.
3. Abra el proyecto exportado en Xcode.
4. Arrastre y suelte los archivos de framework del SDK y Adaptador de Zucks descargados (`.xcframework` o `.framework`) en su proyecto de Xcode.
5. En la pestaña **General** de su destino de aplicación, asegúrese de que estos frameworks estén listados en **Frameworks, Libraries, and Embedded Content** y configurados como **Embed & Sign**.

---

Su aplicación no necesita llamar directamente al código de ninguna red de anuncios de terceros; el Plugin de Godot AdMob de Poing interactúa con el adaptador de la red de mediación para obtener anuncios de terceros en su nombre.
