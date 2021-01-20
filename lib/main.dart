import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation/basic_animation.dart';
import 'package:flutter_animation/complex_animation.dart';
import 'package:flutter_animation/widget/positioned_boom_menu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  int _counter = 0;
  int _selectIndex = 1;
  List<Widget> pages;
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    pages = <Widget>[
      BasicAnimation(),
      ComplexAnimation(),
    ];
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(curve: Curves.easeInOut, parent: controller));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: Text('wo shi Email'),
              accountName: Text('我是Drawer'),
              onDetailsPressed: () {},
            ),
            ListTile(
              title: Text('基本动画'),
              subtitle: Text(
                '基本动画示例',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              leading: CircleAvatar(child: Text("1")),
              onTap: () {
                _selectIndex = 0;
                setState(() {});
              },
            ),
            Divider(), //分割线
            ListTile(
              title: Text('复杂动画'),
              subtitle: Text(
                '复杂动画示例',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              leading: CircleAvatar(child: Text("2")),
              onTap: () {
                _selectIndex = 1;
                setState(() {});
              },
            ),
            Divider(), //分割线
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: pages
            .asMap()
            .keys
            .map((index) => Offstage(
                  offstage: _selectIndex != index,
                  child: TickerMode(
                    enabled: _selectIndex == index,
                    child: pages[index],
                  ),
                ))
            .toList(),
      ),
      floatingActionButton: PositionedBoomMenu(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        onOpen: () => print("open"),
        onClose: () => print("close"),
        scrollVisible: true,
        overlayColor: Colors.black,
        overlayOpacity: 0.7,
        children: <BoomMenuItem>[
          BoomMenuItem(
//          child: Icon(Icons.accessibility, color: Colors.black, size: 40,),
            child: Icon(Icons.ac_unit),
            title: "Logout",
            titleColor: Colors.grey[850],
            subtitle: "Lorem ipsum dolor sit amet, consectetur",
            subTitleColor: Colors.grey[850],
            backgroundColor: Colors.grey[50],
            onTap: () => print('THIRD CHILD'),
          ),
          BoomMenuItem(
            child: Icon(Icons.ac_unit),
            title: "List",
            titleColor: Colors.white,
            subtitle: "Lorem ipsum dolor sit amet, consectetur",
            subTitleColor: Colors.white,
            backgroundColor: Colors.pinkAccent,
            onTap: () => print('FOURTH CHILD'),
          ),
          BoomMenuItem(
            child: Icon(Icons.ac_unit),
            title: "Team",
            titleColor: Colors.grey[850],
            subtitle: "Lorem ipsum dolor sit amet, consectetur",
            subTitleColor: Colors.grey[850],
            backgroundColor: Colors.grey[50],
            onTap: () => print('THIRD CHILD'),
          ),
          BoomMenuItem(
            child: Icon(Icons.ac_unit),
            title: "Profile",
            titleColor: Colors.white,
            subtitle: "Lorem ipsum dolor sit amet, consectetur",
            subTitleColor: Colors.white,
            backgroundColor: Colors.blue,
            onTap: () => print('FOURTH CHILD'),
          )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
