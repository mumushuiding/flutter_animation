import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yxkh_front/api/user_api.dart';
import 'package:yxkh_front/pages/user/changeEmail.dart';
import 'package:yxkh_front/pages/user/login.dart';
import 'package:yxkh_front/pages/user/sign_in.dart';
import 'package:yxkh_front/routes.dart';
import '../theme.dart';
import '../utils/screenUtil.dart';
import '../app.dart';
import 'sidebar_menu.dart';

// DashboardWidget 操作页面
class DashboardWidget extends StatefulWidget {
  final params;
  DashboardWidget({Key key, this.params}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _DashboardWidgetState();
  }
}

class _DashboardWidgetState extends State<DashboardWidget> with AutomaticKeepAliveClientMixin {
  // var _params;
  List<Widget> pages;
  bool _showSidebar = true;
  int _selectIndex = 0;
  bool isInit = true;
  List<RouteHandler> drawerItems;
  dynamic token;
  bool isLogin = false;
  bool hasUserinfo = true;
  bool needLogin = false;
  Widget _getPages(int index) {
    if (pages[index] == null) {
      pages[index] = drawerItems[index].handler();
    }
    // print("当前页面$index:${drawerItems[index].title}");
    return pages[index];
  }

  @override
  void initState() {
    super.initState();
    // _params = widget.params;
    // 判断token参数
    if (widget.params != null) {
      if (widget.params["token"] != null) {
        token = widget.params["token"][0];
      }
    }
    drawerItems = Routes.getNeedsDrawerRegistry();
    if (drawerItems.length > 0) {
      pages = List(drawerItems.length);
      pages[0] = (drawerItems[0].handler());
    }
    _login();
  }

  // 判断是否登陆
  Future<bool> _isLogin() async {
    if (token != null) {
      await App.getUserByToken(token: token);
    } else {
      if (App.getToken() != null) {
        await App.getUserByToken(token: App.getToken());
      }
    }
    if (App.getToken() != null) return true;
    return false;
  }

  // 判断是否登陆
  void _login() {
    if (token != null) {
      if (App.userinfos.user == null) {
        hasUserinfo = false;
      }
      App.getUserByToken(token: token).then((d) {
        setState(() {
          hasUserinfo = true;
        });
      });
    } else {
      if (App.getToken() != null) {
        App.getUserByToken(token: App.getToken()).then((d) {
          setState(() {
            token = App.getToken();
            hasUserinfo = true;
          });
        });
      } else {
        setState(() {
          needLogin = true;
        });
      }
    }
  }

  Widget _buildPage() {
    if (ScreenUtils.isSmallScreen(context) && isInit) {
      _showSidebar = false;
      isInit = false;
    }
    final _media = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Material(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SideBarMenu(
                collapsed: _showSidebar,
                user: App.userinfos.user,
                items: drawerItems,
                onTap: (index) {
                  _selectIndex = index;
                  setState(() {});
                },
                show: (bool show) {
                  _showSidebar = show;
                  setState(() {});
                },
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: DashboardTheme.appBarHeight,
                      width: _media.width,
                      child: AppBar(
                        leading: !_showSidebar
                            ? IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.reorder),
                                onPressed: () {
                                  _showSidebar = true;
                                  setState(() {});
                                },
                              )
                            : Container(),
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
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return token == null
        ? (needLogin
            ? LoginPage(
                onLogin: (account, password) {
                  App.login(account, password).then((data) {
                    if (data != null) {
                      App.showAlertError(context, data);
                      return;
                    }
                    if (App.userinfos.user.email == null) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return ChangeEmailWidget();
                        },
                      ));
                    } else {
                      App.router.navigateTo(context, Routes.YxkhDashboard);
                    }
                  });
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ))
        : (hasUserinfo
            ? _buildPage()
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
  // @override
  // Widget build(BuildContext context) {
  //   super.build(context);
  //   return FutureBuilder(
  //     future: _isLogin(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         if (snapshot.data) {
  //           return _buildPage();
  //         }
  //         return LoginPage(
  //           onLogin: (account, password) {
  //             App.login(account, password).then((data) {
  //               if (data != null) {
  //                 App.showAlertError(context, data);
  //                 return;
  //               }
  //               if (App.userinfos.user.email == null) {
  //                 Navigator.of(context).push(MaterialPageRoute(
  //                   builder: (context) {
  //                     return ChangeEmailWidget();
  //                   },
  //                 ));
  //               } else {
  //                 App.router.navigateTo(context, Routes.YxkhDashboard);
  //               }
  //             });
  //           },
  //         );
  //       } else {
  //         return Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       }
  //     },
  //   );
  // }

  @override
  bool get wantKeepAlive => true;
}
