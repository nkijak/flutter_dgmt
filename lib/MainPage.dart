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
  
  @override
  Widget build(BuildContext context) {
    var exerciseSet = new ExerciseSet();
    sets.add(exerciseSet);
    return  new Card(
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Container(
              height: 80.0,
              margin: new EdgeInsets.all(5.0),
              child: new SimpleBarChart.withSampleData(),
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
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        EntryPage(
                          type: type,
                          exerciseSet: exerciseSet,)),
                  ),
                ),
              ],
            ),
          ]
        ),
      )
        ;
  }
}
class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SimpleBarChart.withSampleData() {
    return new SimpleBarChart(
      _createExerciseData(),
      // Disable animations for image tests.
      animate: true,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<ExerciseSet, String>> _createExerciseData() {
    final data = [ ExerciseSet()];

    return [
      new charts.Series<ExerciseSet, String>(
        id: 'Reps',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (ExerciseSet sales, _) => sales.start.day.toString(),
        measureFn: (ExerciseSet sales, _) => sales.count(),
        data: data,
      )
    ];
  }
}

