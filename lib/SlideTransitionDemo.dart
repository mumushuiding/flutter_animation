import 'package:flutter/material.dart';

class SlideTransitionDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SlideTransitionDemoState();
  }
}

class _SlideTransitionDemoState extends State<SlideTransitionDemo> with SingleTickerProviderStateMixin {
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
    animation = Tween(
      begin: Offset(0.0, 0.0),
      end: Offset(0.5, 0.3),
    ).animate(controller);
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
          SlideTransition(
            position: animation,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.green,
            ),
          ),
          RaisedButton(
            child: Text("SlideTransitionDemo"),
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
