import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

typedef Widget SelectItemBuiler(BuildContext context, Map<String, dynamic> item, bool isSelected);

abstract class SelectBloc {
  Stream<List> get stream;
  List<dynamic> get selected;
  set(List items);
  // 当搜索框中的内容改变时
  void onTextChanged(String filter);
  // 当多选时
  void onSelected(Map<String, dynamic> selected);
  // 清除选择
  void onClear();
  // 全选
  void onSelectAll();
  // 在下拉选项中进行搜索
  List<dynamic> filter(String filterStr);
  void dispose();
}

class SelectBlocImpl implements SelectBloc {
  final String keyTag;
  final String valueTag;
  // 初始值
  final List<dynamic> initValue;
  BehaviorSubject<List> _list$;
  Future<List<dynamic>> Function(String filterStr) getRemoteDataFunc;
  List<Map<String, dynamic>> selected;
  // 上次搜索条件
  String lastFilterStr = "";
  // 上次搜索结果
  List<dynamic> lastList;
  // 初始数据
  List<dynamic> initDatas = List();
  // 远程数据
  // final String URL;
  SelectBlocImpl({List<dynamic> items, this.getRemoteDataFunc, this.keyTag, this.valueTag, this.initValue})
      : assert(valueTag != null) {
    _list$ = BehaviorSubject.seeded(List());
    initDatas = items;
    selected = List();
    if (initValue != null) {
      initValue.forEach((val) {
        int index = items.indexWhere((item) => item[valueTag] == val);
        if (index != -1) {
          items[index]["selected"] = true;
          selected.add(items[index]);
        }
      });
    }
    // print("初始化:$initDatas");
    set(items);
  }
  @override
  void dispose() {
    _list$.close();
    lastList?.clear();
  }

  @override
  Stream<List> get stream => _list$.stream;

  @override
  set(List items) {
    if (items == null) return;
    _list$.add(items);
    lastList = items;
  }

  @override
  void onTextChanged(String filterstr) {
    // print("filterStr:$filterstr,initDatas:$initDatas");
    String filterStr = filterstr.trim();
    if (filterStr == "") {
      _list$.add(initDatas);
      return;
    }
    if (getRemoteDataFunc != null) {
      // 判断 filterStr 是否是上次搜索条件 lastFilterStr的向右扩展
      // 是 过滤之前的查询结果
      // print("上次查询条件：$lastFilterStr");
      if (lastFilterStr != "" && filterStr.startsWith(lastFilterStr)) {
        _list$.add(filter(filterStr));
        return;
      }
      // 否重新查询
      getRemoteDataFunc(filterStr).then((data) {
        // print("重新查询");
        lastFilterStr = filterStr;
        lastList = data;
        _list$.add(data);
      });
    } else {
      _list$.add(filter(filterStr));
    }
  }

  @override
  List<dynamic> filter(String filterStr) {
    return lastList.where((l) {
      return l.toString().contains(filterStr);
    }).toList();
  }

  @override
  void onSelected(Map<String, dynamic> item) {
    item["selected"] = !item["selected"];
    var index = lastList.indexWhere((d) => d[valueTag] == item[valueTag]);
    lastList[index] = item;
    _list$.add(lastList);
    if (item["selected"]) {
      selected.add(item);
    } else {
      selected.removeWhere((s) => s[valueTag] == item[valueTag]);
    }
  }

  @override
  void onClear() {
    lastList.forEach((l) => l["selected"] = false);
    _list$.add(lastList);
    selected = List();
  }

  @override
  void onSelectAll() {
    lastList.forEach((l) => l["selected"] = true);
    _list$.add(lastList);
    selected = lastList;
  }
}

class Select extends StatefulWidget {
  // items 接收的是json数组
  final List<Map<String, dynamic>> items;
  // 对应 json 值的value
  final String valueTag;
  // 对应json值的key
  final String keyTag;
  // 第一个参数返回选择的key,第二个参数返回选择的值
  final Function(dynamic, dynamic) onChange;
  final Future<List<dynamic>> Function(String filterStr) getRemoteDataFunc;
  final int minlines;
  final int maxlines;
  final String hintText;
  final InputDecoration inputDecoration;
  final TextEditingController textEditingController;
  // 初始值
  final List<dynamic> initValue;
  // 是否允许多选
  final bool multiple;
  // 是否禁用
  final bool enabled;
  Select(
      {Key key,
      this.items,
      this.onChange,
      this.getRemoteDataFunc,
      this.minlines,
      this.maxlines,
      this.inputDecoration,
      this.hintText,
      this.textEditingController,
      this.enabled,
      this.valueTag,
      this.keyTag,
      this.multiple = false,
      this.initValue})
      : assert(valueTag != null);
  @override
  State<StatefulWidget> createState() {
    return _SelectState();
  }
}

