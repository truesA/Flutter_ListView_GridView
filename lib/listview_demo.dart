import 'package:flutter/material.dart';

//void main() => runApp(ListViewDemo());

class BaseBean {
  String name;
  int age;
  String content;

  BaseBean(this.name, this.age, this.content);
}

List<BaseBean> list = new List<BaseBean>.generate(
    60, (i) => new BaseBean("name$i", i, "content=$i"));

class ListViewDemo extends StatefulWidget {
  @override
  _ListViewDemoState createState() => new _ListViewDemoState();
}

class _ListViewDemoState extends State<ListViewDemo> {
  List<BaseBean> list;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list = new List<BaseBean>.generate(
        60, (i) => new BaseBean("name$i", i, "content=$i"));
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
              centerTitle: true,
              title: new Text("ListView"),
            ),
            body:
//            listViewDefault(list))
                listViewListTile(list))
//            listViewLayoutBuilder(list)),
//              listViewLayoutCustom(list)),
//              listViewLayoutSeparated(list)),
        );
  }

  ///默认构建
  Widget listViewDefault(List<BaseBean> list) {
    List<Widget> _list = new List();
    for (int i = 0; i < list.length; i++) {
      _list.add(new Center(
        child: new Text(list[i].age.toString()),
      ));
    }

// 添加分割线
    var divideList =
        ListTile.divideTiles(context: context, tiles: _list).toList();
    return new Scrollbar(
      child: new ListView(
        // 添加ListView控件
        children: _list, // 无分割线
//        children: divideList, // 添加分割线/
      ),
    );
  }

  /// ListTile
  Widget listViewListTile(List<BaseBean> list) {
    List<Widget> _list = new List();
    for (int i = 0; i < list.length; i++) {
      _list.add(new Center(
        child: ListTile(
          leading: new Icon(Icons.list),
          title: new Text(list[i].name),
          trailing: new Icon(Icons.keyboard_arrow_right),
        ),
      ));
    }
    return new ListView(
      children: _list,
    );
  }

  ///listView builder 构建
  Widget listViewLayoutBuilder(List<BaseBean> list) {
    return ListView.builder(
        //设置滑动方向 Axis.horizontal 水平  默认 Axis.vertical 垂直
        scrollDirection: Axis.vertical,
        //内间距
        padding: EdgeInsets.all(10.0),
        //是否倒序显示 默认正序 false  倒序true
        reverse: false,
        //false，如果内容不足，则用户无法滚动 而如果[primary]为true，它们总是可以尝试滚动。
        primary: true,
        //确定每一个item的高度 会让item加载更加高效
        itemExtent: 50.0,
        //item 高度会适配 item填充的内容的高度 多用于嵌套listView中 内容大小不确定 比如 垂直布局中 先后放入文字 listView （需要Expend包裹否则无法显示无穷大高度 但是需要确定listview高度 shrinkWrap使用内容适配不会） 文字
        shrinkWrap: true,
        //item 数量
        itemCount: list.length,
        //滑动类型设置
        //new AlwaysScrollableScrollPhysics() 总是可以滑动 NeverScrollableScrollPhysics禁止滚动 BouncingScrollPhysics 内容超过一屏 上拉有回弹效果 ClampingScrollPhysics 包裹内容 不会有回弹
//        cacheExtent: 30.0,  //cacheExtent  设置预加载的区域   cacheExtent 强制设置为了 0.0，从而关闭了“预加载”
        physics: new ClampingScrollPhysics(),
        //滑动监听
//        controller ,
        itemBuilder: (context, i) => new Container(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Text(
                    "${list[i].name}",
                    style: new TextStyle(fontSize: 18.0, color: Colors.red),
                  ),
                  new Text(
                    "${list[i].age}",
                    style: new TextStyle(fontSize: 18.0, color: Colors.green),
                  ),
                  new Text(
                    "${list[i].content}",
                    style: new TextStyle(fontSize: 18.0, color: Colors.blue),
                  ),
                ],
              ),
            ));
  }

  // ignore: slash_for_doc_comments
  /**
   * ListView({
      List<Widget> children,
      })

      ListView.builder({
      int: itemCount,
      IndexedWidgetBuilder itemBuilder,
      })

      ListView.custom({
      SliverChildDelegate childrenDelegate,
      })

      大家可能对前两种比较熟悉，分别是传入一个子元素列表或是传入一个根据索引创建子元素的函数。
      其实前两种方式都是第三种方式的“快捷方式”。因为 ListView 内部是靠这个 childrenDelegate 属性动态初始化子元素的。
   */

  ///listView custom 构建
  Widget listViewLayoutCustom(list) {
//    return ListView.custom(childrenDelegate: new MyChildrenDelegate());
    return ListView.custom(
      itemExtent: 40.0,
      childrenDelegate: MyChildrenDelegate(
        (BuildContext context, int i) {
          return new Container(
              child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Text(
                "${list[i].name}",
                style: new TextStyle(fontSize: 18.0, color: Colors.red),
              ),
              new Text(
                "${list[i].age}",
                style: new TextStyle(fontSize: 18.0, color: Colors.green),
              ),
              new Text(
                "${list[i].content}",
                style: new TextStyle(fontSize: 18.0, color: Colors.blue),
              ),
            ],
          ));
        },
        childCount: list.length,
      ),
      cacheExtent: 0.0,
    );
  }
}

