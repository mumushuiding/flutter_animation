import 'package:flutter/material.dart';
import 'package:yxkh_front/theme.dart';

class ChangePasswordWidget extends StatefulWidget {
  final Function onChange;
  ChangePasswordWidget({this.onChange});
  @override
  State<StatefulWidget> createState() {
    return _ChangePasswordWidgetState();
  }
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  FocusNode oldPassFocusNode = FocusNode();
  FocusNode newPassFocusNode = FocusNode();
  FocusScopeNode focusScopeNode = FocusScopeNode();
  GlobalKey<FormState> _formKey = GlobalKey();
  bool isShow = false;
  String oldPass = "";
  String newPass = "";
  @override
  void dispose() {
    oldPassFocusNode.dispose();
    newPassFocusNode.dispose();
    focusScopeNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
                                padding: const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                                child: TextFormField(
                                  focusNode: oldPassFocusNode,
                                  obscureText: !isShow,
                                  onEditingComplete: () {
                                    focusScopeNode.requestFocus(newPassFocusNode);
                                  },
                                  decoration: InputDecoration(
                                      icon: Icon(
                                        Icons.lock_outline,
                                        color: Colors.black,
                                      ),
                                      hintText: "旧密码",
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          isShow = !isShow;
                                          setState(() {});
                                        },
                                      ),
                                      border: InputBorder.none),
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                  onChanged: (value) {
                                    oldPass = value;
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "旧密码不能为空!";
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
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(left: 25, right: 25, top: 10),
                                child: TextFormField(
                                  focusNode: newPassFocusNode,
                                  decoration: InputDecoration(
                                    icon: Icon(
                                      Icons.vpn_key,
                                      color: Colors.black,
                                    ),
                                    hintText: "新密码",
                                    border: InputBorder.none,
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.remove_red_eye),
                                      color: Colors.black,
                                      onPressed: () {
                                        isShow = !isShow;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  obscureText: !isShow,
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                  onChanged: (value) {
                                    newPass = value;
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "新密码不能为空";
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
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                        }
                        if (oldPass.isNotEmpty && newPass.isNotEmpty) {
                          widget.onChange?.call(oldPass, newPass);
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
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
