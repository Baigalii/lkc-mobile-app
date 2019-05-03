import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lkc/login.dart';
import 'package:lkc/networklayer.dart';
import 'package:lkc/task.dart';
import 'package:http/http.dart' as http;
import 'package:rich_alert/rich_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(PerformanceApp());

class PerformanceApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'Оролцох'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.type}) : super(key: key);
  final String title;
  final int type;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var respPro, respPer;
  var respTask1;
  var uname, email;
  List result = [];
  var translation , validation , modification;



  @override
  void initState() {
    super.initState();
    _showPerformance();
    _showProfile();
//    _sendPost();
//    _sendProfile();
  }

  _showPerformance() async {
    fetchPerformance().then((res) {
      setState(() {
        try {
          translation = res['translation'];
          validation = res['validation'];
          modification = res['modification'];
          print("Translation words:");
          print(translation);
        } catch (e) {
          print(e);
        }
      });
    });
  }

  _showProfile() async {
    fetchProfile().then((res) {
      setState(() {
        try {
          uname = res['name'];
          email = res['email'];
          print("email words:");
          print(translation);
        } catch (e) {
          print(e);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Translation:");
    print(translation);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginApp()),
                ),
          )),
      body: new SingleChildScrollView(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Allocate
            Padding(
              padding: EdgeInsets.all(5.0),
              child: new InkWell(
                onTap: (){
                  _taskType(1);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TaskApp()),
                  );
                },
                child: new Column(
                  children: <Widget>[
                    Center(
                      child: new Container(
                        decoration: BoxDecoration(
                          color: Colors.orange[200],
                        ),
                        width: 350.0,
                        height: 230.0,
                        padding: new EdgeInsets.all(70.0),
                        child: new Image(
                          width: 70.0,
                          height: 70.0,
                          image: new AssetImage("images/translation_logo.png"),
                        ),
                      ),
                    ),
                    Center(
                      child:  new Container(
                        decoration: BoxDecoration(
                          color: Colors.orange,
                        ),
                        width: 350.0,
                        padding: new EdgeInsets.all(5.0),
                        child: new Column(
                          children: <Widget>[
                            new Text(
                              "үг оноох".toUpperCase(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Rearrange
            Padding(
              padding: EdgeInsets.all(5.0),
              child: new InkWell(
                onTap: (){
                  _taskType(2);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TaskApp()),
                  );
                },
                child: new Column(
                  children: <Widget>[
                    new Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[200],
                      ),
                      width: 350.0,
                      height: 230.0,
                      padding: new EdgeInsets.all(70.0),
                      child: new Image(
                        width: 70.0,
                        height: 70.0,
                        image: new AssetImage("images/modification_logo.png"),
                      ),
                    ),
                    new Container(
                      //margin: const EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                      ),
                      width: 350.0,
                      padding: new EdgeInsets.all(5.0),
                      child: new Column(
                        children: <Widget>[
                          new Text(
                            "засварлах".toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Validate
            Padding(
              padding: EdgeInsets.all(5.0),
              child: new InkWell(
                onTap: (){
                  _taskType(3);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TaskApp()),
                  );
                },
                child: new Column(
                  children: <Widget>[
                    new Container(
                      decoration: BoxDecoration(
                        color: Colors.red[200],
                      ),
                      width: 350.0,
                      height: 230.0,
                      padding: new EdgeInsets.all(70.0),
                      child: new Image(
                        width: 70.0,
                        height: 70.0,
                        image: new AssetImage("images/validation_logo.png"),
                      ),
                    ),
                    new Container(
                      //margin: const EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                      ),
                      width: 350.0,
                      padding: new EdgeInsets.all(5.0),
                      child: new Column(
                        children: <Widget>[
                          new Text(
                            "үнэлэх".toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Translate
            Padding(
              padding: EdgeInsets.all(5.0),
              child: new InkWell(
                onTap: (){
                  _taskType(4);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TaskApp()),
                  );
                },
                child: new Column(
                  children: <Widget>[
                    new Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[200],
                      ),
                      width: 350.0,
                      height: 230.0,
                      padding: new EdgeInsets.all(70.0),
                      child: new Image(
                        width: 70.0,
                        height: 70.0,
                        image:
                            new AssetImage("images/gloss_translation_logo.png"),
                      ),
                    ),
                    new Container(
                      //margin: const EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      width: 350.0,
                      padding: new EdgeInsets.all(5.0),
                      child: new Column(
                        children: <Widget>[
                          new Text(
                            "орчуулах".toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Modify
            Padding(
              padding: EdgeInsets.all(5.0),
              child: new InkWell(
                onTap: (){
                  _taskType(5);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TaskApp()),
                  );
                },
                child: new Column(
                  children: <Widget>[
                    new Container(
                      decoration: BoxDecoration(
                        color: Colors.green[200],
                      ),
                      width: 350.0,
                      height: 230.0,
                      padding: new EdgeInsets.all(70.0),
                      child: new Image(
                        width: 70.0,
                        height: 70.0,
                        image: new AssetImage(
                            "images/gloss_modification_logo.png"),
                      ),
                    ),
                    new Container(
                      //margin: const EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.green,
                      ),
                      width: 350.0,
                      padding: new EdgeInsets.all(5.0),
                      child: new Column(
                        children: <Widget>[
                          new Text(
                            "найруулах".toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Sort
            Padding(
              padding: EdgeInsets.all(5.0),
              child: new InkWell(
                onTap: (){
                  _taskType(6);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TaskApp()),
                  );
                },
                child: new Column(
                  children: <Widget>[
                    new Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      width: 350.0,
                      height: 230.0,
                      padding: new EdgeInsets.all(70.0),
                      child: new Image(
                        width: 70.0,
                        height: 70.0,
                        image: new AssetImage("images/sort_logo.png"),
                      ),
                    ),
                    new Container(
                      //margin: const EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                      ),
                      width: 350.0,
                      padding: new EdgeInsets.all(5.0),
                      child: new Column(
                        children: <Widget>[
                          new Text(
                            "эрэмбэлэх".toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      endDrawer: new Drawer(
          //getProfile
          child: new my_drawer(
        email: email,
        uname: uname,
        profileImg: "images/woman_avatar.png",
        background: "images/participation.png",
        translation: translation,
            validation: validation,
              modification: modification,
      )
      ),
    );
  }

   _taskType(int t) async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setInt("taskNum", t );
   }
}


class my_drawer extends StatelessWidget {
  String email, uname, profileImg, background;
  int translation, validation, modification;

  my_drawer({this.email, this.uname, this.background, this.profileImg, this.translation, this.validation, this.modification});

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new UserAccountsDrawerHeader(
          accountName: new Text(uname),
          accountEmail: new Text(email),
          currentAccountPicture: new CircleAvatar(
            backgroundImage: new AssetImage(profileImg),
          ),
          decoration: BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage(background),
              fit: BoxFit.cover,
            ),
          ),
        ),
        new ListTile(
          title: new Text('Орчуулсан: ' + translation.toString()),
          trailing: new Icon(Icons.translate),
          onTap: () {
            print("орчуулсан");
          },
        ),
        new ListTile(
          title: new Text('Засварласан: ' + modification.toString()),
          trailing: new Icon(Icons.update),
          onTap: () {
            print("засварласан");
          },
        ),
        new ListTile(
          title: new Text('Үнэлсэн: ' + validation.toString()),
          trailing: new Icon(Icons.playlist_add_check),
          onTap: () {
            print("үнэлсэн");
          },
        ),
        new ListTile(
          title: new Text('Гарах '),
          trailing: new Icon(Icons.exit_to_app),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginApp()),
            );
          },
        ),
      ],
    );
  }
}
