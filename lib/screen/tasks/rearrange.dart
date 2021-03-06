import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lkc/service/networklayer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:lkc/screen/tasks/chooselanguage.dart';

//Засварлах
class RearrangeApp extends StatefulWidget {
  @override
  _RearrangeAppState createState() => _RearrangeAppState();
}

class _RearrangeAppState extends State<RearrangeApp> {
  List<TextEditingController> _controllers = [];
  List<TextEditingController> _controllerModified = [];
  TextEditingController _textFieldController = TextEditingController();
  List rearrangeWords = [];
  List translatedWords = [];
  List language = [];
  double rating = 3.5;
  var taskId;
  var preWord = [];
  var postWord = [];
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

  String _text =
      'Энэ айд зориулж ямар нэг даалгавар генераци хийгээгүй эсвэл бүх даалгаврууд хийгдэж дууссан байна. Өөр айд шилжинэ үү.';

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();
    _showModification();
    DateTime now = DateTime.now();
    startDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    startDate = startDate.replaceAll(' ', 'T') + '.000Z';
    _setControllers();
  }

  _setControllers() {
    setState(() {
      _controllers.add(new TextEditingController());
      _controllerModified.add(new TextEditingController());
    });
  }

  _showModification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    domainId = prefs.getInt("gid");
    taskNumber = prefs.getInt('taskNum');
    taskId = prefs.getString("taskID");
    print("Task type number");

    DateTime now = DateTime.now();
    startDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    startDate = startDate.replaceAll(' ', 'T') + '.000Z';

    fetchAllocation(taskNumber, domainId).then((res) {
      setState(() {
        _processModifications(res);
      });
    });
  }

  void _processModifications(res) async {
    try {
      if (res['statusCode'] == 0) {
        gloss = 'Энэ айд зориулж ямар нэг даалгавар генераци хийгээгүй '
            'эсвэл бүх даалгаврууд хийгдэж дууссан байна.'
            ' Өөр айд шилжинэ үү.';
      } else {
        rearrangeWords = res['task']['synset'];
        translatedWords = res['task']['translatedWords'];
        var t = res['task']['synset'] as List;
        var codes = t.map((x) {
          return x['languageCode'];
        }).toList();
        language = codes;
        print("Modification words:");
        print(res['task']['synset']);

        for (var i in rearrangeWords) {
          if (i['languageCode'] == _value) {
            lemma = i['lemma'];
            gloss = i['gloss'];
          }
        }

        for (var i = 0; i < translatedWords.length; i++) {
          _controllers
              .add(TextEditingController(text: translatedWords[i]['word']));
          _controllerModified.add(new TextEditingController());
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void _onChanged(String value) {
    for (var item in rearrangeWords) {
      if (item['languageCode'] == value) {
        lemma = item['lemma'];
        gloss = item['gloss'];
      }
    }

    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text(
            "Засварлах",
            style: TextStyle(color: Colors.white, fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                _taskType(2);
                Navigator.pushNamed(context, '/task');
              })),
      body: new SingleChildScrollView(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: new Text(
                'Дараах ойлголтыг илэрхийлэх монгол үг(с)ийн алдааг засах эсвэл алдаатай үгсийг хасна уу',
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
                items: _values.where((x) {
                  return language.contains(x['code']);
                }).map((value) {
                  return new DropdownMenuItem(
                    value: value['code'],
                    child: new Row(
                      children: <Widget>[
                        LangIcon(value['code'].toString()),
                        new Text('  ${value['label']}'),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  _onChanged(value);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    lemma.toLowerCase(),
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    gloss.toLowerCase(),
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 10.0,
            ),
            Column(
              children: _buildWords(context),
            ),
            Divider(
              height: 25.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: new FlatButton(
                      onPressed: () => _showDialog(context),
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Replace with a Row for horizontal icon + text
                        children: <Widget>[
                          Text(
                            "GAP",
                            style: TextStyle(color: Colors.indigo),
                          ),
                          Icon(
                            Icons.event_busy,
                            color: Colors.indigo,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 55.0),
                    child: new FlatButton(
                      onPressed: _skipButton,
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        // Replace with a Row for horizontal icon + text
                        children: <Widget>[
                          Text(
                            "Алгасах",
                            style: TextStyle(color: Colors.indigo),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 5.0),
                    child: new FlatButton(
                      onPressed: _sendButton,
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        // Replace with a Row for horizontal icon + text
                        children: <Widget>[
                          Text(
                            "Илгээх",
                            style: TextStyle(color: Colors.indigo),
                          ),
                        ],
                      ),
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

  _taskType(int t) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("taskNum", t);
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
                onPressed: () async {
                  var modificationGap = [];
                  modificationGap.add({
                    'preWord': "GAP",
                    'postWord': "GAP",
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
                    'modification': modificationGap,
                  });
                  print(obj);
                  var prefs = await SharedPreferences.getInstance();
                  var token = prefs.getString('token');
                  var url = "http://lkc.num.edu.mn/modification";
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

  _buildWords(BuildContext context) {
    var children = <Widget>[];
    for (var i = 0; i < translatedWords.length; i++) {
      var controller = new TextEditingController();
      var controllerModified = _controllerModified[i];
      controller.text = translatedWords[i]['word'];
      children.add(Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: new TextField(
              enabled: false,
              decoration: InputDecoration(
                labelText: '',
                hintText: '',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              controller: controller,
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: new TextField(
                  decoration: InputDecoration(
                    suffix: IconButton(
                      icon: Icon(Icons.spellcheck),
                      onPressed: () {
                        print('spellcheck pressed');
                        print(controllerModified.text =
                            translatedWords[i]['word']);
                        controllerModified.text = translatedWords[i]['word'];
                      },
                    ),
                    fillColor: Colors.blueAccent,
                    labelText: '',
                    hintText: 'Засвар үг',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  controller: controllerModified,
                ),
              )),
              IconButton(
                padding: EdgeInsets.only(left: 20.0, right: 20),
                color: Colors.red,
                icon: Icon(Icons.remove_circle),
                alignment: Alignment.bottomLeft,
                onPressed: () {
                  setState(() {
                    print(i);
                    translatedWords.removeAt(i);
                    _controllers.removeAt(i);
                  });
                },
              ),
            ],
          ),
        ],
      ));
    }
    return children;
  }

  _sendButton() async {
    var modificationWords = [];
    for (var i = 0; i < translatedWords.length; i++) {
      modificationWords.add({
        'preWord': translatedWords[i]['word'],
        'postWord': _controllerModified[i].text,
      });
    }
    print("_controllers.length: ");
    print(_controllers.length);
    DateTime now = DateTime.now();
    endDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    endDate = endDate.replaceAll(' ', 'T') + '.000Z';
    Map obj = {
      'taskId': "${taskId}",
      'domainId': "${domainId}",
      'start_date': "${startDate}",
      'end_date': "${endDate}",
      'modification': modificationWords,
    };
    var body = jsonEncode(obj);
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var url = "http://lkc.num.edu.mn/modification";
    var client = new http.Client();
    client.post(url, body: body, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json, text/plain, */*',
      'Authorization': token,
    }).then((response) async {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      Fluttertoast.showToast(msg: "Амжилттай илгээлээ!");
      client
          .get('http://lkc.num.edu.mn/task/2/' + domainId.toString(), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json, text/plain, */*',
        'Authorization': token,
      }).then((result) {
        print(result.body);
//        print(jsonDecode(result.body)['task']['synset'][0]['lemma']);
        var taskResult = jsonDecode(result.body);
        if (taskResult['statusCode'] != 0) {
          prefs.setString("taskID", taskResult['task']['_id'].toString());
          _showModification();
          _controllers.clear();
          _controllerModified.clear();
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(_text),
            duration: Duration(seconds: 5),
          ));
        }
      });
    });
  }

  _skipButton() async {
    DateTime now = DateTime.now();
    endDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    endDate = endDate.replaceAll(' ', 'T') + '.000Z';

    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var url = "http://lkc.num.edu.mn/modification";
    var client = new http.Client();

    var _body = '{ "taskId": "${taskId}", "domainId": "${domainId}", '
        '"start_date": "${startDate}", "end_date": "${endDate}", "skip": true }';
    print(_body);
    print("Domain id:");
    print(domainId);
    client.post(url, body: _body, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json, text/plain, */*',
      'Authorization': token,
    }).then((response) async {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      client
          .get('http://lkc.num.edu.mn/task/2/' + domainId.toString(), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json, text/plain, */*',
        'Authorization': token,
      }).then((result) {
        print(result.body);
//        print(jsonDecode(result.body)['task']['synset'][0]['lemma']);
        var taskResult = jsonDecode(result.body);
        if (taskResult['statusCode'] != 0) {
          prefs.setString("taskID", taskResult['task']['_id'].toString());
          _showModification();
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(_text),
            duration: Duration(seconds: 5),
          ));
        }
      });
    });
  }
}
