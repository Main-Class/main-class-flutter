part of main_class.acesso;

typedef AlteradorUsuario = Function(UsuarioLogado usuario);

class SessionBloc implements Bloc {
  late BehaviorSubject<UsuarioLogado?> _usuario;

  Stream<UsuarioLogado?> get usuario => _usuario.stream;

  UsuarioLogado? get currentUsuario => _usuario.valueOrNull;

  AcessoHandler acessoHandler;

  SessionBloc({required this.acessoHandler});

  @override
  void dispose() {
    _usuario.close();
    acessoHandler.dispose();
  }

  Future<UsuarioLogado> login(String username, String password,
      [Map<String, dynamic>? extras]) async {
    UsuarioLogado usuario =
        await acessoHandler.login(username, password, extras);

    _add(usuario);

    return usuario;
  }

  _add(UsuarioLogado? usuario) async {
    _usuario.add(usuario);
  }

  update(AlteradorUsuario action) {
    if (currentUsuario != null) {
      action(currentUsuario!);
    }

    _add(currentUsuario);
  }

  logout() async {
    await acessoHandler.logout();
    await _add(null);
  }

  @override
  Future<void> init() async {
    _usuario = new BehaviorSubject();
    await acessoHandler.init();
    await _add(await acessoHandler.getUsuarioLogado());
  }
}
