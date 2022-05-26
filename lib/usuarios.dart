class Usuario{
  String nome = "";
  String email = "";
  String senha = "";

  Usuario({
    required this.nome,
    required this.email,
    required this.senha});

  Usuario.fromMap(Map dados){
    nome = dados["nome"];
    email = dados["email"];
  }
}