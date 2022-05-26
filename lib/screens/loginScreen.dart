import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:todolist/screens/homeScreen.dart';
import 'package:todolist/usuarios.dart';
import 'package:todolist/widgets/alert.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  bool carregando = false;
  bool ocultarSenha = true;

  get _firestore => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 250.0,
              child: Image.asset(
                  "imagem/LoginTodoList.png"
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
                obscureText: ocultarSenha,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onPressed: () {
                        if (ocultarSenha == true) {
                          setState(() {
                            ocultarSenha = false;
                          });
                        }
                        else {
                          setState(() {
                            ocultarSenha = true;
                          });
                        }
                      },
                      icon: Icon(
                          ocultarSenha == true ? Icons.close_rounded : Icons
                              .remove_red_eye_rounded)
                  ),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.redAccent
                    )
                  ),
                  disabledBorder:  const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.blueAccent
                      )
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "Senha",
                ),
                controller: senhaController,
              ),
            ),

            const SizedBox(height: 10.0,),

            FractionallySizedBox(
              widthFactor: 0.6,
              child: ElevatedButton(
                onPressed: () async {
                  if (emailController.text.isEmpty) {
                    showAlertDialog(context, AlertType.info, "Atenção",
                        "Insira o seu email");
                  }
                  else if (senhaController.text.isEmpty) {
                    showAlertDialog(context, AlertType.info, "Atenção",
                        "Insira sua senha");
                  }
                  else {
                    setState(() {
                      carregando = true;
                    });
                    showAlertDialog(
                        context, AlertType.info, "titulo", "mensagem");

                    bool result = await authEmailAccount(
                        emailController.text, senhaController.text);
                    if (result == true) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HomeScreen()
                          ), (route) => false);
                      // }


                      FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.text,
                          password: senhaController.text
                      ).then((value) {
                        if (value.user != null) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HomeScreen()
                              ),
                                  (route) => false);
                        }
                      });


                      setState(() {
                        carregando = false;
                      });
                    }
                  }
                  ElevatedButton.styleFrom(
                  primary: Colors.indigo[200],
                  onPrimary: Colors.white,
                  shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  );
                  const Text("Entrar"
                  );
                },
                child: null,
                ),
            ),
          ],
        ),
      ),
    );
  }


 Future<bool> cadastrarUsuario(Usuario usuario) async {
   try {
     await _auth.createUserWithEmailAndPassword(
         email: usuario.email,
         password: usuario.senha).then((value) {
       _firestore.collection("usuarios").doc(value.user!.uid).
       set({
         "date_time":DateTime.now().toString(),
         "id": value.user!.uid,
         "nome": usuario.nome,
         "email": usuario.email,
       });
     });
     return true;
   }catch (error) {
       print("error: $error");

     return false;
   }
 }



 Future<bool> authEmailAccount(String userEmail, String password) async {
   final _firebaseAuth = FirebaseAuth.instance;
   try {
     await _firebaseAuth.signInWithEmailAndPassword(
       email: userEmail,
       password: password,
     );
     return true;

   } on FirebaseAuthException catch (error) {
     switch (error.code) {
       case "invalid-email":
         Fluttertoast.showToast(msg: 'E-mail inválido');
         break;

       case "wrong-password":
         Fluttertoast.showToast(msg: 'Senha incorreta');
         break;

       case "user-not-found":
         Fluttertoast.showToast(msg: 'Usuário não encontrado');
         break;

       case "user-disable":
         Fluttertoast.showToast(msg: 'Usuário bloqueado ou inativo');
         break;

       case "too-many-requests":
         Fluttertoast.showToast(msg: 'Muitas tentativas. Tente novamente mais tarde');
         break;

       case "operation-not-allowed":
         Fluttertoast.showToast(msg: 'Login desabilitado');
         break;

       case "email-already-in-use":
         Fluttertoast.showToast(msg: 'O e-mail fornecido já está em uso por outro usuário');
         break;

       default:
         Fluttertoast.showToast(msg: 'Ocorreu um erro desconhecido');
         break;
     }

     return false;
   }
 }

}

