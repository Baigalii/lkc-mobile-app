import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lkc/screen/tasks/chooselanguage.dart';

class PreviousApp extends StatefulWidget {
  @override
  _PreviousAppState createState() => _PreviousAppState();
}

class _PreviousAppState extends State<PreviousApp> {
  List prevWords = [];
  List translateWord = [];
  List language = [];
  double rating = 3.5;
  int radioValue;
  var taskId;
  var data;
  var taskResult;
  int domainId;
  int taskNumber;
  String startDate, endDate;
  String gloss = '', lemma = '', taskName;
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

  @override
  void initState() {
    super.initState();
    _showPrev();
    DateTime now = DateTime.now();
    startDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  }

  _showPrev() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    taskNumber = prefs.getInt("taskNum");
    domainId = prefs.getInt("gid");
    taskId = prefs.getString("taskID");

    domainId = 119;
    taskId = "5c99ce76b013d855237c97bd";

    var token = prefs.getString('token');
    var url = "http://lkc.num.edu.mn/translation/prev?domain=" +
        domainId.toString() +
        "&task=" +
        taskId.toString();
    http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json, text/plain, */*',
      'Authorization': token,
    }).then((response) async {
//      taskResult = jsonDecode(response.body);
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      setState(() {
        _processPrevWords(response);
      });
    });
  }

  void _processPrevWords(res) async {
    try {
      prevWords = res['data']['synset'];
      translateWord = res['data']['translation'];
      data = res['data'];
      var t = res['data']['synset'] as List;
      var codes = t.map((x) {
        return x['languageCode'];
      }).toList();
      language = codes;
      for (var i in prevWords) {
        if (i['languageCode'] == _value) {
          lemma = i['lemma'];
          gloss = i['gloss'];
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void _onChanged(String value) {
    for (var item in prevWords) {
      if (item['languageCode'] == value) {
        lemma = item['lemma'];
        gloss = item['gloss'];
      }
    }
    print(value);
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("prevWords->");
    print(prevWords.length);
    return Scaffold(
      appBar: AppBar(
//          bottom: ,
          title: Text(
            "Өмнөх үг",
            style: TextStyle(color: Colors.white, fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushNamed(context, '/task'))),
      body: new SingleChildScrollView(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            Center(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: DropdownButton(
//                isExpanded: true,
                  value: _value,
                  items: _values.where((x) {
//                  print(x);
//                  print(language);
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
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    lemma.toLowerCase(),
                    style: TextStyle(
                      fontSize: 15.0,
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
            Column(
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
                  ),
                ),
              ],
            ),
            Divider(
              height: 25.0,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: new FlatButton(
                    onPressed: () => {},
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Icon(
                          Icons.arrow_back,
                          color: Colors.indigo,
                        ),
                        Text(
                          " Өмнөх",
                          style: TextStyle(color: Colors.indigo),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 150.0, right: 5.0),
                  child: new FlatButton(
                    onPressed: () => {},
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Text(
                          " Дараах",
                          style: TextStyle(color: Colors.indigo),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.indigo,
                        )
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

  void something(int e) {
    setState(() {
      if (e == 0) {
        radioValue = 0;
      } else if (e == 1) {
        radioValue = 1;
      } else if (e == 2) {
        radioValue = 2;
      }
    });
  }
}
