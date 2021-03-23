import 'package:flutter/material.dart';

class ErrorPageWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ErrorPageWidgetState();
  }

}
class _ErrorPageWidgetState extends State<ErrorPageWidget>{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("404"),
    );
  }
  
}