import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/sliver.dart';
import 'package:flutter/src/rendering/sliver_grid.dart';
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
      crossAxisCount: 5,
      //一行多少个
      scrollDirection: Axis.vertical,
      //滚动方向
      crossAxisSpacing: 10.0,
      // 左右间隔
      mainAxisSpacing: 10.0,
      // 上下间隔
      childAspectRatio: 2 / 5,
      //宽高比
      children: initListWidget(list),
    );
  }

  ///GridView.extent 允许您指定项的最大像素宽度
  Widget gridViewDefaultExtent(List<BaseBean> list) {
    return GridView.extent(
      ///设置item的最大像素宽度  比如 130
      maxCrossAxisExtent: 130.0,

      ///其他属性和count一样
      children: initListWidget(list),
    );
  }

  ///GridView.custom 就是自己定制规则
  /// 这里说一下 GridView.count gridDelegate 其实就是内部实现 SliverGridDelegateWithFixedCrossAxisCount
  /// GridView.extent gridDelegate 其实就是内部实现 SliverGridDelegateWithMaxCrossAxisExtent
  Widget gridViewDefaultCustom(List<BaseBean> list) {
    return GridView.custom(
      gridDelegate: MyGridViewDefaultCustom(
        crossAxisCount: 2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 1.0,
      ),
      childrenDelegate: MyGridChildrenDelegate(
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
    );
  }

  ///GridView.builder  可以定义gridDelegate的模式
  Widget gridViewDefaultBuilder(List<BaseBean> list) {
    return GridView.builder(
        gridDelegate: MyGridViewDefaultCustom(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 1.0,
        ),
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
}

///自定义SliverGridDelegate
class MyGridViewDefaultCustom extends SliverGridDelegate {
  ///横轴上的子节点数。  一行多少个child
  final int crossAxisCount;

  ///沿主轴的每个子节点之间的逻辑像素数。 默认垂直方向的子child间距  这里的是主轴方向 当你改变 scrollDirection: Axis.vertical,就是改变了主轴发方向
  final double mainAxisSpacing;

  ///沿横轴的每个子节点之间的逻辑像素数。默认水平方向的子child间距
  final double crossAxisSpacing;

  ///每个孩子的横轴与主轴范围的比率。 child的宽高比  常用来处理child的适配
  final double childAspectRatio;

  bool _debugAssertIsValid() {
    assert(mainAxisSpacing >= 0.0);
    assert(crossAxisSpacing >= 0.0);
    assert(childAspectRatio > 0.0);
    return true;
  }

  const MyGridViewDefaultCustom({
    @required this.crossAxisCount,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.childAspectRatio = 1.0,
  })  : assert(crossAxisCount != null && crossAxisCount > 0),
        assert(mainAxisSpacing != null && mainAxisSpacing >= 0),
        assert(crossAxisSpacing != null && crossAxisSpacing >= 0),
        assert(childAspectRatio != null && childAspectRatio > 0);

  ///  返回值有关网格中图块大小和位置的信息。这里就是处理怎么摆放 我们可以自己定义
  ///   SliverGridLayout是抽象类  SliverGridRegularTileLayout继承于SliverGridLayout是抽象类
  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    // TODO: implement getLayout
    assert(_debugAssertIsValid());

    ///对参数的修饰 自定义
    final double usableCrossAxisExtent =
        constraints.crossAxisExtent - crossAxisSpacing * (crossAxisCount - 1);
    final double childCrossAxisExtent = usableCrossAxisExtent / crossAxisCount;
    final double childMainAxisExtent = childCrossAxisExtent / childAspectRatio;
    return MySliverGridLayout(
      crossAxisCount: crossAxisCount,
      mainAxisStride: childMainAxisExtent + mainAxisSpacing,
      crossAxisStride: childCrossAxisExtent + crossAxisSpacing,
      childMainAxisExtent: childMainAxisExtent,
      childCrossAxisExtent: childCrossAxisExtent,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  /// 和ListView的 shouldRebuild 作用一样   之前的实例和新进来的实例是相同的就返回true
  @override
  bool shouldRelayout(SliverGridDelegate oldDelegate) {
    // TODO: implement shouldRelayout
    return true;
  }
}

///自定义SliverGridLayout
class MySliverGridLayout extends SliverGridLayout {
  final int crossAxisCount;

  final double mainAxisStride;

  final double crossAxisStride;

  final double childMainAxisExtent;

  final double childCrossAxisExtent;

  final bool reverseCrossAxis;

  const MySliverGridLayout({
    @required this.crossAxisCount,
    @required this.mainAxisStride,
    @required this.crossAxisStride,
    @required this.childMainAxisExtent,
    @required this.childCrossAxisExtent,
    @required this.reverseCrossAxis,
  })  : assert(crossAxisCount != null && crossAxisCount > 0),
        assert(mainAxisStride != null && mainAxisStride >= 0),
        assert(crossAxisStride != null && crossAxisStride >= 0),
        assert(childMainAxisExtent != null && childMainAxisExtent >= 0),
        assert(childCrossAxisExtent != null && childCrossAxisExtent >= 0),
        assert(reverseCrossAxis != null);

  ///如果有，则完全显示所有图块所需的滚动范围
  ///“childCount”儿童总数。
  ///
  ///子计数永远不会为空。
  @override
  double computeMaxScrollOffset(int childCount) {
    // TODO: implement computeMaxScrollOffset
    return null;
  }

  ///具有给定索引的子项的大小和位置。
  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    // TODO: implement getGeometryForChildIndex
    return null;
  }

  ///在此滚动偏移处（或之前）可见的最大子索引。
  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    // TODO: implement getMaxChildIndexForScrollOffset
    return null;
  }

  ///在此滚动偏移处（或之后）可见的最小子索引。
  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    // TODO: implement getMinChildIndexForScrollOffset
    return null;
  }
}

// ignore: slash_for_doc_comments
/**
 * 继承SliverChildBuilderDelegate  可以对列表的监听
 */
class MyGridChildrenDelegate extends SliverChildBuilderDelegate {
  MyGridChildrenDelegate(
    Widget Function(BuildContext, int) builder, {
    int childCount,
    bool addAutomaticKeepAlive = true,
    bool addRepaintBoundaries = true,
  }) : super(builder,
            childCount: childCount,
            addAutomaticKeepAlives: addAutomaticKeepAlive,
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
