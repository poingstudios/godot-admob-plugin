# Optimizar la inicialización y la carga de anuncios

Esta guía describe cómo optimizar la inicialización y la carga de anuncios en su proyecto Godot.

## Actualice la configuración de Google Mobile Ads

El Plugin de Godot de Google Mobile Ads habilita la optimización de forma predeterminada e indica al SDK que realice las tareas de inicialización y carga de anuncios en subprocesos en segundo plano.

Las siguientes opciones están disponibles en la Configuración del Proyecto de Godot:

* Deshabilitar la optimización de la inicialización
* Deshabilitar la optimización de la carga de anuncios

Marque estas opciones para indicar al SDK que inicialice y cargue anuncios en el subproceso principal:

| Configuración | Comportamiento |
| :--- | :--- |
| **Disable Initialization Optimization** | Deshabilita la optimización de la llamada de inicialización `MobileAds.initialize()`. |
| **Disable Ad Loading Optimization** | Deshabilita la optimización de las llamadas de carga de anuncios para todos los formatos de anuncios. |

Puede acceder a la configuración de Google Mobile Ads a través del menú de Configuración del Proyecto de Godot:

**Project > Project Settings > Admob > General > Android**

Una vez seleccionado, la interfaz de configuración aparece en la sección **Android**:

![Configuraciones de Optimización de Inicialización](assets/optimize_initialization.png)
