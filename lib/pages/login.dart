import 'package:flutter/material.dart';
import 'package:shpownow/pages/loading.dart';
import 'package:shpownow/pages/sign_up.dart';
import 'package:shpownow/services/flutter_services/authentication.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();

  AuthObject authObject = AuthObject();

  @override
  Widget build(BuildContext context) {
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
                  'Login',
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
                height: 50.0,
              ),
              MaterialButton(
                onPressed: () async {
                  bool loggedIn = await authObject.login(
                      _emailField.text, _passwordField.text);
                  if (loggedIn) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Loading()));
                  }
                },
                child: Text(
                  'Login',
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
              SizedBox(
                height: 20.0,
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                    return SignUpPage();
                  }, transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                    final offsetAnimation = animation.drive(Tween(
                      begin: Offset(1.0, 0.0),
                      end: Offset.zero,
                    ));
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  }));
                },
                child: Text(
                  'New user? Sign up',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontFamily: 'Roboto',
                    letterSpacing: 1.0,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                color: Colors.redAccent[100],
              ),
              SizedBox(
                height: 20.0,
              ),
              InkWell(
                onTap: () async {
                  bool loggedIn = await authObject.signInWithGoogle();
                  if (loggedIn) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Loading()));
                  }
                },
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey,
                        offset: new Offset(2.0, 2.0),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2.0),
                          child: Image.asset(
                            'assets/google logo.jpg',
                            height: 40.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                          child: Text(
                            'Sign in with Google',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Roboto bold',
                              letterSpacing: 1.0,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
