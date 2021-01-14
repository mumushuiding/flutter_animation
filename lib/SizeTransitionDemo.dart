import 'package:flutter/material.dart';

class SizeTransitionDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SizeTransitionDemoState();
  }
}

class _SizeTransitionDemoState extends State<SizeTransitionDemo> with SingleTickerProviderStateMixin {
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
    animation = Tween(begin: 1.0, end: 0.5).animate(controller);
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
          SizeTransition(
            axis: Axis.horizontal,
            sizeFactor: animation,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.green,
            ),
          ),
          RaisedButton(
            child: Text("SizeTransitionDemo"),
            onPressed: () {
              if (controller.status == AnimationStatus.completed) {
                controller.reverse();
              } else {
                controller.forward();
              }
            },
          ),
        ],
      ),
    );
  }
}
