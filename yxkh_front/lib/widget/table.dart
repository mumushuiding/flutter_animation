

import 'package:flutter/material.dart';
class ColumnData{
  String text;
  String key;
  // 值转换函数
  String Function(dynamic) formatter;
  ColumnData(this.text,this.key,{this.formatter});
  String toString(){
    return "key:$key,text:$text";
  }
}
class ResponsiveTable extends StatelessWidget{
  // 专门处理业务数据的模块
  // final ResponsiveTableBloc bloc;
  // final ScrollController scrollController;
  final Widget header;
  final List<Widget> actions;
  // 行操作
  final Widget Function(dynamic) operation;
  final List<dynamic> datas;
  final List<ColumnData> columns;
  final int rowsPerPage;
  ResponsiveTable({Key key,
    this.header,this.actions,this.datas,this.columns,
    this.rowsPerPage=10,this.operation
  }):assert(columns!=null),super(key:key);

  List<DataColumn> getDataColumns(){
    if (operation!=null) {
       columns.insert(0,ColumnData("操作","operate"));
    }
    return this.columns.map((d){
      return DataColumn(label: Text(d.text));
    }).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scrollbar(
            child: PaginatedDataTable(
              header: header ?? Text("通过 header 定义表格标题"),
              actions: actions ?? <Widget>[
                Text("通过 actions 定义操作")
              ],
              rowsPerPage: rowsPerPage,
              onPageChanged: (page){
                print('onPageChanged:$page');
              },
              columns: getDataColumns(),
              source: TableDataTableSource(datas,columns,context,operation: operation),
            ),
          )
    );
  }
  
}

class TableDataTableSource extends DataTableSource{
  final List<dynamic> data;
  final List<ColumnData> columns;
  final BuildContext context;
  // 行操作
  final Widget Function(dynamic) operation;
  TableDataTableSource(this.data,this.columns,this.context,{this.operation});
  List<DataCell> getDataCells(int index){
    List<DataCell> list = List();
    columns.forEach((c){
      switch (c.key) {
        case "operate":
          list.add(DataCell(operation(data[index])));
          break;
        case "index":
          list.add(DataCell(Text("${index+1}")));
          break;
        default:
          
          list.add(DataCell(Text("${c.formatter==null?data[index][c.key]:c.formatter(data[index][c.key])}")));
      }
    });
    return list;
  }
  @override
  DataRow getRow(int index) {
    return DataRow(
      selected: true,
      cells: getDataCells(index),
    );

  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
  
}