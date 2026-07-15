# Habilidades de agente (Beta)

Las habilidades de agente son conjuntos de instrucciones portátiles y autónomas que ayudan a los asistentes de codificación basados en IA (como Antigravity, Claude Code y Cursor) a entender las APIs, convenciones y patrones del Godot AdMob Editor Plugin con mayor precisión.

En lugar de sobrecargar el prompt del sistema de la IA con información sobre cada plataforma, las habilidades de agente aprovechan la divulgación progresiva. Esto permite que el asistente de IA cargue únicamente las instrucciones y recursos que necesita para ejecutar su tarea específica.

---

## Instalar las habilidades

Puede instalar las habilidades de agente de AdMob preconstruidas directamente en su proyecto Godot usando el editor:

1. Abra su proyecto Godot.
2. En el menú superior del editor, haga clic en **Project > Tools > AdMob Manager**.
3. Seleccione la pestaña **AI Copilot**.
4. Haga clic en **Install AI Skills to Project**.

Esto creará automáticamente una carpeta `.skills/` en el directorio raíz de su proyecto y colocará las habilidades disponibles dentro de ella.

!!! note
    Los archivos o carpetas que comienzan con un punto (como `.skills`) están ocultos en el panel FileSystem de Godot de forma predeterminada, pero son totalmente visibles para IDEs externos y asistentes de codificación basados en IA.

### Actualizar las habilidades
Para asegurar que su asistente de IA tenga acceso a las últimas funciones y mejores prácticas, mantenga sus habilidades actualizadas. Para actualizar, abra el AdMob Manager en el Editor Godot y haga clic nuevamente en **Install AI Skills to Project** para sobrescribir la carpeta con los archivos más recientes.

---

## Invocar las habilidades
Una vez que las habilidades estén instaladas en el repositorio de su proyecto, su asistente de IA las indexará y detectará automáticamente. No necesita usar explícitamente el símbolo `@` en su prompt; el asistente referenciará el contexto de la habilidad automáticamente cuando haga preguntas sobre AdMob.

Si desea forzar manualmente al asistente a usar una habilidad específica, puede referenciarla escribiendo `@` seguido del nombre, por ejemplo:
`@godot-admob-banner`

---

## Ver habilidades disponibles

La siguiente tabla describe todas las habilidades disponibles para las funciones del Godot AdMob Editor Plugin:

| Habilidad | Descripción |
| :--- | :--- |
| `godot-admob-get-started` | Asiste en la inicialización del SDK de Google Mobile Ads, el establecimiento de configuraciones de solicitud y la configuración del flujo de consentimiento de la User Messaging Platform (UMP). |
| `godot-admob-banner` | Asiste en la implementación de anuncios de banner (`AdView`), la elección de tamaños de anuncio y la configuración de banners colapsables. |
| `godot-admob-interstitial` | Asiste en la implementación de anuncios intersticiales de pantalla completa, la carga de anuncios y la configuración de callbacks de cierre. |
| `godot-admob-rewarded` | Asiste en la implementación de anuncios bonificados e intersticiales bonificados, la escucha de eventos de recompensa obtenida por el usuario y la limpieza de referencias de anuncios. |
| `godot-admob-app-open` | Asiste en la implementación de anuncios App Open mostrados durante el inicio de la app o las transiciones de la app. |
| `godot-admob-native-overlay` | Asiste en la implementación de anuncios Native Overlay utilizando plantillas de nodos Control pequeñas o medianas personalizadas. |
| `godot-admob-migrate` | Asiste en la migración de su proyecto entre diferentes versiones del plugin (p. ej. de v4.x a v5.x). |
| `godot-admob-mediation` | Asiste en la configuración, integración y verificación de redes de mediación de terceros (AppLovin, Meta Audience Network, Unity Ads, etc.). |
| `godot-admob-troubleshoot` | Asiste en el diagnóstico de errores de carga de anuncios, el manejo de códigos de error, la apertura del Ad Inspector y la resolución de problemas de integración. |
| `godot-admob-privacy` | Asiste en la configuración del consentimiento del usuario (Flujo UMP), el cumplimiento de GDPR, COPPA (tratamiento dirigido a niños), CCPA y opciones de segmentación de solicitudes. |

Puede implementar habilidades de agente para el Godot AdMob Editor Plugin solicitando a su asistente de IA preferido. Las habilidades de agente pueden guiar a su asistente de IA para realizar las siguientes tareas de ejemplo:

* *Ayúdame a inicializar el Godot AdMob Editor Plugin.*
* *Añade un anuncio de banner a mi juego.*
* *Implementa un anuncio bonificado.*
* *Migra mi proyecto de v4 a v5.*
* *Configura el cumplimiento de privacidad de GDPR y COPPA.*
* *Soluciona por qué mis anuncios no se cargan.*
