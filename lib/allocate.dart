import 'dart:convert';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lkc/performance.dart';
import 'package:lkc/synset.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lkc/netwoklayer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:lkc/previous.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:toast/toast.dart';
import 'package:flutter/rendering.dart';

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
  List provideWords = [];
  List language = [];
  bool _validate = false;

  List<double> ratings = [];
//  double rating = 0;

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

  @override
  void initState() {
    super.initState();
    _showTranslation();
    setState(() {
      _star.add(SmoothStarRating());
      _words.add('');
      _controllers.add(new TextEditingController());
      ratings.add(0);
    });
  }

  _showTranslation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int gid = prefs.getInt("gid");
    fetchAllocation(gid).then((res) {
      setState(() {
        try {
          if (res['statusCode'] == 0) {
            gloss =
                'Энэ айд зориулж ямар нэг даалгавар генераци хийгээгүй эсвэл бүх даалгаврууд хийгдэж дууссан байна. Өөр айд шилжинэ үү.';
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
      });
    });
  }

  void _onChanged(String value) {
    setState(() {
      _value = value;
    });
  }
//
//  @override
//  void dispose() {
//    super.dispose();
//  }

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
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) => FlareGiffyDialog(
                        flarePath: 'assets/space_demo.flr',
                        flareAnimation: 'loading',
                        title: Text(
                          'Ажлын заавар',
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.w600),
                        ),
                        description: new Text(
                          'Бид таны оруулсан хувь нэмрийг Монгол НМЦ үүсгэхэд ашиглах болно. Танд баярлалаа.',
                          textAlign: TextAlign.center,
                          style: TextStyle(),
                        ),
                        onOkButtonPressed: () {},
                      ));
            },
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
                    for (var item in provideWords) {
                      if (item['languageCode'] == value) {
                        lemma = item['lemma'];
                        gloss = item['gloss'];
                      }
                    }
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
                  child: FlatButton(
//                  onPressed: _showDialog,
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
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      Map obj = {
                        'taskId': 123, 'domainId': 124, 'start_date': '132123', 'end_date': '23345',
                        'translation': [
                          { 'lemma': 'asd', 'rating': 4 },
                          { 'lemma': 'wer', 'rating': 5 },
                        ],
                      };
                      print(obj);

                      return;
                      setState(() {
                        for (var i = 0; i <= _controllers.length; i++) {
                          _controllers[i].text.isEmpty
                              ? _validate = true
                              : _validate = false;
                        }
                      });
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
              ],
            ),
          ],
        ),
      ),
//        bottomNavigationBar: CurvedNavigationBar(
//          backgroundColor: Colors.blueAccent,
//            items: <Widget>[
//                Icon(Icons.add, size: 20),
//                Icon(Icons.list, size: 30),
//                Icon(Icons.compare_arrows, size: 30),
//                ],
//            onTap: (index) {
//            //Handle button tap
//          },
//        ),
    );
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
                      errorText:
                          _validate ? 'Илгээх өгөгдөл байхгүй байна!' : null,
                      suffix: IconButton(
                        icon: Icon(Icons.cancel),
//                  onPressed: _onClear,
                      ),
//                border: new OutlineInputBorder(
//                  borderSide: new BorderSide(color: Colors.blueAccent),
//                ),
                    ),
                    controller: _controllers[i],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only( right: 20.0),
                child: IconButton(
                  alignment: Alignment.bottomRight,
                  color: Colors.indigo,
                  iconSize: 35.0,
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {
                    setState(() {
                      print(i);
                      _words.add('');
                      _controllers.add(TextEditingController());
                      ratings.add(0);
                    });
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
                  setState(() {
                    print(i);
                    _words.removeAt(i);
                    _controllers.removeAt(i);
                  });
                },
              )
            ],
          ),
        ],
      ));
    }
    return children;
  }

  void _skipButton() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int gid = prefs.getInt("gid");
    int type = prefs.getInt("type");
    getNextTask(gid, type).then((res) {
      setState(() {
        try {
          provideWords = res['data']['synset'];
          print("Provide words:");
          print(res['data']['synset']);
        } catch (e) {
          print(e);
        }
      });
    });
  }

//  _onClear() {
//    setState(() {
//      _controllers[].text = "";
//    });
//  }
}
