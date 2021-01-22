import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:regauth/regauth_Widget.dart';
import 'package:regauth/signin_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// Signing in endpoint should be assigned to [signInLink].
///
/// Signing up endpoint should be assigned to [signUpLink].
///
/// App Name / The org to which the user is signing in or signing up
///  should be assigned to [theAppName].
///
/// Assign false to [leadToSignUpPage] if loginform should not
///  lead to signup page. By default it will be true.
///
/// Assign the key for the mailid the endpoint expects in the map
///  to [signInMapMailIDKey].
///
/// Assign the key for the password the endpoint expects in the map
///  to [signInMapPasswordKey].
class SignInPage extends StatelessWidget {
  /// Signing in endpoint.
  final String signInLink;

  /// Signing up endpoint.
  final String signUpLink;

  /// Mention the App name / The org to which
  ///  the user is signing in or signing up.
  final String theAppName;

  /// Mention as bool if loginform
  ///  should lead to signup page.
  ///  Defaults to true.
  final bool leadToSignUpPage;

  /// Specify the key for the mailid the endpoint expects in the map.
  final String signInMapMailIDKey;

  /// Specify the key for the password the endpoint expects in the map.
  final String signInMapPasswordKey;

  const SignInPage({
    Key key,
    @required this.signInLink,
    this.signUpLink,
    @required this.theAppName,
    this.leadToSignUpPage,
    @required this.signInMapMailIDKey,
    @required this.signInMapPasswordKey,
  }) : super(key: key);

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
            theAppName: theAppName,
            leadToSignUpPage: leadToSignUpPage ?? true,
            signInMapMailIDKey: signInMapMailIDKey,
            signInMapPasswordKey: signInMapPasswordKey,
          ),
        ));
  }
}

// Full login Form
class LoginForm extends StatefulWidget {
  final String signInLink, signUpLink, theAppName;
  final String signInMapMailIDKey;
  final String signInMapPasswordKey;
  final bool leadToSignUpPage;
  const LoginForm({
    Key key,
    @required this.signInLink,
    this.signUpLink,
    @required this.theAppName,
    @required this.leadToSignUpPage,
    @required this.signInMapMailIDKey,
    @required this.signInMapPasswordKey,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();

  String loginStatus = "";
  bool doSignIn = false;
  bool isLoggedIn = false;
  bool showProgress = false;

  /// Set values to the keys depending upon
  /// the user details we get as response.
  ///
  /// [isLoggedIn] Set to true upon successful login.
  ///
  /// [theLoginToken] The JWT token.
  ///
  /// [userName] Full name of the logged in user.
  ///
  /// [userMail] Mail id of the user.
  ///
  /// [userMbl] Mobile number of the user.
  setLoggedIn({
    bool isLoggedIn,
    String theLoginToken,
    String userName,
    String userMail,
    String userMbl,
  }) async {
    /// Init sharedpreference and set the user details for future access.
    SharedPreferences thePrefs = await SharedPreferences.getInstance();

    /// [isLoggedIn] key will contain true if user signs in successfully.
    /// Use it to check if the user is logged in already.
    thePrefs.setBool('isLoggedIn', isLoggedIn);

    /// [loginToken] key will contain "JWT" once user signs in successfully.
    thePrefs.setString("loginToken", theLoginToken);

    /// [userName] key will contain full name of the user upon successful sign in.
    thePrefs.setString("userName", userName);

    /// [userMail] key will contain email Id of the user upon successful sign in.
    thePrefs.setString("userMail", userMail);

    /// [userMbl] key will contain mobile number of the user upon successful sign in.
    thePrefs.setString("userMbl", userMbl);
  }

  goLogin({
    String mailId,
    String pwd,
    String signInMapMailIDKey,
    String signInMapPasswordKey,
  }) async {
    /// The Map that signing in endpoint requires
    Map loginData = {signInMapMailIDKey: mailId, signInMapPasswordKey: pwd};

    try {
      var loginResponse = await http.post(
        widget.signInLink,
        body: loginData,
      );

      /// Notify in case of invalid credintials.
      if (loginResponse.statusCode == 401) {
        setState(
          () {
            loginStatus = 'Invalid Credintials';
          },
        );
      }

      /// Upon submission of right credintials,
      /// decode the json and set values to the keys
      /// using sharedpreference.
      else if (loginResponse.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(loginResponse.body);
        // print(jsonData["token"]);
        //print(jsonData["user"]);

        User theUserDetailsModel = new User();
        theUserDetailsModel = User.fromJson(jsonData["user"]);

        /// As right credintials are sent,
        ///  [doSignin] and [isLoggedIn] are set to true.
        ///  [setLoggedIn] function is invoked.
        setState(
          () {
            doSignIn = true;
            isLoggedIn = true;

            setLoggedIn(
              isLoggedIn: isLoggedIn,
              theLoginToken: jsonData["token"],
              userName: theUserDetailsModel.fullName,
              userMail: theUserDetailsModel.mail,
              userMbl: theUserDetailsModel.mobileNum,
            );

            /// Clear the login status msg once login is done.
            ///
            /// Clearing in case if there is failed login status msg.
            loginStatus = '';
          },
        );
      }

      /// Notify in case of unknown status code.
      else {
        setState(
          () {
            loginStatus = 'Something Wrong. Try again later';
          },
        );
      }

      /// Once all the processes
      /// (either with right credintials or with wrong one) are done,
      /// stop showing progress bar.
      setState(
        () {
          showProgress = false;
        },
      );

      /// If [doSignIN] is set true, pop the page and
      ///  set the same to false once the page is popped.
      if (doSignIn) {
        Navigator.pop(context);
        doSignIn = false; //Reset once login is done
      }
    }

    /// On Socket Exception, catch it,
    ///  stop showing progress indicator and notify by
    ///  setting login status message.
    on SocketException catch (_) {
      setState(
        () {
          showProgress = false;
          loginStatus = 'Check Your Data Connection and try again';
        },
      );
    }

    /// On any other Exception, catch it,
    ///  stop showing progress indicator and notify by
    ///  setting login status message.
    catch (e) {
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
                  goLogin(
                    mailId: mailId,
                    pwd: pwd,
                    signInMapMailIDKey: widget.signInMapMailIDKey,
                    signInMapPasswordKey: widget.signInMapPasswordKey,
                  );
                }
              },
            ),
          ),
          if (widget.leadToSignUpPage ?? true)
            IfNewSignupRow(
              signUpLink: widget.signUpLink,
              theAppName: widget.theAppName,
            ),
          RegAuthStatus(
            regAuthStatusMsg: loginStatus,
            isRegAuthSuccess: isLoggedIn,
          ),
          CircularProgressStatus(
            showCircularProgress: showProgress,
          ),
        ],
      ),
    );
  }
}
