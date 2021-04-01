// YxkhAPI 一线考核API接口
import 'dart:convert';
import 'dart:html';

import 'package:http/http.dart';
import 'package:yxkh_front/api/response_data.dart';

import '../api.dart';
import '../app.dart';

class YxkhAPI {
  // ******************************** 流程 ********************************************
  // 启动流程
  // perform: 默认0直接提交，1为保存不提交
  // businessType: 必填
  static Future<dynamic> startProcess(Map<String, dynamic> data, String title, String templateId, businessType,
      {int perform}) {
    return App.request.post(
        API.base + "/yxkh/getData",
        jsonEncode({
          "header": {"token": App.getToken()},
          "body": {
            "method": "exec/yxkh/startProcess",
            "params": {
              "perform": perform,
              "title": title,
              "templateId": templateId,
              "businessType": businessType,
              "data": data
            }
          }
        }));
  }

  // 审批流程 perform,2、3、4、5 分别表示:通过、驳回、转审、撤消
  static Future<dynamic> completeProcess(Map<String, dynamic> data, String businessType, int perform,
      {String speech, String processInstanceId}) {
    return App.request.post(
        API.base + "/yxkh/getData",
        jsonEncode({
          "header": {"token": App.getToken()},
          "body": {
            "method": "exec/yxkh/completeProcess",
            "params": {
              "perform": perform,
              "processInstanceId": processInstanceId,
              "businessType": businessType,
              "data": data,
              "speech": speech
            }
          }
        }));
  }

  // 查询流程数据{"body":{"method":"visit/yxkh/findFlowDatas","params":{"processInstanceId":"DCg6QkLx61yQEB","businessType":"月度考核"}}}
  static Future<dynamic> findFlowDatas(String processInstanceId, businessType) {
    return App.request.post(
        API.base + "/yxkh/getData",
        jsonEncode({
          "body": {
            "method": "visit/yxkh/findFlowDatas",
            "params": {"processInstanceId": processInstanceId, "businessType": businessType}
          }
        }));
  }

// saveEvalutaion 保存数据
  static Future<dynamic> saveEvalutaion(Map<String, dynamic> e) {
    return App.request.post(
        API.base + "/yxkh/getData",
        jsonEncode({
          "body": {"method": "exec/yxkh/saveEvaluation", "params": e}
        }));
  }

  // 删除流程数据
  static Future<dynamic> delFlow({String processInstanceId, businessType}) {
    return App.request.post(
        API.base + "/yxkh/getData",
        jsonEncode({
          "body": {
            "method": "exec/yxkh/delFlow",
            "params": {"processInstanceId": processInstanceId, "businessType": businessType}
          }
        }));
  }

  // ********************************* 项目 *********************************************
  // 查询项目及项目分数
  static Future<dynamic> findAllProjectWithMarks({String startDate, String endDate, int userid}) {
    return App.request.post(
        API.base + "/yxkh/getData",
        jsonEncode({
          "body": {
            "method": "visit/yxkh/findAllProjectWithMarks",
            "params": {"userId": userid, "startDate": startDate, "endDate": endDate}
          }
        }));
  }

// 添加上月项目
  static Future<dynamic> addLastMonthProject(int userid) {
    return App.request.post(
        API.base + "/yxkh/getData",
        jsonEncode({
          "body": {"method": "visit/yxkh/addLastMonthProject", "user_id": userid}
        }));
  }

  // 添加项目
  static Future<dynamic> addProject(Project project) {
    return App.request.post(
        API.base + "/yxkh/getData",
        jsonEncode({
          "body": {
            "method": "exec/yxkh/addProject",
            "params": {
              "data": [project.toJson()]
            }
          }
        }));
  }

  // 删除项目
  static Future<dynamic> delProject(int id) {
    return App.request.post(
        API.base + "/yxkh/getData",
        jsonEncode({
          "body": {
            "method": "exec/yxkh/delProject",
            "params": {
              "ids": [id]
            }
          }
        }));
  }

  // 修改项目
  static Future<dynamic> updateProject(Project project) {
    return App.request.post(
        API.base + "/yxkh/getData",
        jsonEncode({
          "body": {
            "method": "exec/yxkh/updateProject",
            "params": {"data": project.toJson()}
          }
        }));
  }

