import 'package:flutter/material.dart';
import 'package:yxkh_front/api/response_data.dart';
import 'package:yxkh_front/api/user_api.dart';
import 'package:yxkh_front/widget/select.dart';

import '../app.dart';

class UserAutocompleteWidget extends StatelessWidget {
  final Function(dynamic keys, dynamic vals) callback;
  UserAutocompleteWidget({@required this.callback});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Select(
        onChange: (keys, vals) {
          callback?.call(keys, vals);
        },
        getRemoteDataFunc: (String filter) async {
          var data = await UserAPI.getUsers(filter);
          if (data["status"] != 200) {
            App.showAlertError(context, data["message"]);
            return [];
          }
          var datas = ResponseData.fromResponse(data);
          return datas[0];
        },
        valueTag: "name",
        keyTag: "id",
        inputDecoration: InputDecoration(prefixIcon: Icon(Icons.person), hintText: "输入姓名"),
      ),
    );
  }
}
