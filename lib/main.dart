import 'package:flutter/material.dart';
import 'package:flutterdgmt/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

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

class ExerciseInfo extends StatefulWidget {
  final String header;
  final bool rtl;


  ExerciseInfo(this.header, {this.rtl});
  @override
  _ExerciseInfoState createState() => _ExerciseInfoState();
}

class _ExerciseInfoState extends State<ExerciseInfo> with WidgetsBindingObserver {
  //TODO needs to be variable
  WorkoutController workoutController = PushupWorkoutController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _onResume();
    }
  }

  _onResume() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      workoutController.forceReloadHistory(prefs);
    });
  }

  String _formatDate(DateTime dateTime) => DateFormat.yMd().format(dateTime);


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
          child: Text(widget.header, style: button,),
          onPressed: () {
            print("${widget.header} pushed");
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          children: <Widget>[
            Text("Last", style: label),
            Text(_formatDate(workoutController.lastWorkout), style: value),

            Text('Last Count', style: label),
            Text('${workoutController.currentLog.totalCount}', style: value),

            Text('Total+Tests', style: label),
            Text('${workoutController.totalCount}', style: value),
          ],
        ),
      )
    ];
    return Row(
      children: (widget.rtl == true ? _children.reversed.toList() : _children),
    );
  }
}

