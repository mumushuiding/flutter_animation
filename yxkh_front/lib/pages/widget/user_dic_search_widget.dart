import 'package:flutter/material.dart';
import 'package:yxkh_front/api/response_data.dart';
import 'package:yxkh_front/api/user_api.dart';
import 'package:yxkh_front/widget/user_autocomplete_widget.dart';

import '../../app.dart';

class UserDicSearchWidget extends StatefulWidget {
  //如：“考核组”
  final String type;
  final double textFieldWidth;
  final Function(dynamic vals) callback;
  UserDicSearchWidget({@required this.type, this.textFieldWidth = 100, this.callback});
  @override
  State<StatefulWidget> createState() {
    return _UserDicSearchWidgetState();
  }
}

class _UserDicSearchWidgetState extends State<UserDicSearchWidget> {
  List<dynamic> datas = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            width: widget.textFieldWidth,
            child: UserAutocompleteWidget(
              callback: (keys, vals) {
                UserAPI.findUserLabel(userid: keys, labeltype: widget.type).then((d) {
                  if (d["status"] != 200) {
                    App.showAlertError(context, d["message"]);
                    return;
                  }
                  setState(() {
                    datas = ResponseData.fromResponse(d)[0];
                    widget.callback?.call(datas);
                  });
                });
              },
            )),
        Container(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: datas.length,
            itemBuilder: (context, index) {
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.green), color: Color(0XFFF6FFEE)),
                child: Text(
                  "${datas[index]["tagName"]}",
                  style: TextStyle(color: Color(0xFF72CE4A)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
