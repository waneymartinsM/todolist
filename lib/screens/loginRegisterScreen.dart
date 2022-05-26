import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolist/screens/loginScreen.dart';
import 'package:todolist/screens/registerScreen.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({Key? key}) : super(key: key);

  @override
  _LoginRegisterState createState() => _LoginRegisterState();
}


class _LoginRegisterState extends State<LoginRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 400.0,
                child: Image.asset(
                  "imagem/HomeTodoList.png",
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.5,
                child: ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LoginScreen()
                        )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo[400],
                    onPrimary: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  ),
                  child: const Text("Entrar"),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.7,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RegisterScreen()
                        )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo[800],
                    onPrimary: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  ),
                  child: const Text("Cadastra-se"),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}