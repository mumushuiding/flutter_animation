import 'package:flutter/material.dart';
// ShowFlowStepperWidget 显示流程步骤条
class FlowStepperWidget extends StatelessWidget{
  final Map<String,dynamic> data;
  FlowStepperWidget({Key key,this.data}):assert(data!=null),super(key:key);
  
  StepState getState(int status){
    if (status!=1) {
      return StepState.complete;
    }
    return StepState.editing;
  }
  List<Step> getSteppers(){

    List<Step> steppers = List();
    steppers.add(
      
      Step(
        isActive: data["OpenSpstatus"]!=0&&data["OpenSpstatus"]!=1?false:true,
        title: Wrap(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(2),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                data["ApplyUserImage"]
                ),
              ),
          ),
          Padding(
            padding: EdgeInsets.all(2),
            child: Text(data["ApplyUsername"]),
          ),
          Padding(
            padding: EdgeInsets.all(2),
            child: data["OpenSpstatus"]!=0&&data["OpenSpstatus"]!=1?Text("已提交"):Text("未提交"),
          ),
        ],),
        content: Container()
      )
    );
    data["ApprovalNodes"].forEach((d){
      steppers.add(
      Step(
        title: Column(
          children: getNames(d["Items"]["Item"])
        ),
        isActive: d["NodeStatus"]==1||d["NodeStatus"]==0?true:false,
        // state: getState(d["NodeStatus"]),
        content: Container()
      ));
    });


 
    return steppers;
  }
  String getStatus(int status){
    print("status:$status");
    String result;
    // 1-审批中；2-已通过；3-已驳回;5-撤消
    switch (status) {
      case 0:
        result="审批中";
        break;
      case 1:
        result="审批中";
        break;
      case 2:
        result="已通过";
        break;
      case 3:
        result="已驳回";
        break;
      case 5:
        result="已撤消";
        break;
      default:
    }
    return result;
  }
  List<Widget> getNames(List<dynamic> approvers){
    return approvers.map((a){
      return Row(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(2),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              a["ItemImage"]
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(2),
          child: Text(a["itemName"]),
        ),
        Padding(
          padding: EdgeInsets.all(2),
          child: Text("·"),
        ),
        Padding(padding: EdgeInsets.all(2),child: Text("${getStatus(a["ItemStatus"])}"),),
      ],);
    }).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: Stepper(
        controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}){
          return Row(
            children: <Widget>[],
          );
        },
        type: StepperType.vertical,
        steps: getSteppers(),
      ),
    );
  }

}