// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ListenableTimer {
  late DateTime _dateTime;
  int minutes;
  int seconds;
  late ValueNotifier<DateTime> _time;
  ListenableTimer({
    required this.minutes,
    required this.seconds,
  }) {
    _dateTime = DateTime(DateTime.now().year, 1, 1, 0, minutes, seconds);
    _time = ValueNotifier<DateTime>(_dateTime);
  }

  ValueNotifier<DateTime> get time => _time;

  bool get isFinished => _time.value.minute == 0 && _time.value.second == 0;

  startTimer() {
    Future.delayed(const Duration(seconds: 1)).then((val) {
      if (_dateTime.minute > 0 || _dateTime.second > 0) {
        _dateTime = _dateTime.subtract(const Duration(seconds: 1));
        _time.value = _dateTime;
        startTimer();
      }
    });
  }

  restart({bool multiplied = false}) {
    _dateTime = DateTime(
        DateTime.now().year,
        1,
        1,
        0,
        (multiplied ? minutes * 2 : minutes),
        (multiplied ? seconds * 2 : seconds));
    _time = ValueNotifier<DateTime>(_dateTime);
    Future.delayed(const Duration(seconds: 1)).then((val) {
      if (_dateTime.minute > 0 || _dateTime.second > 0) {
        _dateTime = _dateTime.subtract(const Duration(seconds: 1));
        _time.value = _dateTime;
        startTimer();
      }
    });
  }
}
