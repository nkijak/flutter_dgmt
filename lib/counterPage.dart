import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdgmt/controller.dart';

const CountForTestMessage = 'as many as you can';

class Counter extends StatelessWidget {
  WorkoutController controller;
  int neededCount = 0;
  int count = 0;
  int increment = 1;
  bool showDone = false;

  //TODO need wakelock
  Counter(this.controller) {
    neededCount = controller.nextSet();
    showDone = controller.isMaxSet;

    count = showDone ? 0 : neededCount;
    if (!showDone) increment = -1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Drop and Give Me Twenty!")),
        body: Column(children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xaaaaaaaa),
                        Color(0xffffffff),
                      ]),
                  image: DecorationImage(
                    image: AssetImage('images/bodybg.gif'),
                    repeat: ImageRepeat.repeat,
                  )),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: <Widget>[
                    ProgressMeter(count, increment, neededCount),
                    Expanded(
                      flex: 8,
                      child: RaisedButton(
                        child: Text('COUNT'),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Text(count == 0 && neededCount == 0
                            ? CountForTestMessage
                            : count == 0 ? 'at least $neededCount' : '$count')),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.grey,
                              child: Text("Slide to Finish $showDone"),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ]));
  }
}

class ProgressMeter extends StatefulWidget {
  //TODO deal with USE_SUBCOUNT
  int count;
  int increment;
  int neededCount;

  ProgressMeter(this.count, this.increment, this.neededCount);

  @override
  _ProgressMeterState createState() => _ProgressMeterState();
}

class _ProgressMeterState extends State<ProgressMeter> {
  num get _progressPercent {
    num retval = 0.0;
    if (widget.increment == -1) {
      retval = (1.0 - widget.count * 1.0 / widget.neededCount);
    } else {
      retval = min(1.0, widget.count * 1.0 / widget.neededCount);
    }
    return retval;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: LinearProgressIndicator(value: _progressPercent),
    );
  }
}
