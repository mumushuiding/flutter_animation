import 'dart:convert';
import '../api.dart';
import '../app.dart';
import 'response_data.dart';

class UserAPI {
  // 登陆
  static Future<dynamic> login(String account, String password) {
    return App.request.post(API.base + "/user/login", jsonEncode({"password": password, "account": account}));
  }

  // 修改密码
  static Future<dynamic> alterPassword(String oldpass, String newpass) {
    return App.request.post(
        API.base + "/user/getData",
        jsonEncode({
          "header": {"token": App.getToken()},
          "body": {
            "method": "exec/user/alterPass",
            "params": {"old": oldpass, "new": newpass}
          }
        }));
  }

  // 忘记密码
  static Future<dynamic> forgetPassword(String email) {
    return App.request.post(
        API.base + "/user/getData",
        jsonEncode({
          "header": {"token": App.getToken()},
          "body": {
            "method": "exec/user/forgetPass",
            "metrics": {"email": email}
          }
        }));
  }

  // 获取token获取用户信息
  static Future<dynamic> getUserInfoByToken(String token) {
    // print(API.base+"/user/getData");
    return App.request.post(
        API.base + "/user/getData",
        jsonEncode({
          "header": {"token": token},
          "body": {"method": "visit/user/userinfoByToken"}
        }));
  }

  //查询用户 {"body":{"username":"张三","paged":false,"method":"visit/user/getUsers"}}
  static Future<dynamic> getUsers(String username) {
    // print(API.base+"/user/getData");
    return App.request.post(
        API.base + "/user/getData",
        jsonEncode({
          "body": {
            "method": "visit/user/getUsers",
            "username": username,
          }
        }));
  }

  // 参数格式:{"body":{"metrics":"id,name","params":{"where":"id=1 and name='xx'","userid":"","name":"","departmentid":"","departmentname":"","mobile":"","email":"",}}}metrics为显示的字段,where不为空时忽略其它查询条件
  static Future<dynamic> getAllUsers(String where, {String metric = "*"}) {
    // print(API.base+"/user/getData");
    return App.request.post(
        API.base + "/user/getData",
        jsonEncode({
          "body": {
            "method": "visit/user/findAll",
            "metrics": metric,
            "params": {"where": where}
          }
        }));
  }

  // ******************流程*******************
  // 查询流程执行情况
  static Future<dynamic> getFlowStepper(String processInstanceId) {
    // print(API.base+"/user/getData");
    return App.request.post(
        API.base + "/user/getData",
        jsonEncode({
          "body": {
            "method": "visit/flow/flowStepper",
            "params": {"processInstanceId": processInstanceId}
          }
        }));
  }

  static Future<dynamic> completeFlowTask(String processInstanceId, String businessType, int perform, {String speech}) {
    // print(API.base+"/user/getData");
    return App.request.post(
        API.base + "/user/getData",
        jsonEncode({
          "header": {"token": App.getToken()},
          "body": {
            "method": "exec/flow/completeFlowTask",
            "params": {"businessType": businessType, "thirdNo": processInstanceId, "perform": perform, "speech": speech}
          }
        }));
  }

  // 查询所有流程
  static Future<dynamic> findAllFlow(
      {String userId,
      int uid,
      String title,
      String titleLike,
      String businessType,
      String deptName,
      String candidate,
      String username,
      List<int> posts}) {
    // print(API.base+"/user/getData");
    return App.request.post(
        API.base + "/user/getData",
        jsonEncode({
          "header": {"token": App.getToken()},
          "body": {
            "method": "visit/flow/findall",
            "params": {
              "userId": userId,
              "uid": uid,
              "title": title,
              "titleLike": titleLike,
              "businessType": businessType,
              "deptName": deptName,
              "candidate": candidate,
              "username": username,
              "posts": posts
            }
          }
        }));
  }

  // 查询我的流程
  static Future<dynamic> getMyFlow({Map<String, dynamic> params}) {
    if (params == null) params = Map();
    params["userId"] = App.userinfos.user.userid;
    return App.request.post(
        API.base + "/user/getData",
        jsonEncode({
          "body": {"method": "visit/flow/findall", "paged": true, "params": params}
        }));
  }

  // 待审批流程查询
  static Future<dynamic> findTask({Map<String, dynamic> params}) {
    if (params == null) params = Map();
    // params["candidate"]=App.userinfos.user.userid;
    // params["completed"]=0;
    return App.request.post(
        API.base + "/user/getData",
        jsonEncode({
          "body": {"method": "visit/flow/findall", "paged": true, "params": params}
        }));
  }

