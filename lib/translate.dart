import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lkc/networklayer.dart';
import 'package:lkc/performance.dart';
import 'package:http/http.dart' as http;
import 'package:lkc/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Орчуулах

void main() => runApp(TranslateApp());

class TranslateApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Нүүр хэсэг',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'Орчуулах'),
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

  List translationWords = [];
  List language = [];
  var controller = new TextEditingController();
  var controllerTranslate = new TextEditingController();
  var targetWords;
  var taskId;
  String gloss = '', lemma = '', targetWord = '';
  String _value = 'eng';
  int domainId;
  int taskNumber;
  String startDate, endDate;
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
    _showTranslation();
    DateTime now = DateTime.now();
    startDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    startDate = startDate.replaceAll(' ', 'T') + '.000Z';
  }

  _showTranslation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    domainId = prefs.getInt("gid");
    taskNumber = prefs.getInt("taskNum");
    taskId = prefs.getString("taskID");
    fetchAllocation(taskNumber,domainId).then((res) {
      setState(() {
        _processTranslation(res);
      });
    });
  }

  _processTranslation(res) async{
    try {
      if (res['statusCode'] == 0) {
        gloss = 'Энэ айд зориулж ямар нэг даалгавар генераци хийгээгүй '
            'эсвэл бүх даалгаврууд хийгдэж дууссан байна. Өөр айд шилжинэ үү.';
      } else {
        translationWords = res['task']['synset'];
        targetWords = res['task']['targetWords'];
        var t = res['task']['synset'] as List;
        var codes = t.map((x) {
          return x['languageCode'];
        }).toList();
        language = codes;
        print("Validation words:");
        print(res['task']['synset']);
        for (var i in translationWords) {
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
    for (var item in translationWords) {
      if (item['languageCode'] == value) {
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
    controller.text = targetWords;
    print('Target Words');
    print(targetWords);
    DateTime now;
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              _taskType(4);
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
                'Өгөгдсөн ойлголтын тайлбар өгүүлбэрийг Монгол хэл рүү орчуулан бичнэ үү!',
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
//                        new Icon(Icons.language),
                        _langIcon(value['code'].toString()),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
//                Padding(
//                  padding: EdgeInsets.all(20.0),
//                  child:  new Icon(
//                      Icons.exit_to_app
//                  ),
//                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                      maxLines: 2,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
                    controller: controller,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: new Theme(
                        data: new ThemeData(hintColor: Colors.black),
                        child: new TextField(
                          decoration: InputDecoration(
                            labelText: 'Тайлбар оруулах хэсэг*',
                            hintText: 'Энэ хэсэгт орчуулсан үгээ оруулна уу...',
                            hintStyle: TextStyle(color: Colors.grey),
                            helperText: 'Санамж: зөвхөн тайлбарыг орчуулна',
                            suffixIcon: const Icon(
                              Icons.create,
                              color: Colors.black,
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.indigo, width: 0.0),
                            ),
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.red),
                            ),
                          ),
                          maxLength: 256,
                          controller: controllerTranslate,
                        ),
                      )),
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
                    onPressed: _skipButton,
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Text(
                          "Алгасах",
                          style: TextStyle(color: Colors.indigo),
                        ),
                        Icon(
                          Icons.skip_next,
                          color: Colors.indigo,
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 100.0),
                  child: new FlatButton(
                    onPressed: (){
                        if (controller.text == " ") {
                        Fluttertoast.showToast(msg: "Илгээх өгөгдөл байхгүй байна!");
                        } else {
                          _sendButton();
                        }
                    },
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Text(
                          "Илгээх",
                          style: TextStyle(color: Colors.indigo),
                        ),
                        Icon(
                          Icons.send,
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

  _taskType(int t) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("taskNum", t );
  }

  void _sendButton() async {
      DateTime now = DateTime.now();
      endDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      //2019-04-30T07:24:53.887Z

      Map obj = {
        'taskId': "${taskId}",
        'domainId': "${domainId}",
        'start_date': "${startDate}",
        'end_date': "${endDate}",
        'translation': "${controllerTranslate.text}",
        'translationType': "GlossTranslation",
      };
      var body = jsonEncode(obj);
      var prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var url = "http://lkc.num.edu.mn/translation";
      var client = new http.Client();
      client.post(url, body: body, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json, text/plain, */*',
        'Authorization': token,
      }).then((response) async {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        Fluttertoast.showToast(msg: "Амжилттай илгээлээ!");
        client.get('http://lkc.num.edu.mn/task/4/' + domainId.toString(), headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json, text/plain, */*',
          'Authorization': token,
        }).then((result) {
          print(result.body);
//        print(jsonDecode(result.body)['task']['synset'][0]['lemma']);
          var taskResult = jsonDecode(result.body);
          if (taskResult['statusCode'] != 0) {
            prefs.setString("taskID", taskResult['task']['_id'].toString());
            _showTranslation();
            controllerTranslate.text = " ";
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

    var _body = '{ "taskId": "${taskId}", "domainId": "${domainId}", "start_date": "${startDate}",'
        ' "end_date": "${endDate}", "skip": true , "translationType:" "GlossTranslation"}';
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var url = "http://lkc.num.edu.mn/translation";
    var client = new http.Client();

    client.post(url, body: _body, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json, text/plain, */*',
      'Authorization': token,
    }).then((response) async {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    });

    client.get('http://lkc.num.edu.mn/task/4/' + domainId.toString(), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json, text/plain, */*',
      'Authorization': token,
    }).then((result) {
      print(result.body);
//        print(jsonDecode(result.body)['task']['synset'][0]['lemma']);
      var taskResult = jsonDecode(result.body);
      if (taskResult['statusCode'] != 0) {
        prefs.setString("taskID", taskResult['task']['_id'].toString());
        _showTranslation();

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
  if (value == 'eng') {
    return new Image(
      image: new AssetImage('images/united-kingdom.png'),
      width: 25,
      height: 25,
    );
  } else if (value == 'zho') {
    return new Image(
      image: new AssetImage('images/china.png'),
      width: 25,
      height: 25,
    );
  } else if (value == 'deu') {
    return new Image(
      image: new AssetImage('images/germany.png'),
      width: 25,
      height: 25,
    );
  } else if (value == 'fra') {
    return new Image(
      image: new AssetImage('images/france.png'),
      width: 25,
      height: 25,
    );
  } else if (value == 'rus') {
    return new Image(
      image: new AssetImage('images/russia.png'),
      width: 25,
      height: 25,
    );
  } else if (value == 'jpn') {
    return new Image(
      image: new AssetImage('images/japan.png'),
      width: 25,
      height: 25,
    );
  }
}

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;

  StarRating(
      {this.starCount = 5, this.rating = .0, this.onRatingChanged, this.color});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: Theme.of(context).buttonColor,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: color ?? Theme.of(context).primaryColor,
      );
    }
    return new InkResponse(
      onTap:
          onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
        children:
            new List.generate(starCount, (index) => buildStar(context, index)));
  }
}
