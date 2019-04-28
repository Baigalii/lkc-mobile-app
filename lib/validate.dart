import 'package:flutter/material.dart';
import 'package:lkc/netwoklayer.dart';
import 'package:lkc/performance.dart';
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
  double rating = 3.5;
  int radioValue;

  List correct = [];
  List wrong = [];
  List unfamiliar = [];
  List language = [];

  List<TextEditingController> txtController = [];
  List validationWords = [];
  List modifiedWords = [];
  List _ratings= [];
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
    _showValidation();
  }

  _showValidation() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int gid = prefs.getInt("gid");
    fetchValidation(gid).then((res) {
      setState(() {
        try {
          if(res['statusCode']==0){
            gloss = 'Энэ айд зориулж ямар нэг даалгавар генераци хийгээгүй эсвэл бүх даалгаврууд хийгдэж дууссан байна. Өөр айд шилжинэ үү.';
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
    print(modifiedWords);
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
//          bottom: ,
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
                  for(var item in validationWords){
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
                    onPressed: () => {},
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
                    onPressed: () => {},
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
                    onPressed: () => {},
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
