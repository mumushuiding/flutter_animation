import 'package:flutter/material.dart';

class AnimatedModalBarrierDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AnimatedModalBarrierDemoState();
  }
}

class _AnimatedModalBarrierDemoState extends State<AnimatedModalBarrierDemo> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller = AnimationController(duration: Duration(seconds: 2), vsync: this);
    animation = ColorTween(begin: Colors.red, end: Colors.blue).animate(controller);
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
          Container(
            constraints: BoxConstraints(maxHeight: 100, maxWidth: 100),
            child: AnimatedModalBarrier(
              color: animation,
            ),
          ),
          RaisedButton(
            child: Text("颜色动画"),
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
