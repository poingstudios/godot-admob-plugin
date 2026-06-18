# Anuncios abiertos de aplicaciones

Esta guía está dirigida a editores que integran anuncios abiertos de aplicaciones mediante el SDK de anuncios de Google para móviles.

Los anuncios de apertura de aplicaciones son un formato de anuncio especial destinado a editores que desean monetizar las pantallas de carga de sus aplicaciones. Los anuncios de apertura de aplicaciones se pueden cerrar en cualquier momento y están diseñados para mostrarse cuando los usuarios ponen su aplicación en primer plano.

!!! nota
Los formatos de anuncios específicos pueden variar según la región.

Los anuncios de apertura de aplicaciones muestran automáticamente una pequeña área de marca para que los usuarios sepan que están en su aplicación. A continuación se muestra un ejemplo de cómo se ve un anuncio de apertura de aplicación:

<img src="https://developers.google.com/static/admob/images/app-open-ad.png" width="300">

## Requisitos previos

Antes de continuar, haga lo siguiente:

- Completa la [Guía de introducción](../index.md).

## Pruebe siempre con anuncios de prueba

La siguiente tabla contiene un ID de bloque de anuncios que puede utilizar para solicitar anuncios de prueba. Se ha configurado especialmente para devolver anuncios de prueba en lugar de anuncios de producción para cada solicitud, lo que hace que su uso sea seguro.

Sin embargo, después de registrar una aplicación en la interfaz web de AdMob y crear sus propios ID de bloque de anuncios para usar en su aplicación, explícitamente [configure su dispositivo como dispositivo de prueba](../enable_test_ads.md) durante el desarrollo.

=== "Android"


    ```
    ca-app-pub-3940256099942544/9257395921
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/5575463023
    ```

## Implementación

Los pasos principales para integrar anuncios abiertos de aplicaciones son:

1. Crear una clase de utilidad
2. Cargue el anuncio abierto de la aplicación
3. Escuche eventos de anuncios abiertos de aplicaciones
4. Considere la caducidad del anuncio
5. Escuche los eventos del estado de la aplicación
6. Mostrar el anuncio de aplicación abierta
7. Limpiar el anuncio abierto de la aplicación
8. Precarga el siguiente anuncio abierto de aplicación

### Crear una clase de utilidad

Cree una nueva clase (por ejemplo, `AppOpenAdManager`) para cargar el anuncio. Esta clase controla una variable de instancia para realizar un seguimiento de un anuncio cargado y el ID del bloque de anuncios para cada plataforma.

!!! consejo
Si bien no es estrictamente necesario, se recomienda agregar este script como **Autoload** (Singleton). Esto garantiza que el administrador sobreviva a los cambios de escena y permanezca persistente en el árbol de escenas, lo que proporciona un monitor de estado global perfecto, idéntico a los sistemas automatizados utilizados por Google en otras plataformas.

=== "GDScript"

    ```gdscript linenums="1"
    extends Node

    var _app_open_ad: AppOpenAd
    var _expire_time: int = 0
    var _is_showing_ad: bool = false

    # These ad units are configured to always serve test ads.
    var _ad_unit_id: String:
        get:
            if OS.get_name() == "Android":
                return "ca-app-pub-3940256099942544/9257395921"
            return "ca-app-pub-3940256099942544/5575463023"

    func is_ad_available() -> bool:
        return _app_open_ad != null

    func load_app_open_ad() -> void:
        pass # implementation below

    func show_app_open_ad() -> void:
        pass # implementation below
    ```

=== "C#"

    ```csharp linenums="1"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    using System;

    public partial class AppOpenAdManager : Node
    {
        private AppOpenAd _appOpenAd;
        private long _expireTime;
        private bool _isShowingAd;

        // These ad units are configured to always serve test ads.
        private string _adUnitId => OS.GetName() == "Android" 
            ? "ca-app-pub-3940256099942544/9257395921" 
            : "ca-app-pub-3940256099942544/5575463023";

        public bool IsAdAvailable => _appOpenAd != null;

        public void LoadAppOpenAd()
        {
            // implementation below
        }

        public void ShowAppOpenAd()
        {
            // implementation below
        }
    }
    ```

### Cargue el anuncio abierto de la aplicación

La carga de un anuncio abierto de aplicación se logra utilizando el método `load()` en la clase `AppOpenAdLoader`. El método de carga requiere un ID de bloque de anuncios, un objeto "AdRequest" y un controlador de finalización que se llama cuando la carga del anuncio se realiza correctamente o falla. El objeto `AppOpenAd` cargado se proporciona como parámetro en el controlador de finalización.

