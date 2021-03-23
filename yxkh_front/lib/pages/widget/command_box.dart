import 'package:flutter/material.dart';
import 'package:yxkh_front/api/response_data.dart';
import 'package:yxkh_front/api/yxkh_api.dart';
import 'package:yxkh_front/app.dart';
import 'package:yxkh_front/blocs/flow_task_bloc.dart';
import 'package:yxkh_front/widget/button_countdown.dart';
import 'package:yxkh_front/widget/flow_stepper.dart';

class CommandBoxWidget extends StatefulWidget {
  final FlowTaskBlocImpl taskbloc;
  // create 是否是新建任务
  final bool create;
  // step 当前步骤
  final int step;
  // data 流程数据
  // final Map<String, dynamic> data;
  final FlowData data;
  // templateid 模板id
  final String templateid;
  // title 流程名称
  final String title;
  // businessType 流程类型
  final String businessType;
  CommandBoxWidget(this.taskbloc, this.create, this.step, this.data, this.templateid, this.title, this.businessType)
      : assert(taskbloc != null);
  @override
  State<StatefulWidget> createState() {
    return _CommandBoxWidgetState();
  }
}

class _CommandBoxWidgetState extends State<CommandBoxWidget> {
  FlowTaskBlocImpl taskbloc;
  bool commit = false;
  @override
  void initState() {
    super.initState();
    taskbloc = widget.taskbloc;
  }

  void hasCommit() {
    if (commit) return;
    commit = true;
    Future.delayed(Duration(seconds: 3), () {
      commit = false;
    });
  }

  void _startProcess(int perform, String templateid) {
    hasCommit();
    YxkhAPI.startProcess(widget.data.toJson(), widget.title, templateid, widget.businessType, perform: perform)
        .then((data) {
      // print(data);
      if (data["status"] == 200) {
        var datas = ResponseData.fromResponse(data);
        taskbloc?.onAddTask(datas[1]);
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

  void _completeProcess(int perform) {
    hasCommit();
    // e.startDate = e.startDate.substring(0, 10);
    // e.endDate = e.endDate.substring(0, 10);
    YxkhAPI.completeProcess(widget.data.toJson(), widget.businessType, perform).then((data) {
      if (data["status"] != 200) {
        App.showAlertError(context, data['message']);
        return;
      }
      var datas = ResponseData.fromResponse(data);
      taskbloc?.onCompleteTask(datas[0], datas[1], delete: !_isMyTask(datas[0]));
      Navigator.of(context).pop();
    });
  }

  bool _isMyTask(dynamic process) {
    String userid = App.userinfos.user.userid;
    if (process["userId"] == userid) {
      return true;
    }
    if (process["candidate"] == null) {
      return false;
    }
    List<String> cs = process["candidate"].split(",");
    return cs.contains(userid);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: widget.create
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonCountDown(
                  color: Colors.green,
                  child: Text("提交"),
                  onPressed: widget.step == 0
                      ? () {
                          _startProcess(0, widget.templateid);
                        }
                      : null,
                ),
                ButtonCountDown(
                  color: Colors.blue,
                  child: Text("保存"),
                  onPressed: widget.step == 0
                      ? () {
                          _startProcess(1, widget.templateid);
                        }
                      : null,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonCountDown(
                  child: widget.step != 0 ? Text("审批") : Text("提交"),
                  color: Colors.green,
                  onPressed: () {
                    _completeProcess(2);
                  },
                ),
                ButtonCountDown(
                  child: Text("撤回"),
                  color: Colors.blue,
                  onPressed: widget.step != 0
                      ? () {
                          _completeProcess(5);
                        }
                      : null,
                ),
                ButtonCountDown(
                  color: Colors.grey,
                  child: Text("驳回"),
                  onPressed: widget.step != 0
                      ? () {
                          _completeProcess(3);
                        }
                      : null,
                )
              ],
            ),
    );
  }
}
