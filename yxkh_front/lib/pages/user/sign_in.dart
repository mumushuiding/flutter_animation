import 'package:flutter/material.dart';
import 'package:yxkh_front/api/user_api.dart';
import 'package:yxkh_front/theme.dart';

import '../../app.dart';

class SignInPage extends StatefulWidget {
  final Function onLogin;
  SignInPage({this.onLogin});
  @override
  _SignInPageState createState() => new _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  /*
   * 利用FocusNode和FocusScopeNode来控制焦点
   * 可以通过FocusNode.of(context)来获取widget树中默认的FocusScopeNode
   */
  FocusNode emailFocusNode = new FocusNode();
  FocusNode passwordFocusNode = new FocusNode();
  FocusScopeNode focusScopeNode = new FocusScopeNode();

  GlobalKey<FormState> _SignInFormKey = new GlobalKey();
  String account = "";
  String password = "";
  bool isShowPassWord = false;
  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    focusScopeNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: new Stack(
        alignment: Alignment.center,
//        /**
//         * 注意这里要设置溢出如何处理，设置为visible的话，可以看到孩子，
//         * 设置为clip的话，若溢出会进行裁剪
//         */
//        overflow: Overflow.visible,
        children: <Widget>[
          new Column(
            children: <Widget>[
              //创建表单
              buildSignInTextForm(),
              buildSignInButton(),
              /**
               * Or所在的一行
               */
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      height: 1,
                      width: 100,
                      decoration: BoxDecoration(gradient: DashboardTheme.primaryGradient),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: new Text(
                        "Or",
                        style: new TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    new Container(
                      height: 1,
                      width: 100,
                      decoration: BoxDecoration(
                          gradient: new LinearGradient(colors: [
                        Colors.white,
                        Colors.white10,
                      ])),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: InkWell(
                    child: new Text(
                      "忘记密码?",
                      style: new TextStyle(fontSize: 16, color: Colors.white, decoration: TextDecoration.underline),
                    ),
                    onTap: () {
                      String email = "";
                      App.showAlertDialog(
                          context,
                          Text("找回密码"),
                          Container(
                            child: TextFormField(
                              onChanged: (value) {
                                email = value;
                              },
                              decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.email,
                                    color: Colors.black,
                                  ),
                                  hintText: "请输入邮箱",
                                  border: InputBorder.none),
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ), callback: () {
                        if (email.isNotEmpty) {
                          UserAPI.forgetPassword(email).then((d) {
                            if (d["status"] != 200) {
                              App.showAlertError(context, d["message"]);
                              return;
                            }
                            App.showAlertInfo(context, "成功，新密码已发送至邮箱，请查阅");
                          });
                        }
                      });
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) {
                      //     return ForgetPasswordPage();
                      //   },
                      // ));
                    },
                  )),

              // /**
              //  * 显示第三方登录的按钮
              //  */
              // new SizedBox(
              //   height: 10,
              // ),
              // new Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     new Container(
              //       padding: EdgeInsets.all(10),
              //       decoration: BoxDecoration(
              //         shape: BoxShape.circle,
              //         color: Colors.white,
              //       ),
              //       child: new IconButton(
              //           icon: Icon(
              //             Icons.ac_unit,
              //             color: Color(0xFF0084ff),
              //           ),
              //           onPressed: null),
              //     ),
              //     new SizedBox(
              //       width: 40,
              //     ),
              //     new Container(
              //       padding: EdgeInsets.all(10),
              //       decoration: BoxDecoration(
              //         shape: BoxShape.circle,
              //         color: Colors.white,
              //       ),
              //       child: new IconButton(
              //           icon: Icon(
              //             Icons.access_alarm,
              //             color: Color(0xFF0084ff),
              //           ),
              //           onPressed: null),
              //     ),
              //   ],
              // ),
            ],
          ),
        ],
      ),
    );
  }

  /*
   * 点击控制密码是否显示
   */
  void showPassWord() {
    setState(() {
      isShowPassWord = !isShowPassWord;
    });
  }

  /*
   * 创建登录界面的TextForm
   */
  Widget buildSignInTextForm() {
    return new Container(
      decoration: new BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), color: Colors.white),
      width: 300,
      height: 190,
      /**
       * Flutter提供了一个Form widget，它可以对输入框进行分组，
       * 然后进行一些统一操作，如输入内容校验、输入框重置以及输入内容保存。
       */
      child: new Form(
        key: _SignInFormKey,
        //开启自动检验输入内容，最好还是自己手动检验，不然每次修改子孩子的TextFormField的时候，其他TextFormField也会被检验，感觉不是很好
//        autovalidate: true,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 20),
                child: new TextFormField(
                  //关联焦点
                  focusNode: emailFocusNode,
                  onEditingComplete: () {
                    if (focusScopeNode == null) {
                      focusScopeNode = FocusScope.of(context);
                    }
                    focusScopeNode.requestFocus(passwordFocusNode);
                  },

                  decoration: new InputDecoration(
                      icon: new Icon(
                        Icons.people,
                        color: Colors.black,
                      ),
                      hintText: "姓名/手机",
                      border: InputBorder.none),
                  style: new TextStyle(fontSize: 16, color: Colors.black),
                  onChanged: (value) {
                    account = value;
                  },
                  //验证
                  validator: (value) {
                    if (value.isEmpty) {
                      return "姓名或手机号不能为空!";
                    }
                    return "";
                  },
                  onSaved: (value) {},
                ),
              ),
            ),
            new Container(
              height: 1,
              width: 250,
              color: Colors.grey[400],
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                child: new TextFormField(
                  focusNode: passwordFocusNode,
                  decoration: new InputDecoration(
                      icon: new Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      hintText: "密码",
                      border: InputBorder.none,
                      suffixIcon: new IconButton(
                          icon: new Icon(
                            Icons.remove_red_eye,
                            color: Colors.black,
                          ),
                          onPressed: showPassWord)),
                  //输入密码，需要用*****显示
                  obscureText: !isShowPassWord,
                  style: new TextStyle(fontSize: 16, color: Colors.black),
                  onChanged: (value) {
                    password = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "密码不能为空";
                    }
                    return "";
                  },
                  onSaved: (value) {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*
   * 创建登录界面的按钮
   */
  Widget buildSignInButton() {
    return new GestureDetector(
      child: new Container(
        padding: EdgeInsets.only(left: 42, right: 42, top: 10, bottom: 10),
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)), gradient: DashboardTheme.primaryGradient),
        child: new Text(
          "登陆",
          style: new TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
      onTap: () {
        /**利用key来获取widget的状态FormState
              可以用过FormState对Form的子孙FromField进行统一的操作
           */
        final form = _SignInFormKey.currentState;
        if (form.validate()) {
          //调用所有自孩子的save回调，保存表单内容
          form.save();
        }
        if (account.isNotEmpty && password.isNotEmpty) {
          widget.onLogin?.call(account, password);
        }
      },
    );
  }
}
