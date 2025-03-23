import 'dart:async';
import 'package:cristatepro/admin/model/message.dart';
import 'package:cristatepro/services/notification.dart';
import 'package:cristatepro/user/userPreferences/current_user.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cristatepro/api_connection/api_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageController extends GetxController {
  RxList<Message> messages = <Message>[].obs;
  final CurrentUser currentUser = Get.find();
  RxSet<int> notifiedMessageIds = <int>{}.obs;
  RxMap<int, int> unreadMessageCounts = <int, int>{}.obs;
  RxInt unreadNotificationCount = 0.obs;
  Timer? pollingTimer;

  @override
  void onInit() {
    super.onInit();
    loadMessagesFromSharedPreferences();
    loadNotifiedMessageIdsFromSharedPreferences();
    loadUnreadMessageCountsFromSharedPreferences();
    loadUnreadNotificationCountFromSharedPreferences();
    startPolling();
  }

  void startPolling() {
    pollingTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      fetchMessages(currentUser.user.userId.toString());
    });
  }

  void stopPolling() {
    pollingTimer?.cancel();
  }

  @override
  void onClose() {
    stopPolling();
    super.onClose();
  }

  Future<void> fetchMessages(String userId) async {
    const String url = API.chatFetch;

    final response = await http.post(
      Uri.parse(url),
      body: {'userId': userId},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['success'] == true) {
        List<dynamic>? messageData = jsonResponse['messages'];
        if (messageData != null && messageData.isNotEmpty) {
          List<Message> newMessages =
              messageData.map((data) => Message.fromJson(data)).toList();

          messages.assignAll(newMessages);

          for (Message message in newMessages) {
            if (message.senderId != currentUser.user.userId.toString() &&
                !notifiedMessageIds.contains(message.messageId)) {
              NotificationManager().createNotification(message);
              notifiedMessageIds.add(message.messageId!);

              int propertyId = int.parse(message.propertyId);
              if (message.senderId != currentUser.user.userId.toString()) {
                unreadMessageCounts[propertyId] =
                    (unreadMessageCounts[propertyId] ?? 0) + 1;
              }
            }
          }

          await storeMessagesInSharedPreferences(messages);
          await storeNotifiedMessageIdsInSharedPreferences();
          await storeUnreadMessageCountsInSharedPreferences();
          await updateUnreadNotificationCount();
        }
      } else {
        throw Exception(jsonResponse['message']);
      }
    } else {
      throw Exception(
          'Failed to fetch messages (HTTP Status ${response.statusCode})');
    }
  }

  Future<bool> sendMessage(
      int senderId, int receiverId, int propertyId, String content) async {
    const url = API.chatApp;

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'senderId': currentUser.user.userId.toString(),
          'receiverId': receiverId.toString(),
          'propertyId': propertyId.toString(),
          'content': content,
        },
      );

      if (response.statusCode == 200) {
        final newMessage = Message(
          messageId: DateTime.now().millisecondsSinceEpoch,
          senderId: senderId.toString(),
          receiverId: receiverId.toString(),
          propertyId: propertyId.toString(),
          content: content,
          timeSent: DateTime.now(),
        );
        messages.add(newMessage);

        if (senderId != currentUser.user.userId) {
          unreadMessageCounts[propertyId] =
              (unreadMessageCounts[propertyId] ?? 0) + 1;
        }

        await storeMessagesInSharedPreferences(messages);
        await storeNotifiedMessageIdsInSharedPreferences();
        await storeUnreadMessageCountsInSharedPreferences();
        await updateUnreadNotificationCount();
        return true;
      } else {
        Get.snackbar('Failed to send message', response.body);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error sending message', 'Check your internet connection');
      return false;
    }
  }

  Future<void> storeMessagesInSharedPreferences(
      RxList<Message> messages) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String messagesJson =
        jsonEncode(messages.map((msg) => msg.toJson()).toList());
    await prefs.setString('messages', messagesJson);
  }

  Future<void> loadMessagesFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? messagesJson = prefs.getString('messages');
    if (messagesJson != null) {
      messages.assignAll((jsonDecode(messagesJson) as List)
          .map((data) => Message.fromJson(data))
          .toList());
    }
  }

  Future<void> storeNotifiedMessageIdsInSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<int> notifiedIdsList = notifiedMessageIds.toList();
    await prefs.setString('notifiedMessageIds', jsonEncode(notifiedIdsList));
  }

  Future<void> loadNotifiedMessageIdsFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? notifiedIdsJson = prefs.getString('notifiedMessageIds');
    if (notifiedIdsJson != null) {
      notifiedMessageIds.assignAll(
          (jsonDecode(notifiedIdsJson) as List).map((id) => id as int));
    }
  }

  Future<void> storeUnreadMessageCountsInSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> unreadCounts = unreadMessageCounts.map(
      (key, value) => MapEntry(key.toString(), value),
    );
    await prefs.setString('unreadMessageCounts', jsonEncode(unreadCounts));
  }

  Future<void> loadUnreadMessageCountsFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? unreadCountsJson = prefs.getString('unreadMessageCounts');
    if (unreadCountsJson != null) {
      unreadMessageCounts.assignAll(
          (jsonDecode(unreadCountsJson) as Map<String, dynamic>)
              .map((key, value) => MapEntry(int.parse(key), value as int)));
    }
  }

  Future<void> storeUnreadNotificationCountInSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        'unreadNotificationCount', unreadNotificationCount.value);
  }

  Future<void> loadUnreadNotificationCountFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedCount = prefs.getInt('unreadNotificationCount');
    if (storedCount != null) {
      unreadNotificationCount.value = storedCount;
    } else {}
  }

  Future<void> clearMessages() async {
    messages.clear();
    unreadMessageCounts.clear();
    unreadNotificationCount.value = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('messages');
    await prefs.remove('notifiedMessageIds');
    await prefs.remove('unreadMessageCounts');
    await prefs.remove('unreadNotificationCount');
  }

  Future<void> updateUnreadNotificationCount() async {
    int totalUnreadCount =
        unreadMessageCounts.values.fold(0, (sum, count) => sum + count);
    unreadNotificationCount.value = totalUnreadCount;

    await storeUnreadNotificationCountInSharedPreferences();
  }

  void markAllMessagesAsRead() {
    unreadMessageCounts.clear();
    unreadNotificationCount.value = 0;
    storeUnreadMessageCountsInSharedPreferences();
    storeUnreadNotificationCountInSharedPreferences();
  }

  Future<void> resetUnreadCount(int propertyId) async {
    unreadMessageCounts[propertyId] = 0;
    await storeUnreadMessageCountsInSharedPreferences();
    await updateUnreadNotificationCount();
  }
}