  // 添加分数
  static Future<dynamic> addMark(Mark mark) {
    return App.request.post(
        API.base + "/yxkh/getData",
        jsonEncode({
          "body": {
            "method": "exec/yxkh/addMark",
            "data": [
              [mark.toJson()]
            ]
          }
        }));
  }

  // 删除分数
  static Future<dynamic> delMark(int id) {
    return App.request.post(
        API.base + "/yxkh/getData",
        jsonEncode({
          "body": {
            "method": "exec/yxkh/delMark",
            "params": {
              "ids": [id]
            }
          }
        }));
  }

  // 修改分数
  static Future<dynamic> updateMark(Mark mark) {
    return App.request.post(
        API.base + "/yxkh/getData",
        jsonEncode({
          "body": {
            "method": "exec/yxkh/updateMark",
            "params": {"mark": mark.toJson()}
          }
        }));
  }

  // 查询字典
  static Future<dynamic> findDict({String name, value, type, type2}) {
    return App.request.post(
        API.base + "/yxkh/getData",
        jsonEncode({
          "body": {
            "method": "visit/yxkh/findDict",
            "params": {"name": name, "value": value, "type": type, "type2": type2}
          }
        }));
  }

// sumMarks 加减分合计
  static Future<dynamic> sumMarks({String startDate, String endDate, int userId}) {
    return App.request.post(
        API.base + "/yxkh/getData",
        jsonEncode({
          "body": {
            "method": "visit/yxkh/sumMarks",
            "params": {"startDate": startDate, "endDate": endDate, "userId": userId}
          }
        }));
  }

  // scoreShare 根据部门查询年度或半年考核评分占比
  static Future<dynamic> scoreShare(String department) {
    return App.request.post(
        API.base + "/yxkh/getData",
        jsonEncode({
          "body": {
            "method": "visit/yxkh/scoreShare",
            "params": {"name": department}
          }
        }));
  }

  // 导入群众评议
  static Future<dynamic> importPulicAssessment() {
    return App.request
        .upload(token: App.getToken(), uri: API.base + "/yxkh/import", method: "exec/yxkh/importPublicAssess");
  }

// importMarks 导入加减分
  static Future<dynamic> importMarks({String checked}) {
    return App.request.upload(
        token: App.getToken(), uri: API.base + "/yxkh/import", method: "exec/yxkh/importMarks", checked: checked);
  }
}

class Project {
  int projectId;
  int userId;
  String projectName;
  String projectContent;
  String startDate;
  String endDate;
  String progress;
  List<Mark> marks;
  Project();
  static List<Project> fromResponse(Map<String, dynamic> data) {
    if (data["status"] != 200) {
      print("err:${data["message"]}");
      return null;
    }
    List<Project> pros = List();
    ResponseData rd = ResponseData.fromJson(data["message"]);
    rd.body.data[0].forEach((d) {
      pros.add(Project.fromJson(d));
    });
    return pros;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json["projectId"] = projectId;
    json["userId"] = userId;
    json["projectContent"] = projectContent;
    json["startDate"] = startDate;
    json["endDate"] = endDate;
    json["progress"] = progress;
    return json;
  }

  Project.fromJson(Map<String, dynamic> json) {
    projectId = json["projectId"];
    userId = json["userId"];
    projectName = json["projectName"];
    projectContent = json["projectContent"];
    startDate = json["startDate"];
    endDate = json["endDate"];
    progress = json["progress"];
    marks = Mark.fromList(json["marks"]);
  }
}

class Mark {
  int markId;
  int projectId;

  int userId;
  String username;
  String startDate;
  String endDate;

  String markNumber;
  String markReason;
  String accordingly;
  Mark(this.projectId, this.markNumber, this.markReason, this.accordingly);
  Mark.fromJson(Map<String, dynamic> json) {
    markId = json["markId"];
    projectId = json["projectId"];
    markNumber = json["markNumber"];
    markReason = json["markReason"];
    accordingly = json["accordingly"];
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json["markId"] = markId;
    json["projectId"] = projectId;
    json["markNumber"] = markNumber;
    json["markReason"] = markReason;
    json["accordingly"] = accordingly;
    json["userId"] = userId;
    json["username"] = username;
    json["startDate"] = startDate;
    json["endDate"] = endDate;
    return json;
  }

