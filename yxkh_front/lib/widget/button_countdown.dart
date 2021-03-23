import 'dart:async';

import 'package:flutter/material.dart';

class ButtonCountDown extends StatefulWidget{
  final int seconds;
  final onPressed;
  // child 可以为Text
  final Widget child;
  final double width;
  final double elevation;
  final Color color;
  ButtonCountDown({Key key,this.seconds,this.onPressed,this.child,
    this.color,
    this.width,this.elevation}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return _ButtonCountDownState();
  }

}
class _ButtonCountDownState extends State<ButtonCountDown>{
  int _seconds;
  Timer _timer;
  double _width;
  Widget _child;
  bool pressed;
  Function _onPressed;

  @override void initState(){
    super.initState();
    _width=widget.width;
    _child=widget.child;
    if (_child==null) Text("确定");
    setSeconds();
    _onPressed=widget.onPressed;
  }
  @override void dispose(){
    _cancelTimer();
    super.dispose();
  }
  void setSeconds(){
    _seconds=widget.seconds;
    if (_seconds==null) _seconds=3;
  }
  Function onPressed(){
    // print("ButtonCountDown onPressed");
    return (){
      if (_timer!=null)return;
      _startTimer();
      widget.onPressed?.call();
    }();
  }
  void _startTimer(){
    // print("ButtonCountDown _startTimer");
    _onPressed=null;
    pressed=true;
    _child=Text(_seconds.toString());
    setState(() {});
    _timer=Timer.periodic(Duration(seconds: 1),(timer){
      _child=Text(_seconds.toString());
      if (_seconds<=0){
        pressed=false;
        _cancelTimer();
        _onPressed=widget.onPressed;
        setSeconds();
        _child=widget.child;
        if (_child==null){
          _child=Text('确定');
        }
        setState(() {});
        return;
      }
      setState(() {});
      _seconds--;
    });
    
  }
  void _cancelTimer(){
    _timer?.cancel();
    _timer=null;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        disabledTextColor: Colors.grey[800],
        color: widget.color,
        child: _child,
        disabledColor: Colors.grey,
        minWidth: _width,
        elevation: widget.elevation,
        disabledElevation: 0,
        onPressed: onPressed,
    );
  }
  
}