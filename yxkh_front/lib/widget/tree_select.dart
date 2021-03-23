import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

abstract class TreeSelectBloc {
  Stream<List> get stream;
  void setDatas(List<dynamic> items);
  // 多选时
  void onSelected(Map<dynamic, dynamic> item);
  // 清除选择
  void onClear();
  void dispose();
}

class TreeSelectBlocImpl implements TreeSelectBloc {
  // multiple 是否多选
  final bool multiple;
  // 值key标签
  final String keyTag;
  // 值val标签
  final String valueTag;
  // 子数据对应的key
  final String childrenTag;
  final double width;
  final double height;
  // 初始值
  final List<dynamic> initValue;
  BehaviorSubject<List> _list$;
  List<Map<dynamic, dynamic>> selected;
  // 初始数据
  List<dynamic> initDatas = List();
  // 上次搜索结果
  List<dynamic> lastList;
  TextEditingController textEditingController;
  TreeSelectBlocImpl(
      {List<dynamic> items,
      this.keyTag,
      this.valueTag,
      this.initValue,
      this.multiple,
      this.width,
      this.height,
      this.childrenTag}) {
    _list$ = BehaviorSubject.seeded(List());
    selected = List();
    textEditingController = TextEditingController();
    initDatas = items;
    setInitValue(items);
    _list$.add(items);
    lastList = items;
  }
  @override
  void dispose() {
    _list$.close();
    textEditingController.dispose();
  }

  @override
  void onClear() {
    lastList.forEach((l) => l["selected"] = false);
    _list$.add(lastList);
    selected = List();
  }

  @override
  void onSelected(Map<dynamic, dynamic> item) {
    bool check = !item["selected"];
    List<dynamic> temp = List();
    temp.add(item);
    while (temp.length > 0) {
      dynamic b = temp.removeLast();
      b["selected"] = check;
      var index = lastList.indexWhere((d) => d[valueTag] == b[valueTag]);
      if (index != -1) lastList[index] = b;
      if (b["selected"]) {
        selected.add(b);
      } else {
        selected.removeWhere((s) => s[valueTag] == b[valueTag]);
      }
      if (b[childrenTag].length > 0) {
        temp.addAll(b[childrenTag]);
      }
    }
    _list$.add(lastList);
  }

  @override
  Stream<List> get stream => _list$.stream;
  void setInitValue(List items) {
    if (items == null) return;
    if (initValue != null) {
      textEditingController.text = "${initValue.join(",")}";
      initValue.forEach((val) {
        int index = items.indexWhere((item) => item[valueTag] == val);
        if (index != -1) items[index]["selected"] = true;
      });
    }
  }

  @override
  void setDatas(List items) {
    initDatas = items;
    setInitValue(items);
    _list$.add(items);
    lastList = items;
  }
}

class TreeSelect extends StatefulWidget {
  // 对应 json 值的value
  final String valueTag;
  // 对应json值的key
  final String keyTag;
  // 子数据对应的key
  final String childrenTag;
  // 数据
  final List<dynamic> datas;
  // 初始数据
  final List<dynamic> initValue;
  final Function(dynamic, dynamic) onChange;
  final Future<List<dynamic>> Function(String filterStr) getRemoteDataFunc;
  final int minlines;
  final int maxlines;
  final InputDecoration inputDecoration;
  final TextEditingController textEditingController;
  // width 弹出的显示框的宽度
  final double width;
  final double height;
  final String hintText;
  // 是否允许多选
  final bool multiple;
  // 是否禁用
  final bool enabled;
  // showIcon是否显示图标
  final bool showIcon;
  final Icon icon;
  final EdgeInsets iconPadding;
  TreeSelect(
      {Key key,
      this.datas,
      this.onChange,
      this.getRemoteDataFunc,
      this.minlines,
      this.maxlines,
      this.inputDecoration,
      this.textEditingController,
      this.enabled,
      this.width = 400,
      this.height = 400,
      this.hintText,
      this.multiple = false,
      this.keyTag,
      this.valueTag,
      this.childrenTag = "children",
      this.initValue,
      this.showIcon = false,
      this.iconPadding = const EdgeInsets.only(bottom: 5),
      this.icon})
      : assert(valueTag != null),
        super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _TreeSelectState();
  }
}

class _TreeSelectState extends State<TreeSelect> {
  TreeSelectBlocImpl bloc;
  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    bloc = TreeSelectBlocImpl(
        valueTag: widget.valueTag,
        keyTag: widget.keyTag,
        initValue: widget.initValue,
        childrenTag: widget.childrenTag,
        items: widget.datas,
        multiple: widget.multiple,
        width: widget.width,
        height: widget.height);
  }

  @override
  Widget build(BuildContext context) {
    bloc.setDatas(widget.datas);
    return !widget.showIcon
        ? TextField(
            controller: bloc.textEditingController,
            enabled: widget.enabled,
            maxLines: widget.maxlines,
            minLines: widget.minlines,
            decoration: widget.inputDecoration ??
                InputDecoration(
                  hintText: widget.hintText ?? "点击",
                  contentPadding: EdgeInsets.all(10.0),
                ),
            readOnly: true,
            onTap: () {
              TreeSelectDialog.showModal(
                context,
                bloc: bloc,
                onChange: (ids, text) {
                  // print("select dialog:ids:$ids,text:$text");
                  bloc.textEditingController.text = "${text.join(",")}";
                  widget.onChange?.call(ids, text);
                },
              );
            },
          )
        : Container(
            width: 60,
            // color: Colors.red,
            child: IconButton(
              alignment: Alignment.topCenter,
              padding: widget.iconPadding,
              tooltip: "点击添加",
              icon: widget.icon ?? Icon(Icons.insert_emoticon),
              onPressed: () {
                TreeSelectDialog.showModal(
                  context,
                  bloc: bloc,
                  onChange: (ids, text) {
                    // print("select dialog:ids:$ids,text:$text");
                    bloc.textEditingController.text = "${text.join(",")}";
                    widget.onChange?.call(ids, text);
                  },
                );
              },
            ),
          );
  }
}

