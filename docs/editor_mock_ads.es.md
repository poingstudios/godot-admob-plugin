# Vista previa de anuncios simulados en el editor

Utilice la función Vista previa de anuncios simulados para probar la integración de sus anuncios dentro del Editor Godot antes de crear su juego para dispositivos móviles.

Los anuncios simulados simulan el comportamiento de los anuncios, las devoluciones de llamada del ciclo de vida (como carga, visualización, clics y rechazos) y la presentación de la interfaz de usuario directamente en el Editor Godot. Esto le ayuda a validar el flujo de integración de anuncios, los diseños personalizados y la ubicación de la interfaz de usuario en las primeras etapas del desarrollo.

## Cómo funciona

El complemento detecta automáticamente cuando su juego se está ejecutando en una plataforma de escritorio (Windows, macOS o Linux) dentro del Editor Godot (`OS.has_feature("editor")`). En lugar de fallar debido a la falta de singletons nativos de Android o iOS, el complemento crea instancias de singletons y nodos simulados automáticamente.

No necesita cambiar nada de su código o configuración GDScript o C# para usar anuncios simulados. Todas las API estándar de [`MobileAds`](reference/classes/MobileAds.md) y formatos de anuncios funcionan exactamente de la misma manera.

## Beneficios de utilizar anuncios simulados

Los anuncios simulados son una herramienta poderosa durante el desarrollo que le ayudará a:

- **Valide su flujo de integración de anuncios**: verifique que la inicialización, la carga, la presentación y todas las demás devoluciones de llamadas del ciclo de vida se activen correctamente en la lógica de su juego.
- **Vista previa de diseños visuales**: comprueba cómo se muestran los anuncios en la interfaz de usuario de tu juego, incluido el diseño y la ubicación de diferentes formatos de anuncios en relación con los elementos de tu interfaz de usuario (como `SafeArea`).
- **Iteración rápida**: evite el lento proceso de compilar, exportar e implementar su aplicación en dispositivos físicos o simuladores solo para probar comportamientos publicitarios básicos.

## Formatos soportados

El sistema simulado simula la apariencia visual y las interacciones de cada formato de anuncio principal:

### Banners
- Muestra un contenedor en la pantalla que coincide con el tamaño estándar seleccionado (por ejemplo, banner estándar, banner grande, rectángulo mediano, tabla de clasificación) o tamaño personalizado.
- Admite posiciones de pantalla personalizadas ([`AdPosition`](reference/classes/AdPosition.md).custom(x, y)).
- **Banners plegables**: si especifica "contraíble" en los extras de la solicitud de anuncio, el banner simulado mostrará un botón de alternancia para contraer/expandir (`^`), lo que le permitirá probar los ajustes de diseño y las devoluciones de llamada cuando el banner se contraiga.
- Representa un botón de cierre (`×`) para simular despidos.

![Mock Banner Ad](assets/mock_ad_banner.png)

### Aplicación abierta
- Muestra una superposición de anuncio simulado de App Open en pantalla completa al inicio para probar las transiciones.

![Mock App Open Ad](assets/mock_ad_app_open.png)

### Intersticial
- Genera una tarjeta intersticial de pantalla completa con una marca realista.
- Cuenta con un botón de cierre (`X`) que oculta el anuncio y activa las devoluciones de llamada de despido.

![Mock Interstitial Ad](assets/mock_ad_interstitial.png)

### Intersticial recompensado y recompensado
- Representa una superposición recompensada en pantalla completa.
- Reproduce un temporizador de cuenta atrás de vídeo simulado (normalmente 8 segundos).
- Presenta una ventana emergente de advertencia si intenta cerrar el anuncio antes de que finalice la cuenta regresiva ("¿Está seguro de que desea cerrar? Perderá su recompensa").
- Otorga automáticamente la recompensa (activa la devolución de llamada `on_rewarded_ad_user_earned_reward` / `UserEarnedReward` con detalles de moneda simulada) una vez que se completa la cuenta regresiva.
- El botón de cerrar (`X`) solo se muestra/habilita después de la duración mínima (5 segundos) o cuando se otorga la recompensa.

