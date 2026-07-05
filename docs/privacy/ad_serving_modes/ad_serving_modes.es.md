# Modos de publicación de anuncios

Según la [Política de Consentimiento del Usuario de la UE](https://www.google.com/about/company/user-consent-policy.html) de Google, debes realizar ciertas divulgaciones a tus usuarios en el Espacio Económico Europeo (EEE) y el Reino Unido, y obtener su consentimiento para el uso de cookies u otro almacenamiento local cuando la ley lo exija, así como para la recopilación, el intercambio y el uso de datos personales para la personalización de anuncios. Esta política refleja los requisitos de la Directiva ePrivacy de la UE y del Reglamento General de Protección de Datos (GDPR). Para cumplir con esta política, los editores deben adoptar una [plataforma de gestión de consentimiento certificada por Google](https://support.google.com/admob/answer/13554116) (CMP) que se haya integrado con el [marco TCF](https://iabeurope.eu/transparency-consent-framework/), como el [SDK de User Messaging Platform](../user_messaging_tools/get_started.md). Una vez adoptada, la CMP presenta opciones de consentimiento, conocidas como propósitos, en tu aplicación móvil.

Este documento se basa en:

- [SDK de Google Mobile Ads para Android - Modos de publicación de anuncios](https://developers.google.com/admob/android/privacy/ad-serving-modes)
- [SDK de Google Mobile Ads para iOS - Modos de publicación de anuncios](https://developers.google.com/admob/ios/privacy/ad-serving-modes)

La interfaz exacta de las opciones de consentimiento la mantiene actualizada Google, pero aquí hay una versión anterior como referencia:

![Ejemplo de opciones de consentimiento](https://developers.google.com/static/admob/images/privacy/consent-form-purposes.png)

!!! note
    **Importante:** Además de recopilar el consentimiento de propósitos, también necesitas recopilar el consentimiento del proveedor. Tanto el consentimiento de propósitos como el consentimiento del proveedor son necesarios para que cualquier proveedor, como Google, publique los anuncios apropiados.

Los diferentes tipos de anuncios que se pueden publicar son:

- [Anuncios personalizados](#anuncios-personalizados)
- [Anuncios no personalizados](#anuncios-no-personalizados)
- [Anuncios limitados](#anuncios-limitados)

## Anuncios personalizados

Los [anuncios personalizados](https://support.google.com/admob/answer/7676680) son anuncios que hacen inferencias sobre los intereses de un usuario en función de los sitios que visita o las aplicaciones que usa. Google considera que los anuncios son personalizados cuando se basan en datos recopilados previamente o en datos históricos para determinar o influir en la selección de anuncios.

Google publicará anuncios personalizados cuando se cumplan todos los siguientes criterios. Para obtener más información, lee los [requisitos para anuncios personalizados](https://support.google.com/admob/answer/9760862#consent-policies).

**Leyenda:** ✅ Consentimiento &nbsp;&nbsp;&nbsp;&nbsp; ✔ Interés legítimo

| Propósito | Elección de consentimiento del usuario |
| --- | --- |
| Propósito 1 | ✅ |
| Propósito 2 | ✔ o ✅ |
| Propósito 3 | ✅ |
| Propósito 4 | ✅ |
| Propósito 7 | ✔ o ✅ |
| Propósito 9 | ✔ o ✅ |
| Propósito 10 | ✔ o ✅ |

## Anuncios no personalizados

Los [anuncios no personalizados](https://support.google.com/admob/answer/7676680) no se basan en el comportamiento pasado del usuario. Aunque los anuncios no personalizados no usan cookies ni identificadores de anuncios móviles para la segmentación de anuncios, estos anuncios sí usan cookies o identificadores de anuncios móviles para la limitación de frecuencia y los informes agregados de anuncios.

Google publicará anuncios no personalizados cuando se cumplan todos los siguientes criterios. Para obtener más información, consulta [Requisitos para anuncios no personalizados](https://support.google.com/admob/answer/9760862#consent-policies).

**Leyenda:** ✅ Consentimiento &nbsp;&nbsp;&nbsp;&nbsp; ✔ Interés legítimo &nbsp;&nbsp;&nbsp;&nbsp; 🚫 Sin consentimiento

| Propósito | Elección de consentimiento del usuario |
| --- | --- |
| Propósito 1 | ✅ |
| Propósito 2 | ✔ o ✅ |
| Propósito 7 | ✔ o ✅ |
| Propósito 9 | ✔ o ✅ |
| Propósito 10 | ✔ o ✅ |

## Anuncios limitados

Los [anuncios limitados (LTD)](https://support.google.com/admob/answer/10105530) desactivan toda la personalización y las funciones que requieren el uso de un identificador local.

Google publica anuncios limitados cuando se cumplen todos los siguientes criterios. Para obtener más información, lee [Lanzamiento: Anuncios limitados 2.0](https://support.google.com/admob/answer/10105530#limited-ads-update).

- Propósitos especiales: 1, 2
- Interés legítimo: 7 (solo opcional)
