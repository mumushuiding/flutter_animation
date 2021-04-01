import 'package:flutter/material.dart';
import 'package:yxkh_front/api/user_api.dart';
import 'package:yxkh_front/theme.dart';

import '../../app.dart';
import '../../routes.dart';

class ChangeEmailWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChangeEmailWidgetState();
  }
}

class _ChangeEmailWidgetState extends State<ChangeEmailWidget> {
  FocusNode emailFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();
  FocusNode focusScopeNode = FocusScopeNode();
  final _formKey = GlobalKey<FormState>();
  bool isShow = false;
  String pass = "";
  String email = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(gradient: DashboardTheme.primaryGradient),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: 75,
            ),
            Image(width: 250, height: 191, image: AssetImage("assets/images/login_logo.png")),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Text("请设置邮箱"),
                  Container(
                    decoration:
                        BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    width: 300,
                    height: 190,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                              child: TextFormField(
                                focusNode: emailFocusNode,
                                onEditingComplete: () {
                                  focusScopeNode.requestFocus(passFocusNode);
                                },
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.email,
                                    color: Colors.black,
                                  ),
                                  hintText: "邮箱",
                                ),
                                onChanged: (value) {
                                  email = value;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "邮箱不能为空";
                                  }
                                  return "";
                                },
                              ),
                            ),
                          ),
                          Container(
                            height: 1,
                            width: 250,
                            color: Colors.grey[400],
                          ),
                          Container(
                            height: 1,
                            width: 250,
                            color: Colors.grey[400],
                          ),
                          GestureDetector(
                            onTap: () {
                              if (email.isNotEmpty) {
                                UserAPI.updateUserinfo(App.userinfos.user.id, email: email).then((d) {
                                  if (d["status"] != 200) {
                                    App.showAlertError(context, d["message"]);
                                    return;
                                  }
                                  App.showAlertInfo(context, "成功");
                                  App.router.navigateTo(context, Routes.YxkhDashboard);
                                });
                              } else {
                                return;
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 42, right: 42, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  gradient: DashboardTheme.primaryGradient),
                              child: Text(
                                "确认",
                                style: TextStyle(fontSize: 25, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
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
