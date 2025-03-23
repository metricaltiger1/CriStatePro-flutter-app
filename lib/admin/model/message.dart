class Message {
  final int? messageId;
  late final String senderId;
  final String receiverId;
  final String? receiverName;
  final String propertyId;
  final String content;
  final DateTime timeSent;

  Message({
    this.messageId,
    required this.senderId,
    required this.receiverId,
    this.receiverName,
    required this.propertyId,
    required this.content,
    required this.timeSent,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId:
          json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      senderId: json['senderId'],
      receiverName: json['receiver_fullname'],
      receiverId: json['receiverId'],
      propertyId: json['propertyId'],
      content: json['content'],
      timeSent: DateTime.parse(json['timeSent']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': messageId,
      'senderId': senderId,
      'receiverId': receiverId,
      'receiver_fullname': receiverName,
      'propertyId': propertyId,
      'content': content,
      'timeSent': timeSent.toIso8601String(),
    };
  }
}