  static List<Mark> fromList(List<dynamic> list) {
    if (list == null) return null;
    List<Mark> mark = List();
    list.forEach((l) {
      mark.add(Mark.fromJson(l));
    });
    return mark;
  }
}

class Dict {
  int id;
  String value;

  String toString() {
    return value;
  }

  Dict.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    value = json["value"];
  }
  static List<Dict> fromResponse(Map<String, dynamic> data) {
    if (data["status"] != 200) {
      print("err:${data["message"]}");
      return null;
    }
    List<Dict> result = List();
    ResponseData rd = ResponseData.fromJson(data["message"]);
    rd.body.data[0].forEach((d) {
      result.add(Dict.fromJson(d));
    });
    return result;
  }

  static List<Dict> fromList(List<dynamic> list) {
    if (list == null) return null;
    List<Dict> data = List();
    list.forEach((l) => data.add(Dict.fromJson(l)));
    return data;
  }
}

abstract class FlowData {
  Map<String, dynamic> toJson();
}

class Evaluation implements FlowData {
  int eId;
  int uid;
  String username;
  String department;
  String position;
  String startDate;
  String endDate;
  String processInstanceId;
  String selfEvaluation;
  String attendance;
  String overseerEvaluation;
  // 半年或全年考核 领导点评
  String leadershipEvaluation;
  // 半年或全年考核 群众评议
  String publicEvaluation;
  // 半年或全年考核 组织考核
  String organizationEvaluation;
  // 半年或全年考核 TotalMark 总分
  String totalMark;
  // 半年或全年考核 Marks 考效总分,即考核量化分，即加减分总和
  String marks;
  String evaluationType;
  String createTime;
  String shortComesAndPlan;
  String sparation;
  String leadershipRemark;
  String committed;
  String overseerRemark;
  String publicRemark;
  // 半年或全年考核 考核结果
  String result;
  Evaluation();
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json["eId"] = eId;
    json["uid"] = uid;
    json["position"] = position;
    json["startDate"] = startDate;
    json["endDate"] = endDate;
    json["processInstanceId"] = processInstanceId;
    json["selfEvaluation"] = selfEvaluation;
    json["attendance"] = attendance;
    json["overseerEvaluation"] = overseerEvaluation;
    json["leadershipEvaluation"] = leadershipEvaluation;
    json["publicEvaluation"] = publicEvaluation;
    json["organizationEvaluation"] = organizationEvaluation;
    json["totalMark"] = totalMark;
    json["marks"] = marks;
    json["evaluationType"] = evaluationType;
    json["createTime"] = createTime;
    json["shortComesAndPlan"] = shortComesAndPlan;
    json["sparation"] = sparation;
    json["leadershipRemark"] = leadershipRemark;
    json["committed"] = committed;
    json["overseerRemark"] = overseerRemark;
    json["publicRemark"] = publicRemark;
    json["result"] = result;
    json["username"] = username;
    json["department"] = department;
    return json;
  }

  Evaluation.fromJson(Map<String, dynamic> json) {
    eId = json["eId"];
    uid = json["uid"];
    username = json["username"];
    position = json["position"];
    startDate = json["startDate"];
    endDate = json["endDate"];
    processInstanceId = json["processInstanceId"];
    selfEvaluation = json["selfEvaluation"];
    attendance = json["attendance"];
    overseerEvaluation = json["overseerEvaluation"];
    leadershipEvaluation = json["leadershipEvaluation"];
    publicEvaluation = json["publicEvaluation"];
    organizationEvaluation = json["organizationEvaluation"];
    totalMark = json["totalMark"];
    marks = json["marks"];
    evaluationType = json["evaluationType"];
    createTime = json["createTime"];
    shortComesAndPlan = json["shortComesAndPlan"];
    sparation = json["sparation"];
    leadershipRemark = json["leadershipRemark"];
    committed = json["committed"];
    overseerRemark = json["overseerRemark"];
    publicRemark = json["publicRemark"];
    result = json["result"];
    department = json["department"];
  }
}
