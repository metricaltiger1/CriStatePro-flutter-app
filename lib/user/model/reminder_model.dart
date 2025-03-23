import 'package:flutter/material.dart';

class Reminder {
  DateTime? date;
  TimeOfDay? time;
  String? description;
  int id;
  bool expired = false;
  Key countdownKey;

  Reminder({required this.id}) : countdownKey = UniqueKey();
}
