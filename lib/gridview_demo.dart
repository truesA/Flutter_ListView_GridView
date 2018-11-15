import 'package:flutter/material.dart';
import 'package:flutter_vscode/listview_demo.dart';

class GridViewDemo extends StatefulWidget {
  @override
  _GridViewDemoState createState() => new _GridViewDemoState();
}

class _GridViewDemoState extends State<GridViewDemo> {
  List<BaseBean> gridList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gridList = new List<BaseBean>.generate(
        32, (i) => new BaseBean("name$i", i, "content=$i"));
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "",
      home: new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Text("GridView"),
        ),
        body: gridViewDefaultCount(gridList),
      ),
    );
  }

  List<Widget> initListWidget(List<BaseBean> list) {
    List<Widget> lists = [];
    for (var item in list) {
      lists.add(new Container(
        height: 50.0,
        width: 50.0,
        color: Colors.yellow,
        child: new Center(
            child: new Text(
          item.age.toString(),
        )),
      ));
    }
    return lists;
  }

  Widget gridViewDefaultCount(List<BaseBean> list) {
    return GridView.count(
//      padding: EdgeInsets.all(5.0),
      crossAxisCount: 5, //一行多少个
      scrollDirection: Axis.vertical, //滚动方向
      crossAxisSpacing: 10.0, // 左右间隔
      mainAxisSpacing: 10.0, // 上下间隔
      childAspectRatio: 2 / 5, //宽高比
      children: initListWidget(list),
    );
  }

  ///GridView.extent 允许您指定项的最大像素宽度
  Widget gridViewDefaultExtent(List<BaseBean> list) {
    return GridView.extent(maxCrossAxisExtent: null);
  }

  ///GridView.custom
  Widget gridViewDefaultCustom(List<BaseBean> list) {
    return GridView.custom(gridDelegate: null, childrenDelegate: null);
  }

  ///GridView.builder
  Widget gridViewDefaultBuilder(List<BaseBean> list) {
    return GridView.builder(gridDelegate: null, itemBuilder: null);
  }
}
