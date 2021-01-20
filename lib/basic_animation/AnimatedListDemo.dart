import 'package:flutter/material.dart';

class AnimatedListDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AnimatedListDemoState();
  }
}

class _AnimatedListDemoState extends State<AnimatedListDemo> with SingleTickerProviderStateMixin {
  List<int> _list = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  void _add() {
    final int index = _list.length;
    _list.insert(index, index);
    _listKey.currentState.insertItem(index);
  }

  void _remove() {
    final int index = _list.length - 1;
    var item = _list[index].toString();
    _listKey.currentState.removeItem(index, (context, animation) => _build(item, animation));
    _list.removeAt(index);
  }

  Widget _build(String item, Animation animation) {
    return SlideTransition(
      position: animation
          .drive(CurveTween(curve: Curves.bounceInOut))
          .drive(Tween<Offset>(begin: Offset(1, 1), end: Offset(0, 1))),
      child: Card(
        child: ListTile(
          title: Text(item),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      child: Column(
        children: <Widget>[
          AnimatedList(
            shrinkWrap: true,
            key: _listKey,
            initialItemCount: _list.length,
            itemBuilder: (context, index, animation) {
              return _build(_list[index].toString(), animation);
            },
          ),
          Row(
            children: <Widget>[
              RaisedButton(
                child: Text("动态列表 add"),
                onPressed: () {
                  _add();
                },
              ),
              RaisedButton(
                child: Text("动态列表 remove"),
                onPressed: () {
                  _remove();
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
