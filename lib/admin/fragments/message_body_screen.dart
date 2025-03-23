import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cristatepro/api_connection/api_connection.dart';
import 'package:cristatepro/house/house.dart';
import 'package:cristatepro/house/house_details_page.dart';
import 'package:cristatepro/user/controllers/houses_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cristatepro/admin/controllers/message_controller.dart';
import 'package:cristatepro/admin/model/message.dart';
import 'package:cristatepro/user/userPreferences/current_user.dart';
import 'package:lottie/lottie.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class MessageBodyScreen extends StatelessWidget {
  final int? senderId;
  final int? receiverId;
  final int? propertyId;
  final Message? message;

  const MessageBodyScreen({
    super.key,
    this.senderId,
    this.receiverId,
    this.message,
    this.propertyId,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<_MessageBodyScreenContentController>(
      init: _MessageBodyScreenContentController(),
      builder: (_MessageBodyScreenContentController controller) {
        return _MessageBodyScreenContent(
          senderId: senderId,
          receiverId: receiverId,
          message: message,
          propertyId: propertyId,
          controller: controller,
        );
      },
    );
  }
}

class _MessageBodyScreenContent extends StatelessWidget {
  final int? senderId;
  final int? receiverId;
  final int? propertyId;
  final Message? message;
  final _MessageBodyScreenContentController controller;
  final UserHouseController houseController = Get.find();

