import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:regauth/regauth_Widget.dart';
import 'package:http/http.dart' as http;

/// Signup page
///
/// Signing up endpoint should be assigned to [signUpLink].
///
/// App Name / The org to which the user is signing in or signing up
///  should be assigned to [theAppName].
///
/// Specify the key for the mailid the signup endpoint expects in the map.
///  to [signUpMapMailIDKey].
///
/// Specify the key for the password the signup endpoint expects in the map.
///  to [signUpMapPasswordKey].
///
/// Specify the key for the user's name the signup endpoint expects in the map.
///  to [signUpMapFullNameKey].
///
/// Specify the key for the user's mobile number the signup endpoint expects in the map.
///  to [signUpMapMobileNumberKey].
class SignUpPage extends StatelessWidget {
  /// Signing up endpoint.
  final String signUpLink;

  /// Mention the App name / The org to which
  ///  the user is signing in or signing up.
  final String theAppName;

  /// Specify the key for the mailid the signup endpoint expects in the map.
  final String signUpMapMailIDKey;

  /// Specify the key for the password the signup endpoint expects in the map.
  final String signUpMapPasswordKey;

  /// Specify the key for the user's name the signup endpoint expects in the map.
  final String signUpMapFullNameKey;

  /// Specify the key for the user's mobile number the signup endpoint expects in the map.
  final String signUpMapMobileNumberKey;

  const SignUpPage({
    Key key,
    @required this.signUpLink,
    @required this.theAppName,
    @required this.signUpMapMailIDKey,
    @required this.signUpMapPasswordKey,
    @required this.signUpMapFullNameKey,
    @required this.signUpMapMobileNumberKey,
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
          theAppName: theAppName,
          signUpMapFullNameKey: signUpMapFullNameKey,
          signUpMapMailIDKey: signUpMapMailIDKey,
          signUpMapMobileNumberKey: signUpMapMobileNumberKey,
          signUpMapPasswordKey: signUpMapPasswordKey,
        ),
      ),
    );
  }
}

/// Full Signup form.
///
/// Signing up endpoint should be assigned to [signUpLink].
///
/// App Name / The org to which the user is signing in or signing up
///  should be assigned to [theAppName].
///
/// Specify the key for the mailid the signup endpoint expects in the map.
///  to [signUpMapMailIDKey].
///
/// Specify the key for the password the signup endpoint expects in the map.
///  to [signUpMapPasswordKey].
///
/// Specify the key for the user's name the signup endpoint expects in the map.
///  to [signUpMapFullNameKey].
///
/// Specify the key for the user's mobile number the signup endpoint expects in the map.
///  to [signUpMapMobileNumberKey].
class SignUpForm extends StatefulWidget {
  /// Signing up endpoint.
  final String signUpLink;

  /// Mention the App name / The org to which
  ///  the user is signing in or signing up.
  final String theAppName;

  /// Specify the key for the mailid the signup endpoint expects in the map.
  final String signUpMapMailIDKey;

  /// Specify the key for the password the signup endpoint expects in the map.
  final String signUpMapPasswordKey;

  /// Specify the key for the user's name the signup endpoint expects in the map.
  final String signUpMapFullNameKey;

  /// Specify the key for the user's mobile number the signup endpoint expects in the map.
  final String signUpMapMobileNumberKey;
  const SignUpForm({
    Key key,
    @required this.signUpLink,
    @required this.theAppName,
    @required this.signUpMapMailIDKey,
    @required this.signUpMapPasswordKey,
    @required this.signUpMapFullNameKey,
    @required this.signUpMapMobileNumberKey,
  }) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();

  String signUpStatus = "";
  bool isSignedUp = true;
  bool doSignUp = false;
  bool showProgress = false;

  goSignup({
    String mailId,
    String fullName,
    String pwd,
    String mobileNum,
    String signUpMapMailIDKey,
    String signUpMapPasswordKey,
    String signUpMapFullNameKey,
    String signUpMapMobileNumberKey,
  }) async {
    /// The Map that signing up endpoint expects.
    Map signUpData = {
      signUpMapMailIDKey: mailId,
      signUpMapFullNameKey: fullName,
      signUpMapMobileNumberKey: mobileNum,
      signUpMapPasswordKey: pwd
    };

    try {
      var signUpResponse = await http.post(
        Uri.parse(widget.signUpLink),
        body: signUpData,
      );

      /// Notify  if email id or mobile number already exists.
      if (signUpResponse.statusCode == 400) {
        /// http response 400 gives back a map
        Map<String, dynamic> jsonData = jsonDecode(signUpResponse.body);
        //print(jsonData);

        if (jsonData["username"] != null) {
          /// Following is the response we get if the mail already exists.
          ///
          /// {
          ///     "username": [
          ///        "A user with that username already exists."
          ///     ]
          /// }
          ///
          /// Hence we check if the "username" key is not empty
          ///  and notify with signup status.
          setState(
            () {
              signUpStatus = 'Email Id already exists';
            },
          );
        } else if (jsonData["last_name"] != null) {
          /// Following is the response we get if the phone number already exists.
          /// {
          ///     "last_name": [
          ///         "phone number is already in use"
          ///     ]
          /// }
          /// Hence we check if the "last_name" key is not empty
          ///  and notify with signup status.
          setState(
            () {
              signUpStatus = 'Mobile Number already exists';
            },
          );
        }
      } else if (signUpResponse.statusCode == 201) {
        /// If signup map is proper and got accepted,
        ///  our response will be like the following:
        ///
        /// {
        ///     "username": "ji@ji.comm",
        ///     "first_name": "Ji Ji",
        ///     "last_name": "843456542"
        /// }
        ///
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

      /// Once the process is done according to http response code,
      /// stop showing progress indicator.
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
                  goSignup(
                    fullName: fullName,
                    mailId: mailId,
                    mobileNum: mobileNum,
                    pwd: pwd,
                    signUpMapFullNameKey: widget.signUpMapFullNameKey,
                    signUpMapMailIDKey: widget.signUpMapMailIDKey,
                    signUpMapMobileNumberKey: widget.signUpMapMobileNumberKey,
                    signUpMapPasswordKey: widget.signUpMapPasswordKey,
                  );
                }
              },
            ),
          ),
          IfOldSignIn(
            theAppName: widget.theAppName,
          ),
          RegAuthStatus(
            regAuthStatusMsg: signUpStatus,
            isRegAuthSuccess: isSignedUp,
          ),
          CircularProgressStatus(
            showCircularProgress: showProgress,
          ),
        ],
      ),
    );
  }
}
