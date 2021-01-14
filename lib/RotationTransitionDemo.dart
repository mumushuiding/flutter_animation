import 'package:flutter/material.dart';

class RotationTransitionDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RotationTransitionDemoState();
  }
}

class _RotationTransitionDemoState extends State<RotationTransitionDemo> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
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
          RotationTransition(
            turns: animation,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.green,
            ),
          ),
          RaisedButton(
            child: Text("RotationTransitionDemo"),
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
