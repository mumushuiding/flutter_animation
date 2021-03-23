import 'dart:async';

import 'package:flutter/material.dart';

class IconButtonCountDown extends StatefulWidget {
  final int seconds;
  final onPressed;
  // icon 可以为Text
  final Widget icon;
  final double iconSize;
  final double width;
  final double elevation;
  final Color color;
  final String tooltip;
  IconButtonCountDown(
      {Key key,
      this.seconds,
      this.onPressed,
      this.icon,
      this.color,
      this.iconSize,
      this.tooltip,
      this.width,
      this.elevation})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _IconButtonCountDownState();
  }
}

class _IconButtonCountDownState extends State<IconButtonCountDown> {
  int _seconds;
  Timer _timer;
  Widget _icon;
  bool pressed = false;
  Function _onPressed;

  @override
  void initState() {
    super.initState();
    _icon = widget.icon;
    if (_icon == null) Text("确定");
    setSeconds();
    _onPressed = widget.onPressed;
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  void setSeconds() {
    _seconds = widget.seconds;
    if (_seconds == null) _seconds = 3;
  }

  Function onPressed() {
    if (pressed) {
      return () {};
    }
    return () {
      if (_timer != null) return;
      _startTimer();
      widget.onPressed?.call();
    }();
  }

  void _startTimer() {
    _onPressed = null;
    pressed = true;
    setState(() {});
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // print(_seconds.toString());
      _icon = Icon(Icons.cancel);
      if (_seconds <= 0) {
        pressed = false;
        _cancelTimer();
        _onPressed = widget.onPressed;
        setSeconds();
        _icon = widget.icon;
        if (_icon == null) {
          // _icon=Text('确定');
        }
        setState(() {});
        return;
      }
      setState(() {});
      _seconds--;
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _icon,
      color: widget.color,
      iconSize: widget.iconSize,
      disabledColor: Colors.grey,
      tooltip: widget.tooltip,
      onPressed: onPressed,
    );
  }
}
