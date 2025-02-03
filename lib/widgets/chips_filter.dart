import 'package:flutter/material.dart';
import 'package:flutter_test_app/models/character.dart';
import 'package:flutter_test_app/providers/characters_provider.dart';
import 'package:flutter_test_app/services/api_service.dart';
import 'package:provider/provider.dart';

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
                                                            onPressed: (){

                        Provider.of<CharacterProvider>(context, listen:false).setStatusFilter(specie);
                  
                },),).toList(),
            );
      
          }
        
        
      },);
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