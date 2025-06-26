import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nyamgo/Services/firestore.dart';

class AuthProvider extends ChangeNotifier{
  final Firestore firestore = Firestore();

  User? _user;
  User? get firebaseUser => _user;

  AuthProvider(){
    firestore.auth.authStateChanges().listen((users){
      _user = users;
      notifyListeners();
    });
  }

  Future<void> logout() async{
    await firestore.logout();
  }

  bool get isLoggedIn => _user != null;
}