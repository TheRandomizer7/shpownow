import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shpownow/services/flutter_services/authentication.dart';
import 'package:shpownow/services/flutter_services/firestore.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    AuthObject authObject = AuthObject();
    FirestoreObject firestoreObject = FirestoreObject();

    TextEditingController _usernameField = TextEditingController();
    TextEditingController _emailField = TextEditingController();
    TextEditingController _passwordField = TextEditingController();
    TextEditingController _confirmPasswordField = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.shopping_basket,
              color: Colors.grey[800],
            ),
            SizedBox(
              width: 20.0,
            ),
            Container(
              height: 30.0,
              width: 2.0,
              color: Colors.deepOrange[600],
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              'Shpownow',
              style: TextStyle(
                  fontSize: 20.0,
                  letterSpacing: 2.0,
                  fontFamily: 'Roboto',
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w800),
            )
          ],
        ),
        backgroundColor: Colors.deepOrange[300],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Sign up',
                  style: TextStyle(
                      fontSize: 25.0,
                      letterSpacing: 2.0,
                      fontFamily: 'Roboto',
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w800),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              TextFormField(
                controller: _usernameField,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  labelStyle: TextStyle(
                    color: Colors.grey[800],
                    fontFamily: 'Roboto',
                    letterSpacing: 1.0,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w800,
                  ),
                  hintText: 'Your name',
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.grey[600],
                  ),
                ),
                style: TextStyle(
                  color: Colors.grey[800],
                  fontFamily: 'Roboto',
                  letterSpacing: 1.0,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: _emailField,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: Colors.grey[800],
                    fontFamily: 'Roboto',
                    letterSpacing: 1.0,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w800,
                  ),
                  hintText: 'name@gmail.com',
                  prefixIcon: Icon(
                    Icons.mail,
                    color: Colors.grey[600],
                  ),
                ),
                style: TextStyle(
                  color: Colors.grey[800],
                  fontFamily: 'Roboto',
                  letterSpacing: 1.0,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: _passwordField,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: Colors.grey[800],
                    fontFamily: 'Roboto',
                    letterSpacing: 1.0,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w800,
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.grey[600],
                  ),
                ),
                obscureText: true,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontFamily: 'Roboto',
                  letterSpacing: 1.0,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: _confirmPasswordField,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm password',
                  labelStyle: TextStyle(
                    color: Colors.grey[800],
                    fontFamily: 'Roboto',
                    letterSpacing: 1.0,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w800,
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.grey[600],
                  ),
                ),
                obscureText: true,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontFamily: 'Roboto',
                  letterSpacing: 1.0,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              MaterialButton(
                onPressed: () async {
                  if (_confirmPasswordField.text == _passwordField.text) {
                    bool signedUp = await authObject.signUp(
                        _emailField.text, _passwordField.text);
                    if (signedUp) {
                      bool addedUser =
                          await firestoreObject.addUser(_usernameField.text);
                      if (addedUser) {
                        Navigator.pop(context);
                      } else {
                        Fluttertoast.showToast(
                        msg: 'Something went really wrong, and you may not be able to use your account. Fix your account by signing in with a google account of the same email',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM);
                      }
                    }
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Both passwords don\'t match',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM);
                  }
                },
                child: Text(
                  'Sign up',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontFamily: 'Roboto',
                    letterSpacing: 1.0,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                color: Colors.greenAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
