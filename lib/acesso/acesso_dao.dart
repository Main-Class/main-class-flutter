part of main_class.acesso;

abstract class AcessoHandler {
  Future<void> init();

  Future<UsuarioLogado> login(String username, String password, Map<String, dynamic> extras);

  Future<UsuarioLogado> getUsuarioLogado();

  Future<void> logout();

  void dispose();
}
