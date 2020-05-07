import 'package:flutter/material.dart';
import 'MainPage.dart';

void main() => runApp(new DGMT2());

class DGMT2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green,
      ),
      home: MainPage()
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('DGMT')
        ),
        body: Column(
            children: [
              WorkoutCard(typeName: "pullups"),
              WorkoutCard(typeName: "pushups"),
            ]
        )
    );
  }
}