=== "GDScript"

    ```gdscript linenums="1"
    func load_app_open_ad() -> void:
        # Clean up the old ad before loading a new one.
        if _app_open_ad:
            _app_open_ad.destroy()
            _app_open_ad = null

        print("Loading the app open ad.")

        # Create our request used to load the ad.
        var ad_request := AdRequest.new()

        # Send the request to load the ad.
        var load_callback := AppOpenAdLoadCallback.new()
        load_callback.on_ad_loaded = func(ad: AppOpenAd):
            print("App open ad loaded with response : " + ad.get_response_info().response_id)
            _app_open_ad = ad
            _register_event_handlers(ad)

        load_callback.on_ad_failed_to_load = func(error: LoadAdError):
            print("App open ad failed to load an ad with error : " + error.message)

        AppOpenAdLoader.new().load(_ad_unit_id, ad_request, load_callback)
    ```

=== "C#"

    ```csharp linenums="1"
    public void LoadAppOpenAd()
    {
        // Clean up the old ad before loading a new one.
        if (_appOpenAd != null)
        {
            _appOpenAd.Destroy();
            _appOpenAd = null;
        }

        GD.Print("Loading the app open ad.");

        // Create our request used to load the ad.
        var adRequest = new AdRequest();

        // Send the request to load the ad.
        var loadCallback = new AppOpenAdLoadCallback();
        loadCallback.OnAdLoaded = (ad) =>
        {
            GD.Print("App open ad loaded with response : " + ad.GetResponseInfo().ResponseId);
            _appOpenAd = ad;
            RegisterEventHandlers(ad);
        };
        loadCallback.OnAdFailedToLoad = (error) =>
        {
            GD.Print("App open ad failed to load an ad with error : " + error.Message);
        };

        new AppOpenAdLoader().Load(_adUnitId, adRequest, loadCallback);
    }
    ```

!!! advertencia
Se desaconseja encarecidamente intentar cargar un nuevo anuncio desde el bloque de finalización de solicitud de anuncio cuando un anuncio no se pudo cargar. Si debe cargar un anuncio desde el bloque de finalización de solicitudes de anuncios, limite los reintentos de carga de anuncios para evitar solicitudes de anuncios fallidas continuas en situaciones como conectividad de red limitada.

### Escuche eventos de anuncios abiertos de aplicaciones

Para personalizar aún más el comportamiento de su anuncio, puede vincularse a una serie de eventos en el ciclo de vida del anuncio: apertura, cierre, etc. Escuche estos eventos registrando a un delegado como se muestra a continuación.

=== "GDScript"

    ```gdscript linenums="1"
    func _register_event_handlers(ad: AppOpenAd) -> void:
        # Raised when the ad is estimated to have earned money.
        ad.on_ad_paid = func(ad_value: AdValue):
            print("App open ad paid %d %s." % [ad_value.value_micros, ad_value.currency_code])

        var content_callback := FullScreenContentCallback.new()
        # Raised when an impression is recorded for an ad.
        content_callback.on_ad_impression = func():
            print("App open ad recorded an impression.")
        # Raised when a click is recorded for an ad.
        content_callback.on_ad_clicked = func():
            print("App open ad was clicked.")
        # Raised when an ad opened full screen content.
        content_callback.on_ad_showed_full_screen_content = func():
            print("App open ad full screen content opened.")
        # Raised when the ad closed full screen content.
        content_callback.on_ad_dismissed_full_screen_content = func():
            print("App open ad full screen content closed.")
        # Raised when the ad failed to open full screen content.
        content_callback.on_ad_failed_to_show_full_screen_content = func(error: AdError):
            print("App open ad failed to open full screen content with error : " + error.message)

        ad.full_screen_content_callback = content_callback
    ```

=== "C#"

    ```csharp linenums="1"
    private void RegisterEventHandlers(AppOpenAd ad)
    {
        // Raised when the ad is estimated to have earned money.
        ad.OnAdPaid = (adValue) =>
        {
            GD.Print($"App open ad paid {adValue.ValueMicros} {adValue.CurrencyCode}.");
        };

        var contentCallback = new FullScreenContentCallback();
        // Raised when an impression is recorded for an ad.
        contentCallback.OnAdImpression = () => GD.Print("App open ad recorded an impression.");
        // Raised when a click is recorded for an ad.
        contentCallback.OnAdClicked = () => GD.Print("App open ad was clicked.");
        // Raised when an ad opened full screen content.
        contentCallback.OnAdShowedFullScreenContent = () => GD.Print("App open ad full screen content opened.");
        // Raised when the ad closed full screen content.
        contentCallback.OnAdDismissedFullScreenContent = () => GD.Print("App open ad full screen content closed.");
        // Raised when the ad failed to open full screen content.
        contentCallback.OnAdFailedToShowFullScreenContent = (error) => 
            GD.Print("App open ad failed to open full screen content with error : " + error.Message);

        ad.FullScreenContentCallback = contentCallback;
    }
    ```

### Considere la caducidad del anuncio

