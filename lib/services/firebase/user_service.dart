import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test_app/models/vpart_users.dart';


class UserService {
  static final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  // Crea o reemplaza la información del usuario (set)
  static Future<void> createUser(UserModel user) async {
    await _usersCollection.doc(user.uid).set(user.toMap());
  }

  // Actualiza campos específicos del usuario
  static Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _usersCollection.doc(uid).update(data);
  }

  // Elimina al usuario
  static Future<void> deleteUser(String uid) async {
    await _usersCollection.doc(uid).delete();
  }

  // Recupera la información de un usuario
  static Future<UserModel?> getUser(String uid) async {
    DocumentSnapshot doc = await _usersCollection.doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>, uid);
    }
    return null;
  }
}
