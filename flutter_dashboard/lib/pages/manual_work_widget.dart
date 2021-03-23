import 'package:flutter/material.dart';

class ManualWorkWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ManualWorkWidgetState();
  }

}
class _ManualWorkWidgetState extends State<ManualWorkWidget>{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("日常一线考核工作手册"),
    );
  }
  
}