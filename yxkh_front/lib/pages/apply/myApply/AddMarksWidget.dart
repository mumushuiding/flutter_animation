import 'package:flutter/material.dart';
import 'package:yxkh_front/api/response_data.dart';
import 'package:yxkh_front/api/user_api.dart';
import 'package:yxkh_front/api/yxkh_api.dart';
import 'package:yxkh_front/blocs/flow_task_bloc.dart';
import 'package:yxkh_front/theme.dart';

import '../../../app.dart';

class AddMarksWidget extends StatefulWidget {
  final FlowTaskBlocImpl bloc;
  final String buinessType;
  final Process process;
  AddMarksWidget({this.bloc, this.buinessType, this.process});
  @override
  State<StatefulWidget> createState() {
    return _AddMarksWidgetState();
  }
}

class _AddMarksWidgetState extends State<AddMarksWidget> {
  List<Mark> datas = List();
  double dataHeight = 50;
  double boxHeight = 137;
  String startDate = "";
  String endDate = "";
  final TextStyle hintStyle = TextStyle(fontSize: 12);
  final TextStyle textStyle = TextStyle(fontSize: 12);
  bool committed = false;
  @override
  void initState() {
    getDate();
    super.initState();
  }

  void getDate() {
    var now = DateTime.now();
    var m = now.month - 1;
    var y = now.year;
    if (m == 0) {
      y--;
      m = 12;
    }
    var mstr = m > 9 ? "$m" : "0$m";
    startDate = "$y-$mstr-01";
    endDate = "$y-$mstr-28";
  }

  Widget _buildItem(Mark m) {
    TextEditingController start = TextEditingController(text: startDate);
    TextEditingController end = TextEditingController(text: endDate);
    TextEditingController username = TextEditingController(text: m.username);
    TextEditingController markReason = TextEditingController(text: m.markReason);
    TextEditingController accordingly = TextEditingController(text: m.accordingly);
    TextEditingController markNumber = TextEditingController(text: m.markNumber);
    m.startDate = startDate;
    m.endDate = endDate;
    return Container(
      height: 50,
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey))),
              child: IconButton(
                icon: Icon(Icons.delete_forever),
                onPressed: () {
                  datas.removeWhere((d) => (d.userId == m.userId) && (d.markReason == m.markReason));
                  dataHeight -= 50.0;
                  setState(() {});
                },
              ),
            ),
          ),
          // 开始日期
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey))),
              child: TextField(
                style: textStyle,
                decoration: InputDecoration(hintText: "输入开始日期", hintStyle: hintStyle),
                controller: start,
                onEditingComplete: () {
                  m.startDate = start.text;
                },
              ),
            ),
          ),
          // 结束日期
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey))),
              child: TextField(
                style: textStyle,
                decoration: InputDecoration(hintText: "输入结束日期", hintStyle: hintStyle),
                controller: end,
                onEditingComplete: () {
                  m.endDate = end.text;
                },
              ),
            ),
          ),
          // 姓名或电话
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey))),
              child: TextField(
                controller: username,
                decoration: InputDecoration(hintText: "姓名或电话", hintStyle: hintStyle),
                style: textStyle,
                onEditingComplete: () {
                  if (username.text == null || username.text.isEmpty) {
                    return;
                  }
                  String metrics = "id,userid,name";
                  String where = "name in ('${username.text}') or mobile in ('${username.text}')";
                  UserAPI.getAllUsers(where, metric: metrics).then((data) {
                    if (data["status"] != 200) {
                      App.showAlertError(context, data["message"]);
                      return "";
                    }
                    var rd = ResponseData.fromResponse(data);
                    List<dynamic> datas = rd[0];
                    if (datas.length == 0) {
                      App.showAlertError(context, "用户不存在");
                      return "";
                    }
                    if (datas.length > 1) {
                      App.showAlertError(context, "存在重名,请输入电话");
                      return "";
                    }
                    m.userId = datas[0]["id"];
                    m.username = datas[0]["name"];
                    return "";
                  });
                },
              ),
            ),
          ),
          // 加分原因
          Expanded(
            flex: 5,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey))),
              child: TextField(
                style: textStyle,
                decoration: InputDecoration(hintText: "加分原因", hintStyle: hintStyle),
                controller: markReason,
                onEditingComplete: () {
                  m.markReason = markReason.text;
                },
              ),
            ),
          ),
          // 加分依据
          Expanded(
            flex: 5,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey))),
              child: TextField(
                style: textStyle,
                decoration: InputDecoration(hintText: "加分依据", hintStyle: hintStyle),
                controller: accordingly,
                onEditingComplete: () {
                  m.accordingly = accordingly.text;
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey))),
              child: TextField(
                style: textStyle,
                decoration: InputDecoration(hintText: "分数", hintStyle: hintStyle),
                controller: markNumber,
                onEditingComplete: () {
                  // 数字验证
                  if (markNumber.text == "") {
                    App.showAlertError(context, "不能为空");
                    return;
                  }
                  var num = double.tryParse(markNumber.text);
                  if (num != null) {
                    m.markNumber = markNumber.text;
                  } else {
                    App.showAlertError(context, "只能输入数字");
                    return;
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSubmit() {
    YxkhAPI.addProjectWithMark(datas).then((data) {
      List<dynamic> pids = ResponseData.fromResponseByContext(context, data);
      if (committed) {
        App.showAlertError(context, "不要重复提交");
        return;
      }
      committed = true;
      Future.delayed(Duration(seconds: 5), () {
        committed = false;
      });
      if (pids.length == 0) {
        App.showAlertError(context, "未返回项目id");
        return;
      }
      var ds = {
        "datas": datas
            .map((m) => {
                  "开始": m.startDate,
                  "结束": m.endDate,
                  "姓名": m.username,
                  "分数": m.markNumber,
                  "原因": m.markReason,
                  "依据": m.accordingly
                })
            .toList(),
        "pids": pids
      };
      YxkhAPI.startProcess(
              ds, "${App.userinfos.user.name}-加减分申请", "002d5df2a737dd36a2e78314b07d0bb1_1591669930", "加减分申请")
          .then((data) {
        widget.bloc.addTask(context, data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      height: (boxHeight + dataHeight) > 500 ? 500 : (boxHeight + dataHeight),
      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
      child: Column(
        children: <Widget>[
          IconButton(
            color: Colors.green,
            icon: Icon(Icons.add_circle_outline),
            iconSize: 36,
            onPressed: () {
              Mark m = Mark(0, "0", "", "");
              datas.insert(0, m);
              dataHeight = 50 + datas.length * 50.0;
              setState(() {});
            },
          ),
          Container(
            height: 30,
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey), bottom: BorderSide(color: Colors.grey))),
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey))),
                    child: Text("操作"),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey))),
                    child: Text("开始"),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey))),
                    child: Text("结束"),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey))),
                    child: Text("姓名"),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey))),
                    child: Text("加分原因"),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey))),
                    child: Text("加分依据"),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey))),
                    child: Text("分数"),
                  ),
                ),
              ],
            ),
          ),
          Container(
              height: dataHeight > 400 ? 400 : dataHeight,
              child: SingleChildScrollView(
                child: Column(
                  children: datas.map((d) {
                    return _buildItem(d);
                  }).toList(),
                ),
              )),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 42, right: 42),
              decoration: BoxDecoration(
                gradient: DashboardTheme.primaryGradient,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Text(
                "提交",
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
            onTap: () => _onSubmit(),
          ),
        ],
      ),
    );
  }
}
