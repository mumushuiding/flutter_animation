import 'package:flutter/material.dart';
import 'package:yxkh_front/app.dart';
import 'package:yxkh_front/pages/dashboard.dart';
import 'package:yxkh_front/pages/user/login.dart';
import '../routes.dart';
import '../theme.dart';
import '../api/user_api.dart';
import 'menu_item_tile.dart';

class SideBarMenu extends StatefulWidget {
  final onTap;
  final show;
  final bool collapsed;
  final User user;
  final List<RouteHandler> items;
  SideBarMenu({Key key, this.onTap, this.show, this.collapsed, this.user, this.items}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _SideBarMenuState();
  }
}

class _SideBarMenuState extends State<SideBarMenu> with SingleTickerProviderStateMixin {
  var _onTap;
  var _show;
  User _user;
  double maxWidth = 250;
  double minWidgth = 70;
  bool collapsed = false;
  int selectedIndex = 0;
  bool isInit = true;
  AnimationController _animationController;
  Animation<double> _animation;
  List<RouteHandler> _items;

  @override
  void initState() {
    super.initState();
    _onTap = widget.onTap;
    _user = widget.user;
    _items = widget.items;
    if (_user == null) {
      _user = User();
    }

    _show = widget.show;
    _animationController = AnimationController(vsync: this, duration: Duration(microseconds: 50));
    _animation = Tween<double>(begin: maxWidth, end: minWidgth).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    collapsed = widget.collapsed;
    _animationController.reverse();
    return collapsed
        ? AnimatedBuilder(
            animation: _animation,
            builder: (BuildContext context, Widget child) {
              return Container(
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26, spreadRadius: 2)],
                    color: DashboardTheme.drawerBgColor,
                  ),
                  width: _animation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          color: DashboardTheme.drawerBgColor,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundImage: _user.avatar != null ? NetworkImage(_user.avatar) : null,
                                    backgroundColor: Colors.white,
                                    radius: _animation.value >= 250 ? 30 : 20,
                                  ),
                                  SizedBox(
                                    width: _animation.value >= 250 ? 20 : 0,
                                  ),
                                  (_animation.value >= 250)
                                      ? Row(
                                          children: <Widget>[
                                            Text(_user.name == null ? "张三" : _user.name,
                                                style: DashboardTheme.menuListTileDefaultText),
                                            IconButton(
                                              icon: Icon(Icons.settings_power),
                                              color: Colors.red,
                                              tooltip: "退出",
                                              onPressed: () {
                                                App.logOut();
                                                Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) {
                                                    return DashboardWidget();
                                                  },
                                                ));
                                              },
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ],
                              ),
                              SizedBox(
                                height: _animation.value >= 250 ? 20 : 0,
                              ),
                              (_animation.value >= 250)
                                  ? Text(
                                      _user.departmentname == null ? "部门:空" : "部门:${_user.departmentname}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  : Container(),
                              (_animation.value >= 250)
                                  ? Text(
                                      _user.position == null ? "空" : "职位:${_user.position}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  : Container(),
                              (_animation.value >= 250)
                                  ? Text(
                                      _user.email == null ? "邮箱:空" : "邮箱:${_user.email}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 1,
                        // width: 100,
                        alignment: Alignment.center,
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, counter) {
                            return Divider(
                              height: 2,
                            );
                          },
                          itemCount: _items.length,
                          itemBuilder: (BuildContext context, int index) {
                            return MenuItemTile(
                              title: _items[index].title,
                              icon: _items[index].icon,
                              animationController: _animationController,
                              isSelected: selectedIndex == index,
                              onTap: () {
                                selectedIndex = index;
                                if (_onTap != null) _onTap(index);
                              },
                            );
                          },
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          collapsed = !collapsed;
                          _show(collapsed);
                          collapsed ? _animationController.reverse() : _animationController.forward();
                        },
                        child: AnimatedIcon(
                          icon: AnimatedIcons.close_menu,
                          progress: _animationController,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ));
            },
          )
        : Container();
  }
}
