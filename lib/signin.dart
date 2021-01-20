import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:regauth/regauth_Widget.dart';
import 'package:regauth/signin_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SignInPage extends StatelessWidget {
  final signInLink, signUpLink;
  const SignInPage({Key key, this.signInLink, this.signUpLink})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: RegAuthAppBarTitle(
            regAuthTitle: "Login",
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Theme.of(context).accentColor,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: LoginForm(
            signInLink: signInLink,
            signUpLink: signUpLink,
          ),
        ));
  }
}

// Full login Form
class LoginForm extends StatefulWidget {
  final String signInLink, signUpLink;
  const LoginForm({Key key, this.signInLink, this.signUpLink})
      : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();

  String loginStatus = "";
  bool doSignIn = false;
  bool isLoggedIn = false;
  bool showProgress = false;

  setLoggedIn({
    bool isLoggedInToken,
    String theLoginToken,
    String userName,
    String userMail,
    String userMbl,
  }) async {
    SharedPreferences thePrefs = await SharedPreferences.getInstance();
    thePrefs.setBool('isLoggedIn', isLoggedInToken);
    thePrefs.setString("loginToken", theLoginToken);
    thePrefs.setString("userName", userName);
    thePrefs.setString("userMail", userMail);
    thePrefs.setString("userMbl", userMbl);
  }

  goLogin(String mailId, String pwd) async {
    Map loginData = {"username": mailId, "password": pwd};

    try {
      var loginResponse = await http.post(
        widget.signInLink,
        body: loginData,
      );
      if (loginResponse.statusCode == 401) {
        setState(
          () {
            loginStatus = 'Invalid Credintials';
          },
        );
      } else if (loginResponse.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(loginResponse.body);
        // print(jsonData["token"]);
        //print(jsonData["user"]);

        User theUserDetailsModel = new User();
        theUserDetailsModel = User.fromJson(jsonData["user"]);
        //print(theUserDetailsModel.firstName);

        setState(
          () {
            doSignIn = true;
            isLoggedIn = true;
            setLoggedIn(
              isLoggedInToken: isLoggedIn,
              theLoginToken: jsonData["token"],
              userName: theUserDetailsModel.firstName,
              userMail: theUserDetailsModel.username,
              userMbl: theUserDetailsModel.lastName,
            );
            loginStatus = ''; //Reset once login is done
          },
        );
      } else {
        setState(
          () {
            loginStatus = 'Something Wrong. Try again later';
          },
        );
      }

      setState(
        () {
          showProgress = false;
        },
      );

      if (doSignIn) {
        Navigator.pop(context);
        doSignIn = false; //Reset once login is done
      }
    } on SocketException catch (_) {
      setState(
        () {
          showProgress = false;
          loginStatus = 'Check Your Data Connection and try again';
        },
      );
    } catch (e) {
      debugPrint("$e");
      setState(
        () {
          showProgress = false;
          loginStatus = 'Connection error. Try again later.';
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signInFormKey,
      child: ListView(
        children: <Widget>[
          EmailBox(),
          PwdBox(),
          // ForgotPwdFlatButton(),
          Container(
            height: 50,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: FloatingActionButton(
              isExtended: true,
              child: Text('Login'),
              onPressed: () {
                setState(
                  () {
                    loginStatus = "";
                  },
                );
                if (!_signInFormKey.currentState.validate()) {
                  return;
                } else {
                  _signInFormKey.currentState.save();
                  setState(
                    () {
                      showProgress = true;
                    },
                  );
                  goLogin(mailId, pwd);
                }
              },
            ),
          ),
          IfNewSignupRow(
            signUpLink: widget.signUpLink,
          ),
          RegAuthStatus(
            regAuthStatusMsg: loginStatus,
            isSignUpPageAndSignedUp: false,
          ),
          CircularProgressStatus(
            showCircularProgress: showProgress,
          ),
        ],
      ),
    );
  }
}
