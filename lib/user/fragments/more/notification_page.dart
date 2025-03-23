import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cristatepro/services/notification.dart';
import 'package:cristatepro/user/controllers/reminder.dart';
import 'package:cristatepro/user/model/reminder_model.dart';
import 'package:cristatepro/user/userPreferences/current_user.dart';
import 'package:cristatepro/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:get/get.dart';

class NotificationPage extends StatelessWidget {
  final ReminderController reminderController = Get.put(ReminderController());

  final NotificationManager notificationManager = NotificationManager();

  NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const CustomAppBar(
          title: "Notification",
          centerTitle: true,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: reminderController.selectDate,
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Select Date'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: reminderController.selectTime,
                    icon: const Icon(Icons.access_time),
                    label: const Text('Select Time'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Obx(() => Text(
                    'Selected Date: ${reminderController.newReminder.value.date != null ? '${reminderController.newReminder.value.date!.day}/${reminderController.newReminder.value.date!.month}/${reminderController.newReminder.value.date!.year}' : 'Not Selected'}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: reminderController.newReminder.value.date != null
                          ? Colors.blue
                          : Colors.red,
                    ),
                  )),
              const SizedBox(height: 8),
              Obx(() => Text(
                    'Selected Time: ${reminderController.newReminder.value.time != null ? '${reminderController.newReminder.value.time!.hour}:${reminderController.newReminder.value.time!.minute}' : 'Not Selected'}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: reminderController.newReminder.value.time != null
                          ? Colors.blue
                          : Colors.red,
                    ),
                  )),
              const SizedBox(height: 16),
              TextField(
                controller: reminderController.descriptionController,
                decoration: InputDecoration(
                  hintText: 'Enter description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: reminderController.addReminder,
                child: const Text('Add Reminder'),
              ),
              _buildReminderList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReminderList() {
    return Obx(() {
      // sortedReminders algorithm
      final sortedReminders = List.from(reminderController.reminders)
        ..sort((a, b) {
          if (a.expired != b.expired) {
            return a.expired ? 1 : -1;
          }
          final aDateTime = DateTime(a.date!.year, a.date!.month, a.date!.day,
              a.time!.hour, a.time!.minute);
          final bDateTime = DateTime(b.date!.year, b.date!.month, b.date!.day,
              b.time!.hour, b.time!.minute);
          return aDateTime.compareTo(bDateTime);
        });

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sortedReminders.isNotEmpty)
            _buildCommonTimer(sortedReminders.first),
          const SizedBox(height: 16),
          const Text(
            'Upcoming Reminders:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            itemCount: sortedReminders.length,
            itemBuilder: (context, index) {
              final reminder = sortedReminders[index];
              return Dismissible(
                key: Key(reminder.id.toString()),
                onDismissed: (direction) {
                  reminderController.deleteReminder(reminder.id);
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                child: _buildReminderCard(reminder),
              );
            },
          ),
        ],
      );
    });
  }

  Widget _buildReminderCard(Reminder reminder) {
    return Obx(() => Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          color: reminder.expired ? Colors.red : null,
          child: ListTile(
            title: Text(
              'Date: ${reminder.date!.day}/${reminder.date!.month}/${reminder.date!.year}',
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Time: ${reminder.time!.hour}:${reminder.time!.minute.toString().padLeft(2, '0')}'),
                Text(
                  'Description: ${reminder.description}',
                ),
              ],
            ),
          ),
        ).obs());
  }

  Widget _buildCommonTimer(Reminder? nearestReminder) {
    final CurrentUser currentUser = Get.find();

    if (nearestReminder == null) {
      return Container();
    }

    final now = DateTime.now();
    final reminderDateTime = DateTime(
      nearestReminder.date!.year,
      nearestReminder.date!.month,
      nearestReminder.date!.day,
      nearestReminder.time!.hour,
      nearestReminder.time!.minute,
    );

    final timeRemaining = reminderDateTime.difference(now);

    if (timeRemaining.inSeconds <= 0) {
      nearestReminder.expired = true;
      reminderController.saveReminders();
      reminderController.updateUI();
      return const Text(
        'Time remaining to the next Reminder!',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return KeyedSubtree(
      key: nearestReminder.countdownKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TimerCountdown(
            format: CountDownTimerFormat.daysHoursMinutesSeconds,
            endTime: reminderDateTime,
            onEnd: () {
              nearestReminder.expired = true;
              reminderController.saveReminders();
              reminderController.updateUI();
              notificationManager.createReminderNotification(
                  title:
                      '${Emojis.time_alarm_clock + Emojis.time_watch} Reminder ${Emojis.time_watch + Emojis.time_alarm_clock}',
                  body:
                      'Hello ${currentUser.user.userFirstName}!: ${nearestReminder.description!}',
                  scheduleDate: reminderDateTime);
            },
          ),
          const SizedBox(height: 8),
          Text(
            nearestReminder.description ?? '',
            style: TextStyle(
              color: nearestReminder.expired ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
