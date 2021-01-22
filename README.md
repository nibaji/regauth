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
    leadToSignUpPage: false, //leave it blank or make it "true" to have link for SignUp page
    signInMapMailIDKey: "mailId",
    signInMapPasswordKey: "password",
),
```

For the whole Signin Page:

```dart
SignInPage(
    signInLink: "<signin endpoint>",
    signUpLink: "<signup endpoint>",
    theAppName: "<the app / Org name>",
    leadToSignUpPage: false, //leave it blank or make it "true" to have link for SignUp page
    signInMapMailIDKey: "mailId",
    signInMapPasswordKey: "password",
),
```

Note: 
Signin Page and form shall lead to signup page if 
"leadToSignUpPage" parameter is not set to false.

## CONTRIBUTORS

- [Nidhun Balaji T R](https://github.com/nibaji/)