!!! información "Punto clave"
Los anuncios de aplicación abierta expirarán después de cuatro horas. Los anuncios mostrados más de cuatro horas después del tiempo de solicitud ya no serán válidos y es posible que no generen ingresos.

Para asegurarse de no mostrar un anuncio caducado, agregue un método al `AppOpenAdManager` que verifique cuánto tiempo ha pasado desde que se cargó su anuncio. Luego, utilice ese método para comprobar si el anuncio sigue siendo válido.

El anuncio de apertura de la aplicación tiene un tiempo de espera de 4 horas. Almacene en caché el tiempo de carga en la variable `_expire_time`.

=== "GDScript"

    ```gdscript linenums="1" hl_lines="14-15"
    func load_app_open_ad() -> void:
        # ...
        # Send the request to load the ad.
        var load_callback := AppOpenAdLoadCallback.new()

        load_callback.on_ad_failed_to_load = func(error: LoadAdError):
            # If the operation failed, an error is returned.
            print("App open ad failed to load an ad with error : " + error.message)

        load_callback.on_ad_loaded = func(ad: AppOpenAd):
            # If the operation completed successfully, no error is returned.
            print("App open ad loaded with response : " + ad.get_response_info().response_id)

            # App open ads can be preloaded for up to 4 hours.
            _expire_time = Time.get_unix_time_from_system() + (4 * 60 * 60)

            _app_open_ad = ad
            _register_event_handlers(ad)
    ```

    ```gdscript linenums="1"
    func is_ad_available() -> bool:
        return _app_open_ad != null \
               and Time.get_unix_time_from_system() < _expire_time
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="29-30"
    public void LoadAppOpenAd()
    {
        // Clean up the old ad before loading a new one.
        if (_appOpenAd != null)
        {
            _appOpenAd.Destroy();
            _appOpenAd = null;
        }

        GD.Print("Loading the app open ad.");

        // Create our request used to load the ad.
        var adRequest = new AdRequest();

        // Send the request to load the ad.
        var loadCallback = new AppOpenAdLoadCallback();

        loadCallback.OnAdFailedToLoad = (error) =>
        {
            // If the operation failed, an error is returned.
            GD.Print("App open ad failed to load an ad with error : " + error.Message);
        };

        loadCallback.OnAdLoaded = (ad) =>
        {
            // If the operation completed successfully, no error is returned.
            GD.Print("App open ad loaded with response : " + ad.GetResponseInfo().ResponseId);

            // App open ads can be preloaded for up to 4 hours.
            _expireTime = DateTimeOffset.UtcNow.ToUnixTimeSeconds() + (4 * 60 * 60);

            _appOpenAd = ad;
            RegisterEventHandlers(ad);
        };

        new AppOpenAdLoader().Load(_adUnitId, adRequest, loadCallback);
    }
    ```

    ```csharp linenums="1"
    public bool IsAdAvailable
    {
        get
        {
            return _appOpenAd != null 
                   && DateTimeOffset.UtcNow.ToUnixTimeSeconds() < _expireTime;
        }
    }
    ```

### Escuche los eventos del estado de la aplicación

Utilice las notificaciones de enfoque de Godot para escuchar los eventos en primer plano y en segundo plano de la aplicación.

=== "GDScript"

    ```gdscript linenums="1"
    func _notification(what: int) -> void:
        if what == NOTIFICATION_APPLICATION_FOCUS_IN:
            # If the app is Foregrounded and the ad is available, show it.
            if is_ad_available():
                show_app_open_ad()
    ```

=== "C#"

    ```csharp linenums="1"
    public override void _Notification(int what)
    {
        if (what == NotificationApplicationFocusIn)
        {
            // If the app is Foregrounded and the ad is available, show it.
            if (IsAdAvailable)
            {
                ShowAppOpenAd();
            }
        }
    }
    ```

### Mostrar el anuncio de aplicación abierta

Para mostrar un anuncio de aplicación abierta cargada, llame al método `show()` en la instancia `AppOpenAd`.

!!! nota
Los anuncios de aplicación abierta deben mostrarse durante las pausas naturales en el flujo de una aplicación. Entre niveles de un juego es un buen ejemplo, o después de que el usuario completa una tarea.

=== "GDScript"

    ```gdscript linenums="1"
    func show_app_open_ad() -> void:
        if _app_open_ad:
            print("Showing app open ad.")
            _app_open_ad.show()
        else:
            print("App open ad is not ready yet.")
    ```

=== "C#"

    ```csharp linenums="1"
    public void ShowAppOpenAd()
    {
        if (_appOpenAd != null)
        {
            GD.Print("Showing app open ad.");
            _appOpenAd.Show();
        }
        else
        {
            GD.Print("App open ad is not ready yet.");
        }
    }
    ```

### Limpiar el anuncio abierto de la aplicación

