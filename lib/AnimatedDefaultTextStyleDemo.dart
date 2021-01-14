import 'package:flutter/material.dart';

class AnimatedDefaultTextStyleDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AnimatedDefaultTextStyleDemoState();
  }
}

class _AnimatedDefaultTextStyleDemoState extends State<AnimatedDefaultTextStyleDemo>
    with SingleTickerProviderStateMixin {
  // Animation animation;
  // AnimationController controller;
  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  // @override
  // void initState() {
  //   controller = AnimationController(duration: Duration(milliseconds: 2000), vsync: this);

  //   super.initState();
  // }
  Color color = Colors.red;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      child: Column(
        children: <Widget>[
          AnimatedDefaultTextStyle(
            child: Text("123455666"),
            style: TextStyle(color: color),
            duration: Duration(seconds: 2),
            onEnd: () {},
          ),
          RaisedButton(
            child: Text("改变字体样式"),
            onPressed: () {
              color = color == Colors.red ? Colors.green : Colors.red;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
