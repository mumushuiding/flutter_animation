import 'package:flutter/material.dart';

class AnimatedCrossFadeDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AnimatedCrossFadeDemoState();
  }
}

class _AnimatedCrossFadeDemoState extends State<AnimatedCrossFadeDemo> {
  bool _first = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      child: Column(
        children: <Widget>[
          AnimatedCrossFade(
              duration: const Duration(seconds: 1),
              firstChild: FlutterLogo(
                style: FlutterLogoStyle.horizontal,
                size: 100.0,
              ),
              secondChild: FlutterLogo(
                style: FlutterLogoStyle.stacked,
                size: 100,
              ),
              crossFadeState: _first ? CrossFadeState.showFirst : CrossFadeState.showSecond),
          RaisedButton(
            child: Text("AnimatedCrossFade 内容切换"),
            onPressed: () {
              _first = !_first;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
