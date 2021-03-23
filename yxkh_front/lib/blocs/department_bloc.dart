// // 部门业务逻辑
// import 'package:rxdart/rxdart.dart';
// import 'package:yxkh_front/api/response_data.dart';
// import 'package:yxkh_front/api/user_api.dart';
// import 'package:yxkh_front/widget/tree.dart';

// abstract class DepartmentBloc {
//   Stream<List<TreeData>> get stream;
//   void dispose();
//   void onSearch();
// }
// class DepartmentBlocImpl implements DepartmentBloc{
//   BehaviorSubject<List<TreeData>> _datas=BehaviorSubject.seeded(List());
//   List<TreeData> _curDatas=List();
//   DepartmentBlocImpl(){
//     onSearch();
//   }
//   @override
//   void dispose() {
//     _datas.close();
//     _curDatas.clear();
//   }

//   @override
//   Stream<List<TreeData>> get stream => _datas.stream;

//   @override
//   void onSearch() {
//     UserAPI.getAllDepartments(refresh: false).then((data){
//       if (data["status"]!=200){
//         _datas.addError(data["message"]);
//         return;
//       }
//       var datas = ResponseData.fromResponse(data);
//       _curDatas = TreeData.fromList(datas[0]);
//       _datas.add(_curDatas);
//     });
//   }
  
// }