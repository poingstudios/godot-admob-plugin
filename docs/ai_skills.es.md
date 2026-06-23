# Habilidades de AI Copilot (beta)

Integre asistentes de codificación basados en IA (como Gemini en Antigravity, Cursor, Claude o GitHub Copilot) en el flujo de desarrollo de su juego utilizando las **Habilidades de AI Copilot** (AI Copilot Skills).

El plugin de AdMob viene con una Habilidad de IA preconfigurada que contiene todas las especificaciones, APIs y patrones de código para integrar varios formatos de anuncios (Banners, Intersticiales, Anuncios Bonificados, etc.) tanto en **GDScript** como en **C#**.

---

## Instalación Rápida (Habilidades Integradas)

Puede instalar las habilidades de IA de AdMob preconfiguradas directamente en su proyecto con un solo clic:

1. Abra su proyecto en Godot.
2. En el menú superior del editor, haga clic en **Project -> Tools -> AdMob Manager**.
3. Seleccione el submenú **AI Copilot**.
4. Haga clic en **Install AI Skills to Project**.

Esto creará automáticamente una carpeta `.skills/godot-admob-copilot` en el directorio raíz de su proyecto y colocará el archivo de instrucciones `SKILL.md` dentro de ella.

!!! note
    Los archivos o carpetas que comienzan con un punto (como `.skills`) están ocultos en el panel FileSystem de Godot de forma predeterminada para evitar el desorden, pero son totalmente visibles para IDEs externos (como VS Code, Cursor, Antigravity, etc.).

---

## Invoque la habilidad en su prompt

Después de agregar la habilidad a su proyecto, use los siguientes ejemplos de prompts para invocarla en su herramienta de IA:

Para invocar la habilidad, escriba `@` y seleccione la habilidad `godot-admob-copilot`.

=== "Inicializar MobileAds"

    ```text
    @godot-admob-copilot Escribe el flujo de inicialización completo que incluye la verificación del consentimiento de UMP antes de inicializar MobileAds en GDScript.
    ```

=== "Añadir Anuncio de Banner"

    ```text
    @godot-admob-copilot Muéstrame cómo crear y mostrar un banner adaptativo estándar en la parte inferior de la pantalla en GDScript.
    ```

=== "Añadir Anuncio Bonificado"

    ```text
    @godot-admob-copilot Ayúdame a cargar un Anuncio Bonificado en C# e implementar una función de devolución de llamada para otorgar 100 monedas de oro al jugador una vez que termine de ver el anuncio.
    ```
