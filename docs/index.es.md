# Primeros Pasos

Integrar el complemento AdMob en tu proyecto de Godot para **Godot 3** te permite mostrar fácilmente anuncios de Google Mobile Ads en dispositivos Android e iOS.

---

## Prerrequisitos

- **Godot Engine 3.x Mono/Standard Edition** (v3.3 o superior).
- **Para exportación a Android**:
  - Plantilla de compilación de Android habilitada.
  - Versión objetivo del SDK de Android configurada.
- **Para exportación a iOS**:
  - Máquina macOS con Xcode instalado.
  - Cuenta de desarrollador de Apple activa.
- **Recomendado**: Una [Cuenta de AdMob](https://admob.google.com/) activa con aplicaciones Android/iOS registradas.

---

## Descargar e Importar el Complemento

1. Descarga la última versión desde la página de [GitHub Releases](https://github.com/poingstudios/godot-admob-plugin/releases).
2. Extrae el archivo y copia la carpeta `addons/admob` en el directorio `res://addons/` de tu proyecto de Godot.
3. Abre el Editor de Godot, ve a **Proyecto -> Configuración del Proyecto -> Complementos** y cambia el estado del complemento **AdMob** a **Habilitado**.

Una vez habilitado, el complemento registra automáticamente el singleton `MobileAds` en tu proyecto.

---

## Descargar Plantillas de Plataforma

Abre el Administrador de AdMob dentro del editor de Godot (**Proyecto -> Herramientas -> Administrador de AdMob** o haz clic en la pestaña del panel **AdMob**).

* **Android**: Selecciona **Descargar Plantilla Android** para obtener y extraer los archivos `.aar` y `.gdap` en tu carpeta `res://android/plugins/`.
* **iOS**: Selecciona **Descargar Plantilla iOS** para obtener y extraer los archivos `.gdip` y bibliotecas en tu carpeta `res://ios/plugins/`.

---

## Configuración

En el panel del Editor de AdMob:
1. Configura tus **ID de Aplicación de AdMob** (por ejemplo, `ca-app-pub-3940256099942544~1458002511`).
2. Ingresa tus **ID de Unidad de Anuncio** para los formatos que deseas usar (Banner, Intersticial, Recompensado, Intersticial Recompensado).
3. Activa o desactiva si los anuncios están habilitados y configura comportamientos predeterminados como posición y tamaño del banner.

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

Ahora que el SDK está inicializado, puedes seleccionar e implementar los formatos de anuncio que mejor se adapten al diseño de tu juego:

* [Anuncios Banner](ad_formats/banner.es.md)
* [Anuncios Intersticiales](ad_formats/interstitial.es.md)
* [Anuncios de Video Recompensado](ad_formats/rewarded.es.md)
* [Anuncios Intersticiales Recompensados](ad_formats/rewarded_interstitial.es.md)