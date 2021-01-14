import 'package:flutter/material.dart';

class ScaleTransitionDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScaleTransitionDemoState();
  }
}

class _ScaleTransitionDemoState extends State<ScaleTransitionDemo> with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController controller;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller = AnimationController(duration: Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 0.5).animate(controller);
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      child: Column(
        children: <Widget>[
          ScaleTransition(
            scale: animation,
            child: Container(
              width: 100.0,
              height: 100.0,
              color: Colors.red,
            ),
          ),
          RaisedButton(
            child: Text("ScaleTransitionDemo"),
            onPressed: () {
              if (controller.status == AnimationStatus.completed) {
                controller.reverse();
              } else {
                controller.forward();
              }
            },
          )
        ],
      ),
    );
  }
}
