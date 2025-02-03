import 'package:flutter/material.dart';
import 'package:flutter_test_app/models/character.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_test_app/widgets/chips_filter.dart';
import 'package:flutter_test_app/providers/characters_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CharacterAdapter());
  Hive.registerAdapter(OriginAdapter());
  await Hive.openBox<Character>('characters');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CharacterProvider()),
      ],
      child: const MaterialApp(
        home: ResponsiveApp(),
      ),
    );
  }
}

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
      body: 
      Row(
        children: [
          if (wideScreen)
            NavigationRail(
              selectedIndex: 0,
              destinations: [  NavigationRailDestination(icon: Icon(Icons.inbox_rounded), label: Text('Inbox'))
              ,NavigationRailDestination(icon: Icon(Icons.mail), label: Text('Mail'))
              ]
            ),
    
          Expanded(
            child: 
            Row(
              children: [
                ChipsFilter(), Expanded(child: FilteredCharacterList())
              ],
            ) 
          ) 
        ],
      ),
      bottomNavigationBar: wideScreen
          ? null
          : NavigationBar(
            
            selectedIndex: 0,
              destinations: [  NavigationDestination(icon: Icon(Icons.inbox_rounded), label: 'Inbox')
              ,NavigationDestination(icon: Icon(Icons.mail), label: 'Mail')]
          )
    );
  }
}