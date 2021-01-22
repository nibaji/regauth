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

For the Title Widget alone:

```dart
RegAuthAppBarTitle(
    regAuthTitle: "Login / Signup",
),
```

For the forms alone:

```dart
SignUpForm(
    signUpLink: "<signup endpoint>",
    theAppName: "<the app / Org name>",
),
```

```dart
SignInForm(
    signInLink: "<signin endpoint>",
    signUpLink: "<signup endpoint>",
    theAppName: "<the app / Org name>",
),
```

For the whole Page:

```dart
SignInPage(
    signInLink: "<signin endpoint>",
    signUpLink: "<signup endpoint>",
    theAppName: "<the app / Org name>",
),
```

```dart
SignUpPage(
    signUpLink: "<signup endpoint>",
    theAppName: "<the app / Org name>",
),
```

## CONTRIBUTORS

- [Nidhun Balaji T R](https://github.com/nibaji/)