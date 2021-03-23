import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './api/response_data.dart';
import './utils/http_request.dart';


import 'api/user_api.dart';
import 'fluro_router.dart';
import 'routes.dart';
enum ENV{
  PRODUCTION,
  DEV,
}
class App {
  static const String ASSEST_IMG = 'assets/images/';
  static Map<String, dynamic> config;
  static FluroRouter router;
  static HttpRequest request;
  static Userinfos userinfos;
  static SharedPreferences sharedPreferences;

  // 加载配置
  static Future<void> loadConf() async{
    print('加载配置信息');
    // http连接
    request = HttpRequest(http.Client());
    // 变量
    // 加载用户信息
    userinfos=Userinfos();
    sharedPreferences=await SharedPreferences.getInstance();
    await getUserByToken();

    Routes.setRouters();
    // 路由
    App.router = FluroRouter();

   
    return;
  }
  static Future<void> getUserByToken({String token})async{
  
    String t;
    if (token!=null){
      t=token;
      setToken(token);
    }else{
      t=getToken();
    }
    print('初始化并查询用户数据token:$t');
    if (t==null) {
      return;
    }
    
    var data=await  UserAPI.getUserInfoByToken(t);
    // print("data:$data");
    if (data==null) return;
    if (data["status"]==200){
      ResponseData rd=ResponseData.fromJson(data["message"]);
      App.userinfos=Userinfos.fromResponse(rd);
    }
    return;
  }
  static String getToken(){
    return sharedPreferences.getString("token");
  }
  static void  setToken(String token){
   
    sharedPreferences.setString("token",token);

  }
  static void showAlertError(BuildContext context, String msg){
    showAlertDialog(context,Text('错误'),Text(msg));
  }
  static void showAlertInfo(BuildContext context, String msg){
    showAlertDialog(context,Text('消息'),Text(msg));
  }
  // showAlertDialog 弹出全局对话框 
  static void showAlertDialog(BuildContext context,Widget title,Widget content,{var callback}){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: title,
        content: content,
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              Navigator.of(context).pop();
              if (callback!=null) callback();
            },
            child: Text('确认'),
          ),
          FlatButton(
            color: Colors.grey,
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: Text("取消"),
          ),
        ],
      ),
    );
  }
  static dispose(){
    // print("=====关闭http连接=====");
    request.client.close();
  }
}
