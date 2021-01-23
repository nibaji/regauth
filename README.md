# regauth

<img src="https://shields.io/badge/license-MIT-green">

Login, signup pages & widgets.

## Installing

To use this package:

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  regauth:
    git: https://github.com/nibaji/regauth.git
```

## Usage

For the Signin form alone:

```dart
SignInForm(
    signInLink: "<signin endpoint>",
    signUpLink: "<signup endpoint>",
    theAppName: "<the app / Org name>",
    leadToSignUpPage: false, // leave it blank or make it "true" to have link for SignUp page
    signInMapMailIDKey: "mailId", // Specify the key for the mailid the signin endpoint expects in the map.
    signInMapPasswordKey: "password", // Specify the key for the password the signin endpoint expects in the map.
    
    // leave [signUpMap*Key] parameters untouched, if [leadToSignUpPage] is not set to true.
    signUpMapFullNameKey: "full_name", // Specify the key for the mailid the signup endpoint expects in the map.
    signUpMapMobileNumberKey: "mobile", // Specify the key for the password the signup endpoint expects in the map.
    signUpMapMailIDKey: "mailId", // Specify the key for the user's name the signup endpoint expects in the map.
    signUpMapPasswordKey: "password", // Specify the key for the user's mobile number the signup endpoint expects in the map.
),
```

For the whole Signin Page:

```dart
SignInPage(
    signInLink: "<signin endpoint>",
    signUpLink: "<signup endpoint>",
    theAppName: "<the app / Org name>",
    leadToSignUpPage: false, // leave it blank or make it "true" to have link for SignUp page
    signInMapMailIDKey: "mailId", // Specify the key for the mailid the signin endpoint expects in the map.
    signInMapPasswordKey: "password", // Specify the key for the password the signin endpoint expects in the map.

    // leave [signUpMap*Key] parameters untouched, if [leadToSignUpPage] is not set to true.
    signUpMapFullNameKey: "full_name", // Specify the key for the mailid the signup endpoint expects in the map.
    signUpMapMobileNumberKey: "mobile", // Specify the key for the password the signup endpoint expects in the map.
    signUpMapMailIDKey: "mailId", // Specify the key for the user's name the signup endpoint expects in the map.
    signUpMapPasswordKey: "password", // Specify the key for the user's mobile number the signup endpoint expects in the map.
),
```

Note: 
Signin Page and form shall lead to signup page if 
"leadToSignUpPage" parameter is not set to false.

## CONTRIBUTORS

- [Nidhun Balaji T R](https://github.com/nibaji/)