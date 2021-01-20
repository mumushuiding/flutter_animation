import 'package:flutter/material.dart';

class DecoratedBoxTransitionDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DecoratedBoxTransitionDemoState();
  }
}

class _DecoratedBoxTransitionDemoState extends State<DecoratedBoxTransitionDemo> with SingleTickerProviderStateMixin {
  Animation<Decoration> animation;
  AnimationController controller;
  @override
  void initState() {
    controller = AnimationController(duration: Duration(milliseconds: 2000), vsync: this);
    animation = DecorationTween(
            begin: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(0.0)),
              color: Colors.green,
            ),
            end: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: Colors.red))
        .animate(controller);
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
          DecoratedBoxTransition(
            decoration: animation,
            child: Container(
              width: 100,
              height: 100,
            ),
          ),
          RaisedButton(
            child: Text("DecoratedBoxTransitionDemo"),
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
