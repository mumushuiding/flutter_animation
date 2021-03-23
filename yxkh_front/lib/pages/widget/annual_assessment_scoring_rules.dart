// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:yxkh_front/api/response_data.dart';
import 'package:yxkh_front/api/yxkh_api.dart';

import '../../app.dart';

// AnnualAssessmentScoringRulesWidget 年度和半年考核评分规则
class AnnualAssessmentScoringRulesWidget extends StatefulWidget {
  final String department;
  AnnualAssessmentScoringRulesWidget({this.department});
  @override
  State<StatefulWidget> createState() {
    return _AnnualAssessmentScoringRulesWidgetState();
  }
}

class _AnnualAssessmentScoringRulesWidgetState extends State<AnnualAssessmentScoringRulesWidget> {
  List<dynamic> scoreShares;
  List<dynamic> keys;
  // List<PieChartSectionData> sections = List();
  Map<String, double> dataMap;
  List<Widget> items = List();
  @override
  void initState() {
    super.initState();
    findScoreShares();
  }

// 查询评分占比
  void findScoreShares() {
    YxkhAPI.scoreShare(widget.department).then((data) {
      if (data["status"] != 200) {
        App.showAlertError(context, data["message"]);
        return;
      }
      var datas = ResponseData.fromResponse(data);
      scoreShares = datas[0];
      keys = datas[1];
      dataMap = Map();
      for (var i = 0; i < scoreShares.length; i++) {
        dataMap["${keys[i].substring(0, 4)}"] = double.parse(scoreShares[i]) * 100;
      }
      items.add(Text("评分占比"));
      items.add(PieChart(
        dataMap: dataMap,
        chartRadius: 200,
      ));
      for (var j = 0; j < datas[2].length; j++) {
        items.add(Container(
          width: 400,
          child: ListTile(
            leading: Icon(Icons.all_inclusive),
            title: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text("${datas[3][j]}:"),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text("${datas[2][j]}"),
                )
              ],
            ),
          ),
        ));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 500,
      child: Column(children: items),
    );
  }
}
