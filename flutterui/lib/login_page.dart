import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutterui/contacts_page.dart';
import 'package:regexpattern/regexpattern.dart';
import 'statics.dart' as statics;
import 'prefs.dart' as prefs;
import 'utils.dart' as utils;

Future<bool> _obtainTokens(String username, String password) {
  return utils.decodedPostBody(
    "${statics.tokenBackend}/",
    body: {'username': username, 'password': password},
  ).then((data) {
    if (data != null) {
      prefs.jwtAccessToken = data['access'];
      prefs.jwtRefreshToken = data['refresh'];
      return true;
    }
    return false;
  });
}

Future<void> _getMe(username) {
  return utils
      .decodedGetResults('${statics.usersBackend}/?username=$username',
          useAuthHeader: true)
      .then((data) {
    if (data != null) {
      prefs.me = data[0];
    }
  });
}

Duration get _loginTime => const Duration(milliseconds: 300);

Future<String?> _authUser(LoginData data) async {
  debugPrint('Name: ${data.name}, Password: ${data.password}');
  return Future.delayed(_loginTime).then((_) async {
    if (await _obtainTokens(data.name, data.password)) {
      _getMe(data.name);
      return null;
    }
    return 'No active account found with the given credentials.';
  });
}

class LoginPage extends StatelessWidget {
  final bool doLogin;

  const LoginPage({super.key, required this.doLogin});

/*

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }



  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }

 */

  @override
  Widget build(BuildContext context) {
    if (!doLogin) {
      return const ContactsPage();
    }

    return FlutterLogin(
      showDebugButtons: false,
      userType: LoginUserType.name,
      userValidator: (value) {
        if (value == null || value.isEmpty || !value.isUsername()) {
          return 'Invalid username!';
        }
        return null;
      },
      hideForgotPasswordButton: true,
      title: 'Revixter',
      onLogin: _authUser,
      onSignup: null,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ContactsPage(),
        ));
      },
      onRecoverPassword: (p0) => null,
    );
  }
}
