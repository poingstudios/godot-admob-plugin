# Empezar

Integrar el complemento AdMob en su proyecto Godot, específicamente para Godot v4.2+, es el paso inicial y crucial para permitir la visualización de anuncios y la generación de ingresos. Después de incorporar con éxito este complemento, tendrá la flexibilidad de seleccionar entre varios formatos de anuncios, como banner o intersticial, y continuar con los pasos de implementación necesarios.

Este documento se basa en:

- [Documentación de Android del SDK de anuncios de Google para móviles](https://developers.google.com/admob/android/quick-start)
- [Documentación de iOS del SDK de anuncios de Google para móviles](https://developers.google.com/admob/ios/quick-start)

## Requisitos previos

- Implementar Android:
	- Utilice Godot v4.2 o superior
	- `minSdkVersion` de 24 o superior
	- `compileSdkVersion` de 36 o superior
- Implementar iOS:
	- Utilice Godot v4.1 o superior
	- Utilice Xcode 26.2 o superior
	- Apunte a iOS 16.0 o superior
- Recomendado:[Crear una cuenta de AdMob](https://support.google.com/admob/answer/7356219?visit_id=638286911958663013-3847536692&rd=1)y[registrar una aplicación](https://support.google.com/admob/answer/9989980?visit_id=638286911964685099-3190075945&rd=1).

## Descargue el complemento Godot AdMob de Poing Studios

El complemento Godot AdMob de Poing Studios simplifica el proceso para que los desarrolladores de Godot incorporen anuncios móviles de Google en sus aplicaciones de Android e iOS, eliminando la necesidad de escribir código Java/Kotlin u Objective-C++. En cambio, este complemento ofrece una interfaz basada en GDScript y C# para solicitudes de anuncios, que puede integrarse perfectamente en su proyecto Godot.

Para acceder al complemento, puede descargar el paquete Godot proporcionado o explorar su código fuente en GitHub a través de los enlaces a continuación.

[Descargar desde GitHub](https://github.com/poingstudios/godot-admob-plugin/releases/latest){ .md-button .md-button--primario }[Descargar desde la tienda de activos](https://store.godotengine.org/asset/poingstudios/admob/){ .md-button .md-button--primario }[Código fuente](https://github.com/poingstudios/godot-admob-plugin){ .md-button .md-button--primario }

### Importación del complemento Godot AdMob en el proyecto

El complemento AdMob para Godot está convenientemente disponible a través de Godot Asset Store. Para importar este complemento a su proyecto Godot, siga estos pasos:

1. Abre tu proyecto Godot.
2. Navegue hasta Asset Store dentro del editor Godot.
3. En la barra de búsqueda, ingrese "AdMob" y asegúrese de que el editor esté configurado en "Poing Studios".
![activate_plugin](assets/asset_store.png)
4. Localice el complemento de AdMob y haga clic en el botón "Descargar".
5. Una vez que se complete la descarga, vaya a "Proyecto → Configuración del proyecto" dentro del editor Godot.
6. En la sección "Complementos", busque el complemento "AdMob" y actívelo.
![activate_plugin](assets/activate_plugin.png)
7. Las bibliotecas de Android e iOS se descargarán e instalarán automáticamente.
8. Con estos pasos, habrá integrado con éxito el complemento de AdMob en su proyecto Godot sin necesidad de importar archivos manualmente adicionales.

## Descargar e instalar {: #download-install }
!!! información
Esta sección normalmente **no es obligatoria**, ya que el complemento maneja las bibliotecas automáticamente. Siga estos pasos solo si la descarga automática falló.

=== "Androide"

Para integrar la biblioteca de Android requerida para AdMob en Godot, siga estos pasos:

	1. En Godot, navegue hasta `Proyecto → Herramientas → AdMob Manager → Android → Descargar e instalar`.
	1. Esta acción descargará e instalará la biblioteca de Android adecuada en su proyecto, que se encuentra en `res://addons/admob/android/bin/`.

Si tiene algún problema con la descarga, puede intentar descargar la biblioteca manualmente haciendo clic en[aquí](https://github.com/poingstudios/godot-admob-android/releases/latest).

=== "iOS"

Para integrar la biblioteca iOS requerida para AdMob en Godot, siga estos pasos:

	1. En Godot, navegue hasta `Proyecto → Herramientas → AdMob Manager → iOS → Descargar e instalar`.
	1. Esta acción descargará e instalará automáticamente la biblioteca de iOS requerida en su proyecto en `res://ios/plugins/`.

Si tiene algún problema con la descarga, puede intentar descargar la biblioteca manualmente haciendo clic en[aquí](https://github.com/poingstudios/godot-admob-ios/releases/latest).

### Exportador

=== "Androide"

	1. Instale el[Plantilla de compilación de Android](https://docs.godotengine.org/en/stable/tutorials/export/android_gradle_build.html)navegando a `Proyecto → Instalar plantilla de compilación de Android`.
	1. Configure las opciones preestablecidas de Android en `Proyecto → Configuración del proyecto... → General`:
	    - En la barra lateral izquierda, localice la sección **Admob** y haga clic en **Android**.
	    - Añade tu[ID de aplicación de AdMob](https://support.google.com/admob/answer/7356431)al campo "Id. de aplicación".
	    - Habilite o deshabilite los complementos `Enabled` y Mediación (`Mediation/Meta`, `Mediation/Vungle`) activando las casillas de verificación respectivas.
	
!!! consejo "ID de aplicación frente a ID de bloque de anuncios"
	        - **ID de aplicación** (contiene `~`): se utiliza para el registro de la aplicación y la configuración interna.
	        - **ID del bloque de anuncios** (contiene `/`): se utiliza para cargar formatos de anuncios específicos en su código.
	
	1. Al exportar su proyecto, seleccione "Usar Gradle Build".
	
![export](assets/android/export.png)

=== "iOS"
    
    1. Al exportar su proyecto, actualice `GADApplicationIdentifier` con su[ID de aplicación de AdMob](https://support.google.com/admob/answer/7356431)y asegúrese de que `Ad Mob` esté habilitado en la sección Complementos del cuadro de diálogo Exportar. Si tienes Mediación, marca también `Ad Mob Meta`, etc...
    
![gadapplicationidentifier](assets/ios/gadapplicationidentifier.png)
    
!!! consejo "ID de aplicación frente a ID de bloque de anuncios"
            - **ID de aplicación** (contiene `~`): se utiliza para el registro de la aplicación y la configuración interna.
            - **ID del bloque de anuncios** (contiene `/`): se utiliza para cargar formatos de anuncios específicos en su código.
    
    1. **¡Eso es todo!** Dado que este complemento utiliza paquetes `.xcframework`, Godot 4.2+ integrará automáticamente todas las bibliotecas y marcos necesarios en su proyecto Xcode. No se requieren comandos de terminal manuales, CocoaPods o pasos de configuración de Xcode.
    
    1. [Si se enfrenta al error "__swift_FORCE_LOAD_", lea esto](https://github.com/poingstudios/godot-admob-ios/issues/127).

        1. Cree un archivo `Untitled.swift` en su proyecto Xcode.
        2. Xcode le pedirá que "Crear encabezado de puente → Aceptar".
        3. Su proyecto ahora debería construirse normalmente.
![untitled.swift](assets/ios/untitled.swift.png)
    
    1. Ejecute el juego.
    
    1. [Si está intentando ejecutar en Simulator y no funciona, lea esto](https://github.com/godotengine/godot/issues/44681#issuecomment-751399783).

## Inicialice el SDK de anuncios de Google para móviles {: #initialize-the-google-mobile-ads-sdk }
Antes de cargar anuncios, asegúrese de que su aplicación inicialice el SDK de anuncios de Google para móviles. Puede lograr esto llamando a MobileAds.initialize(). Esta función inicializa el SDK y activa un detector de finalización una vez que finaliza el proceso de inicialización o si excede un tiempo de espera de 30 segundos. Es importante tener en cuenta que esta inicialización debe ocurrir solo una vez, idealmente durante la fase de inicio de la aplicación.

=== "GDScript"

    ```gdscript
    func _ready() -> void:
    	MobileAds.initialize()
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
    	MobileAds.Initialize();
    }
    ```

Si está utilizando la mediación, es esencial esperar a que se llame al controlador de finalización antes de continuar con la carga del anuncio. Este paso garantiza que todos los adaptadores de mediación se inicialicen correctamente antes de realizar solicitudes de anuncios.

## Seleccione un formato de anuncio
El SDK de anuncios de Google para móviles ya se ha importado correctamente y ya está preparado para integrar un anuncio en su aplicación. AdMob ofrece una variedad de formatos de anuncios, lo que le permite seleccionar el que mejor se adapta a la experiencia del usuario de su aplicación.

### Aplicación abierta
<div class="image-text-container" markdown="1">

![app_open](https://developers.google.com/static/admob/images/format-app-open.svg)

La apertura de la aplicación es un formato de anuncio que aparece cuando los usuarios abren o vuelven a su aplicación. El anuncio se superpone a la pantalla de carga.

</div>

[Implementar anuncios de apertura de aplicaciones](ad_formats/app_open.md){ .md-button .md-button--primario }

### Bandera
<div class="image-text-container" markdown="1">

![banner](assets/ad_formats/banner.png)

Los anuncios de banner son anuncios rectangulares, que constan de imágenes o texto, que se integran en el diseño de una aplicación. Estos anuncios permanecen en la pantalla mientras los usuarios interactúan con la aplicación y pueden actualizarse automáticamente después de un intervalo de tiempo designado. Si es nuevo en la publicidad móvil, los anuncios publicitarios proporcionan un excelente punto de partida para su proceso de implementación de anuncios.

</div>

[Implementar anuncios publicitarios](ad_formats/banner/get_started.md){ .md-button .md-button--primario }

### Intersticial
<div class="image-text-container" markdown="1">

![interstitial](assets/ad_formats/interstitial.png)

Los anuncios intersticiales son anuncios expansivos de pantalla completa que se superponen a la interfaz de una aplicación y persisten hasta que el usuario los cierra. Son más efectivos cuando se colocan estratégicamente durante las pausas naturales en la ejecución de la aplicación, como entre niveles de un juego o inmediatamente después de completar una tarea.

</div>

[Implementar anuncios intersticiales](ad_formats/interstitial.md){ .md-button .md-button--primario }

### Superposición nativa
<div class="image-text-container" markdown="1">

![native_overlay](https://developers.google.com/static/admob/images/format-native.svg)

Los anuncios superpuestos nativos le permiten mostrar anuncios diseñados para adaptarse a la apariencia de su aplicación, utilizando plantillas prediseñadas encima del contenido de su aplicación. Admiten la personalización de colores, fuentes y opciones de diseño y, al mismo tiempo, mantienen la integración simple.

</div>

[Implementar anuncios superpuestos nativos](ad_formats/native_overlay.md){ .md-button .md-button--primario }

### Recompensado
<div class="image-text-container" markdown="1">

![rewarded](assets/ad_formats/rewarded.png)

Los anuncios de video recompensados ​​son anuncios de video inmersivos en pantalla completa que brindan a los usuarios la opción de verlos por completo. A cambio de su tiempo y atención, los usuarios reciben recompensas o beneficios dentro de la aplicación.

</div>

[Implementar anuncios recompensados](ad_formats/rewarded.md){ .md-button .md-button--primario }

### Intersticial recompensado
<div class="image-text-container" markdown="1">

![rewarded_interstitial](assets/ad_formats/rewarded_interstitial.png)

Un intersticial recompensado es una forma específica de formato de anuncio incentivado que le permite ofrecer recompensas a cambio de anuncios que aparecen automáticamente durante las transiciones naturales de las aplicaciones. A diferencia de los anuncios bonificados habituales, los usuarios no están obligados a suscribirse activamente para ver un intersticial bonificado; están perfectamente integrados en la experiencia de la aplicación.

</div>

[Implementar anuncios intersticiales bonificados](ad_formats/rewarded_interstitial.md){ .md-button .md-button--primario }

<style>
.imagen-texto-contenedor {
pantalla: flexible;
alinear elementos: centro;
}
.image-text-container img {
margen derecho: 20px;
ancho máximo: 130px;
altura: automático;
}
</style>
