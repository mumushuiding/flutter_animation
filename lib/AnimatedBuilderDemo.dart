import 'package:flutter/material.dart';

class AnimatedBuilderDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AnimatedBuilderDemoState();
  }
}

class _AnimatedBuilderDemoState extends State<AnimatedBuilderDemo> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  @override
  void initState() {
    controller = AnimationController(duration: Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 200.0).animate(controller);
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      child: Column(
        children: <Widget>[
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Container(
                height: animation.value,
                width: animation.value,
                child: FlutterLogo(),
              );
            },
          ),
          RaisedButton(
            child: Text("AnimatedBuilderDemo 动画构造器"),
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
