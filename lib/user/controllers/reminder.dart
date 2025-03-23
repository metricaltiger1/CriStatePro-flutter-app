import 'dart:convert';

import 'package:cristatepro/user/model/reminder_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReminderController extends GetxController {
  final newReminder = Reminder(id: 0).obs;
  final descriptionController = TextEditingController();
  final reminders = <Reminder>[].obs;
  int nextId = 1;

  @override
  void onInit() {
    super.onInit();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? reminderList = prefs.getStringList('reminders');
    if (reminderList != null) {
      reminders.value = reminderList.map((json) {
        final Map<String, dynamic> reminderMap = jsonDecode(json);
        final reminder = Reminder(id: reminderMap['id'])
          ..date = DateTime.parse(reminderMap['date'])
          ..time = TimeOfDay(
            hour: reminderMap['hour'],
            minute: reminderMap['minute'],
          )
          ..description = reminderMap['description']
          ..expired = reminderMap['expired'] ?? false;
        if (reminder.id >= nextId) {
          nextId = reminder.id + 1;
        }
        return reminder;
      }).toList();
    } else {}

    final String? savedDate = prefs.getString('selectedDate');
    if (savedDate != null) {
      newReminder.update((val) {
        val!.date = DateTime.parse(savedDate);
      });
    }

    final String? savedTime = prefs.getString('selectedTime');
    if (savedTime != null) {
      final List<String> timeComponents = savedTime.split(':');
      newReminder.update((val) {
        val!.time = TimeOfDay(
          hour: int.parse(timeComponents[0]),
          minute: int.parse(timeComponents[1]),
        );
      });
    }
  }

  Future<void> saveReminders() async {
    final List<String> reminderList = reminders.map((reminder) {
      final Map<String, dynamic> reminderMap = {
        'date': reminder.date.toString(),
        'hour': reminder.time!.hour,
        'minute': reminder.time!.minute,
        'description': reminder.description,
        'id': reminder.id,
        'expired': reminder.expired,
      };
      return jsonEncode(reminderMap);
    }).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('reminders', reminderList);

    if (newReminder.value.date != null) {
      await prefs.setString('selectedDate', newReminder.value.date.toString());
    }
    if (newReminder.value.time != null) {
      await prefs.setString(
        'selectedTime',
        '${newReminder.value.time!.hour}:${newReminder.value.time!.minute}',
      );
    }
  }

  void addReminder() {
    if (newReminder.value.date != null &&
        newReminder.value.time != null &&
        descriptionController.text.isNotEmpty) {
      newReminder.update((val) {
        val!.description = descriptionController.text;
        val.id = nextId++;
      });
      reminders.add(newReminder.value);
      saveReminders();
      newReminder.value = Reminder(id: nextId);
      descriptionController.clear();
    } else {
      Get.dialog(
        AlertDialog(
          title: const Text('Missing Properties'),
          content: const Text(
              'Please select date, time, and provide a description to add a reminder.'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> editReminder(int index) async {
    final editedReminder = await Get.dialog<Reminder>(
      AlertDialog(
        title: const Text('Edit Reminder'),
        content: Column(
          children: [
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: selectDate,
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Select Date'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: selectTime,
                  icon: const Icon(Icons.access_time),
                  label: const Text('Select Time'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: 'Enter description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (newReminder.value.date != null &&
                  newReminder.value.time != null &&
                  descriptionController.text.isNotEmpty) {
                Get.back(result: newReminder.value);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (editedReminder != null) {
      reminders[index] = editedReminder;
      saveReminders(); // Save reminders to SharedPreferences
    }
  }

  void deleteReminder(int id) {
    reminders.removeWhere((reminder) => reminder.id == id);
    saveReminders();
  }

  Future<void> selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != newReminder.value.date) {
      newReminder.update((val) {
        val!.date = picked;
      });
    }
  }

  Future<void> selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: newReminder.value.time ?? TimeOfDay.now(),
    );

    if (picked != null && picked != newReminder.value.time) {
      final DateTime now = DateTime.now();
      final DateTime selectedTime = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      if (selectedTime.isBefore(now)) {
        Get.dialog(
          AlertDialog(
            title: const Text('Invalid Time'),
            content: const Text('Please select a future time.'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        newReminder.update((val) {
          val!.time = picked;
        });
      }
    }
  }

  // Method to find the nearest reminder
  Reminder? findNearestReminder() {
    final now = DateTime.now();

    Reminder? nearestReminder;
    Duration? timeRemaining;

    for (final reminder in reminders) {
      final reminderDateTime = DateTime(
        reminder.date!.year,
        reminder.date!.month,
        reminder.date!.day,
        reminder.time!.hour,
        reminder.time!.minute,
      );
      final currentDifference = reminderDateTime.difference(now);
      if (currentDifference.inSeconds > 0 &&
          (nearestReminder == null || currentDifference < timeRemaining!)) {
        nearestReminder = reminder;
        timeRemaining = currentDifference;
      }
    }

    return nearestReminder;
  }

  void updateUI() {
    reminders.refresh();
  }
}
