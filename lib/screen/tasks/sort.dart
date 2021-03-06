import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lkc/service/networklayer.dart';
import 'package:http/http.dart' as http;
import 'package:draggable_flutter_list/draggable_flutter_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lkc/screen/tasks/chooselanguage.dart';

//Эрэмбэлэх
class SortApp extends StatefulWidget {
  @override
  _SortAppState createState() => _SortAppState();
}

class _SortAppState extends State<SortApp> {
  double rating = 3.5;
  List sortWords = [];
  List modifiedGlosses = [];
  List language = [];
  List priority = [];
  var taskId;
  int domainId;
  int taskNumber;
  String startDate, endDate;
  String gloss = '', lemma = '';
  String _value = 'eng';
  List<Map> _values = [
    {'code': 'eng', 'label': 'English'},
    {'code': 'fra', 'label': 'French'},
    {'code': 'zho', 'label': 'Chinese'},
    {'code': 'jpn', 'label': 'Japanese'}
  ];
  List items = [];
  String _text =
      'Энэ айд зориулж ямар нэг даалгавар генераци хийгээгүй эсвэл бүх даалгаврууд хийгдэж дууссан байна. Өөр айд шилжинэ үү.';

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();
    _showSort();
    DateTime now = DateTime.now();
    startDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    startDate = startDate.replaceAll(' ', 'T') + '.000Z';
  }

  _showSort() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    domainId = prefs.getInt("gid");
    taskNumber = prefs.getInt("taskNum");
    fetchAllocation(taskNumber, domainId).then((res) {
      setState(() {
        _processSort(res);
      });
    });
  }

  _processSort(res) async {
    try {
      if (res['statusCode'] == 0) {
        gloss = 'Энэ айд зориулж ямар нэг даалгавар генераци хийгээгүй '
            'эсвэл бүх даалгаврууд хийгдэж дууссан байна. Өөр айд шилжинэ үү.';
      } else {
        sortWords = res['task']['synset'];
        modifiedGlosses = res['task']['modifiedGlosses'];
        var t = res['task']['synset'] as List;
        var codes = t.map((x) {
          return x['languageCode'];
        }).toList();
        language = codes;
        print("Sort words:");
        print(res['task']['synset']);
        for (var i in sortWords) {
          if (i['languageCode'] == _value) {
            lemma = i['lemma'];
            gloss = i['gloss'];
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void _onChanged(String value) {
    for (var item in sortWords) {
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
      appBar: AppBar(
          title: Text(
            "Эрэмбэлэх",
            style: TextStyle(color: Colors.white, fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                _taskType(6);
                Navigator.pushNamed(context, '/task');
              })),
      body: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: new Text(
              'Доорх өгүүлбэрүүдийг ойлголтын тайлбарыг хэр оновчтой орчуулснаар эрэмбэлнэ үү!',
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
//                      new Icon(Icons.language),
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
            padding: EdgeInsets.all(20.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
          Expanded(
            child: DragAndDropList(
              modifiedGlosses.length,
              itemBuilder: (BuildContext context, index) {
                return new SizedBox(
                  child: new Card(
                    child: new ListTile(
                        title: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text(
                          modifiedGlosses[index]['_id'].toString() +
                              "   " +
                              modifiedGlosses[index]['gloss'],
                          softWrap: true,
                        ),
                      ],
                    )),
                  ),
                );
              },
              onDragFinish: (before, after) {
                print(before);
                print(after);
                setState(() {
                  print('on drag finish $before $after');
                  var data = modifiedGlosses[before];
                  modifiedGlosses.removeAt(before);
                  modifiedGlosses.insert(after, data);
                });
                print("Priority");
                print(priority);
              },
              canDrag: (index) {
                print('can drag $index');
                return index != 3; //disable drag for index 3
              },
              canBeDraggedTo: (one, two) => true,
              dragElevation: 5.0,
            ),
          ),
          Divider(
            height: 25.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    color: Colors.grey[300],
                    onPressed: _skipButton,
                    child: Text(
                      "Алгасах",
                      style: TextStyle(color: Colors.indigo),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    color: Colors.indigo,
                    onPressed: _sendButton,
                    child: Text(
                      "Илгээх",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _taskType(int t) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("taskNum", t);
  }

  _sendButton() async {
    DateTime now = DateTime.now();
    endDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    var modifiedWords = [];
    for (var i = 0; i <= modifiedGlosses.length; i++) {
      modifiedWords.add({
        'gloss': modifiedGlosses[i]["gloss"],
        '_id': modifiedGlosses[i]["_id"],
//        'priority':
      });
    }

    Map obj = {
      'taskId': "${taskId}",
      'domainId': "${domainId}",
      'start_date': "${startDate}",
      'end_date': "${endDate}",
      'validationType': "GlossValidation",
      'validations': " ",
    };
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
  }

  _skipButton() async {
    DateTime now = DateTime.now();
    endDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    endDate = endDate.replaceAll(' ', 'T') + '.000Z';

    var _body =
        '{ "taskId": "${taskId}", "domainId": "${domainId}", "start_date": "${startDate}", "end_date": "${endDate}", "skip": true, "validationType": "GlossValidation"}';
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

    client.get('http://lkc.num.edu.mn/task/6/' + domainId.toString(), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json, text/plain, */*',
      'Authorization': token,
    }).then((result) {
      print(result.body);
//        print(jsonDecode(result.body)['task']['synset'][0]['lemma']);
      var taskResult = jsonDecode(result.body);
      if (taskResult['statusCode'] != 0) {
        prefs.setString("taskID", taskResult['task']['_id'].toString());
        _showSort();
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(_text),
          duration: Duration(seconds: 5),
        ));
      }
    });
  }
}