![Mock Rewarded Ad](assets/mock_ad_rewarded.png)

### Superposición nativa
- Representa anuncios nativos simulados con estilo de plantilla (que admiten diseños tanto "pequeños" como "medianos") utilizando nodos de control Godot.
- Muestra recursos simulados como íconos de aplicaciones, títulos, botones de llamado a la acción y cuerpos de texto.
- Emite la señal `on_native_overlay_ad_rendered` una vez que la plantilla mock está posicionada, reflejando el comportamiento real del dispositivo para que puedas ajustar la UI (`SafeArea`, etc.) solo después de que el anuncio esté completamente renderizado.

![Mock Native Ad](assets/mock_ad_native.png)

## Devoluciones de llamada del ciclo de vida

Los complementos simulados activan exactamente las mismas señales que los SDK móviles reales, lo que le permite depurar la respuesta de su código a los eventos publicitarios.

Por ejemplo, cuando solicita un anuncio intersticial, se simula la siguiente secuencia:

=== "GDScript"

    ```gdscript
    var _interstitial_ad: InterstitialAd

    func _load_interstitial():
        var listener := InterstitialAdLoadListener.new()
        listener.on_ad_loaded = func(ad: InterstitialAd) -> void:
            _interstitial_ad = ad
            # Simulated callback fires after 0.5s
            print("Ad loaded in Editor!")
            
        listener.on_ad_failed_to_load = func(error: LoadAdError) -> void:
            print("Failed to load: ", error.message)
            
        InterstitialAd.load(unit_id, AdRequest.new(), listener)

    func _show_interstitial():
        if _interstitial_ad:
            var full_screen_listener := FullScreenContentCallback.new()
            full_screen_listener.on_ad_showed_full_screen_content = func() -> void:
                print("Ad shown in Editor!")
                
            full_screen_listener.on_ad_dismissed_full_screen_content = func() -> void:
                print("Ad dismissed in Editor!")
                
            _interstitial_ad.full_screen_content_callback = full_screen_listener
            _interstitial_ad.show()
    ```

=== "C#"

    ```csharp
    private InterstitialAd _interstitialAd;

    private void LoadInterstitial()
    {
        var listener = new InterstitialAdLoadListener
        {
            OnAdLoaded = (ad) =>
            {
                _interstitialAd = ad;
                // Simulated callback fires after 0.5s
                GD.Print("Ad loaded in Editor!");
            },
            OnAdFailedToLoad = (error) =>
            {
                GD.Print("Failed to load: " + error.Message);
            }
        };

        InterstitialAd.Load(unitId, new AdRequest(), listener);
    }

    private void ShowInterstitial()
    {
        if (_interstitialAd != null)
        {
            _interstitialAd.FullScreenContentCallback = new FullScreenContentCallback
            {
                OnAdShowedFullScreenContent = () => GD.Print("Ad shown in Editor!"),
                OnAdDismissedFullScreenContent = () => GD.Print("Ad dismissed in Editor!")
            };
            _interstitialAd.Show();
        }
    }
    ```

## Limitaciones

!!! advertencia "No reemplace las pruebas en el dispositivo"

Si bien la función Vista previa de anuncios simulados es excelente para verificar el flujo lógico y los diseños de la interfaz de usuario, aún debes realizar verificaciones finales en dispositivos móviles físicos o simuladores/emuladores antes de publicar tu juego.

- Los anuncios simulados **no** simulan la latencia de la red, los estados de falla de la red o los adaptadores de red de mediación reales.
- Los anuncios simulados **no** verifican que el ID de la aplicación de AdMob o los ID del bloque de anuncios estén registrados o sean válidos en los servidores de AdMob. Referirse a[Habilitar anuncios de prueba](enable_test_ads.md)para configurar dispositivos de prueba para la validación de dispositivos físicos.
