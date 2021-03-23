import 'package:rxdart/rxdart.dart';
import 'package:yxkh_front/api/user_api.dart';
import 'package:yxkh_front/api/yxkh_api.dart';

import '../app.dart';

// 待审批页面业务数据管理模块
abstract class FlowTaskBloc {
  Stream<List<dynamic>> get taskStream;
  Stream<List<dynamic>> get taskHistoryStream;
  setTask(List<dynamic> items);
  setHistory(List<dynamic> items);
  Map<String, dynamic> get params;
  // 查询任务
  // void onSearchProcess(Map<String,dynamic> params);
  // 删除流程
  void onDeleteProcess(String processInstanceId, String businessType);
  // 查询任务
  void onSearchTask(Map<String, dynamic> params);
  // 搜索历史任务
  void onSearchTaskHistory(Map<String, dynamic> params);
  // 审批任务
  void onCompleteTask(dynamic process, dynamic log);
  void onAddTaskHistory(dynamic process, dynamic flowlog);
  void onAddTask(dynamic process);
  void dispose();
}

class FlowTaskBlocImpl implements FlowTaskBloc {
  // 查询待审批任务的参数
  Map<String, dynamic> params;
  // 查询已审批任务的参数
  Map<String, dynamic> paramsHistory;
  BehaviorSubject<List<dynamic>> _taskList = BehaviorSubject.seeded(List());
  List<dynamic> _curTaskList;
  List<dynamic> _curTaskHistoryList = List();
  BehaviorSubject<List<dynamic>> _taskHistoryList = BehaviorSubject.seeded(List());
  FlowTaskBlocImpl({this.params, this.paramsHistory}) {
    // 查询待审批任务
    onSearchTask(params);
    // 查询审批历史
    onSearchTaskHistory(paramsHistory);
  }
  @override
  void dispose() {
    _taskList.close();
    _taskHistoryList.close();
    _curTaskList?.clear();
  }

  @override
  Stream<List<dynamic>> get taskStream => _taskList.stream;

  @override
  Stream<List<dynamic>> get taskHistoryStream => _taskHistoryList.stream;
  @override
  void onCompleteTask(dynamic process, dynamic log, {bool delete = false}) {
    int index = _curTaskList.indexWhere((d) => d["processInstanceId"] == process["processInstanceId"]);
    if (index == -1) return;
    if (delete) {
      _curTaskList.removeAt(index);
    } else {
      _curTaskList[index] = process;
    }
    _taskList.add(_curTaskList);
    // 增加一条审批纪录
    log["processname"] = process["title"];
    _curTaskHistoryList.insert(0, log);
    _taskHistoryList.add(_curTaskHistoryList);
  }

  @override
  void onAddTask(dynamic process) {
    _curTaskList.insert(0, process);
    _taskList.add(_curTaskList);
  }

  @override
  void onSearchTask(Map<String, dynamic> par) {
    if (par == null || par.length == 0) return;
    // print("查询我的审批任务");
    if (App.userinfos.user == null) return;
    UserAPI.findTask(params: par).then((data) {
      setTask(data["rows"]);
    });
  }

  @override
  void onSearchTaskHistory(Map<String, dynamic> par) {
    if (par == null || par.length == 0) return;
    UserAPI.findFlowLog(params: par).then((data) {
      if (data["status"] == 200) {
        _taskHistoryList.addError(data["message"]);
        return;
      }
      setHistory(data["rows"]);
    });
  }

  @override
  setHistory(List<dynamic> items) {
    if (items == null) {
      items = [];
    }
    _curTaskHistoryList = items;
    _taskHistoryList.add(items);
  }

  @override
  setTask(List<dynamic> items) {
    // print("task:$items");
    if (items == null) {
      items = [];
    }
    _curTaskList = items;
    _taskList.add(items);
  }

  @override
  void onDeleteProcess(String processInstanceId, String businessType) {
    YxkhAPI.delFlow(processInstanceId: processInstanceId, businessType: businessType).then((data) {
      if (data["status"] == 200) {
        _curTaskList.removeWhere((t) => t["processInstanceId"] == processInstanceId);
        _taskList.add(_curTaskList);
      }
    });
  }

  @override
  void onAddTaskHistory(dynamic process, dynamic flowlog) {
    // 当撤回时，新增条纪录
    flowlog["processname"] = process["title"];
    // print("添加新的纪录:$flowlog");
    _curTaskHistoryList.insert(0, flowlog);
    _taskHistoryList.add(_curTaskHistoryList);
    // 待审批页面增加一条
    int index = _curTaskList.indexWhere((d) => d["processInstanceId"] == process["processInstanceId"]);
    if (index == -1) {
      _curTaskList.insert(0, process);
    } else {
      _curTaskList[index] = process;
    }
    _taskList.add(_curTaskList);
  }
}
