import 'package:flutter/material.dart';

class Time {
  static TimeOfDay secondsToTimeOfDay(int seconds) {
    if (seconds == null) return null;

    int hour = (seconds / 60 / 60).floor();
    int minute = (seconds / 60).floor() - hour * 60;
    return TimeOfDay(hour: hour, minute: minute);
  }

  static int timeOfDayToSeconds(TimeOfDay timeOfDay) {
    if (timeOfDay == null) return null;
    return (timeOfDay.hour * 60 + timeOfDay.minute) * 60;
  }
}
