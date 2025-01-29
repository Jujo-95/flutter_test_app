# CUESTIONARIO TÉCNICO PARA DESARROLLADOR FLUTTER

Sección 1: Conocimientos Básicos de Flutter y Dart
## 1. Describe cómo crearías un diseño responsivo utilizando widgets en Flutter. Proporciona un ejemplo de código si es posible.

Para crear un diseño responsivo utilizando widgets en Flutter me voy a referir a un ejemplo común en las aplicaciones: si la app se utiliza en una screen amplia se prefiere que el menu se presente como una barra lateral y si el screen es pequeño < 600 pixeles la aplicación debe presentar una barra de menú inferior, para el ejemplo utilizaré un statefullWidget que percibe cuando la propiedad wide de un objeto de MediaQuery es menor a 600 pixeles y cambia de NavigationRail a NavigationBar, el código lo presento en el archivo: flutter_test_app\lib\main.dart

```dart
class ResponsiveApp extends StatefulWidget {
  const ResponsiveApp({
    super.key,
  });


  @override
  State<ResponsiveApp> createState() => _ResponsiveAppState();
}

class _ResponsiveAppState extends State<ResponsiveApp> {
  bool wideScreen = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    wideScreen = width > 600;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (wideScreen)
            NavigationRail(
              selectedIndex: 0,
              destinations: [  NavigationRailDestination(icon: Icon(Icons.inbox_rounded), label: Text('Inbox'))
              ,NavigationRailDestination(icon: Icon(Icons.mail), label: Text('Mail'))
              ]
            ),
          Expanded(
            child: Placeholder(
            ),
          ),
        ],
      ),
      bottomNavigationBar: wideScreen
          ? null
          : Column(
            children: [
              Expanded(
            child: Placeholder(
            ),
          ),
              NavigationBar(
                
                selectedIndex: 0,
                  destinations: [  NavigationDestination(icon: Icon(Icons.inbox_rounded), label: 'Inbox')
                  ,NavigationDestination(icon: Icon(Icons.mail), label: 'Mail')]
              ),
            ],
          )
    );
  }
}
```


## 2. Explica cómo consumirías una API RESTful y manejarías datos en formato JSON en una app Flutter. Incluye los pasos principales y un fragmento de código.

Para llevar a cabo el consumo de una API, construiría un servicio que utilice la librería `http.dart`, donde se define la lógica de las 4 operaciones principales `get`, `post`, `put` y `delete` para cada uno de los endpoints que se van a utilizar; adicionalmente estas respuestas requieren un modelado, para esto se crea también un modelo para cada endpoint que nos permita leer la respuesta JSON en una clase legible por Dart.

