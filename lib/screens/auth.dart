import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolist/screens/loginRegisterScreen.dart';
import 'package:todolist/screens/homeScreen.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool checarCurrentUser() {
    final _auth = FirebaseAuth.instance;
  User? user = _auth.currentUser;
  return user != null ? true : false;
  }
  onInit(){
    final usuarioLogado = checarCurrentUser();
    if (usuarioLogado == true) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (_) => const HomeScreen()
          ), (route) => false);
    }
    else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (_) => const LoginRegister()
          ), (route) => false);
    }
  }
  @override
  void initState() {
    onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CircularProgressIndicator(),
    );
  }
}
