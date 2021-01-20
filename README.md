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
),
```

```dart
SignInForm(
    signInLink: "<signin endpoint>",
    signUpLink: "<signup endpoint>",
),
```

For the whole Page:

```dart
SignInPage(
    signInLink: "<signin endpoint>",
    signUpLink: "<signup endpoint>",
),
```

```dart
SignUpPage(
    signUpLink: "<signup endpoint>",
),
```

## CONTRIBUTORS

- [Nidhun Balaji T R](https://github.com/nibaji/)