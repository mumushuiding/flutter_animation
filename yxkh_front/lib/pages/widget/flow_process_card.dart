import 'package:flutter/material.dart';

class FlowProcessCard extends StatelessWidget {
  final List<dynamic> datas;
  final double elevation;
  final double width;
  final double height;
  FlowProcessCard({@required this.datas, this.elevation, this.width, this.height});
  // _buildFlowProcess 审批流程样式
  Widget _buildFlowProcess() {
    List<Widget> children = List();
    children.add(Container(
      alignment: Alignment.centerLeft,
      child: Text(
        "审批流程",
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
      children.add(_buildFlowItem(datas[i], i));
    }
    return Card(
        elevation: elevation,
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.all(10),
          child: Column(children: children),
        ));
  }

  Widget _buildFlowItem(dynamic items, int index) {
    StringBuffer userBuffer = StringBuffer();
    bool completed = false;
    items.forEach((item) {
      userBuffer.write(",${item["itemName"]}");
      if (item["ItemStatus"] != 0) {
        completed = true;
      }
    });
    double _height = 50;

    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 25,
            height: _height,
            // color: Colors.grey,
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: 1,
                      top: index == 0 ? _height / 2 : 0,
                      bottom: index == (datas.length - 1) ? _height / 2 : 0),
                  child: Container(
                    height: _height,
                    width: 1.5,
                    color: completed ? Colors.green : Colors.grey,
                  ),
                ),
                ClipOval(
                    child: Container(
                  color: completed ? Colors.green : Colors.grey,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5),
          ),
          ClipOval(
            child: Container(
              height: _height - 10,
              width: _height - 10,
              child: Image.network(
                items[0]["ItemImage"],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5),
          ),
          Container(
            child: Text("${userBuffer.toString().substring(1)}"),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5),
          ),
          Container(
            alignment: Alignment.center,
            child: Text("•"),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Text(completed ? "已审批" : "未审批"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildFlowProcess();
  }
}
