import 'package:flutterdgmt/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class WorkoutController {
  //History history;
  ExerciseSetEz exerciseSet;

  String getTag();
  String getKeyForHistory();
  WorkoutType getWorkoutType();
  void getThisWeekAndDaySet();
  int getFinalTestCount();
  int getLabelResource();
  Difficulty getLevelForTestResult(int testCount);

  void beginExercise(){
    //TODO lookup history
    getThisWeekAndDaySet();
  }

  void loadHistory(SharedPreferences prefs) {
    if (history != null) return;

  }

}

class PushupWorkoutController extends WorkoutController {

}