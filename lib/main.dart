import 'package:flutter/material.dart';
import './login_screen.dart';
import './stopwatch.dart';

void main() => runApp(StopwatchApp());

class StopwatchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const LoginScreen(),
        LoginScreen.route: (context) => const LoginScreen(),
        StopWatch.route: (context) => const StopWatch(
              name: "Default",
              email: "test@gmail.com",
            ),
      },
      initialRoute: '/',
    );
  }
}
