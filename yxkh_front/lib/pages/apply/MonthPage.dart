import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:yxkh_front/api/response_data.dart';
import 'package:yxkh_front/api/user_api.dart';
import 'package:yxkh_front/api/yxkh_api.dart';
import 'package:yxkh_front/blocs/flow_task_bloc.dart';
import 'package:yxkh_front/pages/apply/FlowPage.dart';
import 'package:yxkh_front/pages/apply/before_addmonth_widget.dart';
import 'package:yxkh_front/pages/apply/year_form_widget.dart';
import 'package:yxkh_front/pages/widget/apply_tree_widget.dart';
import 'package:yxkh_front/pages/widget/search_apply_widget.dart';
import 'package:yxkh_front/pages/widget/user_dic_search_widget.dart';
import 'package:yxkh_front/widget/flow_stepper.dart';
import 'package:yxkh_front/widget/select.dart';

import '../../app.dart';
import '../../apply_router.dart';
import 'addmonth.dart';

class MonthPage extends StatefulWidget {
  final params;
  MonthPage({Key key, this.params}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MonthPageState();
  }
}

class _MonthPageState extends State<MonthPage> {
  ScrollController _scrollController;
  FlowTaskBlocImpl bloc;
  Map<String, dynamic> params;
  List<dynamic> departments;
  @override
  void initState() {
    super.initState();
    getDepartments();
    _scrollController = ScrollController();

    if (App.userinfos.user != null) {
      params = {"userId": App.userinfos.user.userid};
      bloc = FlowTaskBlocImpl(params: params);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    bloc.dispose();
    // titles.clear();
  }

  void getDepartments() {
    UserAPI.getAllDepartments(refresh: false).then((data) {
      if (data["status"] != 200) {
        App.showAlertError(context, data["message"]);
        return;
      }
      var datas = ResponseData.fromResponse(data);
      setState(() {
        departments = datas[0];
      });
    });
  }

  void applyMonth(String title) async {
    // 查询是否是考核组成员
    if (!App.hasAssessmentGroupTag()) {
      String label = "";
      App.showAlertDialog(
          context,
          Text("设置考核组"),
          Container(
            width: 300,
            height: 400,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: <Widget>[Icon(Icons.error), Text("不是考核组成员,无法填写月度考核!!")],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: <Widget>[Icon(Icons.settings), Text("设置考核组")],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Select(
                    inputDecoration: InputDecoration(
                      prefixIcon: Icon(Icons.group),
                      hintText: "选择考核组",
                    ),
                    items: [
                      {"key": "第一考核组成员", "value": "第一考核组成员"},
                      {"key": "第二考核组成员", "value": "第二考核组成员"},
                      {"key": "第三考核组成员", "value": "第三考核组成员"},
                      {"key": "第四考核组成员", "value": "第四考核组成员"}
                    ],
                    onChange: (keys, vals) {
                      label = vals;
                    },
                    valueTag: "value",
                    keyTag: "key",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.search),
                      Text(
                        "查询同事所在考核组",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: UserDicSearchWidget(
                    type: "考核组",
                    textFieldWidth: 280,
                    callback: (vals) {
                      label = vals[0]["tagName"];
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child: MaterialButton(
                    elevation: 0,
                    color: Colors.green,
                    child: Text("确定"),
                    onPressed: () {
                      if (label == "") {
                        return;
                      }
                      UserAPI.addUserLabel(userid: App.userinfos.user.id, labelname: label).then((d) {
                        if (d["status"] != 200) {
                          App.showAlertError(context, d["message"]);
                          return;
                        }
                        App.userinfos.labels.add(Label(0, label, ""));
                        App.getUserByToken(token: App.getToken());
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ),
              ],
            ),
          ));
      return;
    }
    // 查询流程是否已经存在
    var data = await UserAPI.findAllFlow(title: App.userinfos.user.name + "-" + title);
    var datas = ResponseData.fromResponse(data);
    if (datas[0].length > 0) {
      App.showAlertError(context, "不能重复提交");
      return;
    }
    int year = int.parse(title.substring(0, 4));
    int month = title.substring(6, 7) == "月" ? int.parse(title.substring(5, 6)) : int.parse(title.substring(5, 7));
    // print("year:$year");
    // print("month:$month");
    var start = DateTime.utc(year, month, 1);
    if (month == 12) {
      month = 1;
      year++;
    }
    var end = DateTime.utc(year, month + 1, 1).subtract(Duration(days: 1));
    var e = {
      "sparation": App.userinfos.user.name + "-" + title,
      "startDate": formatDate(start, [yyyy, "-", mm, "-", dd]),
      "endDate": formatDate(end, [yyyy, "-", mm, "-", dd]),
      "username": App.userinfos.user.name,
    };
    // print(p);
    if (App.userinfos.user == null) {
      App.showAlertError(context, "必须登陆之后才能填写");
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return AddMonth(
        evaluation: Evaluation.fromJson(e),
        taskbloc: bloc,
      );
    }));
  }

  Widget getHeader() {
    return Row(
      children: <Widget>[
        getButtons(),
        Container(
          padding: EdgeInsets.only(left: 15, bottom: 10),
          child: Text(
            "开始您一天的工作吧!",
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF586072)),
          ),
        ),
      ],
    );
  }

  Widget getButtons() {
    return Row(
      children: <Widget>[
        ApplyTreeWidget(
          iconSize: 35,
          iconPadding: EdgeInsets.only(bottom: 0.0),
          callback: (val) {
            if (val == null) return;
            if (val[0].contains("月份-月度考核")) {
              this.applyMonth(val[0]);
            } else {
              ApplyHandler.applyRoute(context, val[0], bloc);
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.search),
          iconSize: 35,
          padding: EdgeInsets.only(bottom: 10),
          color: Colors.blue,
          tooltip: "搜索",
          onPressed: () {
            App.showAlertDialog(
                context,
                Text("搜索"),
                SearchApplyWidget(
                  params: bloc.params,
                  departments: departments,
                ), callback: () {
              bloc.onSearchTask(bloc.params);
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.refresh),
          iconSize: 35,
          color: Colors.blue,
          padding: EdgeInsets.only(bottom: 10),
          tooltip: "刷新数据",
          onPressed: () {
            bloc.onSearchTask(bloc.params);
          },
        ),
      ],
    );
  }

  List<Map<String, dynamic>> getTitles() {
    int i = 0;
    List<Map<String, dynamic>> result = List();
    DateTime now = DateTime.now();
    // 每月25号可以开始填当月
    // 获取年份
    int year = now.year;
    // 获取月份
    int month = now.month;
    int day = now.day;
    if (day < 25) {
      if (month == 1) {
        month = 12;
        year--;
      } else {
        month--;
      }
    }
    result.add({"id": i, "value": "$year年$month月份-月度考核"});
    i++;
    // 可以填写半年之内的一线考核
    int num = 6;
    while (num != 0) {
      num--;
      if (month == 1) {
        month = 12;
        year--;
      } else {
        month--;
      }
      result.add({"id": i, "value": "$year年$month月份-月度考核"});
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: StreamBuilder<List<dynamic>>(
          stream: bloc.taskStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data.isEmpty) {
              // bloc.onSearchTask(bloc.params);
              return Center(
                child: getHeader(),
              );
            }
            return PaginatedDataTable(
              header: getHeader(),
              actions: <Widget>[],
              rowsPerPage: 10,
              onPageChanged: (page) {
                // print('onPageChanged:$page');
              },
              columns: [
                DataColumn(label: Text('操作')),
                // DataColumn(label: Text('ID')),
                DataColumn(label: Text('标题')),
                DataColumn(label: Text('申请人')),
                DataColumn(label: Text('类型')),
                DataColumn(label: Text('部门')),
                DataColumn(label: Text('审批人')),
                DataColumn(label: Text('状态')),
                DataColumn(label: Text('步骤')),
                DataColumn(label: Text('日期')),
              ],
              source: ProcessDataTableSource(
                Process.fromList(snapshot.data),
                bloc,
                context,
              ),
            );
          },
        ));
  }
}

class ProcessDataTableSource extends DataTableSource {
  final List<Process> data;
  final BuildContext context;
  final FlowTaskBlocImpl bloc;
  final onLookup;
  ProcessDataTableSource(this.data, this.bloc, this.context, {this.onLookup}) : assert(bloc != null);

  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(
      index: index,
      cells: [
        // DataCell(Text('${data[index].processInstanceId}')),
        DataCell(PopupMenuButton(
          tooltip: "点击操作",
          onSelected: (val) {
            switch (val) {
              case "查看":
                // onLookup?.call(data[index]);
                Process p = data[index];
                bloc.lookupProcess(context, p);
                break;
              case "进度":
                bloc.lookupFlowStepper(context, data[index].processInstanceId);

                break;
              case "撤回":
                UserAPI.completeFlowTask(data[index].processInstanceId, data[index].businessType, 5).then((data) {
                  if (data["status"] != 200) {
                    App.showAlertError(context, data['message']);
                    return;
                  }
                  var datas = ResponseData.fromResponse(data);
                  bloc?.onCompleteTask(datas[0], datas[1]);
                });
                break;
              case "删除":
                // 判断是否可以删除
                if (data[index].step == 0 && data[index].userId == App.userinfos.user.userid) {
                  bloc.onDeleteProcess(data[index].processInstanceId, data[index].businessType);
                } else {
                  App.showAlertError(context, "未提交时才能删除,确要删除时请先撤回");
                }
                break;
              default:
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: "查看",
              child: ListTile(
                leading: Icon(Icons.remove_red_eye),
                title: Text("查看"),
              ),
            ),
            PopupMenuItem(
              value: "进度",
              child: ListTile(
                leading: Icon(Icons.refresh),
                title: Text("进度"),
              ),
            ),
            PopupMenuItem(
              value: "撤回",
              child: ListTile(
                leading: Icon(Icons.sync),
                title: Text("撤回"),
              ),
            ),
            PopupMenuItem(
              value: "删除",
              child: ListTile(
                leading: Icon(Icons.delete_forever),
                title: Text("删除"),
              ),
            ),
          ],
        )),
        DataCell(Text('${data[index].title}')),
        DataCell(Text('${data[index].username}')),
        DataCell(Text('${data[index].businessType}')),
        DataCell(Text('${data[index].deptName}')),
        DataCell(Text('${data[index].candidate ?? ""}')),
        DataCell(Text('${data[index].completed}')),
        DataCell(Text('${data[index].step}')),
        DataCell(Text('${data[index].requestedDate}')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
