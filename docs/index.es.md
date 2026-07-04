# Primeros Pasos

!!! note "Documentación Godot 3 (v1)"
    Esta documentación es para el plugin **v1**, que solo es compatible con **Godot 3.x**.
    Para **Godot 4.2+**, consulte la [documentación estable](https://poingstudios.github.io/godot-admob-plugin/stable/).

Integrar el complemento AdMob en tu proyecto de Godot para **Godot 3** te permite mostrar fácilmente anuncios de Google Mobile Ads en dispositivos Android e iOS.

---

## Prerrequisitos

- **Godot Engine 3.x Mono/Standard Edition** (v3.3 o superior).
- **Recomendado**: Una [Cuenta de AdMob](https://admob.google.com/) activa con aplicaciones Android/iOS registradas.

=== "Android"

    - Plantilla de compilación de Android habilitada.
    - Versión objetivo del SDK de Android configurada.

=== "iOS"

    - Máquina macOS con Xcode instalado.
    - Cuenta de desarrollador de Apple activa.

---

## Descargar e Importar el Complemento

1. Descarga la última versión desde la página de [GitHub Releases](https://github.com/poingstudios/godot-admob-plugin/releases).
2. Extrae el archivo y copia la carpeta `addons/admob` en el directorio `res://addons/` de tu proyecto de Godot.
3. Abre el Editor de Godot, ve a **Proyecto -> Configuración del Proyecto -> Complementos** y cambia el estado del complemento **AdMob** a **Habilitado**.

Una vez habilitado, el complemento registra automáticamente el singleton `MobileAds` en tu proyecto.

---

## Descargar Plantillas de Plataforma

Abre el Administrador de AdMob dentro del editor de Godot (**Proyecto -> Herramientas -> Administrador de AdMob** o haz clic en la pestaña del panel **AdMob**).

=== "Android"

    Selecciona **Descargar Plantilla Android**. El complemento descargará y extraerá automáticamente los archivos de plantilla necesarios (`.aar` y `.gdap`) directamente en tu carpeta `res://android/plugins/` (no es necesario extraer el archivo zip manualmente).

=== "iOS"

    Selecciona **Descargar Plantilla iOS**. El complemento descargará y extraerá automáticamente los archivos de plantilla necesarios (`.gdip` y bibliotecas) directamente en tu carpeta `res://ios/plugins/` (no es necesario extraer el archivo zip manualmente).

---

## Configuración

En el **panel del Editor de AdMob** (`Proyecto -> Herramientas -> Administrador de AdMob`), configure las siguientes opciones:

| Opción | Descripción |
|--------|-------------|
| **App ID** | Su ID de aplicación de AdMob (ej: `ca-app-pub-3940256099942544~1458002511`). |
| **Ad Unit IDs** | IDs para cada formato de anuncio que planea usar (Banner, Intersticial, Recompensado, Intersticial Recompensado). |
| **Is Enabled** | Active/desactive los anuncios globalmente. |
| **Banner Position** | Elija dónde aparece el banner (Superior, Inferior, Personalizado). |
| **Banner Size** | Seleccione el tamaño del banner (Banner, Banner Grande, Rectángulo Mediano, etc.). |

---

## Inicializar el SDK

Antes de cargar anuncios, el SDK de Google Mobile Ads debe ser inicializado. Si **Está Habilitado** está activo en tu configuración, el complemento se inicializará automáticamente al iniciar.

Si prefieres inicializar manualmente o quieres monitorear la finalización, conéctate a la señal `initialization_complete`:

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("initialization_complete", self, "_on_AdMob_initialization_complete")
        MobileAds.initialize()

    func _on_AdMob_initialization_complete(status: int, adapter_name: String) -> void:
        print("AdMob Initialized: ", status)
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Connect("initialization_complete", this, nameof(_on_AdMob_initialization_complete));
        MobileAds.Call("initialize");
    }

    private void _on_AdMob_initialization_complete(int status, string adapterName)
    {
        GD.Print("AdMob Initialized: " + status);
    }
    ```

---

## Seleccionar un Formato de Anuncio

El SDK de Google Mobile Ads se ha importado correctamente y ya está listo para integrar anuncios en su aplicación. AdMob ofrece una variedad de formatos de anuncios, lo que le permite seleccionar el que mejor se alinee con la experiencia de usuario de su aplicación.

### Banner
<div class="image-text-container" markdown="1">

![banner](assets/ad_formats/banner.png)

Los anuncios de banner son rectangulares, compuestos por imágenes o texto, integrados en el diseño de la aplicación. Permanecen en pantalla mientras los usuarios interactúan con la aplicación y pueden actualizarse automáticamente.

</div>

[Implementar anuncios de banner](ad_formats/banner.es.md){ .md-button .md-button--primary }

### Intersticial
<div class="image-text-container" markdown="1">

![interstitial](assets/ad_formats/interstitial.png)

Los anuncios intersticiales son anuncios expansivos a pantalla completa que cubren la interfaz de la aplicación hasta que el usuario los cierra. Son más efectivos cuando se colocan en pausas naturales, como entre niveles de un juego.

</div>

[Implementar anuncios intersticiales](ad_formats/interstitial.es.md){ .md-button .md-button--primary }

### Recompensado
<div class="image-text-container" markdown="1">

![rewarded](assets/ad_formats/rewarded.png)

Los anuncios de video recompensado son anuncios inmersivos a pantalla completa que ofrecen a los usuarios la opción de verlos por completo. A cambio, los usuarios reciben recompensas o beneficios dentro de la aplicación.

</div>

[Implementar anuncios recompensados](ad_formats/rewarded.es.md){ .md-button .md-button--primary }

### Intersticial Recompensado
<div class="image-text-container" markdown="1">

![rewarded_interstitial](assets/ad_formats/rewarded_interstitial.png)

El Intersticial Recompensado es un formato de anuncio incentivado que ofrece recompensas a cambio de anuncios que aparecen automáticamente durante las transiciones naturales de la aplicación.

</div>

[Implementar anuncios intersticiales recompensados](ad_formats/rewarded_interstitial.es.md){ .md-button .md-button--primary }

<style>
  .image-text-container {
    display: flex;
    align-items: center;
  }
  .image-text-container img {
    margin-right: 20px;
    max-width: 130px;
    height: auto;
  }
</style>