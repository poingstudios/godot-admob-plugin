# Optimización y Ofuscación R8 en Android

Esta guía explica cómo habilitar la reducción de código (shrinking), optimización y ofuscación con R8 en Android en su proyecto Godot para cumplir con los requisitos de Google Play Console.

## Overview

A partir de actualizaciones recientes en Google Play Console, las aplicaciones se evalúan según los umbrales de optimización de aplicaciones:

> **La optimización de la aplicación está por debajo de nuestro umbral: Ofuscación (10%)**  
> *Los porcentajes inferiores al 25% en cualquier categoría de su aplicación pueden afectar su visibilidad y capacidades de publicación en Google Play.*

### Why does this happen?

El SDK Next-Gen de Google Mobile Ads (GMA) traslada la lógica de ejecución en tiempo de ejecución (corrutinas de Kotlin, bibliotecas Jetpack, renderizado de interfaz) directamente al código de bytes DEX de su aplicación. Esto provoca que el código de bytes DEX aumente significativamente (~91 MB de DEX en hasta 11 archivos classes.dex).

Debido a que la plantilla de exportación de Android de Godot deshabilita la minificación (`minifyEnabled false`) de forma predeterminada para proteger los enlaces C++/JNI, ninguno de estos códigos DEX se ofusca, lo que hace que el porcentaje de ofuscación de su aplicación caiga por debajo del umbral del 25%.

---

## Automatic Configuration (Recommended)

El plugin Poing Godot AdMob proporciona una configuración de proyecto automatizada para configurar la optimización con R8:

1. Abra su proyecto en el Editor de Godot.
2. Navegue hasta **Proyecto > Configuración del Proyecto > Admob > General > Android**.
3. Habilite **Enable R8 Optimization**.

```
admob/general/android/enable_r8_optimization = true
```

Al exportar una versión de **Release** con una plantilla de compilación de Android (`android/build/`), el plugin de exportación automáticamente:
- Habilita `minifyEnabled true` y `shrinkResources false` en su configuración de compilación de release.
- Configura `proguardFiles` para hacer referencia a su archivo `proguard-rules.pro`.
- Garantiza que las clases principales de Godot Engine, singletons y métodos nativos JNI se conserven.

---

## Embedded Consumer Rules (AAR)

El plugin Poing Godot AdMob incluye reglas de ProGuard de consumidor (`consumer-rules.pro`) empaquetadas directamente dentro de sus archivos binarios de biblioteca `.aar` para Android.

Cuando R8 se ejecuta durante la compilación de release de Gradle, Gradle fusiona automáticamente las reglas del plugin para proteger:
- Todas las clases del plugin AdMob (`com.poingstudios.godot.admob.**`).
- Todas las subclases de `GodotPlugin` y métodos anotados con `@UsedByGodot`.
- Todos los métodos nativos JNI (`native <methods>;`).

**No** necesita agregar manualmente reglas `-keep` para el plugin AdMob en el archivo `proguard-rules.pro` de su proyecto.

---

## Manual Configuration

Si administra su propia compilación personalizada de Gradle para Android sin utilizar la configuración automática del plugin, siga estos pasos:

### 1. Enable Minification in Gradle

Abra `android/build/build.gradle` (o `android/build/app/build.gradle`) y actualice el bloque `release` bajo `buildTypes`:

```groovy
buildTypes {
    release {
        minifyEnabled true
        shrinkResources false
        proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        // ... configuraciones de firma y otras existentes
    }
}
```

### 2. Configure Godot ProGuard Rules

Abra `android/build/proguard-rules.pro` (o `android/build/app/proguard-rules.pro`) y agregue las siguientes reglas para preservar el entorno de ejecución de Godot Engine:

```proguard
# Godot Engine Core
-keep class org.godotengine.** { *; }
-keepclassmembers class org.godotengine.** { *; }
-keep class com.godot.** { *; }
-keepclassmembers class com.godot.** { *; }
-keep class * extends org.godotengine.godot.plugin.GodotPlugin { *; }
-keepclassmembers class * extends org.godotengine.godot.plugin.GodotPlugin {
    @org.godotengine.godot.plugin.UsedByGodot <methods>;
}

# Standard Android JNI
-keepclasseswithmembernames class * {
    native <methods>;
}
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
```

---

## Soporte Nativo del Motor

En versiones más recientes de Godot Engine donde la opción de exportación (`gradle_build/minification`) esté disponible en el Android Export Preset, puede habilitar la minificación directamente desde el cuadro de diálogo de Exportación de Godot. Las reglas de consumidor integradas del plugin continuarán protegiendo los componentes de AdMob automáticamente.
