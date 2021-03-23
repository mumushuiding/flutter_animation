import 'package:flutter/material.dart';
import 'package:yxkh_front/api/response_data.dart';
import 'package:yxkh_front/api/user_api.dart';
import 'package:yxkh_front/blocs/flow_task_bloc.dart';
import 'package:yxkh_front/pages/apply/flow_information_card.dart';
import 'package:yxkh_front/pages/widget/flow_process_card.dart';

import '../../app.dart';

// FlowPage 流程页面
class FlowPage extends StatefulWidget {
  final Process process;
  final FlowTaskBlocImpl bloc;
  final dynamic reason;
  FlowPage({@required this.process, @required this.bloc, this.reason});
  @override
  State<StatefulWidget> createState() {
    return _FlowPageState();
  }
}

class _FlowPageState extends State<FlowPage> {
  List<dynamic> flowProcess;
  Map<String, dynamic> flowdata;
  // 申请事由
  dynamic reason;
  @override
  void initState() {
    flowdata = {
      "title": widget.process.title,
      "username": widget.process.username,
      "businessType": widget.process.businessType,
      "deptName": widget.process.deptName,
      "requestedDate": widget.process.requestedDate,
    };
    flowProcess = [
      [
        {
          "itemName": "张凌",
          "ItemParty": "技术中心",
          "ItemImage": "http://wework.qpic.cn/bizmail/1rd07pC6CQuL6FOn0pOxPic3Dk7zE7NPt45a0ugszXiag78q7iaZUsltA/0",
          "ItemStatus": 1,
          "ItemSpeech": "",
          "ItemOpTime": 0
        }
      ],
      [
        {
          "itemName": "张凌",
          "ItemParty": "技术中心",
          "ItemImage": "http://wework.qpic.cn/bizmail/1rd07pC6CQuL6FOn0pOxPic3Dk7zE7NPt45a0ugszXiag78q7iaZUsltA/0",
          "ItemStatus": 1,
          "ItemSpeech": "",
          "ItemOpTime": 0
        }
      ],
      [
        {
          "itemName": "张凌",
          "ItemParty": "技术中心",
          "ItemImage": "http://wework.qpic.cn/bizmail/1rd07pC6CQuL6FOn0pOxPic3Dk7zE7NPt45a0ugszXiag78q7iaZUsltA/0",
          "ItemStatus": 1,
          "ItemSpeech": "",
          "ItemOpTime": 0
        }
      ],
      [
        {
          "itemName": "张凌",
          "ItemParty": "技术中心",
          "ItemImage": "http://wework.qpic.cn/bizmail/1rd07pC6CQuL6FOn0pOxPic3Dk7zE7NPt45a0ugszXiag78q7iaZUsltA/0",
          "ItemStatus": 0,
          "ItemSpeech": "",
          "ItemOpTime": 0
        },
        {
          "itemName": "张凌",
          "ItemParty": "技术中心",
          "ItemImage": "http://wework.qpic.cn/bizmail/1rd07pC6CQuL6FOn0pOxPic3Dk7zE7NPt45a0ugszXiag78q7iaZUsltA/0",
          "ItemStatus": 0,
          "ItemSpeech": "",
          "ItemOpTime": 0
        }
      ]
    ];
    reason = widget.reason;
    super.initState();
  }

  void getFlowProcess() {
    UserAPI.getFlowStepper(widget.process.processInstanceId).then((data) {
      if (data["status"] != 200) {
        App.showAlertError(context, data["message"]);
        return;
      }
      var datas = ResponseData.fromResponse(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            FlowInformationCard(
              data: flowdata,
            ),
            Card(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "申请事由",
                        style: TextStyle(fontSize: 18, color: Color(0xFF18233C)),
                      ),
                    ),
                    Container(
                      color: Color(0xFFE8EAEC),
                      height: 1,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "$reason",
                        style: TextStyle(fontSize: 16, color: Color(0xFF18233C)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FlowProcessCard(
              datas: flowProcess,
            ),
          ],
        ),
      ),
    );
  }
}
