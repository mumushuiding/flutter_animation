import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:yxkh_front/api/response_data.dart';
import 'package:yxkh_front/api/user_api.dart';
import 'package:yxkh_front/api/yxkh_api.dart';
import 'package:yxkh_front/blocs/flow_task_bloc.dart';
import 'package:yxkh_front/theme.dart';
import 'package:yxkh_front/utils/screenUtil.dart';
import 'package:yxkh_front/widget/flow_stepper.dart';

import '../../app.dart';

class ExemptionFromAssessment extends StatefulWidget {
  final FlowTaskBlocImpl bloc;
  final String buinessType;
  final Process process;
  ExemptionFromAssessment({this.bloc, this.buinessType, this.process});
  @override
  State<StatefulWidget> createState() {
    return _ExemptionFromAssessmentState();
  }
}

class _ExemptionFromAssessmentState extends State<ExemptionFromAssessment> {
  double width = 300;
  double height = 325;
  String users;
  String reason;
  final _formKey = GlobalKey<FormState>();
  Widget message;
  @override
  void initState() {
    message = Padding(
      padding: EdgeInsets.only(bottom: 20),
    );
    super.initState();
  }

  void _onSubmit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
    }
  }

  void _startProcess(dynamic destinationUser) {
    var ds = {
      "destinationUser": destinationUser,
      "reason": "${destinationUser["departmentname"]}-${destinationUser["name"]}设置为不考核\n原因：$reason"
    };
    YxkhAPI.startProcess(ds, "${destinationUser["name"]}-不考核设置", "002d5df2a737dd36a2e78314b07d0bb1_1591669930", "不考核设置")
        .then((data) {
      if (data["status"] == 200) {
        var datas = ResponseData.fromResponse(data);
        widget.bloc?.onAddTask(datas[1]);

        App.showAlertDialog(
            context,
            Text("审批进度"),
            FlowStepperWidget(
              data: datas[0],
            ), callback: () {
          Navigator.of(context).pop();
        });
      } else {
        App.showAlertError(context, data["message"]);
      }
    });
  }

  Widget buildTextForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 5),
              child: TextFormField(
                decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: "请输入姓名",
                    hintStyle: TextStyle(fontSize: 14),
                    contentPadding: EdgeInsets.all(0)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "请输入姓名";
                  }
                  // 判断用户是否存在或者重名
                  var vals = value.split(",");
                  StringBuffer stringBuffer = StringBuffer();
                  vals.forEach((s) {
                    stringBuffer.write(",'$s'");
                  });
                  String metrics = "id,userid,name,mobile,departmentname";
                  String where = "name in (${stringBuffer.toString().substring(1)})";
                  UserAPI.getAllUsers(where, metric: metrics).then((data) {
                    if (data["status"] != 200) {
                      message = Text(
                        "${data["message"]}",
                        style: TextStyle(color: Colors.red),
                      );
                      setState(() {});
                      return null;
                    }
                    var rd = ResponseData.fromResponse(data);
                    List<dynamic> datas = rd[0];
                    if (datas.length == 0) {
                      message = Text(
                        "用户不存在",
                        style: TextStyle(color: Colors.red),
                      );
                      setState(() {});
                      return null;
                    }
                    if (datas.length > 1) {
                      setState(() {});
                      message = Card(
                        elevation: 0,
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(bottom: 5),
                              alignment: Alignment.centerLeft,
                              child: Text("存在重名,选择一个"),
                            ),
                            Container(
                              height: 150,
                              child: ListView.builder(
                                itemCount: datas.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(datas[index]["name"]),
                                    subtitle: Text("${datas[index]["departmentname"]},${datas[index]["mobile"]}"),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        print(datas[index]["name"]);
                                        // 启动流程
                                        _startProcess(datas[index]);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                      return null;
                    }
                    _startProcess(datas[0]);
                  });
                  return null;
                },
                onSaved: (newValue) => users = newValue,
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 5),
              child: TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.account_balance_wallet),
                  hintText: "请输入原因",
                  hintStyle: TextStyle(fontSize: 14),
                ),
                validator: (value) => (value == null || value.isEmpty) ? "不能为空" : null,
                onSaved: (newValue) => reason = newValue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: width,
        height: height,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), color: Colors.white),
              width: 300,
              height: 150,
              child: buildTextForm(),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 10, top: 5, bottom: 5),
              child: message,
            ),
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
      ),
    );
  }
}
