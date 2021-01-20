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

//AppBar
class RegAuthAppBarTitle extends StatelessWidget {
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

//Email Box
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

//Mobile Number Box
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

//Password Box
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

// Signup Password Box
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

// Confirm Password Box
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

// Full Name Box
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

//Forgot Password Flat Button
class ForgotPwdFlatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        // Navigator.push( //TODO: Forgot PWD
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

// "New to EdenHoe? SignUp" row
class IfNewSignupRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 14),
      child: Row(
        children: <Widget>[
          Text('New to EdenHOE?'),
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
                  builder: (context) => SignUpPage(),
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

//"Already a member? SignIn" row
class IfOldSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 14),
      child: Row(
        children: <Widget>[
          Text('Already a member of EdenHOE?'),
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

// Status Message on submitted data as per http response
class RegAuthStatus extends StatelessWidget {
  final String regAuthStatusMsg;
  final bool isSignUpPageAndSignedUp;
  RegAuthStatus({this.regAuthStatusMsg, this.isSignUpPageAndSignedUp});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 14),
      child: Text(
        regAuthStatusMsg,
        style: TextStyle(
          fontSize: 14,
          color: isSignUpPageAndSignedUp ? Colors.green : Colors.red,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// Circular progress indicator at the bottom
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
