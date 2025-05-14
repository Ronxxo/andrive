import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService with ChangeNotifier {
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Iniciar sesión con nombre y correo
  Future<bool> signInWithNameAndEmail(String name, String email) async {
    try {
      // Verificar si el usuario ya existe
      var userQuery =
          await _firestore
              .collection('users')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      String userId;
      if (userQuery.docs.isNotEmpty) {
        // Usuario existente
        userId = userQuery.docs.first.id;
        var userData = userQuery.docs.first.data();
        _currentUser = UserModel(
          id: userId,
          name: userData['name'],
          email: userData['email'],
          createdAt: (userData['createdAt'] as Timestamp).toDate(),
        );
      } else {
        // Nuevo usuario
        var newUserRef = await _firestore.collection('users').add({
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });

        userId = newUserRef.id;
        _currentUser = UserModel(
          id: userId,
          name: name,
          email: email,
          createdAt: DateTime.now(),
        );
      }

      notifyListeners();
      return true;
    } catch (e) {
      print('Error en el inicio de sesión: $e');
      return false;
    }
  }

  // Cerrar sesión
  void signOut() {
    _currentUser = null;
    notifyListeners();
  }
}