Para el ejemplo utilizaré una API de prueba haciendo llamados a la siguiente URL: [https://rickandmortyapi.com/api/character](https://rickandmortyapi.com/api/character).

En el ejemplo utilizo la variable `Origin` como un modelo con datos anidados para mostrar cómo tratar datos desnormalizados.

Un ejemplo de una respuesta lo presento en: [`flutter_test_app/lib/models/response.dart`](lib/models/response.json)

El modelo y el servicio lo presento en: [`flutter_test_app/lib/models/models.dart`](lib/models/models.dart)

fragmentop de código:


```dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class Origin {
  final String name;

  Origin({required this.name});

  factory Origin.fromJson(Map<String, dynamic> json) {
    return Origin(name: json['name']);
  }
}

class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String image;
  final Origin origin;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.image,
    required this.origin,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      gender: json['gender'],
      image: json['image'],
      origin: Origin.fromJson(json['origin']),
    );
  }
}

class ApiService {
  final String baseUrl = "https://rickandmortyapi.com/api/character";


  Future<List<Character>> fetchCharacters() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        List<dynamic> results = jsonData['results'];
        return results.map((char) => Character.fromJson(char)).toList();
    } else {
        throw Exception("Error al obtener los personajes");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("No se pudo conectar con la API");
    }
  }

}
```


# Sección 2: State Management
## 3. Describe un escenario en el que utilizarías Provider en lugar de setState. Proporciona un ejemplo práctico.

Como concepto general cuando quiero compartir un estado entre varios widget la implementación con Provider es más idonea, acontinuación muestro un ejemplo (siguiendo con el modelo de la api llamada anteriormente) que filtra un listado de persoinajes basado en su especie ('Human'), el widget que contiene los chips es diferente al widget que presenta la lista, por eso lo mejor sería implementar el uso de provider para compartir el estado del filtro y que basado en este estado la lista de characters se filtre.


primero se crea un provider (ChangeNotifierProvider) que almacene la especie a filtrar en una variable
para el widget del filtro se crea un stateless widget que presente cada una de las especies del listado de personajes en chips que se puedan dar clic y notificar al provider del cambio. 
para el listado se crea un stateless widget con un listview que filtre basado en la variable declarada y almacenada en el provider.
aquí al main se le debe adicionar un Multiprovider con el provider CharacterProvider para que los wigets de la app puedan utilizar correctamente el manejo de estados con la librería provider.



```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharacterProvider with ChangeNotifier {
  String _statusFilter = ""; 

  String get statusFilter => _statusFilter;

  void setStatusFilter(String status) {
    _statusFilter = status;
    notifyListeners(); 
  }
}

class ChipsFilter extends StatelessWidget {
  const ChipsFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiService().fetchCharacters(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No characters found');
        } else {
          final speciesList = snapshot.data!.map((e) => e.species).toSet().toList();
          
          return Wrap(
            children: speciesList.map((specie) => ElevatedButton(
              child: Text(specie), 
              onPressed: () {
                Provider.of<CharacterProvider>(context, listen: false).setStatusFilter(specie);
              },
            )).toList(),
          );
        }
      },
    );
  }
}

class FilteredCharacterList extends StatelessWidget {
  const FilteredCharacterList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CharacterProvider>(
      builder: (context, characterProvider, child) {
        return FutureBuilder<List<Character>>(
          future: ApiService().fetchCharacters(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No characters found');
            } else {
              final filteredCharacters = snapshot.data!
                  .where((character) => character.species == characterProvider.statusFilter)
                  .toList();

              return ListView.builder(
                itemCount: filteredCharacters.length,
                itemBuilder: (context, index) {
                  final character = filteredCharacters[index];
                  return ListTile(
                    leading: Image.network(character.image),
                    title: Text(character.name),
                    subtitle: Text(character.species),
                  );
                },
              );
            }
          },
        );
      },
    );
  }
}
```


# Sección 3: Bases de Datos Locales
## 4. ¿Cómo almacenarías y recuperarías datos utilizando SQLite en una aplicación Flutter? Explica los pasos clave y cualquier librería que usarías.

utilizaría la librería sqflite, se encarga de crear el archivo.db donde almacenar los datos

pasos clave:

1. crear un servicio de conexión a la base de datos, este servicio puede ser tipo sigleton para referenciar unicamente una instancia de la clase y evitar multiples conexiones a la base de datos. 
  - en el servicio utilizaría el método openDatabase() para generar la conexión a la base de datos y la clase debería retornar un parámetro database tipo Future<Database>.

2. para estructurar la información debería generar modelos que me permitan transformar la respuesta de la librería en objetos de dart

3. además del servicio de conección puedo generar un servicio que contenga cada operación CRUD que necesite y con el uso del modelo del paso 2 puedo consultar las fiferentes tablas desde cualquier widget y retornar objetos de dart.



# Sección 4: Publicación de Aplicaciones
## 5. Detalla los pasos principales para publicar una aplicación en Google Play Store y Apple App Store. ¿Qué diferencias importantes destacarías?

primero cuando la app esté lista debo generar los archivos específicos de ambas plataformas
para android en google play store : flutter build appbundle --release
para iphone en apple app store: flutter build ipa --release

en las cuentas de desarrollo de apps correspondientes se debe montar el archivo app-release.aab para google play. y .ipa en apple.

la principal diferencia es el costo, pues google play solo cobra una vez de por vida 25 USD mientras que Apple requiere una anualidad de 100 USD al año.



# Sección 5: Conocimientos Técnicos Deseables
## 6. Describe cómo implementarías un inicio de sesión con Google utilizando Firebase Authentication en Flutter.

1. Se debe crear una proyecto en firebase console y agregar las apps de android y ios.
2. Adicionar las dependencias e inicializar firebase al inicio del proyecto en el main.dart

```dart
dependencies:
  firebase_auth: 
  google_sign_in: 
  firebase_core: 
```

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ResponsiveApp());
}
```

3. Adicionar una función que ejecute el inicio de sesión con google algo como:
```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential?> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  return await FirebaseAuth.instance.signInWithCredential(credential);
}
```

4. esta función devuelve un objeto tipo User, que ese puede utilizar en la app para validar si el usuario está logeado o no.





## 7. Explica cómo realizarías una prueba unitaria en Flutter. Proporciona un ejemplo simple.

para el main que tenemos desarrollado una prueba unitaria relevante sería validar que el menú se muestre como NavigationRail (barra lateral) si el tamaño de la pantalla es mayor a 600 y no se muestre si el tamañno es menor a 600.

para esto podemos hacer uso de testWidget, para asignarle el widget MaterialApp y dentro nuestra que usa nuestro widget ResponsiveApp() definido en la pregunta 1.

para realizar el test creamos una instancia de tester.pumpWidget() y dentro insertar nuestro testWidget en un MediaQuery con un Size (800, 600)

y hacemos la prueba con expect() buscando un widget NavigationRail, que para este tamaño debe existir.

la prueba se almacena dentro de 

test\widgets\responsive_app_test.dart

y la prueba se ejecuta con:

flutter test test\widgets\responsive_app_test.dart

y se valida que los test pasen revisando el output del test.

esta sería la prueba unitaria:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_app/main.dart';
import 'package:flutter_test_app/widgets/chips_filter.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('ResponsiveApp shows NavigationRail on wide screens', (WidgetTester tester) async {
    // Define a widget to test
    final testWidget = MaterialApp(
      home: MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => CharacterProvider()  )],
        child: ResponsiveApp()),
    );

    // Build the widget with a wide screen size
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(size: Size(800, 600)),
        child: testWidget,
      ),
    );

    // Verify that the NavigationRail is shown
    expect(find.byType(NavigationRail), findsOneWidget);
  });
}
```



