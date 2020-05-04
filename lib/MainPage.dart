import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import 'models.dart';
import 'EntryPage.dart';

class WorkoutCard extends StatefulWidget {
  WorkoutCard({this.typeName});
  final String typeName;

  @override
  State createState() => WorkoutCardState(type:typeName);

}

class WorkoutCardState extends State<WorkoutCard> {
  WorkoutCardState({this.type});
  final String type;
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ExerciseSet>(
      create: (context) => new ExerciseSet(),
      child:  new Card(
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
            new ButtonTheme.bar( // make buttons use the appropriate styles for cards
              child: new ButtonBar(
                children: <Widget>[
                  new FlatButton(
                    child: Text("RECORD ${type.toUpperCase()}"),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EntryPage(type: type)),
                      );

                      Scaffold.of(context).showSnackBar(SnackBar(content: Text("$result")));
                    },
                  ),
                ],
              ),
            ),
          ]
        ),
      )
    );
  }
}
class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SimpleBarChart.withSampleData() {
    return new SimpleBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
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
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
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