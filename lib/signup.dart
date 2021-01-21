import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:regauth/regauth_Widget.dart';
import 'package:http/http.dart' as http;

/// Signing in endpoint should be assigned to [signInLink].
///
/// Signing up endpoint should be assigned to [signUpLink].
class SignUpPage extends StatelessWidget {
  /// Signing up endpoint.
  final String signUpLink;

  /// Signing in endpoint.
  final String signInLink;
  const SignUpPage({
    Key key,
    @required this.signUpLink,
    this.signInLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RegAuthAppBarTitle(
          regAuthTitle: "Sign Up",
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
        child: SignUpForm(
          signUpLink: signUpLink,
        ),
      ),
    );
  }
}

//Full Signup form
class SignUpForm extends StatefulWidget {
  final String signUpLink;
  const SignUpForm({Key key, this.signUpLink}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();

  String signUpStatus = "";
  bool isSignedUp = true;
  bool doSignUp = false;
  bool showProgress = false;

  goSignup(String mailId, String fullName, String pwd) async {
    /// The Map that signing up endpoint expects.
    Map signUpData = {
      "username": mailId,
      "first_name": fullName,
      "last_name": mobileNum,
      "password": pwd
    };

    try {
      var signUpResponse = await http.post(
        widget.signUpLink,
        body: signUpData,
      );

      /// Notify  if email id or mobile number already exists.
      if (signUpResponse.statusCode == 400) {
        Map<String, dynamic> jsonData = jsonDecode(signUpResponse.body);
        //print(jsonData);
        if (jsonData["username"] != null) {
          setState(
            () {
              signUpStatus = 'Email Id already exists';
            },
          );
        } else if (jsonData["last_name"] != null) {
          setState(
            () {
              signUpStatus = 'Mobile Number already exists';
            },
          );
        }
      } else if (signUpResponse.statusCode == 201) {
        /// As signup map is proper,
        ///  [doSignUp] and [isSignedUp] are set to true.
        ///  Notify by setting signup status message.
        setState(
          () {
            doSignUp = true;
            isSignedUp = true;
            signUpStatus =
                '''Confirm your email id by opening the link sent and then proceed to login'''; //Set signup Status
          },
        );
      }

      setState(
        () {
          showProgress = false;
        },
      );

      /// If [doSignUp] is set true,
      ///  set the same to false.
      if (doSignUp) {
        //Navigator.pop(context);
        doSignUp = false; //Reset once login is done
      }
    }

    /// On Socket Exception, catch it,
    ///  stop showing progress indicator and notify by
    ///  setting signup status message.
    on SocketException catch (_) {
      setState(
        () {
          showProgress = false;
          signUpStatus = 'Check Your Data Connection and try again';
        },
      );
    }

    /// On any other Exception, catch it,
    ///  stop showing progress indicator and notify by
    ///  setting signup status message.
    catch (e) {
      debugPrint("$e");
      setState(
        () {
          showProgress = false;
          signUpStatus = 'Connection error. Try again later.';
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signUpFormKey,
      child: ListView(
        children: <Widget>[
          FullNameBox(),
          EmailBox(),
          MobileNumberBox(),
          SignUpPwdBox(),
          ConfirmPwdBox(),
          Container(
            height: 50,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: FloatingActionButton(
              isExtended: true,
              child: Text('Sign Up'),
              onPressed: () {
                setState(
                  () {
                    signUpStatus = "";
                    isSignedUp = false;
                  },
                );
                if (!_signUpFormKey.currentState.validate()) {
                  return;
                } else {
                  _signUpFormKey.currentState.save();
                  setState(
                    () {
                      showProgress = true;
                    },
                  );
                  goSignup(mailId, fullName, pwd);
                }
              },
            ),
          ),
          IfOldSignIn(),
          RegAuthStatus(
            regAuthStatusMsg: signUpStatus,
            isSignUpPageAndSignedUp: isSignedUp,
          ),
          CircularProgressStatus(
            showCircularProgress: showProgress,
          ),
        ],
      ),
    );
  }
}
