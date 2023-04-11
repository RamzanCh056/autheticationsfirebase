import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'auth/user_auth/main_login.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  final Future<FirebaseApp> initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Box office',
      theme: ThemeData(
          primaryColor: Colors.purple[900],
          colorScheme: ColorScheme.light(
              primary: Colors.purple[900]!
          ),
          appBarTheme: AppBarTheme(
            color: Colors.purple[900],
          ),
          fontFamily: 'regular'),
      home: LoginMain(),
    );
  }
}

