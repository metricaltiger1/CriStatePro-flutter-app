import 'package:cached_network_image/cached_network_image.dart';
import 'package:cristatepro/api_connection/api_connection.dart';
import 'package:cristatepro/user/controllers/houses_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cristatepro/admin/controllers/message_controller.dart';
import 'package:cristatepro/admin/fragments/message_body_screen.dart';
import 'package:cristatepro/admin/model/message.dart';
import 'package:cristatepro/user/userPreferences/current_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageListPage extends StatelessWidget {
  final MessageController messagesController = Get.find<MessageController>();
  final CurrentUser currentUser = Get.find<CurrentUser>();
  final TextEditingController searchController = TextEditingController();
  final UserHouseController houseController = Get.find<UserHouseController>();

  MessageListPage({super.key});

  Future<DateTime?> _loadLastMessageTimestamp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timestampString = prefs.getString('last_message_timestamp');
    return timestampString != null ? DateTime.parse(timestampString) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1B202D),
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xff1B202D),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: MessageSearch(messagesController.messages),
              );
            },
            icon: const Icon(Icons.search),
            color: Colors.white,
          ),
        ],
      ),
      body: FutureBuilder<DateTime?>(
        future: _loadLastMessageTimestamp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading messages'));
          }

          final lastMessageTimestamp = snapshot.data;

          return Obx(() {
            if (messagesController.messages.isEmpty) {
              return const Center(
                child: Text(
                  'No messages yet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              );
            }

            Map<String, List<Message>> groupedMessages = {};
            for (var message in messagesController.messages) {
              if (!groupedMessages.containsKey(message.propertyId)) {
                groupedMessages[message.propertyId] = [];
              }
              groupedMessages[message.propertyId]!.add(message);
            }

            List<String> sortedKeys = groupedMessages.keys.toList();
            sortedKeys.sort((a, b) {
              final Message lastMessageA = groupedMessages[a]!.last;
              final Message lastMessageB = groupedMessages[b]!.last;
              return lastMessageB.timeSent.compareTo(lastMessageA.timeSent);
            });

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
                  child: Text(
                    "RECENTS",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: sortedKeys.map((propertyId) {
                      final messages = groupedMessages[propertyId]!;
                      final latestMessage = messages.last;
                      final firstMessage = messages.first;
                      final houseProperties = houseController
                          .fetchPropertiesByHouseId(int.parse(propertyId));
                      final userName = houseProperties.houseType;

                      // Calculate new message count for the receiver
                      int newMessageCountForReceiver = messagesController
                              .unreadMessageCounts[int.parse(propertyId)] ??
                          0;

                      return GestureDetector(
                        onTap: () {
                          int receiverId;

                          // Check if the receiver is the current user; if so, set the receiver to the sender
                          if (int.parse(firstMessage.senderId) ==
                              currentUser.user.userId) {
                            receiverId = int.parse(firstMessage.receiverId);
                          } else {
                            receiverId = int.parse(firstMessage.senderId);
                          }

                          Get.to(() => MessageBodyScreen(
                                senderId: currentUser.user.userId,
                                message: latestMessage,
                                propertyId: int.parse(latestMessage.propertyId),
                                receiverId: receiverId,
                              ));

                          messagesController
                              .resetUnreadCount(int.parse(propertyId));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: API.profilemage +
                                        houseProperties.houseProfileImage,
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                      radius: 30,
                                      backgroundImage: imageProvider,
                                    ),
                                    placeholder: (context, url) =>
                                        const CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          AssetImage('assets/user.png'),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          AssetImage('assets/user.png'),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    userName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              if (newMessageCountForReceiver > 0)
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '$newMessageCountForReceiver',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xff292F3F),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: sortedKeys.length,
                        itemBuilder: (context, index) {
                          final propertyId = sortedKeys[index];
                          final messages = groupedMessages[propertyId]!;
                          final latestMessage = messages.last;
                          final firstMessage = messages.first;
                          final houseProperties = houseController
                              .fetchPropertiesByHouseId(int.parse(propertyId));
                          final userName =
                              "${houseProperties.houseTitle} ${houseProperties.houseType}";

                          // Calculate new message count for the receiver
                          int newMessageCountForReceiver = messagesController
                                  .unreadMessageCounts[int.parse(propertyId)] ??
                              0;

                          // Check if this is the latest message
                          bool isLatestMessage = lastMessageTimestamp != null &&
                              lastMessageTimestamp == latestMessage.timeSent;

                          return GestureDetector(
                            onTap: () {
                              int receiverId;

                              // Check if the receiver is the current user; if so, set the receiver to the sender
                              if (int.parse(firstMessage.senderId) ==
                                  currentUser.user.userId) {
                                receiverId = int.parse(firstMessage.receiverId);
                              } else {
                                receiverId = int.parse(firstMessage.senderId);
                              }
                              Get.to(() => MessageBodyScreen(
                                    senderId: currentUser.user.userId,
                                    message: latestMessage,
                                    propertyId: int.parse(propertyId),
                                    receiverId: receiverId,
                                  ));
                              messagesController
                                  .resetUnreadCount(int.parse(propertyId));
                            },
                            child: Stack(
                              children: [
                                Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  color: isLatestMessage
                                      ? Colors.blueAccent.withOpacity(0.5)
                                      : Colors.white,
                                  child: ListTile(
                                    leading: CachedNetworkImage(
                                      imageUrl: API.profilemage +
                                          houseProperties.houseProfileImage,
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                        radius: 30,
                                        backgroundImage: imageProvider,
                                      ),
                                      placeholder: (context, url) =>
                                          const CircleAvatar(
                                        radius: 30,
                                        backgroundImage:
                                            AssetImage('assets/user.png'),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const CircleAvatar(
                                        radius: 30,
                                        backgroundImage:
                                            AssetImage('assets/user.png'),
                                      ),
                                    ),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userName.length > 20
                                              ? '${userName.substring(0, 20)}...'
                                              : userName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('E HH:mm')
                                              .format(latestMessage.timeSent),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          latestMessage.content,
                                          maxLines: 1,
                                        ),
                                        const SizedBox(height: 5),
                                      ],
                                    ),
                                  ),
                                ),
                                if (newMessageCountForReceiver > 0)
                                  Positioned(
                                    right: 10,
                                    top: 10,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '$newMessageCountForReceiver',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
        },
      ),
    );
  }
}

class MessageSearch extends SearchDelegate<Message> {
  final List<Message> messages;
  final CurrentUser currentUser = Get.put(CurrentUser());
  final MessageController messagesController = Get.find<MessageController>();

  MessageSearch(this.messages);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Get.back();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Filter messages based on both sender name and message content
    final List<Message> searchedMessages = messages
        .where((message) =>
            message.receiverName!.toLowerCase().contains(query.toLowerCase()) ||
            message.content.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return _buildMessageList(searchedMessages);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Message> searchedMessages = messages
        .where((message) =>
            message.receiverName!.toLowerCase().contains(query.toLowerCase()) ||
            message.content.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return _buildMessageList(searchedMessages);
  }

  Widget _buildMessageList(List<Message> messages) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final userName = message.receiverName!;
        return GestureDetector(
          onTap: () {
            Get.to(() => MessageBodyScreen(
                  message: message,
                  propertyId: int.parse(message.propertyId),
                  senderId: int.parse(message.senderId),
                  receiverId: int.parse(message.receiverId),
                ));
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              color: const Color(0xff292F3F),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: const AssetImage('assets/user.png'),
                  radius: 24,
                  child: Text(userName[0]),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateFormat('E HH:mm').format(message.timeSent),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.content,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
