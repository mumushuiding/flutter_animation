import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class FlowLogCard extends StatelessWidget {
  final List<dynamic> datas;
  final double width;
  final double height;
  final double elevation;
  FlowLogCard({@required this.datas, this.elevation, this.width, this.height});
  @override
  Widget build(BuildContext context) {
    List<Widget> children = List();
    children.add(Container(
      alignment: Alignment.centerLeft,
      child: Text(
        "审批纪录",
        style: TextStyle(fontSize: 18, color: Color(0xFF18233C)),
      ),
    ));
    children.add(Container(
      color: Color(0xFFE8EAEC),
      padding: EdgeInsets.only(top: 5),
      width: width,
      height: 1,
    ));
    children.add(SizedBox(
      height: 10,
      width: width,
    ));
    for (var i = 0; i < datas.length; i++) {
      children.add(_buildItem(datas[i]));
    }
    return Card(
      elevation: elevation,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(10),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildItem(dynamic item) {
    var datetime = DateTime.fromMillisecondsSinceEpoch(int.parse("${item["opTime"]}000"));
    return Container(
      child: Row(
        children: <Widget>[
          Text("${item["username"]}:", style: TextStyle(color: Color(0xFFB2B2B2))),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Text("${item["speech"] ?? ''}"),
            ),
          ),
          Text(
            "${datetime.toString().substring(0, 16)}",
            style: TextStyle(color: Color(0xFFB2B2B2)),
          )
        ],
      ),
    );
  }
}
