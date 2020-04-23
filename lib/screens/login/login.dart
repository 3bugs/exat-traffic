import 'package:flutter/material.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/screens/home/home.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return wrapSystemUiOverlayStyle(child: LoginMain());
  }
}

class LoginMain extends StatefulWidget {
  @override
  _LoginMainState createState() => _LoginMainState();
}

class _LoginMainState extends State<LoginMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: EdgeInsets.only(
                left: getPlatformSize(40.0), right: getPlatformSize(40.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.loose,
                  flex: 1,
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.only(top: getPlatformSize(20.0)),
                      child: Image(
                        image: AssetImage('assets/images/login/exat_logo.png'),
                        width: getPlatformSize(210.0),
                        height: getPlatformSize(210.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 0.0,
                      right: 0.0,
                      top: getPlatformSize(20.0),
                      bottom: getPlatformSize(20.0)),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xaaffffff),
                          blurRadius: getPlatformSize(15.0),
                          // has the effect of softening the shadow
                          spreadRadius: getPlatformSize(3.0),
                          // has the effect of extending the shadow
                          offset: Offset(
                            getPlatformSize(3.0), // horizontal, move right 10
                            getPlatformSize(3.0), // vertical, move down 10
                          ),
                        )
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(getPlatformSize(12.0)),
                        topRight: Radius.circular(getPlatformSize(12.0)),
                        bottomLeft: Radius.circular(getPlatformSize(12.0)),
                        bottomRight: Radius.circular(getPlatformSize(12.0)),
                      )),
                  child: Column(
                    children: <Widget>[
                      LoginField(
                        icon: AssetImage('assets/images/login/ic_username.png'),
                        iconWidth: getPlatformSize(20.0),
                        iconHeight: getPlatformSize(20.0),
                        label: 'USERNAME / EMAIL',
                        hint: 'Enter username or email',
                      ),
                      Container(
                        height: 0.5,
                        color: const Color(0xffe0e0e0),
                      ),
                      LoginField(
                        icon: AssetImage('assets/images/login/ic_password.png'),
                        iconWidth: getPlatformSize(19.25),
                        iconHeight: getPlatformSize(22.0),
                        label: 'PASSWORD',
                        hint: 'Enter password',
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
                            fontSize: getPlatformSize(13.0),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: getPlatformSize(20.0),
                      ),
                      MyButton(
                        text: 'Login',
                        onClickButton: () {
                          //alert(context, 'Login', 'Test login');
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                          );
                        },
                      ),
                      SizedBox(
                        height: getPlatformSize(24.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              fontSize: getPlatformSize(13.0),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: getPlatformSize(8.0)),
                          Text(
                            "SIGN UP",
                            style: TextStyle(
                              fontSize: getPlatformSize(13.0),
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
    );
  }
}

class LoginField extends StatefulWidget {
  LoginField(
      {@required this.icon,
      @required this.iconWidth,
      @required this.iconHeight,
      @required this.label,
      @required this.hint});

  final AssetImage icon;
  final double iconWidth;
  final double iconHeight;
  final String label;
  final String hint;

  @override
  _LoginFieldState createState() => _LoginFieldState();
}

class _LoginFieldState extends State<LoginField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 0,
              left: getPlatformSize(12.0),
              bottom: 0,
              right: getPlatformSize(16.0),
            ),
            child: Image(
              image: widget.icon,
              width: widget.iconWidth,
              height: widget.iconHeight,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: getPlatformSize(7.0), bottom: 0.0),
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: getPlatformSize(12.0),
                      color: Color(0x80515C6F),
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: getPlatformSize(4.0)),
                      border: InputBorder.none,
                      hintText: widget.hint),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  MyButton({@required this.text, @required this.onClickButton});

  final String text;
  final Function onClickButton;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(12),
        //side: BorderSide(color: Colors.red)
      ),
      padding: EdgeInsets.all(getPlatformSize(16.0)),
      onPressed: onClickButton,
      color: Color(0xFF305393),
      textColor: Colors.white,
      child: Text(text.toUpperCase(), style: TextStyle(fontSize: getPlatformSize(15.0))),
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
