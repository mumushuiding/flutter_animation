import 'package:flutter/material.dart';
import 'package:yxkh_front/api/yxkh_api.dart';
import 'package:yxkh_front/app.dart';
import 'package:yxkh_front/pages/apply/myApply/AddMarksWidget.dart';
import 'package:yxkh_front/pages/apply/myApply/DelMarksSubmitOverTime.dart';
import 'package:yxkh_front/pages/apply/DutyFormWidget.dart';
import 'package:yxkh_front/pages/apply/ExemptionFromAssessment.dart';
import 'package:yxkh_front/pages/apply/addmonth.dart';
import 'package:yxkh_front/pages/apply/year_form_widget.dart';

import 'api/user_api.dart';
import 'blocs/flow_task_bloc.dart';

List<ApplyHandler> applyRouter = <ApplyHandler>[
  ApplyHandler(
    title: "月度考核",
    handler: ({bloc, buinessType, process, e}) => AddMonth(
      taskbloc: bloc,
      process: process,
      evaluation: e,
    ),
  ),
  ApplyHandler(
    title: "半年考核",
    handler: ({bloc, buinessType, process, e}) => YearFormWidget(
      bloc: bloc,
      buinessType: buinessType,
      process: process,
      e: e,
    ),
  ),
  ApplyHandler(
    title: "年度考核",
    handler: ({bloc, buinessType, process, e}) => YearFormWidget(
      bloc: bloc,
      buinessType: buinessType,
      process: process,
      e: e,
    ),
  ),
  ApplyHandler(
    title: "责任清单",
    handler: ({bloc, buinessType, process, e}) => DutyFormWidget(
      bloc: bloc,
      buinessType: buinessType,
      process: process,
      e: e ?? Evaluation(),
      templateid: "90148cf9b65e0858ff223c7476271dd2_1589533840",
    ),
  ),
  ApplyHandler(
      title: "用户不考核设置",
      showInDialogue: true,
      handler: ({bloc, buinessType, process, e}) => ExemptionFromAssessment(
            bloc: bloc,
            buinessType: buinessType,
            process: process,
          )),
  ApplyHandler(
    title: "删除超时扣分",
    showInDialogue: true,
    handler: ({bloc, buinessType, e, process}) =>
        DelMarksSubmitOverTime(bloc: bloc, buinessType: "DelMarksSubmitOverTime", process: process),
  ),
  ApplyHandler(
    title: "添加加减分",
    showInDialogue: true,
    handler: ({bloc, buinessType, e, process}) => AddMarksWidget(bloc: bloc, buinessType: "AddMarks", process: process),
  )
];

class ApplyHandler {
  Function({FlowTaskBlocImpl bloc, String buinessType, Process process, Evaluation e}) handler;
  String route;
  IconData icon;
  // 为true时弹出对话框，为false时跳转页面
  bool showInDialogue;
  String title;
  ApplyHandler({this.handler, this.icon, this.title, this.route, this.showInDialogue = false});
  static void applyRoute(BuildContext context, String buinessType, FlowTaskBlocImpl bloc,
      {Evaluation e, Process process}) {
    if (process == null) {
      process = Process(buinessType, buinessType);
      process.deptName = App.userinfos.user.departmentname;
      process.businessType = buinessType;
      process.step = 0;
      process.uid = App.userinfos.user.id;
      process.userId = App.userinfos.user.userid;
      process.username = App.userinfos.user.name;
      process.candidate = App.userinfos.user.userid;
    }
    ApplyHandler ah = applyRouter.singleWhere((r) => r.title == buinessType);
    if (ah.showInDialogue) {
      App.showAlertDialog(
          context, Text(buinessType), ah.handler(bloc: bloc, buinessType: buinessType, process: process, e: e));
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return ah.handler(bloc: bloc, buinessType: buinessType, process: process, e: e);
      },
    ));
  }
}
