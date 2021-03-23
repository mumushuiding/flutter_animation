import 'package:rxdart/rxdart.dart';
import 'package:yxkh_front/api/response_data.dart';
import 'package:yxkh_front/api/yxkh_api.dart';

// 项目业务数据管理模块
abstract class ProjectBloc {
  Stream<List<Project>> get stream;
  Stream<double> get totalStream;
  set(List<Project> items);
  void findAllProjectWithMarks();
  void onUpdate(Project p);
  void onDelete(int id);
  void onAdd(String content, progress);

  void onAddMark(Project p, Mark mark, String username);
  void onDelMark(Project p, int id);

  void getTotalMark();
  void dispose();
  void setCandidate(String candidate);
  String get candidate;
}

class ProjectBlocImpl implements ProjectBloc {
  final String startDate;
  final String endDate;
  final int userid;
  // 审批人
  String candidate;
  double totalMark = 0.0;
  BehaviorSubject<List<Project>> _list$ = BehaviorSubject.seeded(List());
  BehaviorSubject<double> _total$ = BehaviorSubject.seeded(0.0);
  ProjectBlocImpl(this.startDate, this.endDate, this.userid) {
    findAllProjectWithMarks();
  }
  List<Project> items$ = List();
  @override
  void dispose() {
    _list$.close();
    items$.clear();
    _total$.close();
  }

  @override
  void findAllProjectWithMarks() {
    YxkhAPI.findAllProjectWithMarks(startDate: startDate, endDate: endDate, userid: userid).then((data) {
      set(Project.fromResponse(data));
    });
  }

  @override
  void onAdd(String content, progress) {
    if (content == null || content.length == 0) return;
    Project p = Project();
    p.startDate = startDate;
    p.endDate = endDate;
    p.userId = userid;
    p.projectContent = content;
    p.progress = progress;
    p.marks = List();

    YxkhAPI.addProject(p).then((data) {
      List<dynamic> datas = ResponseData.fromResponse(data);
      if (datas.length > 0) {
        p.projectId = datas[0][0];
        items$.add(p);
        _list$.add(items$);
      }
    });
  }

  @override
  void onDelete(int id) {
    YxkhAPI.delProject(id).then((data) {
      if (data["status"] == 200) {
        items$.removeWhere((item) => item.projectId == id);
        _list$.add(items$);
      }
    });
  }

  @override
  void onUpdate(Project p) {
    p.startDate = p.startDate.substring(0, 10);
    p.endDate = p.endDate.substring(0, 10);
    YxkhAPI.updateProject(p).then((data) {
      if (data["status"] == 200) {
        int index = items$.indexWhere((item) => item.projectId == p.projectId);
        items$[index] = p;
        _list$.add(items$);
      }
    });
  }

  @override
  set(List<Project> items) {
    if (items == null) return;
    items$ = items;
    _list$.add(items);
    this.getTotalMark();
    _total$.add(totalMark);
  }

  @override
  Stream<List<Project>> get stream => _list$.stream;

  @override
  void onAddMark(Project p, Mark mark, String username) {
    p.startDate = p.startDate.substring(0, 10);
    p.endDate = p.endDate.substring(0, 10);
    mark.startDate = p.startDate;
    mark.endDate = p.endDate;
    mark.userId = p.userId;
    mark.username = username;
    YxkhAPI.addMark(mark).then((data) {
      List<dynamic> datas = ResponseData.fromResponse(data);
      if (datas.length > 0) {
        mark.markId = datas[0][0];
        totalMark += double.parse(mark.markNumber);
        _total$.add(totalMark);
        var index = (items$.indexWhere((item) => item.projectId == p.projectId));
        items$[index].marks.add(mark);
        _list$.add(items$);
      }
    });
  }

  @override
  void onDelMark(Project p, int id) {
    YxkhAPI.delMark(id).then((data) {
      if (data["status"] == 200) {
        var index = (items$.indexWhere((item) => item.projectId == p.projectId));
        items$[index].marks.removeWhere((m) {
          if (m.markId == id) {
            totalMark -= double.parse(m.markNumber);
            _total$.add(totalMark);
            return true;
          }
          return false;
        });
        _list$.add(items$);
      }
    });
  }

  @override
  void getTotalMark() {
    items$.forEach((p) {
      p.marks.forEach((m) {
        // print(m.markNumber);
        totalMark += double.parse(m.markNumber);
      });
    });
  }

  @override
  Stream<double> get totalStream => _total$.stream;

  @override
  void setCandidate(String candidate1) {
    candidate = candidate1;
  }
}
