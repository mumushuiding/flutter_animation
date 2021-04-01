import 'package:flutter/material.dart';
import 'package:yxkh_front/api/yxkh_api.dart';
import 'package:yxkh_front/blocs/project_bloc.dart';
import 'package:yxkh_front/theme.dart';

import '../../app.dart';
import 'AddMarkWidget.dart';

// ProjectViewWidget 月度考核项目显示组件
class ProjectViewWidget extends StatelessWidget {
  final ProjectBloc bloc;
  final String username;
  ProjectViewWidget({Key key, this.bloc, this.username})
      : assert(bloc != null, username != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        alignment: Alignment.center,
        decoration: DashboardTheme.allBoxDecoration,
        constraints: BoxConstraints(minHeight: 100, maxHeight: 500),
        // height: 200,
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Container(
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 30,
                      alignment: Alignment.center,
                      decoration: DashboardTheme.allBoxDecoration,
                      child: Text("项目内容"),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 30,
                      alignment: Alignment.center,
                      decoration: DashboardTheme.allBoxDecoration,
                      child: Text("进展情况"),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 30,
                      alignment: Alignment.center,
                      decoration: DashboardTheme.allBoxDecoration,
                      child: Text("加减分原因"),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 30,
                      alignment: Alignment.center,
                      decoration: DashboardTheme.allBoxDecoration,
                      child: Text("加减分"),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Flex(direction: Axis.horizontal, children: <Widget>[
                Expanded(
                  flex: 1,
                  child: StreamBuilder<List<dynamic>>(
                    stream: bloc.stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.data.isEmpty) {
                        return Center(
                          child: Text("未添加项目"),
                        );
                      }
                      return Scrollbar(
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return ProjectRowWidget(
                              p: snapshot.data[index],
                              bloc: this.bloc,
                              username: username,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ]),
            ),
            Container(
              height: 50,
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 50,
                      decoration: DashboardTheme.allBoxDecoration,
                      child: bloc.candidate == App.userinfos.user.userid
                          ? Row(
                              children: <Widget>[
                                FlatButton(
                                  child: Text("添加项目"),
                                  color: Colors.blue,
                                  onPressed: () {
                                    TextEditingController content = TextEditingController();
                                    TextEditingController progress = TextEditingController();
                                    App.showAlertDialog(
                                        context,
                                        Text("添加项目"),
                                        ProjectWidget(
                                          content: content,
                                          progress: progress,
                                        ), callback: () {
                                      bloc.onAdd(content.text, progress.text);
                                    });
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                ),
                                FlatButton(
                                  child: Text("添加上月项目"),
                                  color: Colors.red,
                                  onPressed: () {
                                    YxkhAPI.addLastMonthProject(App.userinfos.user.id).then((data) {
                                      if (data["status"] == 200) {
                                        bloc.findAllProjectWithMarks();
                                      } else {
                                        App.showAlertError(context, data["message"]);
                                      }
                                    });
                                  },
                                ),
                              ],
                            )
                          : Container(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: DashboardTheme.allBoxDecoration,
                      child: Text("总分"),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: DashboardTheme.allBoxDecoration,
                      child: StreamBuilder<double>(
                        stream: this.bloc.totalStream,
                        builder: (context, snapshot) {
                          return snapshot.data == null ? Text("0.0") : Text("${snapshot.data.toStringAsFixed(2)}");
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectRowWidget extends StatelessWidget {
  final Project p;
  final ProjectBlocImpl bloc;
  final String username;
  ProjectRowWidget({Key key, this.p, this.bloc, this.username})
      : assert(bloc != null, username != null),
        super(key: key);
  bool _showActions() {
    bool showActions = false;
    if (bloc.candidate == null) {
      if (p.userId == App.userinfos.user.id) {
        showActions = true;
      }
    } else {
      if (bloc.candidate.indexOf(App.userinfos.user.userid) != -1) {
        showActions = true;
      }
    }
    return showActions;
  }

  @override
  Widget build(BuildContext context) {
    print("candidate:${bloc.candidate},curuser:${App.userinfos.user.userid}");
    var height = 80.0;
    if (p.marks != null && p.marks.length > 0) height = 80.0 * p.marks.length;

    return Container(
      decoration: DashboardTheme.allBoxDecoration,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: _showActions()
                  ? Container(
                      height: height,
                      alignment: Alignment.topLeft,
                      // decoration: DashboardTheme.allBoxDecoration,
                      child: PopupMenuButton(
                        tooltip: "操作",
                        onSelected: (val) {
                          switch (val) {
                            case "修改":
                              TextEditingController content = TextEditingController(text: p.projectContent);
                              TextEditingController progress = TextEditingController(text: p.progress);
                              App.showAlertDialog(
                                  context,
                                  Text("修改项目"),
                                  ProjectWidget(
                                    content: content,
                                    progress: progress,
                                  ), callback: () {
                                p.projectContent = content.text;
                                p.progress = progress.text;
                                this.bloc.onUpdate(p);
                              });
                              break;
                            case "评分":
                              App.showAlertDialog(
                                  context,
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text("评分"),
                                      IconButton(
                                        color: Colors.green,
                                        icon: Icon(Icons.add_box),
                                        iconSize: 50,
                                        onPressed: () {
                                          App.showAlertDialog(
                                              context,
                                              Text("添加评分"),
                                              AddMarkWidget(
                                                p: p,
                                                bloc: this.bloc,
                                                username: username,
                                                callback: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              showActions: false);
                                        },
                                      )
                                    ],
                                  ),
                                  UpdateMarksWidget(
                                    p: p,
                                    bloc: this.bloc,
                                  ),
                                  callback: () {});
                              break;
                            case "删除":
                              App.showAlertDialog(context, Text("删除确认"), Text("确认删除吗？"), callback: () {
                                this.bloc.onDelete(p.projectId);
                              });
                              break;
                            default:
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: "修改",
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text("修改"),
                            ),
                          ),
                          PopupMenuItem(
                            value: "评分",
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text("评分"),
                            ),
                          ),
                          PopupMenuItem(
                            value: "删除",
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text("删除"),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container()),
          Flexible(
            flex: 11,
            fit: FlexFit.tight,
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                left: BorderSide(width: 2, color: Colors.grey),
                right: BorderSide(width: 2, color: Colors.grey),
              )),
              constraints: BoxConstraints(minHeight: height),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      alignment: Alignment.center,
                      constraints: BoxConstraints(minHeight: height),
                      decoration: DashboardTheme.rightBoxDecoration,
                      child: Text(p.projectContent),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      constraints: BoxConstraints(minHeight: height),
                      // decoration: DashboardTheme.leftBoxDecoration,
                      child: Text("${p.progress}"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
              flex: 6,
              fit: FlexFit.tight,
              child: MarksWidget(
                marks: p.marks,
              )),
        ],
      ),
    );
  }
}

class MarksWidget extends StatelessWidget {
  final List<Mark> marks;
  MarksWidget({Key key, this.marks}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var height = 80.0;
    if (marks != null && marks.length > 0) height = 80.0 * marks.length;
    return Container(
      height: height,
      child: ListView.builder(
        itemCount: marks.length,
        itemBuilder: (context, index) {
          return Container(
            alignment: Alignment.center,
            // decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey,width: 2))),
            constraints: BoxConstraints(maxHeight: 80.0),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black, width: 0.5),
                        right: BorderSide(color: Colors.grey, width: 2),
                      ),
                    ),
                    constraints: BoxConstraints(minHeight: 80.0),
                    child: Text("${marks[index].accordingly ?? ""}"),
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    alignment: Alignment.center,
                    // decoration: DashboardTheme.allBoxDecoration,
                    constraints: BoxConstraints(minHeight: 80.0),
                    child: Text("${marks[index].markNumber}"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class UpdateMarksWidget extends StatelessWidget {
  final Project p;
  final ProjectBlocImpl bloc;
  UpdateMarksWidget({Key key, this.p, this.bloc})
      : assert(p != null, bloc != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 500,
      child: ListView.builder(
        itemCount: p.marks.length,
        itemBuilder: (context, index) {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black, width: 0.5),
                right: BorderSide(color: Colors.grey, width: 2),
              ),
            ),
            child: Column(
              children: <Widget>[
                Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 4,
                      child: Container(
                        decoration: DashboardTheme.rightBoxDecoration,
                        alignment: Alignment.center,
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 17,
                      child: Container(
                        decoration: DashboardTheme.rightBoxDecoration,
                        alignment: Alignment.center,
                        child: Text(
                          "分数:${p.marks[index].markNumber}",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 17,
                      child: bloc.candidate.contains(App.userinfos.user.userid)
                          ? Container(
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    tooltip: "修改",
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_forever),
                                    tooltip: "删除",
                                    onPressed: () {
                                      if (p.projectContent == "系统导入") {
                                        App.showAlertError(context, "系统导入不可删除");
                                        return;
                                      }
                                      App.showAlertDialog(context, Text("删除"), Text("确定要删除吗？"), callback: () {
                                        this.bloc.onDelMark(p, p.marks[index].markId);
                                        Navigator.of(context).pop();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  alignment: Alignment.center,
                  // decoration: DashboardTheme.rightBoxDecoration,
                  constraints: BoxConstraints(minHeight: 80.0),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text("理 由",
                              textAlign: TextAlign.left, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Flexible(
                        flex: 11,
                        fit: FlexFit.tight,
                        child: Container(
                          decoration: DashboardTheme.leftBoxDecoration,
                          padding: EdgeInsets.only(left: 10),
                          child: Text(" ${p.marks[index].markReason}"),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  alignment: Alignment.center,
                  constraints: BoxConstraints(minHeight: 80.0),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "根 据",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 11,
                        fit: FlexFit.tight,
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          decoration: DashboardTheme.leftBoxDecoration,
                          child: Text(" ${p.marks[index].accordingly}"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ProjectWidget 显示和添加项目组件
class ProjectWidget extends StatelessWidget {
  final TextEditingController content;
  final TextEditingController progress;
  ProjectWidget({Key key, this.content, this.progress}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 500,
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
              child: TextField(
                minLines: 15,
                maxLines: 20,
                controller: content,
                decoration: InputDecoration(
                    hintText: "项目内容",
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide(color: Colors.grey))),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
              child: TextField(
                minLines: 15,
                maxLines: 20,
                controller: progress,
                decoration: InputDecoration(
                    hintText: "项目进展",
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide(color: Colors.grey))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
