import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test_app/models/vpart_users.dart';
import 'package:flutter_test_app/services/firebase/user_service.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _errorMessage;
  AccountType _accountType = AccountType.fan;

  Future<void> _register() async {
    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      setState(() {
        _errorMessage = "Las contraseñas no coinciden";
      });
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    User? user = userCredential.user;
    if (user != null) {
      // Crear el modelo de usuario con la información deseada
      UserModel userModel = UserModel(
        name: _nameController.text,
        uid: user.uid,
        email: user.email ?? '',
        accountType: _accountType, // _accountType es de tipo AccountType
      );
      // Almacenar la información en Firestore usando el método toMap() del modelo
      await UserService.createUser(userModel);
    }
      if (mounted) {
        context.go('/login');
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

  Future<void> _registerWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return; // El usuario canceló el inicio de sesión
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        // Crear el modelo de usuario con la información deseada
        UserModel userModel = UserModel(
          name: googleUser.displayName ?? '',
          uid: user.uid,
          email: user.email ?? '',
          accountType: _accountType, // _accountType es de tipo AccountType
        );
        // Almacenar la información en Firestore usando el método toMap() del modelo
        await UserService.createUser(userModel);
      }

      if (mounted) {
        context.go('/login');
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Ocurrió un error. Inténtalo de nuevo.";
      });
    }
  }

  Widget _buildAccountTypeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _accountType = AccountType.fan;
            });
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: _accountType == AccountType.fan ? Colors.blue : Colors.grey,
          ),
          child: Text("Soy Fan"),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _accountType = AccountType.famoso;
            });
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: _accountType == AccountType.famoso ? Colors.blue : Colors.grey,
          ),
          child: Text("Soy Famoso"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registro")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Nombre"),
              keyboardType: TextInputType.name,
            ),
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
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: "Confirmar Contraseña"),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            _buildAccountTypeSelector(),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _registerWithGoogle,
              icon: Icon(Icons.account_circle),
              label: Text("Registrarse con Google"),
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
            ElevatedButton(
              onPressed: _register,
              child: Text("Registrarse"),
            ),
            TextButton(
              onPressed: () {
                context.go('/login');
              },
              child: Text("¿Ya tienes cuenta? Inicia sesión"),
            ),
          ],
        ),
      ),
    );
  }
}
