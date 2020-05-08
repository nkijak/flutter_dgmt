import 'package:flutter/material.dart';

void main() => runApp(new DGMT2());

class DGMT2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green,
        buttonBarTheme: ButtonBarTheme.of(context)
      ),
        home: Home()
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("DGMT")),
        body: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xaaaaaaaa),
                            Color(0xffffffff),
                          ]
                      ),
                      //TODO this doesn't seem to be appearing
                      image: DecorationImage(
                        image: AssetImage('images/bodybg.gif'),
                        repeat: ImageRepeat.repeat,
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        Image.asset('images/inapp_logo.png'),
                        ExerciseInfo("Push Ups"),
                        ExerciseInfo("Sit Ups", rtl: true,),
                      ],
                    ),
                  ),
                ),
              ),
            ]
        )
    );
  }
}

class ExerciseInfo extends StatelessWidget {
  String header;
  bool rtl = false;

  ExerciseInfo(this.header, {this.rtl});

  final label = TextStyle(
      fontSize: 20,
      shadows: [
        Shadow(color: Color(0xCCFFFFFF),
          offset: Offset(0.0, 1.0),
          blurRadius: 1.0,
        )
      ]
  );
  final value = TextStyle(
      fontSize: 32,
      color: Color(0xFF888888)
  );
  final button = TextStyle(
      fontSize: 35.0,
      shadows: [
        Shadow(color: Color(0xFFFFFFFF),
          offset: Offset(0.0, 1.0),
          blurRadius: 1.0,
        )
      ]
  );

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [
      Expanded(
        child: RaisedButton(
          child: Text(header, style: button,),
          onPressed: () {
            print("$header pushed");
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          children: <Widget>[
            Text(
                "Last",
                style: label
            ),
            Text("1/1/11", style: value),

            Text("Last Count", style: label),
            Text("112", style: value),

            Text("Total+Tests", style: label),
            Text("696", style: value),
          ],
        ),
      )
    ];
    return Row(
      children: (rtl == true ? _children.reversed.toList() : _children),
    );
  }
}

