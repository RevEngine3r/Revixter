import 'package:flutter/cupertino.dart';
import 'prefs.dart' as prefs;
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await prefs.init();
  return runApp(const App());
}
