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

class MyTaskPageWidget extends StatelessWidget {
  final FlowTaskBlocImpl bloc;
  MyTaskPageWidget({Key key, this.bloc})
      : assert(bloc != null),
        super(key: key);
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
            YxkhAPI.importMarks();
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
                        if (value["businessType"] == "月度考核" ||
                            value["businessType"] == "半年考核" ||
                            value["businessType"] == "年度考核" ||
                            value["businessType"] == "责任清单") {
                          YxkhAPI.findFlowDatas(value["processInstanceId"], value["businessType"]).then((data) {
                            if (data["status"] != 200) {
                              App.showAlertError(context, data["message"]);
                              return;
                            }
                            var datas = ResponseData.fromResponse(data);
                            if (datas[0] == null) {
                              App.showAlertError(context, "内容不存在");
                              return;
                            }
                            ApplyHandler.applyRoute(
                              context,
                              value["businessType"],
                              bloc,
                              e: Evaluation.fromJson(datas[0]),
                              process: Process.fromJson(value),
                            );
                          });
                        }

                        break;
                      case "进度":
                        UserAPI.getFlowStepper(value["processInstanceId"]).then((data) {
                          if (data["status"] != 200) {
                            App.showAlertError(context, data["message"]);
                            return;
                          }
                          var datas = ResponseData.fromResponse(data);
                          App.showAlertDialog(
                              context,
                              Text("进度"),
                              FlowStepperWidget(
                                data: datas[0],
                              ));
                        });
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
