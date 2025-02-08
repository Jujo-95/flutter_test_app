import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test_app/pages/famous_home.dart';
import 'package:flutter_test_app/pages/fan_home.dart';
import 'login_page.dart';

class UserTypeWrapper extends StatelessWidget {
  const UserTypeWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Por si acaso, en caso de que no esté autenticado
      return LoginPage();
    }
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
            FirebaseAuth.instance.signOut();
            WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${snapshot.error}. Desautenticado."))
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
            });
          return LoginPage();
            // Desautenticar y redirigir al login

          
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
            FirebaseAuth.instance.signOut();
            WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content:Text("No se encontró información del usuario."))
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
            });
          return LoginPage();
            // Desautenticar y redirigir al login
        }
        final data = snapshot.data!.data() as Map<String, dynamic>;
        final accountType = data['accountType'] as String;
        // Redirige según el tipo de cuenta
        if (accountType == 'famoso') {
          return const FanHome();
        } else {
          return const FamousHome();
        }
      },
    );
  }
}