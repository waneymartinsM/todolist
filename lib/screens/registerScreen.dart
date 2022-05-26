import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:todolist/screens/homeScreen.dart';
import 'package:todolist/widgets/alert.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  bool carregando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 150.0,),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 12.0, horizontal: 24.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "Nome",
                ),
                controller: nomeController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 12.0, horizontal: 24.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "Email",
                ),
                controller: emailController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 12.0, horizontal: 24.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock_outlined),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "Senha",
                ),
                controller: senhaController,
              ),
            ),
            const SizedBox(height: 30.0,),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: ElevatedButton(
                onPressed: () {
                  if(nomeController.text.isEmpty){
                    showAlertDialog(context, AlertType.info, "Atenção", "Insira o seu nome");
                  }
                  else if(emailController.text.isEmpty){
                    showAlertDialog(context, AlertType.info, "Atenção", "Insira o seu email");
                  }
                  else if(EmailValidator.validate(emailController.text) == false){
                    showAlertDialog(context, AlertType.info, "Atenção", "Email é inválido!");
                  }
                  else if(senhaController.text.isEmpty){
                    showAlertDialog(context, AlertType.info, "Atenção", "Insira sua senha");
                  }
                  else if(senhaController.text.length < 7){
                    showAlertDialog(context, AlertType.info, "Atenção", "Sua senha tem menos de 7 caracteres");
                  }
                  else{
                    setState(() {
                      carregando = true;
                    });

                    FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: senhaController.text

                    ).then((value){
                      FirebaseFirestore.instance.collection("usuarios").doc(value.user!.uid).set({
                        "id": value.user!.uid,
                        "nome": nomeController.text,
                        "email": emailController.text,
                        "senha" : senhaController.text
                      });
                    });

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()
                        ), (route) => false
                    );

                    setState(() {
                      carregando = false;
                    });
                  }
                },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo[800],
                    onPrimary: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.00))),
                  ),
                child: const Text("Cadastrar"),
            ),
            )
          ],
        ),
      ),
    );
  }
}