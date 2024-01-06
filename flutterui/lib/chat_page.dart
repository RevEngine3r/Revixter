import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'shared.dart' as shared;

class ChatPage extends StatefulWidget {
  final shared.Chat chat;

  const ChatPage(this.chat, {super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    widget.chat.updateChatPage = setState;
  }

  @override
  Widget build(BuildContext context) => Chat(
        messages: widget.chat.messages,
        onSendPressed: _handleSendPressed,
        user: widget.chat.remoteUser,
      );

  void _handleSendPressed(types.PartialText message) {
    setState(() => widget.chat.addNewLocalMessage(message));
  }

  @override
  void dispose() {
    super.dispose();
    widget.chat.updateChatPage = null;
  }
}
