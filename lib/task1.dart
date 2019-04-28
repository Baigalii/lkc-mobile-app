import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lkc/words.dart';
import 'package:lkc/netwoklayer.dart';

void main() => runApp(new MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Task';
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: new ThemeData(
        primaryColor: Colors.indigo,
        primaryColorDark: Colors.indigo,
        accentColor: const Color(0xFFFFAD32),
      ),
      home: new HomePage(title: appTitle),
    );
  }
}

class HomePage extends StatelessWidget {
  final String title;
  TabController tabController;

  HomePage({Key key, this.title}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title,
          style: new TextStyle(
            color: const Color(0xFFFFFFFF),
          ),
        ),
      ),
//      body: new FutureBuilder<List<Word>>(
//        future: fetchCountry(new http.Client()),
//        builder: (context, snapshot) {
//          if (snapshot.hasError) print(snapshot.error);
//
//          return snapshot.hasData
//              ? new WordGridView(word: snapshot.data)
//              : new Center(child: new CircularProgressIndicator());
//        },
//      ),,
      bottomNavigationBar: new Material(
        color: Colors.indigo,
        child: new TabBar(
            controller: tabController,
            tabs: <Widget>[
              new Tab(
                child: new Image(image: new AssetImage('images/united-kingdom.png')),
              ),
              new Tab(
                child: new Image(image: new AssetImage('images/china.png')),
//                icon: new ImageIcon(new AssetImage("images/china.png")),
              ),
              new Tab(
                child: new Image(image: new AssetImage('images/france.png')),
//                icon: new ImageIcon(new AssetImage("images/france.png")),
              ),
              new Tab(
                child: new Image(image: new AssetImage('images/japan.png')),
//                icon: new ImageIcon(new AssetImage("images/japan.png")),
              ),
              new Tab(
                child: new Image(image: new AssetImage('images/germany.png')),
//                icon: new ImageIcon(new AssetImage("images/germany.png")),
              ),
              new Tab(
                child: new Image(image: new AssetImage('images/russia.png')),
//                icon: new ImageIcon(new AssetImage("images/russia.png")),
              ),
            ]
        ),
      ),
    );
  }
}