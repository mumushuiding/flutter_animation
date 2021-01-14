import 'package:flutter/material.dart';

class AnimatedPositionedDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AnimatedPositionedDemoState();
  }
}

class _AnimatedPositionedDemoState extends State<AnimatedPositionedDemo> {
  double top = 50.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          AnimatedPositioned(
            top: top,
            duration: Duration(seconds: 2),
            child: Container(
              width: 100,
              height: 100,
              color: Colors.green,
            ),
          ),
          RaisedButton(
            child: Text("容器移动位置"),
            onPressed: () {
              if (top == 50.0) {
                top = 0.0;
              } else {
                top = 50.0;
              }
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
