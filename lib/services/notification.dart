import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cristatepro/admin/fragments/houses/admin_house_list_view.dart';
import 'package:cristatepro/admin/fragments/message_list_screen.dart';
import 'package:cristatepro/admin/model/message.dart';
import 'package:cristatepro/user/fragments/houses/house_list_fragment_screen.dart';
import 'package:cristatepro/user/userPreferences/current_user.dart';
import 'package:cristatepro/user/fragments/more/notification_page.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;

final CurrentUser currentUser = Get.find();

class NotificationManager {
  NotificationManager();

  Future<void> createReminderNotification({
    required String title,
    required String body,
    required DateTime scheduleDate,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'scheduled_channel',
        title: title,
        body: body,
        bigPicture: 'assets/housepage.jpeg',
        notificationLayout: NotificationLayout.BigPicture,
        actionType: ActionType.Default,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'VIEW',
          label: 'View Reminder',
          actionType: ActionType.Default,
        ),
      ],
      schedule: NotificationCalendar.fromDate(
        date: scheduleDate,
        preciseAlarm: true,
        repeats: true,
        allowWhileIdle: true,
      ),
    );
  }

  void createNotification(Message message) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: message.messageId ?? 0,
        channelKey: 'house_channel',
        title:
            '${Emojis.person_activity_man_getting_massage + Emojis.hotel_bellhop_bell} New Message for you ${message.receiverName}',
        body: message.content,
        notificationLayout: NotificationLayout.Default,
        actionType: ActionType.Default,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'REPLY',
          label: 'Reply',
          actionType: ActionType.Default,
        ),
      ],
    );
  }

  Future<void> newHouseNotifications() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'house_channel',
        title:
            '${Emojis.building_house_with_garden + Emojis.activites_firecracker}New House Created ${Emojis.activites_firecracker + Emojis.hotel_bellhop_bell}',
        body:
            'Congratulation ${currentUser.user.userFirstName} ${Emojis.activites_fireworks + Emojis.activites_firecracker}New house has been created successfully 🎉',
        bigPicture: 'assets/housepage.jpeg',
        notificationLayout: NotificationLayout.BigPicture,
        actionType: ActionType.Default,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'VIEW',
          label: 'View',
          actionType: ActionType.Default,
        ),
      ],
    );
  }

  void scheduleWeeklyNotifications(String currentUser) {
    // Define the day-to-notification mapping
    Map<int, Map<String, String>> notifications = {
      DateTime.monday: {
        'title': "Motivation Monday: Your Dream Home Awaits! 🏡🔑🌙",
        'body':
            "Hello $currentUser! Start your week with a new beginning. Explore exclusive listings and find your perfect home today!"
      },
      DateTime.tuesday: {
        'title': "Turnkey Tuesday: Ready-to-Move-In Homes! 🔑",
        'body':
            "Hi $currentUser! Discover homes that are ready for you to move in. Find the perfect place with just a few taps!"
      },
      DateTime.wednesday: {
        'title': "Wishlist Wednesday: Homes You’ll Love! ❤️🎀",
        'body':
            "Hey there $currentUser! Browse handpicked homes tailored to your preferences. Your dream home is just a click away!"
      },
      DateTime.thursday: {
        'title': "Thrilling Thursday: Hot New Listings! ⏰❤️",
        'body':
            "How do you do $currentUser? Check out the latest listings that just hit the market. Don't miss out on these fantastic deals!"
      },
      DateTime.friday: {
        'title': "Find-It Friday: Your New Home Is Here! 🏡🎆",
        'body':
            "How are you $currentUser? Kick off the weekend by finding your dream home. Start exploring our new listings now!"
      },
      DateTime.saturday: {
        'title': "Savings Saturday: Best Deals on Homes! 🏡💰",
        'body':
            "Dear $currentUser! Discover the best deals on homes this weekend. Save big and find the perfect place today!"
      },
      DateTime.sunday: {
        'title': "Serenity Sunday: Peaceful Homes Await! ☀️🏡",
        'body':
            "Had a fabulous weekend $currentUser? End your week on a high note. Explore tranquil homes that offer peace and comfort."
      },
    };

    // Schedule notifications for each day
    notifications.forEach((day, notification) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: createUniqueId(),
          channelKey: 'scheduled_channel',
          title: notification['title'],
          body: notification['body'],
          bigPicture: 'assets/housepage.jpeg',
          notificationLayout: NotificationLayout.BigPicture,
          actionType: ActionType.Default,
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'FIND',
            label: 'Find a Home',
            actionType: ActionType.Default,
          ),
        ],
        schedule: NotificationCalendar(
          year: DateTime.now().year,
          month: DateTime.now().month,
          day: DateTime.now().day +
              ((day - DateTime.now().weekday + 7) %
                  7), // Calculate the next occurrence of the day
          hour: 16, // 4 PM
          minute: 0,
          second: 0,
          millisecond: 0,
          repeats: true, // Repeat weekly
        ),
      );
    });
  }

  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  Future<void> requestNotificationPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  void cancelWeeklyNotifications() {
    AwesomeNotifications().cancelAll();
  }

  void initializeNotifications() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: (receivedAction) async {
        if (receivedAction.channelKey == 'message_channel' && Platform.isIOS) {
          int currentBadgeCount =
              await AwesomeNotifications().getGlobalBadgeCounter();
          AwesomeNotifications().setGlobalBadgeCounter(currentBadgeCount - 1);
        }

        if (receivedAction.channelKey == 'reminder_channel' &&
            (receivedAction.buttonKeyPressed == 'VIEW' ||
                receivedAction.buttonKeyPressed == "")) {
          Get.to(() => NotificationPage());
        }

        if (receivedAction.channelKey == 'house_channel' &&
            (receivedAction.buttonKeyPressed == 'VIEW' ||
                receivedAction.buttonKeyPressed == "")) {
          Get.to(() => AdminHouseListView());
        }

        if (receivedAction.channelKey == 'scheduled_channel' &&
            (receivedAction.buttonKeyPressed == 'FIND' ||
                receivedAction.buttonKeyPressed == "")) {
          Get.to(() => UserHouseListView());
        }

        if (receivedAction.channelKey == 'message_channel' &&
            (receivedAction.buttonKeyPressed == 'REPLY' ||
                receivedAction.buttonKeyPressed == "")) {
          Get.to(() => MessageListPage());
        }
      },
    );
  }
}
