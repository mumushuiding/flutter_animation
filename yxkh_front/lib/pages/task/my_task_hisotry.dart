import 'package:flutter/material.dart';
import 'package:yxkh_front/api/response_data.dart';
import 'package:yxkh_front/api/user_api.dart';
import 'package:yxkh_front/app.dart';
import 'package:yxkh_front/blocs/flow_task_bloc.dart';
import 'package:yxkh_front/widget/flow_stepper.dart';
import 'package:yxkh_front/widget/icon_button_countdown.dart';
import 'package:yxkh_front/widget/table.dart';

class MyTaskHistoryPageWidget extends StatelessWidget {
  final FlowTaskBlocImpl bloc;
  MyTaskHistoryPageWidget({Key key, this.bloc})
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
          bloc.onSearchTaskHistory(bloc.paramsHistory);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<List<dynamic>>(
        stream: bloc.taskHistoryStream,
        builder: (context, spanshot) {
          if (!spanshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (spanshot.data.isEmpty) {
            return Center(
              child: Row(
                children: _actions(context),
              ),
            );
          }
          return Scrollbar(
            child: ResponsiveTable(
              datas: spanshot.data,
              header: Row(
                children: _actions(context),
              ),
              actions: <Widget>[],
              columns: <ColumnData>[
                // ColumnData("序号","index"),
                ColumnData("标题", "processname"),
                ColumnData("审批人", "username"),
                ColumnData("审批状态", "status", formatter: (val) {
                  String result;
                  // 1-审批中；2-已通过；3-已驳回;5-撤消
                  switch (val) {
                    case 1:
                      result = "审批中";
                      break;
                    case 2:
                      result = "已通过";
                      break;
                    case 3:
                      result = "已驳回";
                      break;
                    case 5:
                      result = "撤消";
                      break;
                    default:
                  }
                  return result;
                }),
                ColumnData("审批时间", "opTime", formatter: (val) {
                  var datetime = DateTime.fromMillisecondsSinceEpoch(int.parse("${val}000"));
                  return datetime.toString();
                }),
              ],
              operation: (value) {
                return PopupMenuButton(
                  tooltip: "点击操作",
                  onSelected: (val) {
                    switch (val) {
                      case "撤回":
                        UserAPI.completeFlowTask(value["thirdNo"], value["businessType"], 5).then((data) {
                          if (data["status"] != 200) {
                            App.showAlertError(context, data['message']);
                            return;
                          }
                          var datas = ResponseData.fromResponse(data);
                          bloc?.onAddTaskHistory(datas[0], value);
                        });
                        break;
                      case "进度":
                        UserAPI.getFlowStepper(value["thirdNo"]).then((data) {
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
                      value: "撤回",
                      child: ListTile(
                        leading: Icon(Icons.close),
                        title: Text("撤回"),
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
            ),
          );
        },
      ),
    );
  }
}
