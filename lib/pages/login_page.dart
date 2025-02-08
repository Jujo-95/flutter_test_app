import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _errorMessage;

  Future<void> _signIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      User? user = userCredential.user;
      if (user != null && mounted) {
        context.go('/');
      }
    } catch (e) {
      setState(() {
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'invalid-email':
              _errorMessage = "El correo electrónico no es válido.";
              break;
            case 'weak-password':
              _errorMessage = "La contraseña es demasiado débil.";
              break;
            case 'email-already-in-use':
              _errorMessage = "El correo electrónico ya está en uso.";
              break;
            default:
              _errorMessage = "Ocurrió un error. Inténtalo de nuevo.";
          }
        } else {
          _errorMessage = "Ocurrió un error. Inténtalo de nuevo.";
        }
      });
    }
  }

  Future<void> _signinWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null && mounted) {
        context.go('/');
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Ocurrió un error al iniciar sesión con Google. Inténtalo de nuevo.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Iniciar Sesión")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Correo Electrónico"),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Contraseña"),
              obscureText: true,
            ),
            if (_errorMessage != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
              SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _signinWithGoogle,
              icon: Icon(Icons.account_circle),
              label: Text("Iniciar sesión con Google"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signIn,
              child: Text("Ingresar"),
            ),
            TextButton(
              onPressed: () {
                context.go('/register');
              },
              child: Text("¿No tienes cuenta? Regístrate"),
            ),
          ],
        ),
      ),
    );
  }
}
