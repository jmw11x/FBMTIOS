// @dart=2.9
import 'package:flutter/material.dart';
import 'package:jwilson177hw1/screens/wrapper.dart';
import 'package:jwilson177hw1/services/auth.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    _auth.signInAnon();
    return StreamProvider<MyUser>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
