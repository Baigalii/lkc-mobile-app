import 'package:flutter/material.dart';
import 'package:lkc/netwoklayer.dart';
import 'package:lkc/performance.dart';
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
  var targetWords;
  String gloss = '', lemma = '', targetWord = '';
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
    _showTranslation();

  }

  _showTranslation() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int gid = prefs.getInt("gid");
    fetchTranslation(gid).then((res) {
      setState(() {
        try {
          if(res['languageCode']==0){
            gloss = 'Энэ айд зориулж ямар нэг даалгавар генераци хийгээгүй эсвэл бүх даалгаврууд хийгдэж дууссан байна. Өөр айд шилжинэ үү.';
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
            for(var i in translationWords){
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

    controller.text = targetWords;
    print('Target Words');
    print(targetWords);
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
                  for(var item in translationWords){
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
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )
                  ),
                  controller: controller,
                ),
              ),

//                Padding(
//                  padding: EdgeInsets.all(20.0),
//                  child:  new Text(targetWords, style: TextStyle(), ),
//                ),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: new Theme(
                      data: new ThemeData(
                          hintColor: Colors.black
                      ),
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
                            borderSide: const BorderSide(color: Colors.indigo, width: 0.0),
                          ),
                          border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.red),
                          ),
                        ),
                        maxLength: 256,
                      ),
                    )
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
                  padding: EdgeInsets.only(left: 100.0),
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
