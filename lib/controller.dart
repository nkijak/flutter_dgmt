import 'dart:convert';

import 'package:flutterdgmt/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class WorkoutController {
  History history;
  ExerciseSet exerciseSet;

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
    forceReloadHistory(prefs);
  }

  void forceReloadHistory(SharedPreferences prefs) {
    history = History.deserialize(prefs.getString(getKeyForHistory()));
    print('Loaded history as ${prefs.getString(getKeyForHistory())}');

    if (history == null) {
      history = History();
      history.type = getWorkoutType();
    }
    if (exerciseSet == null && !isTest && !isFinal) getThisWeekAndDaySet();
  }

  WorkoutController addTestResult(int testCount) {
    history.testResults.add(testCount);
    return this;
  }

  WorkoutController resetDay() {
    history.day = 1;
    return this;
  }

  DayAndWeek advanceDate() {
    int day = history.day;
    int week = history.week;

    if (day == 3) {
      day = (week==5 ? 0 : week%2);
      history.day = day;
      history.week += 1;
    } else {
      history.day += 1;
    }

    return new DayAndWeek(day, week);
  }

  void saveHistory(SharedPreferences prefs) {
    lastWorkout = DateTime.now();
    prefs.setString(getKeyForHistory(), jsonEncode(history.toJSON()));
  }

  int get week => (history==null? 1: history.week);
  int get day => (history==null? 0: history.day);
  bool get isTest => (history == null || history.isTest());
  bool get isFinal => (history != null && history.isFinal());
  String get levelForDisplay => history.currentLevel.label;
  bool get finalUnlocked => history.finalUnlocked;
  bool get shouldDisplayDayAsTest => history != null && (history.isTest() || history.isFinal());
  Level get currentLevel => history.currentLevel;
  Logg get currentLog => history.currentLog;
  void markFinalComplete() {
    history.finished = true;
  }
  void resetToWorkoutForFinal() {
    history.week = 6;
    resetDay();
  }
  int get totalCount => history.totalCount;
  int nextSet() => exerciseSet.next();
  bool get isMaxSet => exerciseSet.isMax;
  int get completedSets => exerciseSet.getSetsDone();
  int get incompleteSets => exerciseSet.getSetsToGo();
  int get totalCountLeft => exerciseSet.getCountLeft();
  set lastWorkout(DateTime last) => history.lastWorkout = last;
  set dayAndWeek(DayAndWeek dayAndWeek){
    print('Setting day=${dayAndWeek.day} and week=${dayAndWeek.week}');
    history.day = dayAndWeek.day;
    history.week = dayAndWeek.week;
    getThisWeekAndDaySet();
  }
  get dayAndWeek => DayAndWeek(day, week);
  Logg addCountAndTimeLog(int count, int time) {
    Logg log = history.currentLog;
    log.addCountAndTime(count, time);
    return log;
  }
  void removeCurrentLog() { history.removeCurrentLog(); }
  bool changeCurrentLevel(Level level) {
    history.currentLevel = level;
    bool changedFromTestToOther = false;
    if (history.day == 0) {
      history.day = 1;
      changedFromTestToOther=true;
    }
    getThisWeekAndDaySet();
    return changedFromTestToOther;
  }

}

class PushupWorkoutController extends WorkoutController {
  @override
  String getKeyForHistory() => "history";

  @override
  String getTag() => "nthings:PUSHUP-CONTROL";

  @override
  WorkoutType getWorkoutType() => WorkoutType.PUSHUP;

  @override
  int getFinalTestCount() => 100;

  @override
  int getLabelResource() => -1;  //TODO remove, android only

  @override
  Difficulty getLevelForTestResult(int testCount) {
    // TODO: implement getLevelForTestResult
    throw UnimplementedError();
  }

  @override
  void getThisWeekAndDaySet() {
    super.exerciseSet = ExerciseSet.getPushupSetFor(history.week, history.day, history.currentLevel);
  }
}