import 'package:flutter/material.dart';

// FlowInformationCard 流程基本信息
class FlowInformationCard extends StatelessWidget {
  final dynamic data;
  final double width;
  final double height;
  final double elevation;
  final TextStyle textStyle;
  final TextStyle labelTextStyle;
  FlowInformationCard(
      {@required this.data,
      this.textStyle = const TextStyle(color: Color(0xFF18233C), fontSize: 14),
      this.labelTextStyle = const TextStyle(color: Colors.grey, fontSize: 14),
      this.width,
      this.height,
      this.elevation});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      child: Container(
        width: width,
        height: height,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              child: Text(
                "基本信息",
                style: TextStyle(fontSize: 18, color: Color(0xFF18233C)),
              ),
            ),
            Container(
              color: Color(0xFFE8EAEC),
              width: width,
              height: 1,
            ),
            Container(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text(
                          "标题: ",
                          style: labelTextStyle,
                        ),
                        Text(
                          data["title"],
                          style: textStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text(
                          "申请人: ",
                          style: labelTextStyle,
                        ),
                        Text(
                          data["username"],
                          style: textStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text(
                          "申请类型: ",
                          style: labelTextStyle,
                        ),
                        Text(
                          data["businessType"],
                          style: textStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text(
                          "所在部门: ",
                          style: labelTextStyle,
                        ),
                        Text(
                          data["deptName"],
                          style: textStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text(
                          "申请日期: ",
                          style: labelTextStyle,
                        ),
                        Text(
                          data["requestedDate"],
                          style: textStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
