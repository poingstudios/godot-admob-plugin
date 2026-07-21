# Solucionar problemas de subasta

La subasta permite que las fuentes de anuncios compitan en tiempo real por tu inventario de anuncios. Esta página proporciona pasos para solucionar problemas comunes de subasta.

## Problemas comunes de subasta

### Los anuncios no se cargan

Si los anuncios no se cargan con la subasta:

1. **Verificar la versión del adaptador**: Asegúrate de estar utilizando la última versión del adaptador de subasta.
2. **Verificar la inicialización**: Comprueba que el SDK y los adaptadores de subasta estén correctamente inicializados.
3. **Verificar la configuración del bloque de anuncios**: Verifica que tu bloque de anuncios esté configurado para subasta en la interfaz de usuario de AdMob.

### Tasa de relleno baja

Si experimentas una tasa de relleno baja con la subasta:

1. **Verificar el estado de la fuente de anuncios**: Verifica que la fuente de anuncios esté activa y configurada correctamente.
2. **Revisar los precios mínimos (floor pricing)**: Comprueba si tus precios mínimos son demasiado altos.
3. **Cobertura geográfica**: Algunas fuentes de anuncios tienen una cobertura geográfica limitada.

### Problemas de latencia

Si la subasta está causando latencia:

1. **Verificar las condiciones de la red**: Las malas condiciones de la red pueden aumentar la latencia de la subasta.
2. **Monitorear la latencia del adaptador**: Utiliza el estado de inicialización para verificar la latencia del adaptador.
3. **Optimizar la configuración del tiempo de espera**: Ajusta la configuración del tiempo de espera si está disponible.

## Herramientas de depuración

### Inspector de anuncios (Ad Inspector)

Utiliza el Inspector de anuncios para depurar problemas de subasta:

1. Habilita el Inspector de anuncios en tu aplicación.
2. Abre el Inspector de anuncios cuando se cargue un anuncio.
3. Verifica el estado de la subasta y la información de la respuesta.

### Registros (Logs)

Habilita el registro para ver información detallada de la subasta:

=== "GDScript"

    ```gdscript
    # Habilitar el registro de depuración
    MobileAds.set_debug(true)
    ```

=== "C#"

    ```csharp
    // Habilitar el registro de depuración
    MobileAds.SetDebug(true);
    ```

## Asistencia adicional

Si continúas experimentando problemas, ponte en contacto con el [soporte del SDK de anuncios de Google para móviles](https://support.google.com/admob/contact/contact_us_gma_sdk).
