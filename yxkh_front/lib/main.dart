import 'package:flutter/material.dart';
import 'package:yxkh_front/pages/dashboard.dart';
import 'app.dart';
import 'fluro_router.dart';
import 'routes.dart';

// import 'package:flutter/rendering.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  App.loadConf().then((v) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RestartWidget(
        child: MaterialApp(
      theme: ThemeData(backgroundColor: Colors.white),
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: DashboardWidget(),
      ),
      // 在以下注册的页面可以直接通过url访问
      initialRoute: "/",
      onGenerateRoute: FluroRouter.onGenerateRoute,
    ));
  }
}

class RestartWidget extends StatefulWidget {
  final Widget child;
  RestartWidget({Key key, @required this.child})
      : assert(child != null),
        super(key: key);
  static restartApp(BuildContext context) {
    final _RestartWidgetState state = context.findAncestorStateOfType<_RestartWidgetState>();
    state.restartApp();
  }

  @override
  State<StatefulWidget> createState() {
    return _RestartWidgetState();
  }
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();
  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  void dispose() {
    super.dispose();
    // print("========销毁APP===");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      child: widget.child,
    );
  }
}
