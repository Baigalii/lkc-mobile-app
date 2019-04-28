import 'package:flutter/material.dart';
import 'package:lkc/task.dart';


void main() => runApp(PreviousApp());

class PreviousApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'Өмнөх орчуулга'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double rating = 3.5;
  int radioValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
//          bottom: ,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskApp()),
            ),
          )),
      body: new SingleChildScrollView(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: new Text(
                'Түр байзаарай, би өмнө юу гэж орчууллаа?',
                style: new TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
            Divider(
              height: 10.0,
            ),

            Padding(
              padding: EdgeInsets.all(20.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("necromania, necrophilia, necrophilism".toLowerCase(), style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,),
                  ),
                  Text("an irresistible sexual attraction to dead bodies".toLowerCase(), style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),),
                ],
              ),
            ),

            Divider(
              height: 25.0,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: new  FlatButton(
                    onPressed: () => {},
                    padding: EdgeInsets.all(10.0),
                    child: Row( // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Icon(Icons.arrow_back, color: Colors.indigo,),
                        Text(" Өмнөх", style: TextStyle(color: Colors.indigo),),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 150.0, right: 5.0),
                  child: new FlatButton(
                    onPressed: () => {},
                    padding: EdgeInsets.all(10.0),
                    child: Row( // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Text(" Дараах", style: TextStyle(color: Colors.indigo),),
                        Icon(Icons.arrow_forward, color: Colors.indigo,)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  void something(int e){
    setState((){
      if(e == 0){
        radioValue = 0;
      } else if (e == 1){
        radioValue = 1;
      } else if (e == 2){
        radioValue = 2;
      }
    });
  }
}
