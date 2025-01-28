# CUESTIONARIO TÉCNICO PARA DESARROLLADOR FLUTTER

Sección 1: Conocimientos Básicos de Flutter y Dart
## 1. Describe cómo crearías un diseño responsivo utilizando widgets en Flutter. Proporciona un ejemplo de código si es posible.

Para crear un diseño responsivo utilizando widgets en Flutter me voy a referir a un ejemplo común en las aplicaciones: si la app se utiliza en una screen amplia se prefiere que el menu se presente como una barra lateral y si el screen es pequeño < 600 pixeles la aplicación debe presentar una barra de menú inferior, para el ejemplo utilizaré un statefullWidget que percibe cuando la propiedad wide de un objeto de MediaQuery es menor a 600 pixeles y cambia de NavigationRail a NavigationBar, el código lo presento en el archivo: flutter_test_app\lib\main.dart

## 2. Explica cómo consumirías una API RESTful y manejarías datos en formato JSON en una app Flutter. Incluye los pasos principales y un fragmento de código.

Para llevar a cabo el consumo de una API, construiría un servicio que utilice la librería https.dart, donde se define la lógica de las 4 operaciones principales get, post, put y delete para cada una de los endpoint que se van a utilizar; adicionalmente estas respuestas requieren un modelado, para esto se crea también un modelo para cada endpoint que nos permita leer la respuesta json en una clase legible por dart.

para el ejemplo utilizaré una api de prueba haciendo llamados a la siguiente url: "https://rickandmortyapi.com/api/character"

en el ejemplo utilizo la variable Origin como un modelo con datos anidados para mostrar como tratar datos desnormalizados

un ejemplo de una respuesta lo presento en: flutter_test_app\lib\models\response.dart
el modelo y el servicio lo presento en: flutter_test_app\lib\models\models.dart


# Sección 2: State Management
## 3. Describe un escenario en el que utilizarías Provider en lugar de setState. Proporciona un ejemplo práctico.

Como concepto general cuando quiero compartir un estado entre varios widget la implementación con Provider es más idonea



# Sección 3: Bases de Datos Locales
## 4. ¿Cómo almacenarías y recuperarías datos utilizando SQLite en una aplicación Flutter? Explica los pasos clave y cualquier librería que usarías.




# Sección 4: Publicación de Aplicaciones
## 5. Detalla los pasos principales para publicar una aplicación en Google Play Store y Apple App Store. ¿Qué diferencias importantes destacarías?



# Sección 5: Conocimientos Técnicos Deseables
## 6. Describe cómo implementarías un inicio de sesión con Google utilizando Firebase Authentication en Flutter.



## 7. Explica cómo realizarías una prueba unitaria en Flutter. Proporciona un ejemplo simple.



## 8. ¿Qué técnicas usarías para optimizar el rendimiento de una aplicación Flutter?




# Sección 6: Resolución de Problemas
## 9. Imagina que una de tus aplicaciones Flutter tiene tiempos de carga muy largos al abrir. ¿Cómo diagnosticarías y resolverías este problema?




Sección 7: Competencias Personales
10. Describe una situación en la que hayas trabajado en equipo para resolver un problema técnico. ¿Cuál fue tu rol y qué aprendiste?



11. ¿Cómo te mantienes actualizado con las últimas tecnologías y herramientas en desarrollo móvil?




