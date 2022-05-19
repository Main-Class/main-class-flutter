part of main_class.view;

typedef PostLoadBuilder<T> = Function(BuildContext context, T? preLoaderResult);
typedef PreLoader<T> = Future<T> Function(BuildContext context);

class Splash<T> extends StatefulWidget {
  final Widget splash;
  final PreLoader<T>? preLoader;
  final PostLoadBuilder<T> builder;
  final Duration minAwait;
  final Duration animationDuration;

  const Splash({
    required this.splash,
    this.preLoader,
    required this.builder,
    this.minAwait = const Duration(milliseconds: 1500),
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  _SplashState<T> createState() => _SplashState<T>();
}

class _SplashState<T> extends State<Splash<T>> {
  bool _loading = true;
  T? _preLoaderResult;

  @override
  void initState() {
    super.initState();

    _executePreLoader();
  }

  _executePreLoader() async {
    try {
      _preLoaderResult = (await Future.wait([
        Future.delayed(widget.minAwait, () {}),
        widget.preLoader != null ? widget.preLoader!(context) : Future.value(),
      ]))[1];
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            widget.splash,
            AnimatedCrossFade(
              firstChild: Container(),
              secondChild: _loading
                  ? Container()
                  : widget.builder(context, _preLoaderResult),
              crossFadeState: _loading
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: widget.animationDuration,
            ),
          ],
        ),
      ),
    );
  }
}