class _SelectState extends State<Select> {
  SelectBlocImpl bloc;
  TextEditingController textEditingController;
  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
    if (widget.textEditingController == null) textEditingController.dispose();
  }

  @override
  void initState() {
    super.initState();
    textEditingController = widget.textEditingController ?? TextEditingController();
    if (widget.initValue != null && widget.items != null) {
      textEditingController.text = "${widget.initValue.join(",")}";
    }
    bloc = SelectBlocImpl(
        initValue: widget.initValue,
        items: widget.items,
        getRemoteDataFunc: widget.getRemoteDataFunc,
        keyTag: widget.keyTag,
        valueTag: widget.valueTag);
    // print("初始化select:${widget.items}");
  }

  @override
  Widget build(BuildContext context) {
    // print("创建select:${widget.items}");
    return TextField(
      controller: textEditingController,
      enabled: widget.enabled,
      maxLines: widget.maxlines,
      minLines: widget.minlines,
      decoration: widget.inputDecoration ??
          InputDecoration(
            hintText: widget.hintText ?? "点击",
            contentPadding: EdgeInsets.all(10),
          ),
      readOnly: true,
      onTap: () {
        SelectDialog.showModal(
          context,
          bloc: bloc,
          onChange: (val) {
            // print("selected val:$val");
            if (!widget.multiple) {
              textEditingController.text = "${val[bloc.valueTag]}";
              widget.onChange?.call(val[bloc.keyTag], val[bloc.valueTag]);
            } else {
              // print("SelectDialog onchange");
              List<dynamic> keys = List();
              List<dynamic> vals = List();
              val.forEach((v) {
                keys.add(v[bloc.keyTag]);
                vals.add(v[bloc.valueTag]);
              });
              widget.onChange?.call(keys, vals);
            }
          },
          multiple: widget.multiple,
        );
      },
    );
  }
}

class SelectDialog extends StatelessWidget {
  final void Function(dynamic) onChange;
  final SelectBlocImpl bloc;
  final bool multiple;
  SelectDialog({
    this.onChange,
    this.bloc,
    this.multiple,
  });
  static Future<T> showModal<T>(
    BuildContext context, {
    SelectBloc bloc,
    bool multiple = false,
    void Function(dynamic) onChange,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.done_outline),
                  color: Colors.green,
                  iconSize: 40,
                  tooltip: "全选",
                  disabledColor: Colors.grey,
                  onPressed: multiple
                      ? () {
                          bloc.onSelectAll();
                          onChange.call(bloc.selected);
                        }
                      : null,
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  color: Colors.red,
                  padding: EdgeInsets.only(bottom: 0),
                  iconSize: 40,
                  tooltip: "清除",
                  disabledColor: Colors.grey,
                  onPressed: () {
                    if (multiple) {
                      bloc.onClear();
                      onChange(bloc.selected);
                    } else {
                      onChange(Map());
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
            actions: <Widget>[
              multiple
                  ? MaterialButton(
                      color: Colors.green,
                      child: Text("确定"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  : Container(),
              MaterialButton(
                color: Colors.grey,
                child: Text("取消"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
            content: SelectDialog(
              onChange: onChange,
              bloc: bloc,
              multiple: multiple,
            ));
      },
    );
  }

  SelectItemBuiler get itemBuilder => (context, item, isSelected) {
        return Container(
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
          child: ListTile(
            title: Text("${item[bloc.valueTag]}"),
            selected: isSelected,
            trailing: Icon(Icons.done_outline),
          ),
        );
      };
  @override
  Widget build(BuildContext context) {
    TextEditingController searchText = TextEditingController(text: "${bloc.lastFilterStr ?? ""}");
    return Container(
      width: 500,
      height: 500,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchText,
              onChanged: (val) {
                bloc.onTextChanged(val);
              },
              decoration: InputDecoration(hintText: "搜索", contentPadding: EdgeInsets.all(2.0)),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<dynamic>>(
              stream: bloc.stream,
              builder: (context, snapshot) {
                // print("data:${snapshot.data}");
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
                      Map<String, dynamic> item = snapshot.data[index];
                      if (item["selected"] == null) item["selected"] = false;
                      return InkWell(
                          child: itemBuilder(context, item, item["selected"]),
                          onTap: () {
                            if (!multiple) {
                              onChange.call(item);
                              Navigator.pop(context);
                            } else {
                              bloc.onSelected(item);
                              onChange.call(bloc.selected);
                            }
                          });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
