import 'package:regauth/signup.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

String fullName = "";
String mailId = "";
String mobileNum = "";
TextEditingController passwordController = TextEditingController();
String pwd = "";
TextEditingController passwordConfirmController = TextEditingController();
String pwdConfirm = "";

///AppBar Title widget that gets [regAuthTitle].
///
///Only to use with indivitual login/signup forms and not with pages.
class RegAuthAppBarTitle extends StatelessWidget {
  /// Title in for the Appbar.
  final String regAuthTitle;
  const RegAuthAppBarTitle({Key key, this.regAuthTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      regAuthTitle,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w900,
        color: Theme.of(context).accentColor,
      ),
    );
  }
}

///Email Box with validation.
class EmailBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        validator: (String value) {
          if (value.isEmpty) {
            return 'Email Id is Required';
          } else if (!EmailValidator.validate(value)) {
            return 'Please enter a valid email Address';
          } else
            return null;
        },
        onSaved: (String value) {
          mailId = value;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          suffixIcon: Icon(
            Icons.mail_outline_outlined,
          ),
          hintText: 'Email ID',
        ),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }
}

///Mobile Number Box with country codes and validation.
/// restricts input to 10 digits.
class MobileNumberBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: IntlPhoneField(
        validator: (String value) {
          if (value.isEmpty) {
            return 'Mobile Number is Required';
          } else if (value.length != 10) {
            return 'Mobile number is invalid';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          hintText: 'Mobile Number',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          suffixIcon: Icon(
            Icons.phone_android_outlined,
          ),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
        initialCountryCode: 'IN',
        onSaved: (value) {
          mobileNum = value.completeNumber;
        },
      ),
    );
  }
}

///Password Box for login form.
///Should not be null.
class PwdBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        validator: (String value) {
          if (value.isEmpty) {
            return 'Password is Required';
          } else
            return null;
        },
        onSaved: (String value) {
          pwd = value;
        },
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Password',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          suffixIcon: Icon(
            Icons.lock_open_outlined,
          ),
        ),
      ),
    );
  }
}

/// Password Box for signup form.
/// Validates to have atleast 8 digits.
class SignUpPwdBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        validator: (String value) {
          if (value.isEmpty) {
            return 'Password is Required';
          } else if (value.length < 8) {
            return 'Password should atleast have 8 characters';
          } else {
            return null;
          }
        },
        onSaved: (String value) {
          pwd = value;
        },
        obscureText: true,
        controller: passwordController,
        decoration: InputDecoration(
          hintText: 'Password',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          suffixIcon: Icon(
            Icons.lock_outlined,
          ),
        ),
      ),
    );
  }
}

/// Confirm Password Box in signup page.
/// Validation checks the values to match that in signup password box.
class ConfirmPwdBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        validator: (String value) {
          if (value.isEmpty) {
            return 'Password Confirmation is Required';
          } else if (passwordController.text !=
              passwordConfirmController.text) {
            return 'Password mismatch';
          } else {
            return null;
          }
        },
        onSaved: (String value) {
          pwdConfirm = value;
        },
        obscureText: true,
        controller: passwordConfirmController,
        decoration: InputDecoration(
          hintText: 'Confirm Password',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          suffixIcon: Icon(
            Icons.lock_outlined,
          ),
        ),
      ),
    );
  }
}

/// Full Name Box in signup form.
/// Validates to have atleast 2 chars.
class FullNameBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        validator: (String value) {
          if (value.isEmpty) {
            return 'Name is Required';
          } else if (value.length < 2) {
            return 'Name should atleast have 2 characters';
          } else {
            return null;
          }
        },
        onSaved: (String value) {
          fullName = value;
        },
        decoration: InputDecoration(
          hintText: 'Full Name',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          suffixIcon: Icon(
            Icons.person_outline,
          ),
        ),
      ),
    );
  }
}

///Forgot Password Flat Button in login form.
class ForgotPwdFlatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        // Navigator.push( //TODO: Forgot PWD Page
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ForgotPWD(),
        //   ),
        // );
      },
      textColor: Theme.of(context).accentColor,
      child: Text('Forgot Password'),
    );
  }
}

/// "New to "THE APP"? SignUp" row in login form.
class IfNewSignupRow extends StatelessWidget {
  final String signUpLink;
  final String theAppName;
  final String signUpMapMailIDKey;
  final String signUpMapPasswordKey;
  final String signUpMapFullNameKey;
  final String signUpMapMobileNumberKey;
  const IfNewSignupRow({
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
    return Container(
      margin: EdgeInsets.only(top: 14),
      child: Row(
        children: <Widget>[
          Text('New to $theAppName?'),
          FlatButton(
            textColor: Theme.of(context).accentColor,
            child: Text(
              'Sign up',
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignUpPage(
                    signUpLink: signUpLink,
                    theAppName: theAppName,
                    signUpMapMailIDKey: signUpMapMailIDKey,
                    signUpMapPasswordKey: signUpMapPasswordKey,
                    signUpMapFullNameKey: signUpMapFullNameKey,
                    signUpMapMobileNumberKey: signUpMapMobileNumberKey,
                  ),
                ),
              );
            },
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}

/// "Already a member? SignIn" row in signup form.
class IfOldSignIn extends StatelessWidget {
  final String theAppName;
  const IfOldSignIn({Key key, @required this.theAppName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 14),
      child: Row(
        children: <Widget>[
          Text('Already a member of $theAppName?'),
          FlatButton(
            textColor: Theme.of(context).accentColor,
            child: Text(
              'Sign In',
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}

/// Status Message on submitted data as per http response.
class RegAuthStatus extends StatelessWidget {
  final String regAuthStatusMsg;
  final bool isRegAuthSuccess;
  RegAuthStatus({this.regAuthStatusMsg, this.isRegAuthSuccess});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 14),
      child: Text(
        regAuthStatusMsg,
        style: TextStyle(
          fontSize: 14,
          color: isRegAuthSuccess ? Colors.green : Colors.red,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Circular progress indicator at the bottom to indicate progress.
class CircularProgressStatus extends StatelessWidget {
  final bool showCircularProgress;
  CircularProgressStatus({this.showCircularProgress});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: showCircularProgress
          ? CircularProgressIndicator(
              backgroundColor: Colors.orange,
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
            )
          : null,
    );
  }
}
