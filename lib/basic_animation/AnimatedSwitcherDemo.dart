import 'package:flutter/material.dart';

class AnimatedSwitcherDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AnimatedSwitcherDemoState();
  }
}

class _AnimatedSwitcherDemoState extends State<AnimatedSwitcherDemo> {
  var _child1 = Container(
    key: ValueKey("1"),
    height: 200,
    width: 200,
    color: Colors.green,
  );
  var _child2 = Container(
    key: ValueKey("2"),
    height: 100,
    width: 100,
    color: Colors.blue,
  );
  Widget _child;
  @override
  void initState() {
    _child = _child1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      child: Column(
        children: <Widget>[
          AnimatedSwitcher(
            duration: Duration(seconds: 2),
            child: _child,
            switchInCurve: Curves.bounceIn,
            switchOutCurve: Curves.bounceOut,
          ),
          RaisedButton(
            child: Text("组件切换"),
            onPressed: () {
              _child = _child == _child1 ? _child2 : _child1;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
