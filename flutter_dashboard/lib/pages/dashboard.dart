import 'package:flutter/material.dart';
import '../api/user_api.dart';
import '../routes.dart';
import '../theme.dart';
import '../utils/screenUtil.dart';
import '../app.dart';
import 'sidebar_menu.dart';
// DashboardWidget 操作页面
class DashboardWidget extends StatefulWidget{
  final params;
  DashboardWidget({Key key,this.params}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return _DashboardWidgetState();
  }

}
class _DashboardWidgetState extends State<DashboardWidget> with AutomaticKeepAliveClientMixin{
  var _params;
  User _user;
  List<Widget> pages=List();
  bool _showSidebar=true;
  int _selectIndex = 0;
  bool isInit=true;
  List<RouteHandler> drawerItems;
  void getUserinfo() async{
   await App.getUserByToken();
  }
  Widget _getPages(int index){
    if (pages[index]==null){
      pages[index]=drawerItems[index].handler();
    }
    // print("当前页面$index:${drawerItems[index].title}");
    return pages[index];
  }
  @override void initState(){
    super.initState();
    _params=widget.params;
    drawerItems=Routes.getNeedsDrawerRegistry();
    _user=App.userinfos.user;
    if (drawerItems.length>0){
      pages=List(drawerItems.length);
      pages[0]=(drawerItems[0].handler());
    }

  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (ScreenUtils.isSmallScreen(context)&&isInit){
      _showSidebar=false;
      isInit=false;
    }
    final _media = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (BuildContext context,BoxConstraints constraints){
        return Material(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SideBarMenu(
                collapsed: _showSidebar,
                user:_user,
                items: drawerItems,
                onTap: (index){
                  _selectIndex=index;
                  setState(() {
            
                  });
                },
                show: (bool show){
                  _showSidebar=show;
                  setState(() {
                    
                  });
                },
              ),
              Flexible(
                fit:FlexFit.loose,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: DashboardTheme.appBarHeight,
                      width: _media.width,
                      child: AppBar(
                        leading: !_showSidebar?IconButton(color: Colors.white,icon: Icon(Icons.reorder),onPressed: (){
                          _showSidebar=true;
                          setState(() {
                            
                          });
                        },):Container(),
                        elevation: 4,
                        centerTitle: true,
                        title: Text(
                          '一线考核',
                        ),
                        backgroundColor: DashboardTheme.drawerBgColor,
                      ),
                    ),
                    Expanded(
                        child: Stack(
                          children: pages.asMap().keys.map((index)=>Offstage(
                            offstage: _selectIndex!=index,
                            child: TickerMode(enabled: _selectIndex==index,child: _getPages(index),),
                          )).toList(),
                        ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
  
}