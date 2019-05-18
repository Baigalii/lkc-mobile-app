import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lkc/networklayer.dart';
import 'package:lkc/performance.dart';
import 'package:http/http.dart' as http;
import 'package:lkc/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Үнэлэх

void main() => runApp(ValidateApp());

class ValidateApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'Үнэлэх'),
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
  int radioValue;
  List language = [];

  List<TextEditingController> txtController = [];
  TextEditingController _textFieldController = TextEditingController();
  List validationWords = [];
  List modifiedWords = [];
  List _ratings= [];
  var taskId;
  int domainId;
  int taskNumber;
  String startDate, endDate;
  String gloss = '', lemma = '';
  String _value = 'eng';
  List<Map> _values = [
    {'code': 'eng', 'label': 'English'},
    {'code': 'zho', 'label': 'Chinese'},
    {'code': 'deu', 'label': 'Deutsch'},
    {'code': 'fra', 'label': 'French'},
    {'code': 'rus', 'label': 'Russian'},
    {'code': 'jpn', 'label': 'Japanese'},
  ];

  String _text = 'Энэ айд зориулж ямар нэг даалгавар генераци хийгээгүй эсвэл бүх даалгаврууд хийгдэж дууссан байна. Өөр айд шилжинэ үү.';

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();
    _showValidation();
    DateTime now = DateTime.now();
    startDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    startDate = startDate.replaceAll(' ', 'T') + '.000Z';
  }



  _showValidation() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    domainId = prefs.getInt("gid");
    taskNumber = prefs.getInt("taskNum");
    taskId = prefs.getString("taskID");
    fetchAllocation(taskNumber, domainId).then((res) {
      setState(() {
        _processValidations(res);
      });
    });
  }

  _processValidations(res) async{
    try {
      if(res['statusCode']==0){
        gloss = 'Энэ айд зориулж ямар нэг даалгавар генераци хийгээгүй '
            'эсвэл бүх даалгаврууд хийгдэж дууссан байна. Өөр айд шилжинэ үү.';
      } else {
        validationWords = res['task']['synset'];
        modifiedWords = res['task']['modifiedWords'];
        var t = res['task']['synset'] as List;
        var codes = t.map((x) {
          return x['languageCode'];
        }).toList();
        language = codes;
        print("Validation words:");
        print(res['task']['synset']);
        for(var i in validationWords){
          if(i['languageCode']==_value){
            lemma = i['lemma'];
            gloss = i['gloss'];
          }
        }
        _ratings = List(modifiedWords.length);
      }
    } catch (e) {
      print(e);
    }
  }

  void _onChanged(String value){
    for(var item in validationWords){
      if(item['languageCode']==value){
        lemma = item['lemma'];
        gloss = item['gloss'];
      }
    }
    setState(() {
      _value = value;
    });
  }

  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(modifiedWords);
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
//          bottom: ,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              _taskType(3);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskApp()),
              );
            }
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
                'Дараах ойлголтыг илэрхийлэх монгол үг(с)ээс оновчтой тохирохыг нь үнэлнэ үү',
                style: new TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
            Divider(
              height: 10.0,
            ),
            Center(
              child: DropdownButton(
                value: _value,
                items: _values.where((x){
                  return language.contains(x['code']);
                }).map((value){
                  return new DropdownMenuItem(
                    value: value['code'],
                    child: new Row(
                      children: <Widget>[
//                        new Icon(Icons.language),
                        _langIcon(value['code'].toString()),
                        new Text('  ${value['label']}'),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value){
                  _onChanged(value);
                  },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(lemma.toLowerCase(), style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,),
                  ),
                  Text(gloss.toLowerCase(), style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _validateWords(context),
            ),
            Divider(
              height: 25.0,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: new FlatButton(
                    onPressed: () => _showDialog(context),
                    padding: EdgeInsets.all(10.0),
                    child: Row( // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Text("GAP", style: TextStyle(color: Colors.indigo),),
                        Icon(Icons.event_busy, color: Colors.indigo,)
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 55.0),
                  child: new  FlatButton(
                    onPressed: _skipButton,
                    padding: EdgeInsets.all(10.0),
                    child: Row( // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Text("Алгасах", style: TextStyle(color: Colors.indigo),),
                        Icon(Icons.skip_next, color: Colors.indigo,)
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 5.0),
                  child: new FlatButton(
                    onPressed: (){
                        if(_ratings.length==0){
                          Fluttertoast.showToast(msg: "Илгээх өгөгдөл байхгүй байна.");
                        } else {
                          _sendButton();
                        }
                    },
                    padding: EdgeInsets.all(10.0),
                    child: Row( // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Text("Илгээх", style: TextStyle(color: Colors.indigo),),
                        Icon(Icons.send, color: Colors.indigo,)
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
  _taskType(int t) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("taskNum", t );
  }

  _showDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'GAP (дүйцэлгүй ойлголт)',
              style: TextStyle(color: Colors.indigo, fontSize: 15.0),
            ),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(
                  hintText: "GAP гэж үзсэн шалтгаан?",
                  hintStyle: TextStyle(fontSize: 15.0)),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('OK'),
                onPressed: () async{
                  var validationsGap = [];
                  validationsGap.add({
                    'words': "GAP",
                    'rating': 5,
                  });

                  DateTime now = DateTime.now();
                  endDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

                  var obj = jsonEncode({
                    'taskId': "${taskId}",
                    'domainId': "${domainId}",
                    'gap': "true",
                    'gapReason': "${_textFieldController.text}",
                    'start_date': "${startDate}",
                    'end_date': "${endDate}",
                    'validations': validationsGap,
                  });
                  print(obj);
                  var prefs = await SharedPreferences.getInstance();
                  var token = prefs.getString('token');
                  var url = "http://lkc.num.edu.mn/validation";
                  http.post(url, body: obj, headers: {
                    'Content-Type': 'application/json',
                    'Authorization': token,
                  }).then((response) async {
                    print("Response status: ${response.statusCode}");
                    print("Response body: ${response.body}");
                  });
                  Navigator.pop(context);
                },
              ),
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
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

  _validateWords(BuildContext context) {
    var children = <Widget>[];
    for (var i=0; i < modifiedWords.length; i++) {
      var controller = new TextEditingController();
      controller.text = modifiedWords[i]['word'];
      children.add(Column(
        children: <Widget>[
         Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: new TextField(
                enabled: false,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey),
                  border: new OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  ),
                controller: controller,
              ),
            ),
          Padding(
            padding: EdgeInsets.only(left: 30.0, right: 30.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    children: <Widget>[
                      new Radio(
                        onChanged: (value){
                          setState(() {
//                            correct[i] = value;
                            _ratings[i] = value;
                          });
                        },
                        activeColor: Colors.indigo,
                        groupValue: _ratings[i],
                        value: 0,
                      ),
                      new Icon(
                        Icons.check,
                        color: Colors.indigo,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child:  Row(
                    children: <Widget>[
                      new Radio(
                        onChanged: (value ) {
                          setState(() {
                            //wrong[i] = value;
                            _ratings[i] = value;
                          });
                        },
                        activeColor: Colors.red,
                        groupValue: _ratings[i],
                        value: 1,
                      ),
                      new Icon(
                        Icons.clear,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    children: <Widget>[
                      new Radio(
                        onChanged: (value ) {
                          setState(() {
                            //unfamiliar[i] = value;
                            _ratings[i] = value;
                            print(_ratings);
                          });
                        },
                        activeColor: Colors.pink,
                        groupValue: _ratings[i],
                        value: 2,
                      ),
                      new Icon(
                        Icons.sentiment_very_dissatisfied,
                        color: Colors.pink,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ));
    }
    return children;
  }

  _sendButton() async{
    var validationWords = [];
    for (var i = 0; i < modifiedWords.length; i++) {
      validationWords.add({
        'lemma': modifiedWords[i]['word'],
        'rating': _ratings[i],
      });
    }

      DateTime now = DateTime.now();
      endDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      endDate = endDate.replaceAll(' ', 'T') + '.000Z';

      Map obj = {
        'taskId': "${taskId}",
        'domainId': "${domainId}",
        'start_date': "${startDate}",
        'end_date': "${endDate}",
        'validations': validationWords,
      };
      print(obj);
    var _body = jsonEncode(obj);
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var url = "http://lkc.num.edu.mn/validation";
    var client = new http.Client();
    client.post(url, body: _body, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json, text/plain, */*',
      'Authorization': token,
    }).then((response) async {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      client.get('http://lkc.num.edu.mn/task/3/' + domainId.toString(), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json, text/plain, */*',
        'Authorization': token,
      }).then((result) {
        print(result.body);
//        print(jsonDecode(result.body)['task']['synset'][0]['lemma']);
        var taskResult = jsonDecode(result.body);
        if (taskResult['statusCode'] != 0) {
          prefs.setString("taskID", taskResult['task']['_id'].toString());
          _showValidation();
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(_text),
            duration: Duration(seconds: 5),
          ));
        }
      });
    });
    }

  _skipButton() async{
    DateTime now = DateTime.now();
    endDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    endDate = endDate.replaceAll(' ', 'T') + '.000Z';

    var _body = '{ "taskId": "${taskId}", "domainId": "${domainId}", "start_date": "${startDate}", "end_date": "${endDate}", "skip": true }';
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var url = "http://lkc.num.edu.mn/validation";
    var client = new http.Client();

    client.post(url, body: _body, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json, text/plain, */*',
      'Authorization': token,
    }).then((response) async {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    });

    client.get('http://lkc.num.edu.mn/task/3/' + domainId.toString(), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json, text/plain, */*',
      'Authorization': token,
    }).then((result) {
      print(result.body);
//        print(jsonDecode(result.body)['task']['synset'][0]['lemma']);
      var taskResult = jsonDecode(result.body);
      if (taskResult['statusCode'] != 0) {
        prefs.setString("taskID", taskResult['task']['_id'].toString());
        _showValidation();
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(_text),
          duration: Duration(seconds: 5),
        ));
      }
    });
  }
}

_langIcon(String value) {
  if(value=='eng'){
    return new Image(image: new AssetImage('images/united-kingdom.png'), width: 25, height: 25,);
  } else if(value=='zho'){
    return new Image(image: new AssetImage('images/china.png'), width: 25, height: 25,);
  } else if(value=='deu'){
    return new Image(image: new AssetImage('images/germany.png'), width: 25, height: 25,);
  } else if(value=='fra'){
    return new Image(image: new AssetImage('images/france.png'), width: 25, height: 25,);
  } else if(value=='rus'){
    return new Image(image: new AssetImage('images/russia.png'), width: 25, height: 25,);
  } else if(value=='jpn'){
    return new Image(image: new AssetImage('images/japan.png'), width: 25, height: 25,);
  }
}
