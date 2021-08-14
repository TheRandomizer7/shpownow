import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shpownow/pages/loading.dart';
import 'package:shpownow/pages/login.dart';
import 'package:shpownow/services/flutter_services/authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AuthObject authObject = AuthObject();
  try {
    runApp(MaterialApp(
      home: await authObject.isUserSignedIn() ? Loading() : LoginPage(),
    ));
  } catch (e) {
    print(e.toString());
  }
}
