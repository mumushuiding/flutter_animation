import 'package:flutter/material.dart';
import 'package:yxkh_front/widget/select.dart';
import 'package:yxkh_front/widget/tree_select.dart';

import '../../app.dart';

class SearchApplyWidget extends StatelessWidget {
  final Map<String, dynamic> params;
  final List<dynamic> departments;
  SearchApplyWidget({this.params, this.departments}) : assert(departments != null);
  @override
  Widget build(BuildContext context) {
    var par = params ?? Map();
    TextEditingController tec = TextEditingController(text: par["userId"] != null ? "我的申请" : "所有申请");
    TextEditingController dept = TextEditingController(text: par["deptName"] ?? "");
    TextEditingController titleLike = TextEditingController(text: par["titleLike"] ?? "");
    return Container(
      width: 400,
      height: 400,
      child: Column(
        children: <Widget>[
          Select(
            textEditingController: tec,
            items: [
              {"key": "我的申请", "value": "我的申请"},
              {"key": "所有申请", "value": "所有申请"}
            ],
            onChange: (keys, vals) {
              tec.text = vals;
              if (keys == "我的申请") {
                par["userId"] = App.userinfos.user.userid;
              } else {
                par["userId"] = null;
              }
            },
            hintText: "选择“我的申请”或者“所有申请”",
            valueTag: "value",
            keyTag: "key",
          ),
          // 部门查询
          TreeSelect(
            datas: departments,
            onChange: (ids, text) {
              // print("ids:$ids,text:$text");
              params["deptName"] = "${text.join(",")}";
              dept.text = "${text.join(",")}";
            },
            hintText: "选择部门",
            textEditingController: dept,
            valueTag: "name",
            keyTag: "id",
            multiple: true,
            initValue: params["deptName"] == null ? [] : params["deptName"].split(","),
          ),
          // 标题查询
          TextField(
            maxLines: 1,
            controller: titleLike,
            onChanged: (val) {
              par["titleLike"] = val;
            },
            decoration: InputDecoration(contentPadding: EdgeInsets.all(10.0), hintText: "填写申请标题"),
          ),
        ],
      ),
    );
  }
}
