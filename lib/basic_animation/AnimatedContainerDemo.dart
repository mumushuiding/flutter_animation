import 'package:flutter/material.dart';

class AnimatedContainerDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AnimatedContainerDemoState();
  }
}

class _AnimatedContainerDemoState extends State<AnimatedContainerDemo> {
  double _height = 100;
  Color _color = Colors.red;
  _changeValue() {
    setState(() {
      _height = _height == 100 ? 200 : 100;
      _color = _color == Colors.red ? Colors.blue : Colors.red;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      child: Column(
        children: <Widget>[
          Text("AnimatedContainer 改变容器大小"),
          AnimatedContainer(
            color: _color,
            height: _height,
            width: 400,
            curve: Curves.elasticIn,
            duration: Duration(seconds: 1),
          ),
          RaisedButton(
            child: Text('动画'),
            onPressed: _changeValue,
          ),
        ],
      ),
    );
  }
}
