import 'package:flutter/foundation.dart';

class Rep {
  DateTime when = DateTime.now();
}

class ExerciseSetEz{
  List<Rep> reps = List<Rep>();
  DateTime start = DateTime.now();

  void rep() {
    reps.add(Rep());
  }

  int count() {
    return reps.length;
  }
}

class DayAndWeek {
    final int day;
    final int week;
    DayAndWeek(this.day, this.week);

    static notFound() => DayAndWeek(-1,-1);

    bool wasFound() => day > 0 && week > 0;

    @override
    bool operator ==(Object other) =>
        identical(this, other) ||
            other is DayAndWeek &&
                runtimeType == other.runtimeType &&
                day == other.day &&
                week == other.week;

    @override
    int get hashCode =>
        day.hashCode ^
        week.hashCode;
}

class ExerciseSet {
  //TODO test
  List<int> counts;
  List<int> rests;
  int countIndex = 0;
  int restIndex = 0;
  bool onCount = true;
  bool wrappedCounts;
  bool wrappedRests;
  ExerciseSet(this.counts, this.rests);

  int next() {
    int retval = -2;
    onCount = !onCount;
    if (!onCount) {
      print('ExerciseSet:next -- returning next count at index $countIndex');
      retval = counts[countIndex];
      if (countIndex + 1 >= counts.length) {
        print('ExerciseSet:next -- ${countIndex + 1} is >= ${counts
            .length} wrapping back to index 0');
        countIndex = 0;
        wrappedCounts = true;
      } else {
        countIndex++;
      }
    } else {
      retval = rests[restIndex];
      print('ExerciseSet:next -- returning next rest at index $restIndex');
      if (restIndex+1>=rests.length) {
        restIndex = 0;
        wrappedRests = true;
      } else {
        restIndex++;
      }
    }
    return retval;
  }

  bool hasNext(){
    bool stillHasCounts = (countIndex < counts.length) && !wrappedCounts;
    bool stillHasRests = (restIndex < rests.length) && !wrappedRests;
    return stillHasCounts || stillHasRests;
  }

  bool isMax() => !onCount && countIndex == 0 && wrappedCounts;

  int getSetsToGo() {
    int totalSets = (counts.length > rests.length)? counts.length: rests.length+1;
    return totalSets - getSetsDone();
  }

  int getSetsDone() => countIndex;

  int getCountLeft() {
    int totalCount = 0;
    //TODO use map
    for (int i = countIndex; i < counts.length; i++) {
      totalCount += counts[i];
    }
    return totalCount;
  }

  List<int> getCounts() {
    return counts;
  }

  List<int> getRests() {
    return rests;
  }

  List<int> getMinMaxCounts() {
    int min = 10000000;
    int max = -10000000;
    //TODO use reduce
    for(int count in counts) {
      if (count > max) max = count;
      if (count < min) min = count;
    }

    print('DGMT!ExerciseSet -- Found min $min and max $max for set');
    return [min,max];
  }

}

enum WorkoutType { PUSHUP, SITUP, SQUAT }
enum Level { EASY, MED, HARD }

final int LONG_REST = 120000;
final int MEDIUM_REST = 90000;
final int STANDARD_REST = 60000;
final int SHORT_REST = 45000;

final PushupSchedule = {
  'week1': {
    'day1': {
      Level.EASY: {
        'reps': [2,3,2,2,3],
        'rests': [STANDARD_REST]
      },
      Level.MED: {
        'reps': [6,6,4,4,5],
        'rests': [STANDARD_REST]
      },
      Level.HARD: {
        'reps': [10,12,7,7,9],
        'rests': [STANDARD_REST]
      },
    },
    'day2': {
      Level.EASY: {
        'reps': [3,4,2,3,4],
        'rests': [MEDIUM_REST]
      },
      Level.MED: {
        'reps': [6,8,6,6,7],
        'rests': [MEDIUM_REST]
      },
      Level.HARD: {
        'reps': [10,12,8,8,12],
        'rests': [MEDIUM_REST]
      },
    },
    'day3': {
      Level.EASY: {
        'reps': [4,5,4,4,5],
        'rests': [LONG_REST]
      },
      Level.MED: {
        'reps': [8,10,7,7,10],
        'rests': [LONG_REST]
      },
      Level.HARD: {
        'reps': [11,15,8,8,13],
        'rests': [LONG_REST]
      },
    },
  }
  //TODO add other weeks
};