  // 查询审批纪录
  //  参数格式:{"body":{"start_index":1,"max_results":15,"params":{"thirdNo":"fdfdf","userId":"linting","username":"张三"}}}
  // thirdNo 为流程ID
  static Future<dynamic> findFlowLog({Map<String, dynamic> params}) {
    if (params == null) params = Map();
    return App.request.post(
        API.base + "/user/getData",
        jsonEncode({
          "body": {"method": "visit/flow/log", "paged": true, "params": params}
        }));
  }

  //  ******************************* 部门 *****************************
  // 获取所有部门
  static Future<dynamic> getAllDepartments({bool paged = false, bool refresh = false}) {
    return App.request.post(
        API.base + "/user/getData",
        jsonEncode({
          "body": {"refresh": refresh, "paged": paged, "method": "visit/department/all"}
        }));
  }
}

// 包含用户所有信息
class Userinfos {
  String token;
  User user;
  // 用户标签或角色
  List<Label> labels;
  Userinfos();
  Userinfos.fromResponse(ResponseData tj) {
    token = tj.header.token;
    user = User.fromJson(tj.body.data[0]);
    labels = Label.fromList(tj.body.data[1]);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data["token"] = token;
    if (user != null) data["user"] = user.toJson();
    if (labels != null) {
      List<Map<String, dynamic>> ls = List();
      labels.forEach((l) => ls.add(l.toJson()));
      data["labels"] = ls;
    }
    return data;
  }
}

class User {
  int id;
  // 对应微信ID
  String userid;
  String name;
  String departmentname;
  String mobile;
  String email;
  String avatar;
  String position;
  User();
  User.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    id = json["id"];
    userid = json["userid"];
    departmentname = json["departmentname"];
    mobile = json["mobile"];
    email = json["email"];
    avatar = json["avatar"];
    position = json["position"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = Map();
    json["name"] = name;
    json["id"] = id;
    json["userid"] = userid;
    json["departmentname"] = departmentname;
    json["mobile"] = mobile;
    json["email"] = email;
    json["avatar"] = avatar;
    json["position"] = position;
    return json;
  }

  static List<User> fromList(List<dynamic> list) {
    List<User> users = List();
    list.forEach((json) {
      users.add(User.fromJson(json));
    });
    return users;
  }
}

// 用户标签,即用户角色
class Label {
  int labelid;
  int uId;
  String labelname;
  String describe;
  Label(this.labelid, this.labelname, this.describe);
  Label.fromJson(Map<String, dynamic> json) {
    if (json["id"] == null) {
      labelid = json["tagId"];
    } else {
      labelid = json["id"];
    }
    uId = json["uId"];
    labelname = json["tagName"];
    describe = json["describe"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = Map();
    json["id"] = labelid;
    json["tagName"] = labelname;
    json["describe"] = describe;
    return json;
  }

  static List<Label> fromList(List<dynamic> list) {
    List<Label> labels = List();
    list.forEach((json) {
      labels.add(Label.fromJson(json));
    });
    return labels;
  }
}

class Process {
  String processInstanceId;
  String title;
  String username;
  String businessType;
  String deptName;
  String candidate;
  int completed;
  String requestedDate;
  // 对应用户id
  int uid;
  // 对应用户微信id
  String userId;
  String deploymentId;
  bool selected;
  // 当前执行步骤
  int step;
  Process(this.title, this.businessType, {this.selected = false});
  static List<Process> fromResponse(Map<String, dynamic> data) {
    if (data["status"] != 200) {
      print("err:${data["message"]}");
      return null;
    }
    List<Process> datas = List();
    var rd = ResponseData.fromJson(data["message"]);
    rd.body.data[0].forEach((d) {
      datas.add(Process.fromJson(d));
    });
    return datas;
  }

  static List<Process> fromList(List<dynamic> list) {
    List<Process> ps = List();
    list.forEach((json) {
      ps.add(Process.fromJson(json));
    });
    return ps;
  }

  Process.fromJson(Map<String, dynamic> json) {
    processInstanceId = json["processInstanceId"];
    userId = json["userId"];
    uid = json["uid"];
    requestedDate = json["requestedDate"];
    title = json["title"];
    businessType = json["businessType"];
    deploymentId = json["deploymentId"];
    completed = json["completed"];
    deptName = json["deptName"];
    candidate = json["candidate"];
    username = json["username"];
    step = json["step"];
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json["processInstanceId"] = processInstanceId;
    json["userId"] = userId;
    json["uid"] = uid;
    json["requestedDate"] = requestedDate;
    json["title"] = title;
    json["businessType"] = businessType;
    json["deploymentId"] = deploymentId;
    json["completed"] = completed;
    json["deptName"] = deptName;
    json["candidate"] = candidate;
    json["username"] = username;
    json["step"] = step;
    return json;
  }
}
