
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

