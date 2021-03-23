import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:yxkh_front/api/response_data.dart';
import 'package:yxkh_front/api/user_api.dart';
import 'package:yxkh_front/api/yxkh_api.dart';
import 'package:yxkh_front/app.dart';
import 'package:yxkh_front/blocs/flow_task_bloc.dart';
import 'package:yxkh_front/blocs/project_bloc.dart';
import 'package:yxkh_front/theme.dart';
import 'package:yxkh_front/widget/button_countdown.dart';
import 'package:yxkh_front/widget/flow_stepper.dart';
import 'package:yxkh_front/widget/select.dart';

import 'ProjectViewWidget.dart';

// AddMonth 添加月度考核
class AddMonth extends StatefulWidget {
  final params;
  // 解决:审批之后审批页面数据更新
  final FlowTaskBlocImpl taskbloc;
  final Evaluation evaluation;
  final Process process;
  AddMonth({Key key, this.params, this.evaluation, this.process, this.taskbloc}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _AddMonthState();
  }
}

class _AddMonthState extends State<AddMonth> {
  // 一线考核数据
  Evaluation e;
  // 流程
  Process p;
  User u;
  ScrollController _scrollController;
  ProjectBlocImpl bloc;
  FlowTaskBlocImpl taskbloc;
  TextEditingController plan;
  TextEditingController attendance;
  // 领导点评
  TextEditingController leaderRemark;
  TextEditingController overseerRemark;
  TextEditingController selfEvaluation;
  TextEditingController leaderEvaluation;
  TextEditingController overseerEvaluation;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    taskbloc = widget.taskbloc;
    e = widget.evaluation;
    p = widget.process;
    if (widget.params != null) {
      if (widget.params["e"] != null) {
        // 新建
        e = Evaluation.fromJson(jsonDecode(widget.params["e"].first));
      }
      if (widget.params["p"] != null) {
        p = Process.fromJson(jsonDecode(widget.params["p"].first));
      }
    }
    // e.createTime=formatDate(DateTime.now(),[yyyy, '-', mm, '-', dd]);
    if (e.processInstanceId == null) {
      // Navigator.of(context).pop();
      u = App.userinfos.user;
      if (u == null) {
        App.showAlertError(context, "未登陆无法操作");
        return;
      }
      e.position = u.position;
      e.uid = u.id;
      e.attendance = "旷工(0)天，请假(0)天";
      e.leadershipRemark = "基本属实";
      e.overseerRemark = "工作正常推进";
      e.selfEvaluation = "合格";
      e.leadershipEvaluation = "合格";
      e.overseerEvaluation = "合格";
      p = Process(e.sparation, "月度考核");
      p.step = 0;
      p.candidate = u.userid;
    } else {
      if (p == null) {
        // 远程查询流程
        print("参数p是流程数据，不能为空");
        return;
      }
      u = User();
      u.id = p.uid;
      u.userid = p.userId;
      u.name = p.username;
      u.departmentname = p.deptName;
    }
    plan = TextEditingController(text: e.shortComesAndPlan);
    attendance = TextEditingController(text: e.attendance);
    leaderEvaluation = TextEditingController(text: e.leadershipEvaluation);
    leaderRemark = TextEditingController(text: e.leadershipRemark);
    overseerRemark = TextEditingController(text: e.overseerRemark);
    selfEvaluation = TextEditingController(text: e.selfEvaluation);
    overseerEvaluation = TextEditingController(text: e.overseerEvaluation);
    bloc = ProjectBlocImpl(e.startDate, e.endDate, u.id);
    bloc.candidate = p.candidate;
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    bloc.dispose();
    plan.dispose();
    attendance.dispose();
    leaderRemark.dispose();
    overseerRemark.dispose();
    selfEvaluation?.dispose();
    leaderEvaluation?.dispose();
    overseerEvaluation?.dispose();
  }

  bool _validate(Evaluation evaluation) {
    // 考勤情况
    if (attendance.text.trim() == "") attendance.text = "旷工(0)天，请假(0)天";

    return true;
  }

  void _startProcess(Evaluation evaluation, int perform, String title) {
    if (!_validate(evaluation)) return;
    // 查询流程是否已经存在
    UserAPI.findAllFlow(title: title).then((data) {
      var datas = ResponseData.fromResponse(data);
      if (datas[0].length > 0) {
        App.showAlertError(context, "不能重复提交");
        return;
      }
      YxkhAPI.startProcess(evaluation.toJson(), e.sparation, "002d5df2a737dd36a2e78314b07d0bb1_1591669930", "月度考核",
              perform: perform)
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
    });
  }

  _completeProcess(Evaluation e, int perform) {
    e.startDate = e.startDate.substring(0, 10);
    e.endDate = e.endDate.substring(0, 10);
    YxkhAPI.completeProcess(e.toJson(), "月度考核", perform).then((data) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text("月度考核申请"),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                  "日常工作一线干部考核情况督查登记表",
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
                      child: Text(
                        "表格类型",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: DashboardTheme.allBoxDecoration,
                      child: Text(
                        "${e.sparation}",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: DashboardTheme.allBoxDecoration,
                      child: Text(
                        "填表日期",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      decoration: DashboardTheme.allBoxDecoration,
                      child: Text(
                        "姓名",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: DashboardTheme.allBoxDecoration,
                      child: Text(
                        "${u.name}",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: DashboardTheme.allBoxDecoration,
                      child: Text(
                        "职务",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: DashboardTheme.allBoxDecoration,
                      child: Text(
                        "${e.position}",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: DashboardTheme.allBoxDecoration,
                      child: Text(
                        "部门",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      decoration: DashboardTheme.allBoxDecoration,
                      child: Text(
                        "${u.departmentname}",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsetsDirectional.only(start: 5.0),
                    width: 25,
                    constraints: BoxConstraints(minHeight: 500),
                    decoration: BoxDecoration(
                        border: Border(
                      left: BorderSide(
                        color: Colors.grey,
                        width: 2,
                      ),
                      right: BorderSide(
                        color: Colors.grey,
                        width: 2,
                      ),
                    )),
                    child: Text(
                      "个人自评",
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsetsDirectional.only(start: 5.0),
                    width: 25,
                    constraints: BoxConstraints(
                      minHeight: 500,
                    ),
                    // decoration: DashboardTheme.allBoxDecoration,
                    child: Text(
                      "项目进展",
                    ),
                  ),
                  Expanded(
                    child: ProjectViewWidget(
                      bloc: bloc,
                      username: u.name,
                    ),
                  )
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
                      height: 100,
                      alignment: Alignment.center,
                      decoration: DashboardTheme.allBoxDecoration,
                      child: Text(
                        "问题及整改计划",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 100,
                      alignment: Alignment.center,
                      decoration: DashboardTheme.allBoxDecoration,
                      child: TextField(
                        maxLines: 10,
                        enabled: p.step == 0 ? true : false,
                        controller: plan,
                        onChanged: (val) {
                          e.shortComesAndPlan = val;
                        },
                        decoration: InputDecoration(
                          // fillColor:  Colors.red,
                          contentPadding: EdgeInsets.all(10.0),
                          border: InputBorder.none,
                          // filled: true,
                          // fillColor: Colors.blue[100]
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
                      height: 50,
                      alignment: Alignment.center,
                      decoration: DashboardTheme.allBoxDecoration,
                      child: Text(
                        "考勤情况",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: p.step == 0 ? DashboardTheme.allRedBoxDecoration : DashboardTheme.allBoxDecoration,
                      child: TextField(
                        maxLines: 1,
                        enabled: p.step == 0 ? true : false,
                        controller: attendance,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(width: 4, color: p.step == 0 ? Colors.red : Colors.grey))),
                        onChanged: (val) {
                          e.attendance = val;
                        },
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
                      child: Text(
                        "自我定格",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: p.step == 0 ? DashboardTheme.allRedBoxDecoration : DashboardTheme.allBoxDecoration,
                      child: Select(
                        textEditingController: selfEvaluation,
                        enabled: p.step == 0 ? true : false,
                        items: [
                          {"value": "优秀"},
                          {"value": "合格"},
                          {"value": "基本合格"},
                          {"value": "不合格"}
                        ],
                        onChange: (keys, vals) {
                          e.selfEvaluation = vals;
                        },
                        keyTag: "id",
                        valueTag: "value",
                        hintText: "评价",
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
                      child: Text(
                        "领导点评",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: p.step == 1 ? DashboardTheme.allRedBoxDecoration : DashboardTheme.allBoxDecoration,
                      child: Select(
                        textEditingController: leaderEvaluation,
                        enabled: p.step == 1 ? true : false,
                        items: [
                          {"value": "优秀"},
                          {"value": "合格"},
                          {"value": "基本合格"},
                          {"value": "不合格"}
                        ],
                        onChange: (keys, vals) {
                          e.leadershipEvaluation = vals;
                        },
                        keyTag: "id",
                        valueTag: "value",
                        hintText: "评价",
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: p.step == 1 ? DashboardTheme.allRedBoxDecoration : DashboardTheme.allBoxDecoration,
                      child: TextField(
                        maxLines: 1,
                        enabled: p.step == 1 ? true : false,
                        controller: leaderRemark,
                        onChanged: (val) {
                          e.leadershipRemark = val;
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide(color: Colors.grey))),
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
                      child: Text(
                        "组织考评",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: p.step == 2 ? DashboardTheme.allRedBoxDecoration : DashboardTheme.allBoxDecoration,
                      child: Select(
                        textEditingController: overseerEvaluation,
                        enabled: p.step == 2 ? true : false,
                        items: [
                          {"value": "优秀"},
                          {"value": "合格"},
                          {"value": "基本合格"},
                          {"value": "不合格"}
                        ],
                        onChange: (keys, vals) {
                          e.overseerEvaluation = vals;
                        },
                        keyTag: "id",
                        valueTag: "value",
                        hintText: "评价",
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: p.step == 2 ? DashboardTheme.allRedBoxDecoration : DashboardTheme.allBoxDecoration,
                      child: TextField(
                        maxLines: 1,
                        enabled: p.step == 2 ? true : false,
                        controller: overseerRemark,
                        onChanged: (val) {
                          e.overseerRemark = val;
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide(color: Colors.grey))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 50,
                child: e.processInstanceId == null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ButtonCountDown(
                            color: Colors.green,
                            child: Text("提交"),
                            onPressed: p.step == 0
                                ? () {
                                    _startProcess(e, 0, p.title);
                                  }
                                : null,
                          ),
                          ButtonCountDown(
                            color: Colors.grey,
                            child: Text("保存"),
                            onPressed: p.step == 0
                                ? () {
                                    _startProcess(e, 1, p.title);
                                  }
                                : null,
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ButtonCountDown(
                            child: p.step != 0 ? Text("审批") : Text("提交"),
                            color: Colors.green,
                            onPressed: () {
                              _completeProcess(e, 2);
                            },
                          ),
                          ButtonCountDown(
                            child: Text("撤回"),
                            color: Colors.blue,
                            onPressed: p.step != 0
                                ? () {
                                    _completeProcess(e, 5);
                                  }
                                : null,
                          ),
                          ButtonCountDown(
                            color: Colors.grey,
                            child: Text("驳回"),
                            onPressed: p.step != 0
                                ? () {
                                    _completeProcess(e, 3);
                                  }
                                : null,
                          )
                        ],
                      ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
