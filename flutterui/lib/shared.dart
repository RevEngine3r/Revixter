import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart' as uuid;
import 'prefs.dart' as prefs;

var myUUID = const uuid.Uuid();

class Chat {
  static types.User? _localUser;
  late final String _remoteUserID;
  late final types.User _remoteUser;
  final List<types.TextMessage> _messages = [];
  Function? updateChatPage;

  Chat(remoteUserDataMap) {
    _remoteUserID = remoteUserDataMap['id'].toString();
    _remoteUser = types.User(id: _remoteUserID, metadata: remoteUserDataMap);
    Chat._localUser ??= types.User(id: prefs.myID.toString());
  }

  types.User get remoteUser => _remoteUser;

  types.User? get localUser => _localUser;

  List<types.TextMessage> get messages => _messages;


  void addNewRemoteMessage(Map<String, String> message) {
    _messages.insert(
        0,
        types.TextMessage(
          author: _remoteUser,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: myUUID.v4(),
          text: message['msg'] ?? '',
        ));

    if (updateChatPage != null) {
      updateChatPage!();
    }
  }

  void addNewLocalMessage(types.PartialText message) {
    _messages.insert(
        0,
        types.TextMessage(
          author: _localUser!,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: myUUID.v4(),
          text: message.text,
        ));
  }
}
