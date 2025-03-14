import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/data/models/index.dart';
import 'src/data/services/index.dart';
import 'src/ui/index.dart';

void main() {
  _setTargetPlatformForDesktop();
  init(); // TODO: Update Firebase Config in `init()` method
  runApp(MyApp());
}

void _setTargetPlatformForDesktop() {
  TargetPlatform targetPlatform;
  if (Platform.isMacOS) {
    targetPlatform = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}

ThemeData get lightTheme => ThemeData(
      dividerColor: Colors.grey[300],
      primarySwatch: Colors.blue,
      canvasColor: Colors.transparent,
      dialogBackgroundColor: Colors.white,
      fontFamily: 'Raleway',
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      accentColor: Colors.redAccent,
    );

class MyApp extends StatelessWidget {
  static const String title = 'Flutter Tasky';

  @override
  Widget build(BuildContext context) {
    return ListenableProvider.value(
      value: AuthState()..init(),
      child: Consumer<AuthState>(
        builder: (context, auth, child) {
          if (!auth.isLoggedIn) {
            return MaterialApp(
              title: title,
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              home: LoginScreen(),
            );
          }

          return MultiProvider(
            providers: [
              ListenableProvider.value(value: TaskState(auth.cred.uid)..init()),
            ],
            child: MaterialApp(
              title: title,
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              home: HomeScreen(),
            ),
          );
        },
      ),
    );
  }
}
