import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatController {
  final wsUrl = Uri.parse('ws://localhost:8080/ws');
  late final channel = WebSocketChannel.connect(wsUrl);

  final msg = ValueNotifier<List<MessageEntity>>([]);

  init() async {
    await channel.ready;

    channel.stream.listen(
      (message) {
        msg.value = List.from(msg.value)..add(MessageEntity.fromJson(message));
      },
      onError: (error, stackTrace) {},
      onDone: () {},
      cancelOnError: true,
    );
  }

  sendMessage(String message, String username) {
    channel.sink
        .add(MessageEntity(message: message, username: username).toJson());
  }
}

class MessageEntity {
  final String message;
  final String username;

  MessageEntity({required this.message, required this.username});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'username': username,
    };
  }

  factory MessageEntity.fromMap(Map<String, dynamic> map) {
    return MessageEntity(
      message: map['message'] as String,
      username: map['username'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageEntity.fromJson(String jsonString) =>
      MessageEntity.fromMap(json.decode(jsonString));
}
