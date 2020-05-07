import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'models.dart';
import 'EntryPage.dart';

class WorkoutCard extends StatefulWidget {
  WorkoutCard({this.typeName});
  final String typeName;

  @override
  State createState() => WorkoutCardState(type:typeName, sets: List<ExerciseSet>());

}

class WorkoutCardState extends State<WorkoutCard> {
  WorkoutCardState({this.type, this.sets});
  final String type;
  final List<ExerciseSet> sets;

  _allowSetEntry(BuildContext context, ExerciseSet exerciseSet) async {
    final ExerciseSet result = await Navigator.push(
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
                  onPressed: () { _allowSetEntry(context, ExerciseSet()); }
                ),
              ],
            ),
          ]
        ),
      );
  }
}

class ExerciseBarChart extends StatelessWidget {
  final List<ExerciseSet> sets;
  final bool animate;
  ExerciseBarChart(this.sets, {this.animate});

  @override
  Widget build(BuildContext context) {
    final List<charts.Series<ExerciseSet, String>> series = [
      new charts.Series<ExerciseSet, String>(
        id: 'Reps',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (ExerciseSet sales, _) => sales.start.day.toString(),
        measureFn: (ExerciseSet sales, _) => sales.count(),
        data: sets,
      )
    ];
    return new charts.BarChart(
      series,
      animate: animate
    );
  }
}

