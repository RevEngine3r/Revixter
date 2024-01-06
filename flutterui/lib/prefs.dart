import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences _prefs;

Future<void> init() async {
  _prefs = await SharedPreferences.getInstance();
}

// JWT Access Token Last Updated Unix Time Stamp
var _jwtAccessTokenLastUpdateKey = 'jwt_access_token_last_update';

DateTime? get jwtAccessTokenLastUpdateKey =>
    DateTime.fromMillisecondsSinceEpoch(
        _prefs.getInt(_jwtAccessTokenLastUpdateKey)!);

set jwtAccessTokenLastUpdateKey(value) =>
    _prefs.setInt(_jwtAccessTokenLastUpdateKey, value);

// JWT Access Token
var _jwtAccessTokenKey = 'jwt_access_token';

String? get jwtAccessToken => _prefs.getString(_jwtAccessTokenKey);

set jwtAccessToken(value) {
  _prefs.setString(_jwtAccessTokenKey, value);
  jwtAccessTokenLastUpdateKey = DateTime.timestamp().millisecondsSinceEpoch;
}

// JWT Refresh Token Token
var _jwtRefreshTokenKey = 'jwt_refresh_token';

String? get jwtRefreshToken => _prefs.getString(_jwtRefreshTokenKey);

set jwtRefreshToken(value) => _prefs.setString(_jwtRefreshTokenKey, value);

// Me
var _me = 'me';

Map<String, dynamic> get me => json.decode(_prefs.getString(_me)!);

set me(value) => _prefs.setString(_me, json.encode(value));

String get myUsername => me['username'] as String;

String get myEmail => me['email'] as String;

int get myID => me['id'];

// My Users List
var _myUsersList = 'my_users_list';

Map<String, dynamic> get myUsersList =>
    json.decode(_prefs.getString(_myUsersList) ?? '{}');

void addContact(username, user) {
  var users = myUsersList;
  users[username] = user;
  _prefs.setString(_myUsersList, json.encode(users));
}
