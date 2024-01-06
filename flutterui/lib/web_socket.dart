import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:flutter/material.dart';
import 'statics.dart' as statics;

WebSocketChannel? channel;

void init() async {
  channel = WebSocketChannel.connect(Uri.parse(statics.apiHost));

  await channel!.ready;

  channel!.stream.listen((msg) {
    debugPrint(msg.toString());
  });
}
