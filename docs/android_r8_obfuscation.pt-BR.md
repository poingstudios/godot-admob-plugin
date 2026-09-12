# Otimização e Ofuscação R8 no Android

Este guia explica como habilitar a redução de código (shrinking), otimização e ofuscação com o R8 no Android em seu projeto Godot para cumprir os requisitos do Google Play Console.

## Overview

A partir de atualizações recentes no Google Play Console, os aplicativos são avaliados em relação aos limites de otimização do aplicativo:

> **A otimização do app está abaixo do nosso limite: Ofuscação (10%)**  
> *Porcentagens inferiores a 25% em qualquer categoria do seu aplicativo podem afetar sua visibilidade e recursos de publicação no Google Play.*

### Why does this happen?

O SDK Next-Gen do Google Mobile Ads (GMA) move a lógica de execução em tempo de execução (corrotinas Kotlin, bibliotecas Jetpack, renderização de interface) diretamente para o bytecode DEX do seu aplicativo. Isso faz com que o bytecode DEX aumente significativamente (~91 MB de DEX em até 11 arquivos classes.dex).

Como o modelo de exportação do Android no Godot desativa a minificação (`minifyEnabled false`) por padrão para proteger as ligações C++/JNI, nenhum desses códigos DEX é ofuscado, fazendo com que a taxa de ofuscação do seu app fique abaixo do limite de 25%.

---

## Automatic Configuration (Recommended)

O plugin Poing Godot AdMob fornece uma configuração de projeto automatizada para configurar a otimização com R8:

1. Abra seu projeto no Editor do Godot.
2. Navegue até **Projeto > Configurações do Projeto > Admob > General > Android**.
3. Ative **Enable R8 Optimization**.

```
admob/general/android/enable_r8_optimization = true
```

Ao exportar uma versão de **Release** com um modelo de compilação Android (`android/build/`), o plugin de exportação automaticamente:

- Habilita `minifyEnabled true` e `shrinkResources false` na sua configuração de compilação de release.
- Configura `proguardFiles` para referenciar o seu arquivo `proguard-rules.pro`.
- Garante que as classes principais do Godot Engine, singletons e métodos nativos JNI sejam preservados.

---

## Embedded Consumer Rules (AAR)

O plugin Poing Godot AdMob empacota regras de ProGuard de consumidor (`consumer-rules.pro`) diretamente dentro de seus binários de biblioteca `.aar` para Android.

Quando o R8 é executado durante a compilação de release do Gradle, o Gradle mescla automaticamente as regras do plugin para proteger:

- Todas as classes do plugin AdMob (`com.poingstudios.godot.admob.**`).
- Todas as subclasses de `GodotPlugin` e métodos anotados com `@UsedByGodot`.
- Todos os métodos nativos JNI (`native <methods>;`).

Você **não** precisa adicionar manualmente regras `-keep` para o plugin AdMob no arquivo `proguard-rules.pro` do seu projeto.

---

## Manual Configuration

Se você gerencia sua própria compilação Gradle customizada do Android sem usar a configuração automática do plugin, siga estas etapas:

### 1. Enable Minification in Gradle

Abra `android/build/build.gradle` (ou `android/build/app/build.gradle`) e atualize o bloco `release` sob `buildTypes`:

```groovy
buildTypes {
    release {
        minifyEnabled true
        shrinkResources false
        proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        // ... configurações de assinatura e outras existentes
    }
}
```

### 2. Configure Godot ProGuard Rules

Abra `android/build/proguard-rules.pro` (ou `android/build/app/proguard-rules.pro`) e adicione as seguintes regras para preservar o runtime do Godot Engine:

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

# Suppress harmless warnings from Kotlin metadata and optional mediation dependencies
-dontwarn kotlin.Metadata
-dontwarn com.android.billingclient.**
-dontwarn com.bytedance.sdk.**
-dontwarn com.tiktok.**
-dontwarn jp.maio.sdk.**
-dontwarn ru.ok.tracer.**
```

---

## Suporte Nativo da Engine

Em versões mais recentes do Godot Engine onde a opção de exportação (`gradle_build/minification`) estiver disponível no Android Export Preset, você poderá ativar a minificação diretamente da caixa de diálogo de Exportação do Godot. As regras de consumidor incorporadas do plugin continuarão a proteger os componentes do AdMob automaticamente.