## 8. ¿Qué técnicas usarías para optimizar el rendimiento de una aplicación Flutter?

Delegar funciones pesadas a servicios extenos, aprovechar funciones y apis en el backend que alivianen algunos procesos. estos servicios externos también se pueden utilizar para el almacenamiento de imágnenes y de esta manera hacer más liviana la app. 

evitar renderizar complentamente la UI. utilizando provider, por ejemplo que permite renderizar solo partes específicas de la UI sin reconstruir toda la pantalla




# Sección 6: Resolución de Problemas
## 9. Imagina que una de tus aplicaciones Flutter tiene tiempos de carga muy largos al abrir. ¿Cómo diagnosticarías y resolverías este problema?

ejecuto la app en modo debug con flutter run --debug
abor devtools y reseteo la app para ver su tiempo de carga t basado en los gráficos de barra puedo identificar el cuello de botella y analizar el widget.


Sección 7: Competencias Personales
10. Describe una situación en la que hayas trabajado en equipo para resolver un problema técnico. ¿Cuál fue tu rol y qué aprendiste?

En un proyecto de ingeniería de datos, el equipo creció rápidamente y se hicieron muchas actualizaciones, lo que generaba conflictos y desorganización en el código. Mi rol fue liderar la implementación de una solución.
Introdujimos DBT (Data Build Tool) para gestionar y versionar las transformaciones de datos de manera más eficiente, mejorando la trazabilidad y la modularidad.
Manejo de versiones en GitHub: Establecimos un flujo de trabajo en GitHub con ramas específicas para desarrollo, pruebas y producción, además de usar pull requests para revisiones de código y evitar conflictos.

El uso de DBT mejoró la claridad en las transformaciones de datos y el manejo de versiones en GitHub redujo los conflictos y mejoró la colaboración.

Aprendí la importancia de tener herramientas y flujos de trabajo adecuados en proyectos de datos para evitar desorden y mejorar la eficiencia del equipo.


11. ¿Cómo te mantienes actualizado con las últimas tecnologías y herramientas en desarrollo móvil?

Anteriormente me mantenia actualizado remitiéndome a la documentación y cuando quería aprender una herramienta o tema nuevo hacía codelabs que son tutoriales paso a paso que muestran el uso de diferentes herramientas, además aprovecho mucho el recurso de youtube para mirar el widget of the day para descubrir widgets nuevos que puedan evitarme reinventar la rueda. 
Actualmente además de lo contado anteriormente también estoy suscrito a un newsletter de "code with andrea" que cada cierto tiempo muestra artículos relevantes rewlacionados al desarrollo con flutter.
otra forma de aprender a mantenerme actualizado en el uso de las tecnologías es con la ayuda de AI, con chatgpt, cuando debo aprender una nueva herramienta le pido que me genere un paso a paso de los features más importantes y cómo usarlos de manera práctica, así hago mi "curso personalizado" he descubiuerto que yo aprendo haciendo, y para mi es la forma más rápida de aprender algo nuevo o repasar.




