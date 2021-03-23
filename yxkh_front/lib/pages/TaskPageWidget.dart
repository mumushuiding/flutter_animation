import 'package:flutter/material.dart';
import 'package:yxkh_front/blocs/flow_task_bloc.dart';
import 'package:yxkh_front/pages/task/my_task_hisotry.dart';
import 'package:yxkh_front/pages/task/my_task_page.dart';
import '../app.dart';
import '../routes.dart';

class TaskPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TaskPageWidgetState();
  }
}

class _TaskPageWidgetState extends State<TaskPageWidget> with SingleTickerProviderStateMixin {
  TabController _tabController;
  FlowTaskBlocImpl bloc;
  // FlowTaskBlocImpl bloc2;
  List<RouteHandler> _list;
  List<Widget> pages;
  int _selectIndex = 0;
  @override
  void dispose() {
    bloc.dispose();
    // bloc2.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    bloc = FlowTaskBlocImpl(
        params: {"candidate": App.userinfos.user.userid, "completed": 0},
        paramsHistory: {"userId": App.userinfos.user.userid});
    // bloc2=FlowTaskBlocImpl();
    _list = <RouteHandler>[
      RouteHandler(
          title: "待审批",
          icon: Icons.gps_not_fixed,
          handler: ({Map<String, dynamic> params, BuildContext context}) => MyTaskPageWidget(bloc: this.bloc)),
      RouteHandler(
          title: "审批纪录",
          icon: Icons.face,
          handler: ({Map<String, dynamic> params, BuildContext context}) => MyTaskHistoryPageWidget(
                bloc: this.bloc,
              )),
    ];
    _tabController = TabController(vsync: this, length: _list.length);
    pages = List(_list.length);
    pages[0] = _list[0].handler();
  }

  Widget _getPages(int index) {
    if (pages[index] == null) {
      pages[index] = _list[index].handler();
    }
    // print("当前页面$index:${drawerItems[index].title}");
    return pages[index];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Material(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                child: AppBar(
                  backgroundColor: Colors.black,
                  title: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: Colors.red, //选中下划线的颜色
                    indicatorSize: TabBarIndicatorSize.label, //选中下划线的长度，label时跟文字内容长度一样，tab时跟一个Tab的长度一样
                    indicatorWeight: 3.0, //选中下划线的高度，值越大高度越高，默认为2。0
                    labelPadding: EdgeInsets.fromLTRB(10, 15, 10, 20),
                    tabs: _list.map((l) => Text(l.title)).toList(),
                    onTap: (index) {
                      _selectIndex = index;
                      setState(() {});
                    },
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: pages
                      .asMap()
                      .keys
                      .map((index) => Offstage(
                            offstage: _selectIndex != index,
                            child: TickerMode(
                              enabled: _selectIndex == index,
                              child: _getPages(index),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
