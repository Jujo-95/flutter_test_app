import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test_app/models/character.dart';


class ApiService {
  final String baseUrl = "https://rickandmortyapi.com/api/character";
  

  Future<List<Character>> fetchCharacters() async {

    final Box<Character> box = await Hive.openBox<Character>('character');
    final Box<Character> characterBox = box;
    
    if (characterBox.isOpen && characterBox.isNotEmpty) {

      return characterBox.values.toList();
    } 
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        List<dynamic> results = jsonData['results'];
        List<Character> characters = results.map((char) => Character.fromJson(char)).toList();
      

        await characterBox.clear();
        await characterBox.addAll(characters);

        return characters;
        } else {
        throw Exception("Error al obtener los personajes");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("No se pudo conectar con la API");
    }
  }

  void invalidateCache() async {
      final Box<Character> box = await Hive.openBox<Character>('character');
    final Box<Character> characterBox = box;

    characterBox.clear();
  }

}

