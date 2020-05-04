import 'package:flutter/foundation.dart';

class Rep {
  DateTime when = DateTime.now();
}

class ExerciseSet extends ChangeNotifier {
  List<Rep> reps = List<Rep>();

  void rep() {
    reps.add(Rep());
    notifyListeners();
  }

  int count() {
    return reps.length;
  }
}

