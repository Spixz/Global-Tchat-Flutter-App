class Message {
  final String id;
  final String content;
  final String senderId;
  final String? receiverId;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
    required this.createdAt,
    this.receiverId,
  });
}
