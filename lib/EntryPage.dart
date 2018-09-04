import 'package:flutter/material.dart';

class EntryPage extends StatelessWidget {
  EntryPage({this.type});
  final String type;

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
            child: Text("Try to do N!")
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