Cuando haya terminado con un `AppOpenAd`, asegúrese de llamar al método `destroy()` antes de soltar su referencia:

=== "GDScript"

    ```gdscript
    _app_open_ad.destroy()
    ```

=== "C#"

    ```csharp
    _appOpenAd.Destroy();
    ```

Esto notifica al complemento que el objeto ya no se usa y que la memoria que ocupa se puede recuperar. Si no se llama a este método, se producirán pérdidas de memoria.

### Precarga el siguiente anuncio abierto de aplicación

`AppOpenAd` es un objeto de un solo uso. Esto significa que una vez que se muestra un anuncio de aplicación abierta, el objeto no se puede volver a utilizar. Para solicitar otro anuncio de apertura de aplicación, deberá crear un nuevo objeto "AppOpenAd".

Para preparar un anuncio de apertura de aplicación para la siguiente oportunidad de impresión, cargue previamente el anuncio de apertura de aplicación una vez que se genere el evento `on_ad_dismissed_full_screen_content` o `on_ad_failed_to_show_full_screen_content`.

=== "GDScript"

    ```gdscript linenums="1"
    # Inside _register_event_handlers...
    content_callback.on_ad_dismissed_full_screen_content = func():
        print("App open ad full screen content closed.")
        # Reload the ad so that we can show another as soon as possible.
        load_app_open_ad()

    content_callback.on_ad_failed_to_show_full_screen_content = func(error: AdError):
        print("App open ad failed to open full screen content.")
        # Reload the ad so that we can show another as soon as possible.
        load_app_open_ad()
    ```

=== "C#"

    ```csharp linenums="1"
    // Inside RegisterEventHandlers...
    contentCallback.OnAdDismissedFullScreenContent = () => 
    {
        GD.Print("App open ad full screen content closed.");
        // Reload the ad so that we can show another as soon as possible.
        LoadAppOpenAd();
    };

    contentCallback.OnAdFailedToShowFullScreenContent = (error) => 
    {
        GD.Print("App open ad failed to open full screen content.");
        // Reload the ad so that we can show another as soon as possible.
        LoadAppOpenAd();
    };
    ```

## Arranques en frío y pantallas de carga.

Hasta ahora, la documentación supone que solo muestra anuncios de aplicaciones abiertas cuando los usuarios ponen su aplicación en primer plano cuando está suspendida en la memoria. Los "arranques en frío" ocurren cuando se inicia la aplicación pero no se suspendió previamente en la memoria.

Un ejemplo de inicio en frío es cuando un usuario abre su aplicación por primera vez. Con los arranques en frío, no tendrá un anuncio abierto de aplicación previamente cargada que esté listo para mostrarse de inmediato. La demora entre el momento en que solicita un anuncio y el momento en que recibe una respuesta puede crear una situación en la que los usuarios puedan usar brevemente su aplicación antes de ser sorprendidos por un anuncio. Esto debe evitarse porque es una mala experiencia para el usuario.

La forma preferida de usar anuncios de apertura de aplicaciones en arranques en frío es usar una pantalla de carga para cargar los recursos del juego o de la aplicación y mostrar solo el anuncio desde la pantalla de carga. Si su aplicación completó la carga y envió al usuario al contenido principal de su aplicación, no muestre el anuncio.

!!! información "Punto clave"
Para continuar cargando recursos de la aplicación mientras se muestra el anuncio de apertura de la aplicación, cargue siempre los recursos en un hilo en segundo plano.

## Mejores prácticas

Los anuncios de apertura de aplicaciones lo ayudan a monetizar la pantalla de carga de su aplicación cuando la aplicación se inicia por primera vez y durante los cambios de aplicación, pero es importante tener en cuenta las siguientes prácticas recomendadas para que sus usuarios disfruten usando su aplicación.

*   Muestre su primer anuncio de aplicación abierta después de que sus usuarios hayan usado su aplicación varias veces.
*   Muestre anuncios de aplicaciones abiertas en momentos en los que, de otro modo, sus usuarios estarían esperando a que se cargue su aplicación.
*   Si tiene una pantalla de carga debajo del anuncio abierto de la aplicación y su pantalla de carga completa la carga antes de que se descarte el anuncio, descarte su pantalla de carga en el controlador de eventos `on_ad_dismissed_full_screen_content`.
*   Asegúrese de que su `AppOpenAdManager` (el nodo que implementa el detector de estado de la aplicación) esté presente en el árbol de escena. Se requieren notificaciones del ciclo de vida como `NOTIFICATION_APPLICATION_FOCUS_IN` para que se activen eventos, así que no elimine este nodo; Los eventos dejan de activarse si el nodo se elimina del árbol.

## Recursos adicionales

- [Proyecto de muestra](https://github.com/poingstudios/godot-admob-plugin/tree/master/addons/admob/sample): Una implementación mínima de todos los formatos de anuncios.
