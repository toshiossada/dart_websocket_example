import 'package:flutter/material.dart';

import 'chat_controller.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final controller = ChatController();
  final txtName = TextEditingController();
  final txtMessage = TextEditingController();
  @override
  void initState() {
    super.initState();
    controller.init();
  }

  @override
  void dispose() {
    super.dispose();
    controller.channel.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: txtName,
          decoration: const InputDecoration(
            hintText: 'Nome de usuario',
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: controller.msg,
                builder: (context, snapshot, _) {
                  return ListView.builder(
                    itemCount: snapshot.length,
                    itemBuilder: (context, index) {
                      final item = snapshot[index];
                      var msg = '${item.username}: ${item.message}';
                      var align = MainAxisAlignment.start;
                      var bgColor = Colors.yellow;
                      if (item.username == txtName.text) {
                        msg = '${item.message} - (Você)';
                        bgColor = Colors.red;
                        align = MainAxisAlignment.end;
                      }

                      return Container(
                        color: bgColor,
                        child: Row(
                          mainAxisAlignment: align,
                          children: [
                            Text(msg),
                          ],
                        ),
                      );
                    },
                  );
                }),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: txtMessage,
                  decoration: const InputDecoration(
                    hintText: 'Type a message',
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.sendMessage(txtMessage.text, txtName.text);
                },
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
