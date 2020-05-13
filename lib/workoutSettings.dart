import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutterdgmt/controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'models.dart';

class WorkoutSettingPage extends StatelessWidget {
  final WorkoutController controller;
  WorkoutSettingPage(this.controller){
    this.controller.getThisWeekAndDaySet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.getWorkoutType().toString()),
      ),
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
                      image: DecorationImage(
                        image: AssetImage('images/bodybg.gif'),
                        repeat: ImageRepeat.repeat,
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        SpeechBalloon(controller),
                        LevelSelector(controller),
                        Container(
                          height: 80.0,
                          color: Colors.white,
                          margin: EdgeInsets.all(5.0),
                          child: ExerciseBarChart(controller),
                        ),
                        StartButton(controller),
                        TestButton(controller),
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

class StartButton extends StatelessWidget {
  WorkoutController controller;
  StartButton(this.controller);

  void _doActivity(){
    print("Do activity stuff");
  }

  @override
  Widget build(BuildContext context) {
    return
      FlatButton(
        child:Text('Start',),
        onPressed: _doActivity,);
  }
}


class TestButton extends StatelessWidget {
  WorkoutController controller;
  TestButton(this.controller);

  @override
  Widget build(BuildContext context) {
    //TODO this is more complicated, but is likely going away so not bothering
    return FlatButton(child:Text("FINAL"),
        onPressed: (controller.finalUnlocked? () {
          print("final requested");
        }: null));
  }
}


class SpeechBalloon extends StatefulWidget {
  WorkoutController controller;
  SpeechBalloon(this.controller);
  @override
  _SpeechBalloonState createState() => _SpeechBalloonState();
}

class _SpeechBalloonState extends State<SpeechBalloon> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, )
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Drop and Give Me ${widget.controller.totalCountLeft}!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 30.0
                ),),
            ),
          ),
        ),
      ],
    );
  }
}


class LevelSelector extends StatefulWidget {
  final WorkoutController controller;
  LevelSelector(this.controller);
  @override
  _LevelSelectorState createState() => _LevelSelectorState();
}

typedef PressHandler();

class _LevelSelectorState extends State<LevelSelector> {
  void _selectDay(int day) {
    _updateDayAndWeek(widget.controller.dayAndWeek.changeDay(day));
  }
  void _selectWeek(int week) {
    _updateDayAndWeek(widget.controller.dayAndWeek.changeWeek(week));
  }
  void _updateDayAndWeek(DayAndWeek dayAndWeek) {
    bool changed = dayAndWeek != widget.controller.dayAndWeek;
    if (dayAndWeek.wasFound() && !widget.controller.isTest && changed) {
      setState(() {
        widget.controller.dayAndWeek = dayAndWeek;
      });
    }
  }
  void _selectDifficulty(Difficulty diff) {

  }

  String _buttonLabel(int index) {
    if (index < 6) {
      return '${index+1}';
    }
    if (index < 9) {
      return '${index - 5}';
    }
    return ['E','M','H'][index - 9];
  }

  PressHandler _setupOnPress(int index){
    DayAndWeek dayAndWeek = widget.controller.dayAndWeek;
    if (index < 6) {
      return dayAndWeek.day >= index?
          () => _selectDay(index+1):
          null;
    }
    if (index < 9) {
      return dayAndWeek.week >= (index-5)?
          () => _selectWeek(index - 5):
          null;
    }
    int levelIndex = widget.controller.currentLevel.index;
    return levelIndex >= (index - 9)?
        () => _selectDifficulty(Difficulty.values[index - 9]):
        null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, top: 10.0, right: 40.0, bottom: 10.0),
      child: StaggeredGridView.countBuilder(
          shrinkWrap: true,
          crossAxisCount: 6,
          itemCount: 12,
          itemBuilder: (BuildContext context, int index) =>
              RaisedButton(
                  child:Text(_buttonLabel(index)),
                  onPressed: _setupOnPress(index),),
          staggeredTileBuilder: (int index) =>
              StaggeredTile.count(index < 6? 1: 2, 1),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
      ),
    );
  }
}

class ExerciseBarChart extends StatefulWidget {
  final WorkoutController controller;
  final bool animate;
  ExerciseBarChart(this.controller, {this.animate});
  @override
  _ExerciseBarChartState createState() => _ExerciseBarChartState();
}

class _ExerciseBarChartState extends State<ExerciseBarChart> {

  @override
  Widget build(BuildContext context) {
    final List<charts.Series<int, String>> series = [
      new charts.Series<int, String>(
        id: 'Reps',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (int expected, int index) => '$index',
        measureFn: (int expected, int index) => expected,
        data: widget.controller.exerciseSet.counts,
      )
    ];
    return new charts.BarChart(
        series,
        animate: widget.animate
    );
  }
}
