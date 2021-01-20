import 'package:flutter/material.dart';

class AnimatedPhysicalModelDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AnimatedPhysicalModelDemoState();
  }
}

class _AnimatedPhysicalModelDemoState extends State<AnimatedPhysicalModelDemo> {
  Color color = Colors.red;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      child: Column(
        children: <Widget>[
          AnimatedPhysicalModel(
            duration: Duration(seconds: 2),
            shape: BoxShape.rectangle,
            elevation: 20.0,
            color: Colors.transparent,
            shadowColor: color,
            child: Container(
              width: 100.0,
              height: 100.0,
              color: Colors.black,
            ),
          ),
          RaisedButton(
            child: Text("容器外形变化动画"),
            onPressed: () {
              if (color == Colors.red) {
                color = Colors.green;
              } else {
                color = Colors.red;
              }
              setState(() {});
            },
          )
        ],
      ),
    );
  }
}
