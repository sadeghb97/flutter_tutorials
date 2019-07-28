class ChatModel {
  final int id;
  final String name;
  final String message;
  final String time;
  final String avatarUrl;
  final bool isLocal;

  ChatModel({this.id, this.name, this.message, this.time, this.avatarUrl, this.isLocal});
}

class SocketMessage {
  final int senderId;
  final String message;
  final String messageId;
  bool acknowledgement = false;

  SocketMessage({this.senderId, this.message}) :
      messageId = "$senderId-${DateTime.now().microsecondsSinceEpoch}";
}