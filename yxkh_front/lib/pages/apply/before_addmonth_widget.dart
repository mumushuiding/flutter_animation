import 'package:flutter/material.dart';
// BeforeAddMonthPage 月度考核前导页面，主要是选择填写的月份
class BeforeAddMonthPage extends StatelessWidget{
    List<Map<String,dynamic>> getTitles(){
    int i=0;
    List<Map<String,dynamic>> result = List();
    DateTime now = DateTime.now();
    // 每月25号可以开始填当月
      // 获取年份
      int year = now.year;
      // 获取月份 
      int month = now.month;
      int day = now.day;
      if (day<25) {
        if (month==1){
          month=12;
          year--;
        }else{
          month--;
        }
      }
      result.add({"id":i,"value":"$year年$month月份-月度考核"});
      i++;
    // 可以填写半年之内的一线考核
      int num=6;
      while (num!=0) {
        num--;
        if (month==1){
          month=12;
          year--;
        }else{
          month--;
        }
        result.add({"id":i,"value":"$year年$month月份-月度考核"});
      }
      return result;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("这是前导页面"),
    );
  }

}