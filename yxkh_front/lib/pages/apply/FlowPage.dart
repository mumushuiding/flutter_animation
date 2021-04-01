import 'package:flutter/material.dart';
import 'package:yxkh_front/api/response_data.dart';
import 'package:yxkh_front/api/user_api.dart';
import 'package:yxkh_front/api/yxkh_api.dart';
import 'package:yxkh_front/blocs/flow_task_bloc.dart';
import 'package:yxkh_front/pages/apply/flow_information_card.dart';
import 'package:yxkh_front/pages/widget/flow_log_card.dart';
import 'package:yxkh_front/pages/widget/flow_process_card.dart';
import 'package:yxkh_front/theme.dart';

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
  List<dynamic> flowlogs = [];
  Map<String, dynamic> flowdata;
  // 申请事由
  dynamic reason;
  // 审批意见
  String speech = "";
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
    getFlowProcess();
    getFlowLog();
    super.initState();
  }

  void getFlowLog() {
    UserAPI.findLogSpeechByThirdNo(widget.process.processInstanceId).then((d) {
      if (d["status"] != 200) {
        App.showAlertError(context, d["message"]);
        return;
      }
      var datas = ResponseData.fromResponse(d);
      flowlogs = datas[0];
      setState(() {});
    });
  }

  void getFlowProcess() {
    UserAPI.getFlowStepper(widget.process.processInstanceId).then((data) {
      if (data["status"] != 200) {
        App.showAlertError(context, data["message"]);
        return;
      }
      var datas = ResponseData.fromResponse(data);
      flowProcess = [];
      datas[0]["ApprovalNodes"].forEach((d) {
        flowProcess.add(d["Items"]["Item"]);
        setState(() {});
      });
    });
  }

  void _completeProcess(int perform) {
    YxkhAPI.completeProcess(null, widget.process.businessType, perform,
            speech: speech, processInstanceId: widget.process.processInstanceId)
        .then((data) {
      if (data["status"] != 200) {
        App.showAlertError(context, data['message']);
        return;
      }
      var datas = ResponseData.fromResponse(data);
      widget.bloc?.onCompleteTask(datas[0], datas[1]);
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 520,
          child: SingleChildScrollView(
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
                  // 审批意见
                  flowlogs.length > 0 ? FlowLogCard(datas: flowlogs) : Container(),
                ],
              ),
            ),
          ),
        ),
        Positioned(
            bottom: 1,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  color: Color(0xFFE8EAEC),
                  padding: EdgeInsets.only(top: 5),
                  height: 2,
                  width: 400,
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      widget.process.step != 0
                          ? Container(
                              width: 140,
                              child: TextFormField(
                                decoration: InputDecoration(hintText: "填写审批意见"),
                                onChanged: (value) => speech = value,
                              ),
                            )
                          : Container(),
                      MaterialButton(
                        color: Colors.green,
                        child: Text(
                          widget.process.step == 0 ? "提交" : "审批",
                        ),
                        onPressed: () {
                          _completeProcess(2);
                        },
                      ),
                      MaterialButton(
                        color: Colors.grey,
                        child: Text(
                          "撤回",
                        ),
                        onPressed: () {
                          _completeProcess(5);
                        },
                      ),
                      MaterialButton(
                        color: Colors.grey,
                        child: Text(
                          "驳回",
                        ),
                        onPressed: () {
                          _completeProcess(3);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ))
      ],
    );
  }
}
