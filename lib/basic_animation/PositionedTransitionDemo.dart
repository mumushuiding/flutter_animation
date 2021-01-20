import 'package:flutter/material.dart';

class PositionedTransitionDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PositionedTransitionDemoState();
  }
}

class _PositionedTransitionDemoState extends State<PositionedTransitionDemo> with SingleTickerProviderStateMixin {
  Animation<RelativeRect> animation;
  AnimationController controller;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller = AnimationController(duration: Duration(milliseconds: 2000), vsync: this);
    animation = RelativeRectTween(
            begin: RelativeRect.fromLTRB(200.0, 200.0, 200.0, 200.0),
            end: RelativeRect.fromLTRB(20.0, 20.0, 20.0, 20.0))
        .animate(controller);
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 400,
      child: Stack(
        children: <Widget>[
          PositionedTransition(
            rect: animation,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.red,
            ),
          ),
          RaisedButton(
            child: Text("PositionedTransitionDemo"),
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
