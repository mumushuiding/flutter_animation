import 'package:flutter/material.dart';
import 'package:yxkh_front/blocs/count_bloc.dart';

class UnderPage extends StatelessWidget{
  final CountBloc bloc;
  UnderPage({@required this.bloc});
  @override
  Widget build(BuildContext context) {
    print("创建 underpageg");
   return Scaffold(
     body: Center(
     child: StreamBuilder(
       stream: bloc.stream,
       initialData: bloc.value,
       builder: (context,snapshot)=>Text(
         "You hit me: ${snapshot.data} times"
       ),
     ),
     
   ),
   floatingActionButton: FloatingActionButton(
        onPressed: (){
          bloc.increment();
          print("点击");
        },
        child: Icon(Icons.add),
      ),
   );
  }
  
}