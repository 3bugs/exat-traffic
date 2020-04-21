import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:exattraffic/etc/utils.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      home: LoginMain(),
    ); // MaterialApp
  }
}

class LoginMain extends StatefulWidget {
  @override
  LoginMainState createState() => LoginMainState();
}

class LoginMainState extends State<LoginMain> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        appBar: null,
        //backgroundColor: Colors.blue,
        body: DecoratedBox(
          position: DecorationPosition.background,
          decoration: BoxDecoration(
            //color: Colors.red,
            image: DecorationImage(
                image: AssetImage('assets/images/login/bg_login.jpg'),
                fit: BoxFit.cover),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 32, right: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.loose,
                    flex: 1,
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Image(
                          image:
                              AssetImage('assets/images/login/exat_logo.png'),
                          width: 200,
                          height: 200,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 20),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xaaffffff),
                            blurRadius: 15.0,
                            // has the effect of softening the shadow
                            spreadRadius: 3.0,
                            // has the effect of extending the shadow
                            offset: Offset(
                              3.0, // horizontal, move right 10
                              3.0, // vertical, move down 10
                            ),
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft: const Radius.circular(12),
                          bottomRight: const Radius.circular(12),
                        )),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 0,
                                  left: 12,
                                  bottom: 0,
                                  right: 16,
                                ),
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/login/ic_username.png'),
                                  width: 22,
                                  height: 22,
                                ),
                                /*child: Icon(
                            Icons.person_outline,
                            size: 22,
                            color: const Color(0xffaaaaaa),
                          )*/
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 7, bottom: 0),
                                      child: Text(
                                        'USERNAME / EMAIL',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0x80515C6F),
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ),
                                    TextField(
                                      decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding:
                                              EdgeInsets.symmetric(vertical: 4),
                                          border: InputBorder.none,
                                          hintText: 'Enter username or email'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 0.5,
                          color: const Color(0xffe0e0e0),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 0,
                                  left: 12,
                                  bottom: 0,
                                  right: 16,
                                ),
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/login/ic_password.png'),
                                  width: 22,
                                  height: 24,
                                ),
                                /*child: Icon(
                            Icons.lock_outline,
                            size: 20,
                            color: const Color(0xffaaaaaa),
                          )*/
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 7, bottom: 0),
                                      child: Text(
                                        'PASSWORD',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0x80515C6F),
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ),
                                    TextField(
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding:
                                              EdgeInsets.symmetric(vertical: 4),
                                          border: InputBorder.none,
                                          hintText: 'Enter password'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RaisedButton(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(12),
                            //side: BorderSide(color: Colors.red)
                          ),
                          padding: const EdgeInsets.all(16),
                          onPressed: () {},
                          color: Color(0xFF305393),
                          textColor: Colors.white,
                          child: Text('Login'.toUpperCase(),
                              style: TextStyle(fontSize: 15)),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "SIGN UP",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD7E340),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BlueBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Color(0x80FF0000),
        border: Border.all(),
      ),
    );
  }
}
