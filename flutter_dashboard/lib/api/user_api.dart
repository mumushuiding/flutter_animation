import 'dart:convert';

import '../api.dart';
import '../app.dart';
import 'response_data.dart';

class UserAPI{
    // 获取token获取用户信息
  static Future<dynamic> getUserInfoByToken(String token){
    // print(API.base+"/user/getData");
    return App.request.post(API.base+"/user/getData",
      jsonEncode({"header":{"token":token},"body":{"method":"visit/user/userinfoByToken"}}));
  }

}
// 包含用户所有信息
class Userinfos{
  String token;
  User user;
  // 用户标签或角色
  List<Label> labels;
  Userinfos();
  Userinfos.fromResponse(ResponseData tj){
    token=tj.header.token;
    user=User.fromJson(tj.body.data[0]);
    labels=Label.fromList(tj.body.data[1]);
  }
  Map<String,dynamic> toJson(){
    final Map<String, dynamic> data = Map();
    data["token"]=token;
    if(user!=null) data["user"]=user.toJson();
    if(labels!=null){
      List<Map<String, dynamic>> ls=List();
      labels.forEach((l)=>ls.add(l.toJson()));
      data["labels"]=ls;
    }
    return data;
  }
}
class User{
  int id;
  String name;
  String departmentname;
  String mobile;
  String email;
  String avatar;
  String position;
  User();
  User.fromJson(Map<String,dynamic> json){
    name=json["name"];
    id=json["id"];
    departmentname=json["departmentname"];
    mobile=json["mobile"];
    email=json["email"];
    avatar=json["avatar"];
    position=json["position"];
  }
  Map<String,dynamic> toJson(){
    final Map<String, dynamic> json = Map();
    json["name"]=name;
    json["id"]=id;
    json["departmentname"]=departmentname;
    json["mobile"]=mobile;
    json["email"]=email;
    json["avatar"]=avatar;
    json["position"]=position;
    return json;
  }
  static List<User> fromList(List<dynamic> list){
    List<User> users=List();
    list.forEach((json){
      users.add(User.fromJson(json));
    });
    return users;
  }
}
// 用户标签,即用户角色
class Label{
  int labelid;
  int uId;
  String labelname;
  String describe;
  Label(this.labelid,this.labelname,this.describe);
  Label.fromJson(Map<String,dynamic> json){
    if (json["id"]==null){
      labelid=json["tagId"];
    } else {
      labelid=json["id"];
    }
    uId = json["uId"];
    labelname=json["tagName"];
    describe = json["describe"];
  }
  Map<String,dynamic> toJson(){
    final Map<String, dynamic> json = Map();
    json["id"]=labelid;
    json["tagName"]=labelname;
    json["describe"]=describe;
    return json;
  }
  static List<Label> fromList(List<dynamic> list){
    List<Label> labels=List();
    list.forEach((json){
      labels.add(Label.fromJson(json));
    });
    return labels;
  }
}