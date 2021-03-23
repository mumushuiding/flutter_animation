import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yxkh_front/api/response_data.dart';
import 'package:yxkh_front/api/yxkh_api.dart';
import 'package:yxkh_front/blocs/project_bloc.dart';
import 'package:yxkh_front/widget/select.dart';

import '../../app.dart';

class AddMarkWidget extends StatelessWidget {
  final Project p;
  final ProjectBlocImpl bloc;
  final callback;
  final String username;
  final TextEditingController mark = TextEditingController();
  final TextEditingController reason = TextEditingController();
  final TextEditingController according = TextEditingController();
  AddMarkWidget({Key key, this.p, this.bloc, this.callback, this.username})
      : assert(bloc != null, username != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 500,
      child: Column(
        children: <Widget>[
          TextField(
            controller: mark,
            inputFormatters: [WhitelistingTextInputFormatter(RegExp('[\-|0-9]+[.]{0,1}[0-9]*[dD]{0,1}'))],
            decoration: InputDecoration(
                hintText: "分数：",
                contentPadding: EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide(color: Colors.grey))),
          ),
          TextField(
            maxLines: 10,
            controller: reason,
            decoration: InputDecoration(
                hintText: "理由：",
                contentPadding: EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide(color: Colors.grey))),
          ),
          Select(
            onChange: (keys, vals) {
              according.text = vals;
            },
            getRemoteDataFunc: (String filterStr) async {
              var data = await YxkhAPI.findDict(name: "评分依据", value: filterStr);
              return ResponseData.fromResponse(data)[0];
            },
            valueTag: "value",
            inputDecoration: InputDecoration(contentPadding: EdgeInsets.all(10.0), hintText: "输入查询条件,如：加分项"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                color: Colors.blue,
                onPressed: () {
                  if (mark.text.trim() == "") {
                    App.showAlertError(context, "分数不能为空");
                    return;
                  }
                  Mark m = Mark(p.projectId, mark.text, this.reason.text, this.according.text);
                  this.bloc.onAddMark(p, m, username);
                  Navigator.of(context).pop();
                  if (callback != null) callback();
                },
                child: Text('确认'),
              ),
              FlatButton(
                color: Colors.grey,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("取消"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
