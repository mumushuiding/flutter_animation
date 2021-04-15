import 'package:flutter/material.dart';
import 'package:yxkh_front/api/response_data.dart';
import 'package:yxkh_front/api/user_api.dart';
import 'package:yxkh_front/api/yxkh_api.dart';
import 'package:yxkh_front/blocs/flow_task_bloc.dart';
import 'package:yxkh_front/widget/select.dart';

import '../../../app.dart';
import '../../../theme.dart';

class DelMarksSubmitOverTime extends StatefulWidget {
  final FlowTaskBlocImpl bloc;
  final String buinessType;
  final Process process;
  DelMarksSubmitOverTime({this.bloc, this.buinessType, this.process});
  @override
  State<StatefulWidget> createState() {
    return _DelMarksSubmitOverTimeState();
  }
}

class _DelMarksSubmitOverTimeState extends State<DelMarksSubmitOverTime> {
  List<Map<String, dynamic>> datas;
  int projectId;
  String date;
  String reason;
  bool committed = false;
  @override
  void initState() {
    this.getDatas();
    super.initState();
  }

  // 获取半年内超时扣分
  void getDatas() {
    var uid = App.userinfos.user.id;
    if (uid == null || uid == 0) {
      App.showAlertError(context, "用户id为空，请重新登陆");
      return;
    }
    YxkhAPI.findMarkDelaySubmit(uid).then((d) {
      var ds = ResponseData.fromResponseByContext(context, d)[0];
      if (ds.length == 0) {
        return;
      }
      datas = [];
      ds.forEach((d) {
        datas.add({"val": d["startDate"].substring(0, 7), "key": d["projectId"]});
      });
      setState(() {});
    });
  }

  void _startProcess() {
    if (projectId == null) {
      App.showAlertError(context, "不能为空");
      return;
    }
    if (committed) {
      return;
    }
    committed = true;
    Future.delayed(Duration(seconds: 5), () => committed = false);
    var ds = {
      "projectId": projectId,
      "reason": reason,
    };
    widget.bloc.startProcess(
        context, ds, "${App.userinfos.user.name}-删除$date超时扣分", "002d5df2a737dd36a2e78314b07d0bb1_1591669930", "删除超时扣分");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 200,
      child: Column(
        children: <Widget>[
          datas != null
              ? Select(
                  items: datas,
                  keyTag: "key",
                  valueTag: "val",
                  inputDecoration: InputDecoration(prefixIcon: Icon(Icons.calendar_today), hintText: "点击选择月份"),
                  onChange: (keys, vals) {
                    projectId = keys;
                    date = vals;
                  },
                )
              : Container(
                  child: Text("近期无超时扣分"),
                ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 5, top: 10, bottom: 5),
              child: TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.assignment_late),
                  hintText: "请输入原因",
                  hintStyle: TextStyle(fontSize: 16),
                ),
                validator: (value) => (value == null || value.isEmpty) ? "不能为空" : null,
                onSaved: (newValue) => reason = newValue,
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(top: 30),
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
            onTap: () => _startProcess(),
          ),
        ],
      ),
    );
  }
}
