import 'dart:convert';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lkc/performance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lkc/networklayer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:lkc/previous.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';


//Үг оноох

void main() => runApp(AllocateApp());

class AllocateApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Нүүр хэсэг',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'Үг оноох'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<String> _words = [];
  List<TextEditingController> _controllers = [];
  List<SmoothStarRating> _star = [];
  TextEditingController _textFieldController = TextEditingController();
  List provideWords = [];
  List language = [];
  bool _validate = false;

  List<double> ratings = [];
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

  @override
  void initState() {
    super.initState();
    _showTranslation();
    DateTime now = DateTime.now();
    startDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    setState(() {
      _star.add(SmoothStarRating());
      _words.add('');
      _controllers.add(new TextEditingController());
      ratings.add(0);
    });
  }

  _showTranslation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    taskNumber = prefs.getInt("taskNum");
    domainId = prefs.getInt("gid");
    taskId = prefs.getString("taskID");
    fetchAllocation(taskNumber,domainId).then((res) {
      setState(() {
        _processAllocations(res);
      });
    });
  }

  void _processAllocations(res) async{
    try {
      if (res['statusCode'] == 0) {
        gloss = 'Энэ айд зориулж ямар нэг даалгавар генераци хийгээгүй '
            'эсвэл бүх даалгаврууд хийгдэж дууссан байна. Өөр айд шилжинэ үү.';
      } else {
        provideWords = res['task']['synset'];
        var t = res['task']['synset'] as List;
        var codes = t.map((x) {
          return x['languageCode'];
        }).toList();
        language = codes;
        for (var i in provideWords) {
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
    for (var item in provideWords) {
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
    print("Task list length: ");
    print(provideWords.length);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PerformanceApp()),
              ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.live_help),
            tooltip: 'Ажлын заавар',
//            onPressed: () {
//              showDialog(
//                  context: context,
//                  builder: (_) => FlareGiffyDialog(
//                        flarePath: 'assets/space_demo.flr',
//                        flareAnimation: 'loading',
//                        title: Text(
//                          'Ажлын заавар',
//                          style: TextStyle(
//                              fontSize: 22.0, fontWeight: FontWeight.w600),
//                        ),
//                        description: new Text(
//                          'Бид таны оруулсан хувь нэмрийг Монгол НМЦ үүсгэхэд ашиглах болно. Танд баярлалаа.',
//                          textAlign: TextAlign.center,
//                          style: TextStyle(),
//                        ),
//                        onOkButtonPressed: () {},
//                      ));
//            },
          ),
        ],
      ),
      body: new SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: new Text(
                'Дараах ойлголтыг илэрхийлэх монгол үг(с)ийг оноож бичнэ үү',
                style: new TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
            Divider(
              height: 5.0,
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

//            Divider(
//              height: 10.0,
//            ),
            Column(
              children: _buildWords(context),
            ),
            Divider(
              height: 25.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PreviousApp()),
                          ),
                        },
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Icon(
                          Icons.skip_previous,
                          color: Colors.indigo,
                        ),
                        Text(
                          "Өмнөх",
                          style: TextStyle(color: Colors.indigo),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    padding: EdgeInsets.only(left: 80.0),
                    onPressed: _skipButton,
                    //padding: EdgeInsets.all(10.0),
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
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: FlatButton(
                      onPressed: () => _showDialog(context),
                      splashColor: Colors.indigo,
                      child: Row(
                        // Replace with a Row for horizontal icon + text
                        children: <Widget>[
                          Icon(
                            Icons.event_busy,
                            color: Colors.indigo,
                          ),
                          Text(
                            "GAP",
                            style: TextStyle(color: Colors.indigo),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: FlatButton(
                      padding: EdgeInsets.only(left: 80.0),
                      onPressed: (){
                        _sendButton();
                      },
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
                  var translationGap = [];
                    translationGap.add({
                      'lemma': "GAP",
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
                    'translation': translationGap,
                  });
                  print(obj);
                  var prefs = await SharedPreferences.getInstance();
                  var token = prefs.getString('token');
                  var url = "http://lkc.num.edu.mn/translation";
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

  _buildWords(BuildContext context) {
    var children = <Widget>[];
    for (var i = 0; i < _words.length; i++) {
      children.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 30.0, right: 10.0),
                  child: new TextField(
                    decoration: InputDecoration(
                      labelText: 'Илэрхийлэх үг',
                      hintText: '',
                      hintStyle: TextStyle(color: Colors.grey),
                      suffix: IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: (){
                          setState(() {
                            _controllers[i].text = "";
                          });
                        },
                      ),
                    ),
                    controller: _controllers[i],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: IconButton(
                  alignment: Alignment.bottomRight,
                  color: Colors.indigo,
                  iconSize: 35.0,
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {
                    if(_controllers[i].text == "") {
                      Fluttertoast.showToast(msg: "Үгээ оруулна уу!");
                    }
                    else if(_controllers[i].text != "" && ratings[i]<=0){
                      Fluttertoast.showToast(msg: "Өөрийн үнэлгээгээ дарна уу!");
                    }else {
                      setState(() {
                        print(i);
                        _words.add('');
                        _controllers.add(TextEditingController());
                        ratings.add(0);
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                child: SmoothStarRating(
                  rating: ratings[i],
                  size: 25,
                  starCount: 5,
                  onRatingChanged: (value) {
                    setState(() {
                      ratings[i] = value;
                    });
                  },
                ),
              ),
              IconButton(
                padding: EdgeInsets.only(left: 70.0),
                alignment: Alignment.centerLeft,
                color: Colors.red,
                icon: Icon(Icons.remove_circle),
                onPressed: () {
                  if(_controllers.length==1){
                    Fluttertoast.showToast(msg: "Bolohgui ee");
                  } else {
                    setState(() {
                      print(i);
                      _words.removeAt(i);
                      _controllers.removeAt(i);
                    });
                  }
                },
              )
            ],
          ),
        ],
      ));
    }

    return children;
  }

  _sendButton() async {
    var translationWords = [];
    for (var i = 0; i < _words.length; i++) {
      translationWords.add({
        'lemma': _controllers[i].text,
        'rating': ratings[i],
      });
    }
    DateTime now = DateTime.now();
    endDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    Map obj = {
      'taskId': "${taskId}",
      'domainId': "${domainId}",
      'start_date': "${startDate}",
      'end_date': "${endDate}",
      'translation': translationWords,
    };
    print(obj);
    var _body = jsonEncode(obj);
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var url = "http://lkc.num.edu.mn/translation";
    var client = new http.Client();

    client.post(url, body: _body, headers: {
      'Content-Type': 'application/json',
      'Authorization': token,
    }).then((response) async {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      client.get('http://lkc.num.edu.mn/task/1/' + domainId.toString(), headers: {
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
    });

  }

  _skipButton() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int gid = prefs.getInt("gid");
    var type = prefs.getInt("type");
    String taskName = "translation";
    String taskId = prefs.getString('taskID');

    getNextTask(taskName, gid, taskId).then((res) {
      if (res['success'] == true) {
        prefs.setString('taskID', res['data']['taskId']);
        _processAllocations({
          'status': 1,
          'task': {
            'synset': res['data']['synset'],
          }
        });
        print(res['data']['synset']);
        _onChanged(language[0]);
      }
//      try {
//        provideWords = res['data']['synset'];
//        print("Provide words:");
//        print(res['data']['synset']);
//        print(res);
//      } catch (e) {
//        print(e);
//      }
    });
  }
}


