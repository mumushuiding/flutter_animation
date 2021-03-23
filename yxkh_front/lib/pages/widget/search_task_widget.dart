import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yxkh_front/api/response_data.dart';
import 'package:yxkh_front/api/user_api.dart';
import 'package:yxkh_front/widget/select.dart';
import 'package:yxkh_front/widget/tree.dart';
import 'package:yxkh_front/widget/tree_select.dart';

import '../../app.dart';
// import 'package:yxkh_front/pages/widget/department_treee_widget.dart';
// SearchTaskWidget 搜索流程
class SearchTaskWidget extends StatefulWidget{
  final Map<String,dynamic> params;
  SearchTaskWidget({Key key,this.params}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return _SearchTaskWidgetState();
  }
}
class _SearchTaskWidgetState extends State<SearchTaskWidget> {
  List<dynamic> departments;
  TextEditingController post;
  TextEditingController username;
  TextEditingController dept;
  Map<String,dynamic> params;
  @override void dispose(){
    super.dispose();
    post.dispose();
    username.dispose();
    dept.dispose();
  }
  @override void initState(){
    super.initState();
    getDepartments();
    params = widget.params ?? Map();
    post=TextEditingController(text: "${params["postsValus"]??""}");
    username=TextEditingController(text: params["username"]);
    dept=TextEditingController(text: params["deptName"]??"");
  }
  void getDepartments(){
    UserAPI.getAllDepartments(refresh: false).then((data){
      if (data["status"]!=200){
        App.showAlertError(context,data["message"]);
        return;
      }
      var datas = ResponseData.fromResponse(data);
      setState(() {
        departments = datas[0];
      });
    });
  }
  @override
  Widget build(BuildContext context) {
     return Container(
      width: 400,
      height: 400,
      child: Column(
        children: <Widget>[
          // 部门查询
          TreeSelect(datas: departments,onChange: (ids,text){
              // print("ids:$ids,text:$text");
              params["deptName"]="${text.join(",")}";
              dept.text = "${text.join(",")}";
            },
            hintText: "选择部门",
            textEditingController: dept,
            valueTag: "name",
            keyTag: "id",
            multiple: true,
            initValue: params["deptName"]==null?[]:params["deptName"].split(","),
          ),
          // 职级查询
          Select(items: [{"id":0,"value":"普通员工"},{"id":1,"value":"中层副职"},{"id":2,"value":"中层正职"}],onChange: (keys,vals){
              if (vals!=null){
                post.text="${vals.join(",")}";
              }
              params["posts"]=keys;
              params["postsValus"]=vals;
            },
            textEditingController: post,
            valueTag: "value",
            keyTag: "id",
            hintText: "选择职级",
            multiple: true,
            initValue: params["postsValus"],
          ),
          // 人名查询
          Select(onChange: (keys,vals){
              username.text="${vals??""}";
              params["username"]=vals;
            },
            getRemoteDataFunc: (String filterStr)async{
              var data=await UserAPI.getUsers(filterStr);
              return ResponseData.fromResponse(data)[0];
            },
            textEditingController: username,
            valueTag: "name",
            keyTag: "id",
            hintText: "申请人真实姓名",
          )
        ],
      ),
    );
  }
  
}