class TreeSelectDialog extends StatelessWidget {
  final void Function(dynamic, dynamic) onChange;
  final TreeSelectBlocImpl bloc;
  TreeSelectDialog({this.onChange, this.bloc});
  static Future<T> showModal<T>(BuildContext context,
      {void Function(dynamic, dynamic) onChange, TreeSelectBlocImpl bloc}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: IconButton(
            icon: Icon(Icons.close),
            iconSize: 45,
            color: Colors.red,
            tooltip: "清空",
            onPressed: () {
              if (!bloc.multiple) {
                Navigator.of(context).pop();
              } else {
                bloc.onClear();
              }
              onChange([], []);
            },
          ),
          content: TreeSelectDialog(
            onChange: onChange,
            bloc: bloc,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: bloc.width,
      height: bloc.height,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(0),
            child: TextField(
              controller: bloc.textEditingController,
              readOnly: true,
              onChanged: (val) {},
              decoration: InputDecoration(hintText: "点击X清除内容", contentPadding: EdgeInsets.all(2.0)),
            ),
          ),
          Expanded(
            child: TreeWidget(
              bloc: bloc,
              onSelected: onChange,
            ),
          ),
        ],
      ),
    );
  }
}

class TreeWidget extends StatelessWidget {
  final TreeSelectBlocImpl bloc;
  final Function(dynamic, dynamic) onSelected;
  TreeWidget({
    Key key,
    this.bloc,
    this.onSelected,
  })  : assert(onSelected != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder<List<dynamic>>(
      stream: bloc.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.data.isEmpty) {
          return Center(
            child: Text("没有找到数据"),
          );
        }
        return Scrollbar(
          child: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return TreeItemWidget(
                bloc: bloc,
                bean: snapshot.data[index],
                onSelected: onSelected,
              );
            },
          ),
        );
      },
    ));
  }
}

class TreeItemWidget extends StatelessWidget {
  final TreeSelectBlocImpl bloc;
  final Map<dynamic, dynamic> bean;
  final Function(List<dynamic>, List<dynamic>) onSelected;
  TreeItemWidget({Key key, this.bean, this.onSelected, this.bloc})
      : assert(onSelected != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _buildItem(bean, 0, context),
    );
  }

  void check(dynamic bean) {
    if (!bloc.multiple) {
      bloc.selected.clear();
      bloc.selected.add(bean);
      sendData();
      return;
    }
    bloc.onSelected(bean);
    sendData();
  }

  void sendData() {
    List<dynamic> text = List();
    List<dynamic> ids = List();
    bloc.selected.forEach((t) {
      ids.add(t[bloc.keyTag]);
      text.add(t[bloc.valueTag]);
    });
    // print("widget items:ids:$ids,text:$text");
    onSelected(ids, text);
  }

  Widget _buildItem(Map<dynamic, dynamic> bean, int level, BuildContext context) {
    if (bean["selected"] == null && bloc.multiple) {
      bean["selected"] = false;
    }
    if (bean[bloc.childrenTag] == null || bean[bloc.childrenTag].length == 0) {
      return ListTile(
        leading: Icon(
          Icons.ac_unit,
          color: Colors.grey,
          size: 24,
        ),
        title: !bloc.multiple
            ? Row(
                children: <Widget>[
                  Text("${bean[bloc.valueTag]}"),
                ],
              )
            : CheckboxListTile(
                title: Text("${bean[bloc.valueTag]}"),
                value: bean["selected"],
                onChanged: (bool value) {
                  check(bean);
                },
              ),
        onTap: () {
          if (onSelected == null) return;
          check(bean);
          // if (!bloc.multiple) {
          //   print("点击选中,退出关闭");
          //   // Navigator.of(context).pop();
          // }
        },
      );
    }
    level++;
    return ExpansionTile(
      title: !bloc.multiple
          ? Row(
              children: <Widget>[
                Text("${bean[bloc.valueTag]}"),
              ],
            )
          : CheckboxListTile(
              title: Text("${bean[bloc.valueTag]}"),
              value: bean["selected"],
              onChanged: (bool value) {
                check(bean);
              },
            ),
      children: bean[bloc.childrenTag].map<Widget>((b) => _buildItem(b, level, context)).toList(),
      leading: Icon(
        Icons.ac_unit,
        size: (5 - level) * 10.0,
      ),
      // leading: CircleAvatar(radius: (5 / level) * 10, child: Icon(Icons.ac_unit)),
      // leading: CircleAvatar(
      //   radius: (5 / level) * 10,
      //   backgroundColor: Colors.green,
      //   child: Text(
      //     "${bean[bloc.valueTag].substring(0, 1)}",
      //     style: TextStyle(color: Colors.white),
      //   ),
      // ),
    );
  }
}
