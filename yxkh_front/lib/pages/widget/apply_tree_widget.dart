import 'package:flutter/material.dart';
import 'package:yxkh_front/widget/tree_select.dart';

//流程类型选择树形结构
class ApplyTreeWidget extends StatelessWidget {
  final Function(dynamic) callback;
  final double iconSize;
  final EdgeInsets iconPadding;
  ApplyTreeWidget({Key key, this.callback, this.iconSize = 40, this.iconPadding}) : super(key: key);
  List<dynamic> getDatas() {
    return [
      {
        "name": "工作考核",
        "children": [
          {"name": "月度考核", "children": this.getTitles()},
          {"name": "半年考核"},
          {"name": "年度考核"},
          {"name": "责任清单"}
        ]
      },
      {
        "name": "我的申请",
        "children": [
          {"name": "用户不考核设置"}
        ],
      },
    ];
  }

  List<Map<String, dynamic>> getTitles() {
    int i = 0;
    List<Map<String, dynamic>> result = List();
    DateTime now = DateTime.now();
    // 每月25号可以开始填当月
    // 获取年份
    int year = now.year;
    // 获取月份
    int month = now.month;
    int day = now.day;
    if (day < 25) {
      if (month == 1) {
        month = 12;
        year--;
      } else {
        month--;
      }
    }
    result.add({"id": i, "name": "$year年$month月份-月度考核"});
    i++;
    // 可以填写半年之内的一线考核
    int num = 6;
    while (num != 0) {
      num--;
      if (month == 1) {
        month = 12;
        year--;
      } else {
        month--;
      }
      result.add({"id": i, "name": "$year年$month月份-月度考核"});
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return TreeSelect(
      datas: getDatas(),
      hintText: "选择",
      valueTag: "name",
      showIcon: true,
      icon: Icon(
        Icons.add_box,
        size: iconSize,
        color: Colors.blue,
        semanticLabel: "点击添加",
      ),
      onChange: (ids, text) {
        Navigator.of(context).pop();
        callback.call(text);
      },
    );
  }
}
