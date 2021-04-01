import 'dart:io';
import 'package:flutter/material.dart';
import 'package:yxkh_front/api/response_data.dart';
import 'package:yxkh_front/api/user_api.dart';
import 'package:yxkh_front/api/yxkh_api.dart';
import 'package:yxkh_front/blocs/flow_task_bloc.dart';
import 'package:yxkh_front/widget/flow_stepper.dart';
import 'package:yxkh_front/widget/icon_button_countdown.dart';
import 'package:yxkh_front/widget/table.dart';
import '../../app.dart';
import '../../apply_router.dart';
import '../widget/search_task_widget.dart';

class MyTaskPageWidget extends StatefulWidget {
  final FlowTaskBlocImpl bloc;
  MyTaskPageWidget({Key key, this.bloc})
      : assert(bloc != null),
        super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MyTaskPageWidgetState();
  }
}

class _MyTaskPageWidgetState extends State<MyTaskPageWidget> {
  FlowTaskBlocImpl bloc;
  @override
  void initState() {
    bloc = widget.bloc;
    super.initState();
  }

  List<Widget> _actions(BuildContext context) {
    return <Widget>[
      IconButtonCountDown(
        icon: Icon(Icons.refresh),
        iconSize: 50,
        color: Colors.blue,
        tooltip: "刷新",
        onPressed: () {
          bloc.onSearchTask(bloc.params);
        },
      ),
      IconButton(
        icon: Icon(Icons.search),
        iconSize: 50,
        color: Colors.blue,
        tooltip: "搜索",
        onPressed: () {
          var params = bloc.params;
          App.showAlertDialog(context, Text("搜索"), SearchTaskWidget(params: params), callback: () {
            // print("params:$params");
            bloc.params = params;
            bloc.onSearchTask(bloc.params);
          });
        },
      ),
      FlatButton.icon(
          label: Text("导入群众评议"),
          icon: Icon(Icons.import_export),
          onPressed: () {
            if (App.userinfos.labels.indexWhere((l) => l.labelname.contains("考核组考核员")) == -1) {
              App.showAlertError(context, "只有考核组考核员才能导入");
              return;
            }
            YxkhAPI.importPulicAssessment();
          }),
      FlatButton.icon(
          label: Text("导入加减分"),
          icon: Icon(Icons.import_export),
          onPressed: () {
            if (App.userinfos.labels.indexWhere((l) => l.labelname.contains("考核组考核员")) == -1) {
              App.showAlertError(context, "只有考核组考核员才能导入");
              return;
            }
            YxkhAPI.importMarks(checked: "0");
          }),
      FlatButton.icon(
          label: Text("导入加减分(直接生效)"),
          icon: Icon(Icons.import_export),
          onPressed: () {
            if (App.userinfos.labels.indexWhere((l) => l.labelname.contains("考核办")) == -1) {
              App.showAlertError(context, "只有考核办才能导入");
              return;
            }
            YxkhAPI.importMarks(checked: "1");
          })
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<List<dynamic>>(
        stream: bloc.taskStream,
        builder: (context, snapshot) {
          // print("task:${snapshot.data}");
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data.isEmpty) {
            return Center(
                child: Row(
              children: _actions(context),
            ));
          }
          return Scrollbar(
            child: ResponsiveTable(
              datas: snapshot.data,
              header: Row(
                children: _actions(context),
              ),
              // rowActions: ,
              actions: <Widget>[],
              operation: (value) {
                return PopupMenuButton(
                  tooltip: "点击操作",
                  onSelected: (val) {
                    switch (val) {
                      case "审批":
                        Process p = Process.fromJson(value);
                        bloc.lookupProcess(context, p);
                        break;
                      case "进度":
                        bloc.lookupFlowStepper(context, value["processInstanceId"]);
                        // UserAPI.getFlowStepper(value["processInstanceId"]).then((data) {
                        //   if (data["status"] != 200) {
                        //     App.showAlertError(context, data["message"]);
                        //     return;
                        //   }
                        //   var datas = ResponseData.fromResponse(data);
                        //   App.showAlertDialog(
                        //       context,
                        //       Text("进度"),
                        //       FlowStepperWidget(
                        //         data: datas[0],
                        //       ));
                        // });
                        break;
                      default:
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: "审批",
                      child: ListTile(
                        leading: Icon(Icons.remove_red_eye),
                        title: Text("审批"),
                      ),
                    ),
                    PopupMenuItem(
                      value: "进度",
                      child: ListTile(
                        leading: Icon(Icons.refresh),
                        title: Text("进度"),
                      ),
                    ),
                  ],
                );
              },
              columns: <ColumnData>[
                // ColumnData("序号","index"),
                ColumnData("标题", "title"),
                ColumnData("申请人", "username"),
                ColumnData("类型", "businessType"),
                ColumnData("部门", "deptName"),
                ColumnData("审批人", "candidate"),
                ColumnData("状态", "completed"),
                ColumnData("步骤", "step"),
                ColumnData("日期", "requestedDate"),
              ],
            ),
          );
        },
      ),
    );
  }
}
