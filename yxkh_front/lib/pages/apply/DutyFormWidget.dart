import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:yxkh_front/api/user_api.dart';
import 'package:yxkh_front/api/yxkh_api.dart';
import 'package:yxkh_front/blocs/flow_task_bloc.dart';
import 'package:yxkh_front/pages/widget/command_box.dart';

import '../../app.dart';
import '../../theme.dart';

// 责任清单
class DutyFormWidget extends StatelessWidget {
  final FlowTaskBlocImpl bloc;
  final String buinessType;
  final Process process;
  // 申请表数据
  final Evaluation e;
  // 流程模板templateid
  final String templateid;
  DutyFormWidget({Key key, this.bloc, this.buinessType, this.process, this.e, this.templateid})
      : assert(templateid != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    User u;
    int year = DateTime.now().year;
    if (process.processInstanceId == null) {
      u = App.userinfos.user;
      e.position = u.position;
      e.uid = u.id;
      e.sparation = "$year年-${process.businessType}";
      e.startDate = "$year-01-01";
      e.endDate = "$year-12-31";
      e.username = u.name;
      process.title = u.name + "-" + e.sparation;
    } else {
      u = User();
      u.id = process.uid;
      u.userid = process.userId;
      u.name = process.username;
      u.departmentname = process.deptName;
    }
    // 岗位职责
    TextEditingController dutylist = TextEditingController(text: "${e.shortComesAndPlan ?? ""}");
    // 年度任务安排
    TextEditingController selfEvaluation = TextEditingController(text: "${e.selfEvaluation ?? ""}");
    return Scaffold(
      appBar: AppBar(
        title: Text("${process.title}"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  height: 100,
                  alignment: Alignment.center,
                  decoration: DashboardTheme.allBoxDecoration,
                  child: Text(
                    "日常工作一线干部(工作人员)责任清单($year)年",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Flex(
                  mainAxisAlignment: MainAxisAlignment.center,
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: DashboardTheme.allBoxDecoration,
                        child: Text("表格类型", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: DashboardTheme.allBoxDecoration,
                        child: Text("$year年一线干部${process.businessType}",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: DashboardTheme.allBoxDecoration,
                        child: Text("填表日期", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: DashboardTheme.allBoxDecoration,
                        child: Text(
                          formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]),
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Flex(
                  mainAxisAlignment: MainAxisAlignment.center,
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: DashboardTheme.allBoxDecoration,
                        child: Text("姓名", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: DashboardTheme.allBoxDecoration,
                        child: Text("${process.username}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: DashboardTheme.allBoxDecoration,
                        child: Text("部门", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: DashboardTheme.allBoxDecoration,
                        child: Text("${process.deptName}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: DashboardTheme.allBoxDecoration,
                        child: Text("职务", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: DashboardTheme.allBoxDecoration,
                        child: Text("${e.position}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Flex(
                  mainAxisAlignment: MainAxisAlignment.center,
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 300,
                        alignment: Alignment.center,
                        decoration: DashboardTheme.allBoxDecoration,
                        child: Text(
                          "岗\n位\n职\n责",
                          style: DashboardTheme.formTextStyle,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 11,
                      child: Container(
                        height: 300,
                        alignment: Alignment.center,
                        decoration: DashboardTheme.allBoxDecoration,
                        child: TextField(
                          maxLines: 50,
                          enabled: process.step == 0 ? true : false,
                          controller: dutylist,
                          onChanged: (value) {
                            e.shortComesAndPlan = value;
                          },
                          decoration: InputDecoration(
                            hintText: "录入岗位职责",
                            contentPadding: EdgeInsets.all(10.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Flex(
                  mainAxisAlignment: MainAxisAlignment.center,
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 400,
                        alignment: Alignment.center,
                        decoration: DashboardTheme.allBoxDecoration,
                        child: Text(
                          "年\n度\n工\n作\n任\n务",
                          style: DashboardTheme.formTextStyle,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 11,
                      child: Container(
                        height: 400,
                        alignment: Alignment.center,
                        decoration: DashboardTheme.allBoxDecoration,
                        child: TextField(
                          maxLines: 50,
                          enabled: process.step == 0 ? true : false,
                          controller: selfEvaluation,
                          onChanged: (value) {
                            e.selfEvaluation = value;
                          },
                          decoration: InputDecoration(
                            hintText: "录入年度工作任务",
                            contentPadding: EdgeInsets.all(10.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: CommandBoxWidget(bloc, process.processInstanceId == null ? true : false, process.step, e,
                    templateid, process.title, process.businessType),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
