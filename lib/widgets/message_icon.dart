import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cristatepro/admin/controllers/message_controller.dart';
import 'package:cristatepro/admin/fragments/message_list_screen.dart';

class MessageIconButton extends StatelessWidget {
  final MessageController messageController = Get.find<MessageController>();

  MessageIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final unreadCount = messageController.unreadNotificationCount.value;

      return Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            iconSize: 30,
            color: Colors.blue,
            splashColor: Colors.amber,
            onPressed: () {
              Get.to(() => MessageListPage());
            },
            icon: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Image.asset(
                'assets/messages.png',
                width: 40.0,
                height: 40.0,
              ),
            ),
          ),
          if (unreadCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
                child: Center(
                  child: Text(
                    '$unreadCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
