import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ResponsiveApp(),
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