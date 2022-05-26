import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:todolist/screens/loginRegisterScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List _listaTarefas = [];
  Map<String, dynamic> _ultimaTarefaRemovida = Map();
  final TextEditingController _controllerTarefa = TextEditingController();

  Future<File> _getFile() async {

    final diretorio = await getApplicationDocumentsDirectory();
    return File( "${diretorio.path}/dados.json" );

  }

  _salvarTarefa(){

    String textoDigitado = _controllerTarefa.text;

    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = textoDigitado;
    tarefa["realizada"] = false;

    setState(() {
      _listaTarefas.add( tarefa );
    });
    _salvarArquivo();
    _controllerTarefa.text = "";
  }

  _salvarArquivo() async {

    var arquivo = await _getFile();

    String dados = json.encode( _listaTarefas );
    arquivo.writeAsString( dados );

  }

  _lerArquivo() async {

    try{

      final arquivo = await _getFile();
      return arquivo.readAsString();

    }catch(e){
      return null;
    }

  }

  @override
  void initState() {
    super.initState();

    _lerArquivo().then( (dados){
      setState(() {
        _listaTarefas = json.decode(dados);
      });
    } );

  }

  Widget criarItemLista(context, index){

    return Dismissible(
        key: Key( DateTime.now().millisecondsSinceEpoch.toString() ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction){

          _ultimaTarefaRemovida = _listaTarefas[index];
          _listaTarefas.removeAt(index);

          _salvarArquivo();

          final snackbar = SnackBar(
            backgroundColor: Colors.indigo[100],
            duration: const Duration(seconds: 5),
            content: const Text("Tarefa removida!"),
            action: SnackBarAction(
                label: "Desfazer",
                textColor: Colors.white,
                onPressed: (){

                  setState(() {
                    _listaTarefas.insert(index, _ultimaTarefaRemovida);
                  });
                  _salvarArquivo();

                }
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackbar);

        },
        background: Container(
          color: Colors.red,
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const <Widget>[
              Icon(
                Icons.delete,
                color: Colors.white,
              )
            ],
          ),
        ),
        child: CheckboxListTile(
          title: Text( _listaTarefas[index]['titulo'] ),
          value: _listaTarefas[index]['realizada'],
          onChanged: (valorAlterado){

            setState(() {
              _listaTarefas[index]['realizada'] = valorAlterado;
            });

            _salvarArquivo();

          },
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        title: const Text("To-do List"),
        backgroundColor: Colors.indigo[300],
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginRegister()
                  ), (route) => false
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: Colors.indigo[300],
          onPressed: (){
            showDialog(
                context: context,
                builder: (context){

                  return AlertDialog(
                    backgroundColor: Colors.indigo[100],
                    title: const Text("Adicionar Tarefa"),
                    content: TextField(
                      controller: _controllerTarefa,
                      decoration: const InputDecoration(
                          labelText: "Digite sua tarefa",
                      ),
                      onChanged: (text){},
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text("Cancelar"),
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                        ),
                      ),
                      TextButton(
                        child: const Text("Salvar"),
                        onPressed: (){
                          _salvarTarefa();
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                        ),
                      )
                    ],
                  );
                }
            );
          }
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount: _listaTarefas.length,
                itemBuilder: criarItemLista
            ),
          )
        ],
      ),
    );
  }
}