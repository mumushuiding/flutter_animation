import 'package:flutter/material.dart';

class AnimatedIconDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AnimatedIconDemoState();
  }
}

class _AnimatedIconDemoState extends State<AnimatedIconDemo> with TickerProviderStateMixin {
  AnimationController controller;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller = AnimationController(duration: Duration(seconds: 2), vsync: this);
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
          AnimatedIcon(
            icon: AnimatedIcons.view_list,
            progress: controller,
          ),
          RaisedButton(
            child: Text("动态图标"),
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
