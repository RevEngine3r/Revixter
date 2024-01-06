import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterui/login_page.dart';
import 'prefs.dart' as prefs;
import 'package:http/http.dart' as http;
import 'statics.dart' as statics;
import 'utils.dart' as utils;

Future<bool> _verifyToken(String token) {
  return http.post(
    Uri.parse('${statics.tokenVerifyBackend}/'),
    body: {'token': token},
  ).then((value) => value.statusCode == 200);
}

Future<void> _refreshTokens(String refreshToken) {
  return utils.decodedPostResults(
    '${statics.tokenRefreshBackend}/',
    body: {'refresh': refreshToken},
  ).then((data) {
    if (data != null) {
      prefs.jwtAccessToken = data['access'];
      prefs.jwtRefreshToken = data['refresh'];
    }
  });
}

Future<bool> _needsLogin() async {
  final accessToken = prefs.jwtAccessToken;
  debugPrint("access: $accessToken");

  // if access token is invalid
  if ((accessToken == null) ||
      (accessToken.isEmpty) ||
      (!await _verifyToken(accessToken))) {
    final refreshToken = prefs.jwtRefreshToken;
    debugPrint("refresh: $refreshToken");

    // if refresh token is invalid too
    if ((refreshToken == null) ||
        (refreshToken.isEmpty) ||
        (!await _verifyToken(refreshToken))) {
      debugPrint("refresh token invalid.");
      // login via user pass is needed to obtain fresh and valid tokens
      return true;
    }

    // if refresh token is valid, obtain fresh tokens with it
    _refreshTokens(refreshToken);
    debugPrint("access token refreshed.");
  }

  // if access token is valid no need to login or refresh
  return false;
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Revixter',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: FutureBuilder(
        future: _needsLogin(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());
          }
          if (snapshot.hasData) {
            var login = snapshot.data!;
            return LoginPage(doLogin: login);
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
