part of main_class.acesso;

class SessionBloc implements Bloc {
  BehaviorSubject<UsuarioLogado> _usuario;

  Stream<UsuarioLogado> get usuario => _usuario.stream;

  UsuarioLogado get currentUsuario => _usuario.value;

  StreamSubscription<UsuarioLogado> _usuarioSubscription;

  AcessoHandler acessoHandler;

  SessionBloc({this.acessoHandler});

  @override
  void dispose() {
    _usuarioSubscription?.cancel();
    _usuario.close();
  }

  Future<UsuarioLogado> login(
    String username,
    String password,
    Map<String, dynamic> extras,
  ) async {
    UsuarioLogado usuario =
        await acessoHandler.login(username, password, extras);

    _add(usuario);

    return usuario;
  }

  _add(UsuarioLogado usuario) async {
    _usuario.add(usuario);
  }

  logout() async {
    await acessoHandler.logout();
    await _add(null);
  }

  @override
  Future<void> init() async {
    _usuario = new BehaviorSubject();
  }

  load() async {
    await _add(await acessoHandler.getUsuarioLogado());
  }
}
