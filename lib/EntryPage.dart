import 'package:flutter/material.dart';
import 'models.dart';

class EntryPage extends StatelessWidget {
  EntryPage({Key key, this.type, this.exerciseSet}):super(key: key);
  final String type;
  final ExerciseSet exerciseSet;

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type),
      ),
      body: new Column(
        children:[
          Container(
            child: Counter(exerciseSet)
          ),
          Flexible(
            child: Container(
              margin: new EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                controller: _textController,
                decoration: new InputDecoration.collapsed(hintText: "How many did you do?"),
              )
            ),
          ),
          Container(
            child: RaisedButton(
              child: Text("Submit"),
              onPressed: () => Navigator.pop(context, _textController.text)
            )
          )
        ],
      )
    );
  }
}

class Counter extends StatefulWidget {
  Counter(this.exerciseSet);
  final ExerciseSet exerciseSet;
  @override
  State<StatefulWidget> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  void _increment() {
    setState(() {
      widget.exerciseSet.rep();
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Row(
      children: <Widget>[
        RaisedButton(
            onPressed: _increment,
            child: Text(widget.exerciseSet.count().toString())
        )
      ],
    )
    ;
  }
}