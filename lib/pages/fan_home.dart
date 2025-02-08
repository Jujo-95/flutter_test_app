import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FanHome extends StatelessWidget {
  const FanHome({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: ListTile(title: Text("Bienvenido, ${user!.email ?? 'Usuario'}"), subtitle: Text('Fan'),)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Bienvenido a la app del Club de Fans"),
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