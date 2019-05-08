import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lkc/networklayer.dart';
import 'package:lkc/performance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


//Найруулах

void main() => runApp(ModifyApp());

class ModifyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Нүүр хэсэг',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'Найруулах'),
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
  var controller = new TextEditingController();
  double rating = 3.5;
  List reviseWords = [];
  List translatedGlosses = [];
  List language = [];
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

  void initState() {
    super.initState();
    _showRevise();
      DateTime now = DateTime.now();
      startDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  }

  _showRevise() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    domainId = prefs.getInt("gid");
    taskNumber = prefs.getInt("taskNum");
    taskId = prefs.getString("taskID");
    fetchAllocation(taskNumber, domainId).then((res) {
      setState(() {
        try {
          if(res['languageCode']==0){
            gloss = 'Энэ айд зориулж ямар нэг даалгавар генераци хийгээгүй '
                'эсвэл бүх даалгаврууд хийгдэж дууссан байна. Өөр айд шилжинэ үү.';
          } else {
            reviseWords = res['task']['synset'];
//            if(res['translatedGlosses']==0)
            translatedGlosses = res['task']['translatedGlosses'];
            var t = res['task']['synset'] as List;
            var codes = t.map((x) {
              return x['languageCode'];
            }).toList();
            language = codes;
            print("Revise words:");
            print(res['task']['synset']);
            for(var i in reviseWords){
              if(i['languageCode']==_value){
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

  void _onChanged(String value){
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () =>  Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PerformanceApp()),
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
                'Тайлбарын орчуулсан өгүүлбэрээс сонгон авч өгүүлбэр зүйн болон үгийн сангийн алдааг нь засаж найруулан бичнэ үү!',
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
                  for(var item in reviseWords){
                    if(item['languageCode']==value){
                      lemma = item['lemma'];
                      gloss = item['gloss'];
                    }
                  }
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
            Divider(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: new TextField(
                      decoration: InputDecoration(
                        labelText: 'Тайлбар засварлах хэсэг*',
                        hintText: 'Засаж найруулсан орчуулгаа энд бичнэ үү...',
                        hintStyle: TextStyle(color: Colors.grey),
                        helperText: 'Санамж: зөвхөн тайлбарыг орчуулна',
                        suffixIcon: const Icon(
                          Icons.create,
                          color: Colors.indigo,
                        ),
                      ),
                      maxLength: 256,
                      controller: controller,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: new ExpansionTile(
                backgroundColor: Colors.indigo[200],
                title: new Text("Зүүлт"),
                children: _translatedGlosses(context),
              ),
            ),
            Divider(
              height: 25.0,
            ),
            Row(
              children: <Widget>[
               Expanded(
                 child: new  FlatButton(
                   onPressed: _skipButton,
                   padding: EdgeInsets.only(left: 10.0),
                   child: Row( // Replace with a Row for horizontal icon + text
                     children: <Widget>[
                       Text(" Алгасах", style: TextStyle(color: Colors.indigo),),
                       Icon(Icons.skip_next, color: Colors.indigo,)
                     ],
                   ),
                 ),
                ),
                Expanded(
                  child: new FlatButton(
                    onPressed: _sendButton,
                    padding: EdgeInsets.only(left: 10.0),
                    child: Row( // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Text(" Илгээх ", style: TextStyle(color: Colors.indigo),),
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

  _translatedGlosses(BuildContext context) {
    var children = <Widget>[];
    for (var i=0; i < translatedGlosses.length; i++) {
      var controller = new TextEditingController();
      controller.text = translatedGlosses[i]['gloss'];
      children.add(Row(
        children: <Widget>[
          new Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: new TextField(
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.attachment),
                ),
                controller: controller,
                enabled: false,
              ),
            ),
          ),
        ],
      ));
    }
    return children;
  }
  _sendButton() async{
    DateTime now = DateTime.now();
    endDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    Map data = {
      'taskId': "${taskId}",
      'domainId': "${domainId}",
      'start_date': "${startDate}",
      'end_date': "${endDate}",
      'modification': "${controller.text}",
      'modificationType': "GlossModification",
    };
    print(data);
    var body = jsonEncode(data);
    print(body);
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var url = "http://lkc.num.edu.mn/translation";
    http.post(url,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
        body: body
    )
        .then((response) async {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    });

  }

  _skipButton() async{
    DateTime now = DateTime.now();
    endDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    Map obj = {
      'taskId': "${taskId}",
      'domainId': "${domainId}",
      'start_date': "${startDate}",
      'end_date': "${endDate}",
      'skip': true,
      'modificationType': "GlossModification",
    };
    var body = jsonEncode(obj);
    print(obj);
//    var prefs = await SharedPreferences.getInstance();
//    var token = prefs.getString('token');
//    var url = "http://lkc.num.edu.mn/translation";
//    http.post(url, body: body, headers: {
//      'Content-Type': 'application/json',
//      'Authorization': token,
//    })
//        .then((response) async {
//      print("Response status: ${response.statusCode}");
//      print("Response body: ${response.body}");
//    });
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
