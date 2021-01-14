import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedOpacityDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AnimatedOpacityDemoState();
  }
}

class _AnimatedOpacityDemoState extends State<AnimatedOpacityDemo> with SingleTickerProviderStateMixin {
  double opacity = 0.8;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      child: Column(
        children: <Widget>[
          AnimatedOpacity(
            opacity: opacity,
            duration: Duration(seconds: 2),
            child: Container(
              width: 100,
              height: 100,
              color: Colors.black,
            ),
          ),
          RaisedButton(
            child: Text("修改容器透明度"),
            onPressed: () {
              opacity = Random().nextDouble();
              print("AnimatedOpacityDemo opacity:$opacity");
              setState(() {});
            },
          )
        ],
      ),
    );
  }
}
