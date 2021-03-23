// import 'package:flutter/material.dart';
// import 'package:yxkh_front/utils/screenUtil.dart';
// class TreeData{
//   int id;
//   String name;
//   bool selected;
//   List<TreeData> children;
//   TreeData(this.id,this.name,{this.selected=false});
//   String toString(){
//     return name;
//   }
//   TreeData.fromJson(Map<String, dynamic> json){
//     id=json["id"];
//     name=json["name"];
//     children=fromList(json["children"]);
//   }
//   static List<TreeData> fromList(List<dynamic> list){
//     List<TreeData> dep=List();
//     if(list!=null)list.forEach((json){
//       // print(TreeData.fromJson(json).toString());
//       dep.add(TreeData.fromJson(json));
//     });
//     return dep;
//   }
// }
// class TreeWidget extends StatefulWidget{
//   final List<TreeData> data;
//   final bool multiple;
//   final Function(String,String) onSelected;
//   final width;
//   final height;
//   TreeWidget({Key key,this.data,this.multiple=false,this.onSelected,
//     this.width,this.height
//   }):super(key:key);
//   @override
//   State<StatefulWidget> createState() {
//     return _TreeWidgetState();
//   }
// }
// class _TreeWidgetState extends State<TreeWidget>{
//   var _data;
//   var _width;
//   var _height;
//   double fontSize=14.0;
//   @override void initState(){
//     super.initState();
//     _data=widget.data;
//     _width=widget.width;
//     _height=widget.height;
//     if (_data==null) _data=List();
//   }
//   @override
//   Widget build(BuildContext context) {
//     if(ScreenUtils.isSmallScreen(context)){
//       _width=ScreenUtils.screenW(context);
//       _height=ScreenUtils.screenH(context);
//       // fontSize=10;
//     }else{
//       // fontSize=16;
//     }
//     // print("width=$_width");
//     return SingleChildScrollView(
//         child: Container(
//           width: _width==null?350:_width,
//           height: _height==null?400:_height,
//           // decoration:BoxDecoration(
//           //   border: Border.symmetric(vertical: BorderSide(color: Colors.grey))
//           // ),
//           child: ListView.builder(
//             itemBuilder: (BuildContext context,int index)=>TreeItemWidget(bean:_data[index],fontSize:fontSize,multiple:widget.multiple,onSelected: (ids,text){
//               widget.onSelected(ids,text);
//             },),
//             itemCount: _data.length,
//           )
//         )
//       );
//   }
  
// }
// class TreeItemWidget extends StatefulWidget{
//   final TreeData bean;
//   final bool multiple;
//   final Function(String,String) onSelected;
//   final double fontSize;
//   TreeItemWidget({Key key,this.bean,this.multiple=false,
//   this.onSelected,this.fontSize
//   }):super(key:key);
//   @override
//   State<StatefulWidget> createState() {
//     return _TreeItemWidgetState();
//   }
  
// }
// class _TreeItemWidgetState extends State<TreeItemWidget>{
//   var _bean;
//   bool _multiple;
//   double fontSize;
//   List<TreeData> _selected;
//   Function(String,String) _onSelected;
//   @override void initState(){
//     super.initState();
//     _bean=widget.bean;
//     // if (_bean==null) _bean=List();
//     _multiple=widget.multiple;
//     _selected=List();
//     _onSelected=widget.onSelected;
//     fontSize=widget.fontSize;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: _buildItem(_bean,0),
//     );
//   }
//   void check(TreeData bean){
//     bool check=!bean.selected;
//     List<TreeData> temp=List();
//     temp.add(bean);
//     while(temp.length>0){
//       TreeData b=temp.removeLast();
//       b.selected=check;
//       int index=_selected.indexWhere((item)=>item.id==b.id);
//       if (!check&&index!=-1){
//         _selected.removeAt(index);
//       }else{
//         // 点中、原先不存在，就添加
//         if (check&&index==-1){
//           TreeData x=TreeData(b.id,b.name);
//           _selected.add(x);
//         }
//       }
//       if (b.children.length>0){
//         temp.addAll(b.children);
//       }
//     }
//     sendData();
//   }
//   void sendData(){
//       String text="";
//     String ids="";
//     _selected.forEach((t){
//       ids += ",${t.id}";
//       text +=",${t.name}";
//     });
//     if (_selected.length>0) {
//       ids =ids.substring(1);
//       text = text.substring(1);
//     }
//     _onSelected(ids,text);
//   }
//   Widget _buildItem(TreeData bean,int level){

//     if(bean.children.isEmpty){
//       return ListTile(
//         leading: CircleAvatar(
//         radius: fontSize/2,
//         child: Icon(Icons.home)
//       ),
//         title: !_multiple?Row(children: <Widget>[
//           Text(bean.name,style: TextStyle(fontSize: fontSize),),
//         ],):CheckboxListTile(
//         title: Text(bean.name,style: TextStyle(fontSize: fontSize),),
//         value: bean.selected,
//         onChanged: (bool value){
//           setState(() {
//             check(bean);
//           });
//         },
//       ),
//       onTap: () {
//         if(_onSelected==null)return;
//         if (!_multiple){
//           _selected.clear();
//           _selected.add(bean);
//         }
//         sendData();
        
//        },
//       );
//     }
//     level++;
//     return ExpansionTile(
//         title: !_multiple?Row(children: <Widget>[
//           Text(bean.name,style: TextStyle(fontSize: fontSize),),
//         ],):CheckboxListTile(
//         title: Text(bean.name,style: TextStyle(fontSize: fontSize),),
//         value: bean.selected,
//         onChanged: (bool value){
//           setState(() {
//             check(bean);
//           });
//         },
//       ),
//       children: bean.children.map<Widget>((b)=>_buildItem(b,level)).toList(),
//       leading: CircleAvatar(
//         radius: (5/level)*fontSize/2,
//         backgroundColor: Colors.green,
//         child: Text(bean.name.substring(0,1),style: TextStyle(color: Colors.white,fontSize: fontSize),),
//       ),
//     );
//   }
// }