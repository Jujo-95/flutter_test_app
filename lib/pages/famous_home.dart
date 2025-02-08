import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FamousHome extends StatelessWidget {
  const FamousHome({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar( title:  ListTile(title: Text("Bienvenido, ${user!.email ?? 'Usuario'}"), subtitle: Text('Famoso'),)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Bienvenido a Vepart"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: Text("Cerrar Sesión"),
            ),
          ],
        ),
      ),
    );
  }
}