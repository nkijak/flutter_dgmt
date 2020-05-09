import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'models.dart';
import 'EntryPage.dart';

class WorkoutCard extends StatefulWidget {
  WorkoutCard({this.typeName});
  final String typeName;

  @override
  State createState() => WorkoutCardState(type:typeName, sets: List<ExerciseSetEz>());

}

class WorkoutCardState extends State<WorkoutCard> {
  WorkoutCardState({this.type, this.sets});
  final String type;
  final List<ExerciseSetEz> sets;

  _allowSetEntry(BuildContext context, ExerciseSetEz exerciseSet) async {
    final ExerciseSetEz result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            EntryPage(
                type: type,
                exerciseSet: exerciseSet
            )));

    setState(() {
      sets.add(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return  new Card(
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Container(
              height: 80.0,
              margin: EdgeInsets.all(5.0),
              child: ExerciseBarChart(sets),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      margin: new EdgeInsets.all(20.0),
                      child: Text("per day"),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("00"),
                    Text("per"),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(type),
                  ],
                )
              ],
            ),
            new ButtonBar(
              children: <Widget>[
                new FlatButton(
                  child: Text("RECORD ${type.toUpperCase()}"),
                  onPressed: () { _allowSetEntry(context, ExerciseSetEz()); }
                ),
              ],
            ),
          ]
        ),
      );
  }
}

class ExerciseBarChart extends StatelessWidget {
  final List<ExerciseSetEz> sets;
  final bool animate;
  ExerciseBarChart(this.sets, {this.animate});

  @override
  Widget build(BuildContext context) {
    final List<charts.Series<ExerciseSetEz, String>> series = [
      new charts.Series<ExerciseSetEz, String>(
        id: 'Reps',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (ExerciseSetEz sales, _) => sales.start.day.toString(),
        measureFn: (ExerciseSetEz sales, _) => sales.count(),
        data: sets,
      )
    ];
    return new charts.BarChart(
      series,
      animate: animate
    );
  }
}

