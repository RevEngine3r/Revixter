import 'package:flutter/material.dart';
import 'chat_page.dart';
import 'statics.dart' as statics;
import 'prefs.dart' as prefs;
import 'package:easy_search_bar/easy_search_bar.dart';
import 'shared.dart' as shared;
import 'utils.dart' as utils;

Map<int, shared.Chat> idChats = {};
Map<String, shared.Chat> usernameChats = {};

void addNewRemoteMessage(msg){
  return;
}

shared.Chat addNewChat(user) {
  var chat = shared.Chat(user);
  var id = user['id'];
  var username = user['username'];

  if (!idChats.containsKey(id)) {
    idChats[id] = chat;
  }
  if (!usernameChats.containsKey(username)) {
    usernameChats[username] = chat;
  }

  return chat;
}

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  void navigateToChatPage(context, shared.Chat chat) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ChatPage(chat),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final users = {};
    return Scaffold(
      appBar: EasySearchBar(
        title: const Text('Search'),
        asyncSuggestions: (value) {
          return utils
              .decodedGetResults('${statics.usersBackend}/',
                  useAuthHeader: true)
              .then((data) {
            List<String> suggestions = [];
            debugPrint(data.toString());
            if (data != null) {
              for (var user in data) {
                var username = user['username'];
                suggestions.add(username);
                users[username] = user;
              }
            }
            return suggestions;
          });
        },
        onSearch: (search) {
          return;
        },
        onSuggestionTap: (suggestion) {
          var user = users[suggestion];
          prefs.addContact(suggestion, user);
          var chat = addNewChat(user);
          navigateToChatPage(context, chat);
        },
      ),
      body: PopScope(
          canPop: true,
          onPopInvoked: (didPop) => Navigator.pop(context),
          child: ListView(
            children: prefs.myUsersList.values.map((user) {
              var username = user['username'];
              return ListTile(
                leading: const Icon(
                  Icons.person_2_rounded,
                  color: Colors.blue,
                ),
                title: Text(
                  username,
                ),
                trailing: const Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.deepOrange,
                ),
                onTap: () {
                  navigateToChatPage(context, usernameChats[username]!);
                },
              );
            }).toList(),
          )),
    );
  }
}
