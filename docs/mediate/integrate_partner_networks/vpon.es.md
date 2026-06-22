# Vpon

El adaptador de mediación de Vpon le permite integrar anuncios de Vpon en su juego de Godot utilizando la mediación de AdMob.

## Integraciones Soportadas

| Formato de Anuncio | Bidding | Waterfall |
| :--- | :--- | :--- |
| **Banner** | ❌ | |
| **Interstitial** | ❌ | |
| **Rewarded** | ❌ | |

## Pasos de Integración

### Android

#### 1. Habilitar Vpon en la Configuración del Proyecto
- Habilite **Vpon** en `admob/android/mediation/vpon` en la Configuración del Proyecto de Godot.

#### 2. Configurar la Mediación en la Consola de AdMob
Configure Vpon como un socio de mediación en su consola de AdMob:
1. Inicie sesión en su **cuenta de AdMob**.
2. Vaya a **Mediación** y cree o edite un **Grupo de mediación**.
3. En el flujo de la red de anuncios (waterfall), agregue Vpon como un **Evento personalizado**.
4. **Nombre de Clase (Class Name)**: Ingrese `com.vpadn.mediation.VpadnAdapter`.
5. **Parámetro**: Ingrese su clave de licencia (License Key) de Vpon.

---

### iOS

Dado que Vpon se integra a través de Eventos personalizados en iOS, los desarrolladores deben agregar el SDK de Vpon y los archivos del framework del adaptador de AdMob a sus configuraciones de compilación de Xcode durante la exportación.

#### 1. Configurar la Mediación en la Consola de AdMob
1. Inicie sesión en su **cuenta de AdMob**.
2. Vaya a **Mediación** y cree o edite un **Grupo de mediación**.
3. En el flujo de la red de anuncios (waterfall), agregue Vpon como un **Evento personalizado**.
4. **Nombre de Clase (Class Name)**: Ingrese `VponAdMobAdapter`.
5. **Parámetro**: Ingrese su clave de licencia de Vpon / ID del bloque de anuncios (Ad Unit ID).
