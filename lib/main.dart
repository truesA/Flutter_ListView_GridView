import 'package:flutter/material.dart';
import 'package:flutter_vscode/gridview_demo.dart';
import 'package:flutter_vscode/listview_demo.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'ListView GridView Demo',
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("ListView GridView Demo"),
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
            new OutlineButton(
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new ListViewDemo()));
              },
              child: new Text("ListView code"),
              textColor: Colors.blue,
              highlightColor: Colors.yellow,
            ),
            new OutlineButton(
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new GridViewDemo()));
              },
              child: new Text("GridView code"),
              textColor: Colors.blue,
              highlightColor: Colors.yellow,
            ),
          ],
        ),
      ),
    );
  }
}
