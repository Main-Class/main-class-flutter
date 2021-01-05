part of main_class.acesso;

class UsuarioLogado extends Model<dynamic> {
  String email;
  String nome;
  String foto;

  UsuarioLogado({this.nome, this.email, this.foto, dynamic id}) : super(id: id);
}
