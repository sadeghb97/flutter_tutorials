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
  final int id;
  final String message;
  SocketMessage({this.id, this.message});
}