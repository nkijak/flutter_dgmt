import 'package:flutter/material.dart';
import 'package:flutterdgmt/controller.dart';
import 'package:flutterdgmt/workoutSettings.dart';
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
        buttonBarTheme: ButtonBarTheme.of(context),
        buttonTheme: ButtonTheme.of(context).copyWith(minWidth: 50,padding: EdgeInsets.only(left: 3, right: 3))
      ),
        home: Home()
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Drop and Give Me Twenty!")),
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
        //XXX this sizedbox is kinda gross, not sure how to do it otherwise
        child: SizedBox(
          height: 165,
          child: RaisedButton(
              color: Colors.grey[400],
              highlightColor: Colors.green,
              child: Text(widget.header, style: button,),
              onPressed: widget.rtl == true? null: () {
                print("${widget.header} pushed");
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    WorkoutSettingPage(workoutController))); //TODO get title from controller
              },
            ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          crossAxisAlignment: (widget.rtl ==true? CrossAxisAlignment.end: CrossAxisAlignment.start),
          children: <Widget>[
            Text("Last", style: label, textAlign: TextAlign.left,),
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

