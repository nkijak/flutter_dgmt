import 'package:flutter/foundation.dart';

class Rep {
  DateTime when = DateTime.now();
}

class ExerciseSet{
  List<Rep> reps = List<Rep>();
  DateTime start = DateTime.now();

  void rep() {
    reps.add(Rep());
  }

  int count() {
    return reps.length;
  }
}

