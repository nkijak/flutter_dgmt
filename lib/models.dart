import 'dart:convert';

import 'package:flutter/foundation.dart';

class Rep {
  DateTime when = DateTime.now();
  int avgTime;
  int count;
  History history;
  Rep.fromJSON(this.history, Map<String, dynamic> json) {
    count = json['count'];
    avgTime = json['avgTime'];
  }
  Rep(this.history, this.count, this.avgTime);

  Map<String, dynamic> toJSON() => {
    "count": count,
    "avgTime": avgTime
  };
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

  ExerciseSet.getPushupSetFor(int week, int day, Level level) {
    print('getting pushups for week $week, day $day, level $level');
    final schedule = PushupSchedule['week$week']['day$day'][level];
    counts = schedule['counts'];
    rests = schedule['rests'];
  }

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

  bool get isMax => !onCount && countIndex == 0 && wrappedCounts;

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
enum Difficulty { EASY, MED, HARD }

const int LONG_REST = 120000;
const int MEDIUM_REST = 90000;
const int STANDARD_REST = 60000;
const int SHORT_REST = 45000;

const PushupSchedule = {
  'week1': {
    'day1': {
      Difficulty.EASY: {
        'reps': [2,3,2,2,3],
        'rests': [STANDARD_REST]
      },
      Difficulty.MED: {
        'reps': [6,6,4,4,5],
        'rests': [STANDARD_REST]
      },
      Difficulty.HARD: {
        'reps': [10,12,7,7,9],
        'rests': [STANDARD_REST]
      },
    },
    'day2': {
      Difficulty.EASY: {
        'reps': [3,4,2,3,4],
        'rests': [MEDIUM_REST]
      },
      Difficulty.MED: {
        'reps': [6,8,6,6,7],
        'rests': [MEDIUM_REST]
      },
      Difficulty.HARD: {
        'reps': [10,12,8,8,12],
        'rests': [MEDIUM_REST]
      },
    },
    'day3': {
      Difficulty.EASY: {
        'reps': [4,5,4,4,5],
        'rests': [LONG_REST]
      },
      Difficulty.MED: {
        'reps': [8,10,7,7,10],
        'rests': [LONG_REST]
      },
      Difficulty.HARD: {
        'reps': [11,15,8,8,13],
        'rests': [LONG_REST]
      },
    },
  }
  //TODO add other weeks
};

class Logg{
  History history;
  int week;
  int day;
  List<Rep> _counts = [];

  Logg(this.history, this.week, this.day);
  Logg.fromJSON(this.history, Map<String, dynamic> json){
    week = json['week'];
    day = json['day'];
    List<Map<String, dynamic>> jsonCounts = json['counts']
    _counts = jsonCounts.map((jsoncount) => Rep.fromJSON(history, jsoncount));

  }

  List<int> get counts {
    return _counts.map((rep) => rep.count);
  }

  int get totalCount =>
      _counts.fold(0, (total, rep) => total + rep.count);

  //TODO averageMillisPerPushup?
  //TODO averagePushupFrequency?

  Map<String, dynamic> toJSON(){
    return {
      "week": week,
      "day": day,
      "counts": counts.map((rep) => rep.toJSON())
    };
  }

  Rep addCountAndTime(count, time) {
    Rep rep = Rep(history, count, time);
    _counts.add(rep);
    return rep;
  }

  bool isFor(week, day) =>
      this.week == week && this.day == day;
}

class Level {
  int index;
  int startWeek;
  String label;
  Level(this.index, this.startWeek, this.label);
  Map<String, dynamic> toJSON() => {
    'index': index,
    'startWeek': startWeek,
    'label': label
  };
}

class GenericLevel extends Level {

  GenericLevel(int index, int startWeek, String label):super(index, startWeek, label);

  GenericLevel.fromJson(Map<String, dynamic> json):super(
    json['index'],
    json['label'],
    json['startWeek']
  );
}


class History {
  List<int> testResults = List();
  Level currentLevel;
  List<Logg> logs = List();
  int week = 1;
  int day = 0;
  WorkoutType type;
  DateTime lastWorkout;
  bool finished;
  bool finalUnlocked;

  History();

  History.deserialize(String jsonHistory) {
    final json = jsonDecode(jsonHistory);
    day = json['day'];
    week = json['week'];
    type = WorkoutType.values.firstWhere((el) => el == json['type']);
    currentLevel = GenericLevel.fromJson(json['level']);

    lastWorkout = DateTime.fromMillisecondsSinceEpoch(json['lastWorkout']);
    finished = json['finished'];
    finalUnlocked = json['finalUnlocked'];

    List<int> jsonTestResults = json['testResults'];
    testResults.addAll(jsonTestResults);

    List<Map<String, dynamic>> jsonLogs = json['logs'];
    logs.addAll(jsonLogs.map((el) => Logg.fromJSON(this, el)));
  }

  Map<String, dynamic> toJSON() =>
    {
      'week': week,
      'day': day,
      'level': currentLevel.toJSON(),
      'testResults': testResults,
      'type': type.toString(),
      'finished': finished,
      'finalUnlocked': finalUnlocked,
      'lastWorkout': lastWorkout.millisecondsSinceEpoch,
      'logs': logs.map((el) => el.toJSON())
    };

  Logg get currentLog {
    if (logs.isEmpty) {
      logs.add(Logg(this, week, day));
    }
    return logs.last;
  }

  Logg removeCurrentLog() {
    if (logs.isEmpty) return null;
    return logs.removeLast();
  }

  bool equals(DayAndWeek dayAndWeek) =>
      day == dayAndWeek.day && week == dayAndWeek.week;

  int get totalCount {
    final totalCount = logs.fold(0, (totalCount, log) => totalCount + log.totalCount);
    return testResults.fold(totalCount, (totalCount, i) => totalCount+i);
  }

  bool isTest() => day == 0 && week != 7;
  void setToTest() {
    day = 0;
  }
  bool isFinal() {
    if (week >= 7) {
      finalUnlocked=true;
      return true;
    }
    return false;
  }
}