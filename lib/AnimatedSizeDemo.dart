import 'package:flutter/material.dart';

class AnimatedSizeDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AnimatedSizeDemoState();
  }
}

class _AnimatedSizeDemoState extends State<AnimatedSizeDemo> with SingleTickerProviderStateMixin {
  double height = 100;
  double width = 100;
  var color = Colors.red;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AnimatedSize(
          vsync: this,
          duration: Duration(seconds: 2),
          child: Container(
            height: height,
            width: width,
            color: color,
          ),
        ),
        RaisedButton(
          child: Text("改变容器大小"),
          onPressed: () {
            height = height == 100 ? 200 : 100;
            width = width == 100 ? 200 : 100;
            color = color == Colors.red ? Colors.green : Colors.red;
            setState(() {});
          },
        ),
      ],
    );
  }
}
