import 'package:flutter/material.dart';
import 'package:lkc/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Нүүр хэсэг',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      initialRoute: '/',
      routes: routes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final Map<String, Map<String, String>> localizedValues;
  MyHomePage({Key key, this.title, this.localizedValues}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentStep = 0;
  int _lan;
  var lans = <String>[
    'English (en)',
    'Mongolia (mn)',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("images/wallpaper.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: new Card(
                child: new Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: new Text(
                    'тавтай морил!'.toUpperCase(),
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.0, top: 70.0, right: 5.0),
            child: new Card(
              child: new Stepper(
                controlsBuilder: (BuildContext context,
                    {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                  return Row(
                    children: <Widget>[
                      FlatButton(
                        onPressed: onStepCancel,
                        child: const Text('Return'),
                      ),
                      FlatButton(
                        onPressed: onStepContinue,
                        child: const Text('Proceed'),
                      ),
                    ],
                  );
                },
                steps: _mySteps(),
                type: StepperType.vertical,
                currentStep: this._currentStep,
                onStepTapped: (step) {
                  setState(() {
                    this._currentStep = step;
                  });
                },
                onStepContinue: () {
                  setState(() {
                    if (this._currentStep < this._mySteps().length - 1) {
                      this._currentStep = this._currentStep + 1;
                    } else {
                      //Logic to check if everything is complicated
                      Navigator.pushNamed(context, "/");
                      print('Task, check fields.');
                    }
                  });
                },
                onStepCancel: () {
                  setState(() {
                    if (this._currentStep == 0) {}
                    if (this._currentStep > 0) {
                      this._currentStep = this._currentStep - 1;
                    } else {
                      this._currentStep = 0;
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Step> _mySteps() {
    List<Step> _steps = [
      Step(
        title: Text('Хэл сонгох'),
        content: DropdownButton<String>(
          hint: new Text('Хэлээ сонгоно уу'),
          value: _lan == null ? null : lans[_lan],
          items: lans.map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _lan = lans.indexOf(value);
            });
          },
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Text('Төсөл'),
        content: InkWell(
          child: Text("Энд дарж манай төсөлтэй танилцана уу."),
          onTap: () {
            Navigator.pushNamed(context, '/project');
          },
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text('Нутагшуулалт'),
        content: InkWell(
          child: Text(
              'Энд дарж ойлголтыг нутагшуулах зааварчилгаатай танилцана уу.'),
          onTap: () {
            Navigator.pushNamed(context, '/guidelines');
          },
        ),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: Text('Даалгавар'),
        content: new Ink(
          decoration: new BoxDecoration(
            color: Colors.white30,
          ),
          child: new InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
            child: Text(
                'Та өмнөх шаардлагуудыг хангасан бол "Оролцох" товчийг дарна уу.'),
          ),
        ),
        isActive: _currentStep >= 3,
      ),
    ];
    return _steps;
  }
}
