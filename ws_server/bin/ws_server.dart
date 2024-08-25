import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/io.dart';

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

  factory MessageEntity.fromJson(String source) =>
      MessageEntity.fromMap(json.decode(source) as Map<String, dynamic>);
}

List<IOWebSocketChannel> webSockets = [];
main(List<String> arguments) async {
  var wsHandler = webSocketHandler((IOWebSocketChannel webSocket) {
    webSockets.add(webSocket);

    webSocket.stream.listen((message) {
      final messageEntity = MessageEntity.fromJson(message);

      for (var element in webSockets) {
        element.sink.add(messageEntity.toJson());
      }
    }, onDone: () {
      webSockets.remove(webSocket);
    });
  });
  final router = Router()..get('/ws', wsHandler);

  // Configure a pipeline that logs requests.
  final handler =
      Pipeline().addMiddleware(logRequests()).addHandler(router.call);

  await serve(handler, 'localhost', 8080).then((handler) {
    print('Serving at ws://${handler.address.host}:${handler.port}');
  });
}