  _MessageBodyScreenContent({
    required this.senderId,
    required this.receiverId,
    required this.propertyId,
    required this.message,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    HouseModel house = houseController.fetchPropertiesByHouseId(propertyId!);
    return Scaffold(
      appBar: AppBar(
        title: controller.isSearching
            ? TextField(
                onChanged: (value) {
                  controller.updateSearchQuery(value, propertyId!);
                },
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search messages...',
                  hintStyle: TextStyle(color: Colors.white70),
                ),
              )
            : Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: API.profilemage + house.houseProfileImage,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 20,
                      backgroundImage: imageProvider,
                    ),
                    placeholder: (context, url) => const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/user.png'),
                    ),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/user.png'),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  if (house.houseType == 'Unavailable')
                    const Text(
                      "This house is unavailable",
                      style: TextStyle(color: Colors.white),
                    )
                  else
                    GestureDetector(
                      onTap: () {
                        Get.to(() => UserHouseDetailScreen(house: house));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            house.houseTitle.length > 20
                                ? '${house.houseTitle.substring(0, 15)}...'
                                : house.houseTitle,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 24),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            'posted by ${house.userFullname}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
        backgroundColor: const Color(0xff1B202D),
        leading: IconButton(
          onPressed: () {
            if (controller.isSearching) {
              controller.stopSearching();
            } else {
              Get.back();
            }
          },
          icon: Icon(controller.isSearching
              ? Icons.close
              : Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {
              controller.startSearching();
            },
            icon: const Icon(Icons.search),
            color: Colors.white,
          ),
        ],
      ),
      body: Stack(
        children: [
          Lottie.asset(
            'assets/chatroom_background.json',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildMessageList(context),
              ),
              _buildReplyField(context),
              Obx(
                () => Offstage(
                  offstage: !controller.emojiShowing.value,
                  child: SizedBox(
                    height: 250,
                    child: EmojiPicker(
                      textEditingController: controller.replyController,
                      config: const Config(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(BuildContext context) {
    return GetX<_MessageBodyScreenContentController>(
      init: controller,
      builder: (_MessageBodyScreenContentController controller) {
        final List<Message> displayedMessages =
            controller.getDisplayedMessages(propertyId);

        return displayedMessages.isEmpty
            ? Center(
                child: controller.isSearching
                    ? Text(
                        'No messages found for "${controller.searchQuery}"',
                        style: const TextStyle(color: Colors.white),
                      )
                    : const Text(
                        'No messages yet. Start chatting with the house agent.',
                        style: TextStyle(color: Colors.white),
                      ),
              )
            : GroupedListView<Message, String>(
                reverse: true,
                elements: displayedMessages.reversed.toList(),
                groupBy: (message) {
                  final DateTime messageDate = message.timeSent;
                  final now = DateTime.now();
                  final today = DateTime(now.year, now.month, now.day);
                  final yesterday = DateTime(now.year, now.month, now.day - 1);

                  if (messageDate.year == today.year &&
                      messageDate.month == today.month &&
                      messageDate.day == today.day) {
                    return 'Today';
                  } else if (messageDate.year == yesterday.year &&
                      messageDate.month == yesterday.month &&
                      messageDate.day == yesterday.day) {
                    return 'Yesterday';
                  } else {
                    return DateFormat('MMM d, yyyy').format(messageDate);
                  }
                },
                groupComparator: (group1, group2) {
                  if (group1 == 'Today') {
                    return -1;
                  } else if (group2 == 'Today') {
                    return 1;
                  } else {
                    return group2.compareTo(group1);
                  }
                },
                groupSeparatorBuilder: (String groupByValue) => Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    groupByValue,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                itemBuilder: (context, message) {
                  final isCurrentUser = message.senderId ==
                      controller.currentUser.user.userId.toString();
                  final isSenderOrReceiver =
                      (message.senderId == senderId.toString() ||
                              message.receiverId == receiverId.toString()) ||
                          (message.senderId == receiverId.toString() ||
                              message.receiverId == senderId.toString());
                  if (isSenderOrReceiver) {
                    return Column(
                      crossAxisAlignment: isCurrentUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        buildMessageBubble(
                          message.content,
                          isCurrentUser: isCurrentUser,
                          timeSent: message.timeSent,
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              );
      },
    );
  }

  Widget buildMessageBubble(
    String text, {
    required bool isCurrentUser,
    required DateTime timeSent,
  }) {
    final bubbleColor = isCurrentUser ? Colors.green : Colors.blue;
    final delivered = isCurrentUser ? true : false;

    return Align(
      child: BubbleSpecialThree(
        isSender: isCurrentUser,
        text: '$text\n\n${DateFormat('E HH:mm').format(timeSent)}',
        color: bubbleColor,
        tail: true,
        delivered: delivered,
        textStyle: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildReplyField(BuildContext context) {
    final controller = Get.find<_MessageBodyScreenContentController>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GetBuilder<_MessageBodyScreenContentController>(
        init: controller,
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xff292F3F),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.8),
                          child: IconButton(
                            onPressed: () {
                              if (controller.emojiShowing.value) {
                                controller.toggleEmojiKeyboard();
                                FocusScope.of(context).requestFocus(
                                    controller.textFieldFocusNode);
                              } else {
                                FocusScope.of(context).unfocus();
                                Future.delayed(
                                    const Duration(milliseconds: 300), () {
                                  controller.toggleEmojiKeyboard();
                                });
                              }
                            },
                            icon: Icon(controller.emojiShowing.value
                                ? Icons.keyboard
                                : Icons.emoji_emotions_rounded),
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 200),
                            child: Obx(() {
                              return TextField(
                                controller: controller.replyController,
                                focusNode: controller.textFieldFocusNode,
                                onChanged: (value) {
                                  controller.updateReplyText(value);
                                },
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Type your reply...',
                                  hintStyle: TextStyle(color: Colors.white70),
                                  border: InputBorder.none,
                                ),
                                enabled: !controller.isSending.value,
                                onTap: () {
                                  if (controller.emojiShowing.value) {
                                    controller.toggleEmojiKeyboard();
                                  }
                                },
                              );
                            }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.8),
                          child: Obx(() {
                            return controller.isSending.value
                                ? const Center(
                                    child:
                                        Icon(Icons.rocket, color: Colors.white),
                                  )
                                : IconButton(
                                    onPressed: () async {
                                      if (controller.replyController.text
                                          .trim()
                                          .isNotEmpty) {
                                        controller.isSending.value = true;
                                        await Future.microtask(() =>
                                            controller.sendMessage(
                                              senderId,
                                              receiverId,
                                              propertyId,
                                              controller.replyController.text,
                                            ));
                                        controller.isSending.value = false;
                                      }
                                    },
                                    icon: const Icon(Icons.send),
                                    color: Colors.white,
                                  );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MessageBodyScreenContentController extends GetxController {
  final MessageController messageController = Get.find();
  final CurrentUser currentUser = Get.put(CurrentUser());
  final TextEditingController replyController = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();
  late String searchQuery = '';
  late List<Message> searchResult = [];
  late bool isSearching = false;
  RxBool isSending = false.obs;
  RxBool emojiShowing = false.obs;

  @override
  void onClose() {
    textFieldFocusNode.dispose();
    super.onClose();
  }

  void startSearching() {
    isSearching = true;
    update();
  }

  void updateReplyText(String text) {
    replyController.text = text;
  }

  void stopSearching() {
    isSearching = false;
    searchQuery = '';
    searchResult.clear();
    update();
  }

  void updateSearchQuery(String query, int propertyId) {
    searchQuery = query;
    searchResult = getDisplayedMessages(propertyId)
        .where((msg) => msg.content.toLowerCase().contains(query.toLowerCase()))
        .toList();
    update();
  }

  List<Message> getDisplayedMessages(int? propertyId) {
    final List<Message> propertyMessages = messageController.messages
        .where((msg) => msg.propertyId == propertyId.toString())
        .toList();

    return searchQuery.isEmpty ? propertyMessages : searchResult;
  }

  void sendMessage(
      int? senderId, int? receiverId, int? propertyId, String content) async {
    if (content.isNotEmpty) {
      isSending.value = true;
      bool success = await messageController.sendMessage(
          senderId!, receiverId!, propertyId!, content);
      isSending.value = false;

      if (success) {
        final audioPlayer = AudioPlayer();
        final player = AudioCache(prefix: 'assets/');
        final url = await player.loadAsFile('sentmessage.mp3');
        await audioPlayer.play(DeviceFileSource(url.path));
        replyController.clear();
      }
    }
  }

  void toggleEmojiKeyboard() {
    emojiShowing.value = !emojiShowing.value;
    update();
  }
}