// ignore: slash_for_doc_comments
/**
 * 继承SliverChildBuilderDelegate  可以对列表的监听
 */
class MyChildrenDelegate extends SliverChildBuilderDelegate {
  MyChildrenDelegate(
    Widget Function(BuildContext, int) builder, {
    int childCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
  }) : super(builder,
            childCount: childCount,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries);

  ///监听 在可见的列表中 显示的第一个位置和最后一个位置
  @override
  void didFinishLayout(int firstIndex, int lastIndex) {
    print('firstIndex: $firstIndex, lastIndex: $lastIndex');
  }

  ///可不重写 重写不能为null  默认是true  添加进来的实例与之前的实例是否相同 相同返回true 反之false
  ///listView 暂时没有看到应用场景 源码中使用在 SliverFillViewport 中
  @override
  bool shouldRebuild(SliverChildBuilderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    print("oldDelegate$oldDelegate");
    return super.shouldRebuild(oldDelegate);
  }
}

///  listView separated 构建 用于多类型 分割
Widget listViewLayoutSeparated(List<BaseBean> list) {
  return ListView.separated(
    itemCount: list.length,
    separatorBuilder: (content, index) {
      //和itemBuilder 同级别的执行
      if (index == 2) {
        return new Container(
          height: 40.0,
          child: new Center(
            child: new Text("类型1"),
          ),
          color: Colors.red,
        );
      } else if (index == 7) {
        return new Container(
          height: 40.0,
          child: new Center(
            child: new Text("类型2"),
          ),
          color: Colors.blue,
        );
      } else if (index == 14) {
        return new Container(
          height: 40.0,
          child: new Center(
            child: new Text("类型3"),
          ),
          color: Colors.yellow,
        );
      } else {
        return new Container();
      }
    },
    itemBuilder: (content, i) {
      return new InkWell(
        child: new Container(
            height: 30.0,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Text(
                  "${list[i].name}",
                  style: new TextStyle(fontSize: 18.0, color: Colors.red),
                ),
                new Text(
                  "${list[i].age}",
                  style: new TextStyle(fontSize: 18.0, color: Colors.green),
                ),
                new Text(
                  "${list[i].content}",
                  style: new TextStyle(fontSize: 18.0, color: Colors.blue),
                ),
              ],
            )),
        onTap: () {
          print("1111");
        },
      );
//      return ;
    },
  );
}
