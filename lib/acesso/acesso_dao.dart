part of main_class.acesso;

abstract class AcessoHandler {
  Future<UsuarioLogado> login(String username, String password, Map<String, dynamic> extras);

  Future<UsuarioLogado> getUsuarioLogado();

  Future<void> lgoout();
}
