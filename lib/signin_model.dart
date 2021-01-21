/// Model for the response json we get on logging in.
/// This model is for the following response.
///
/// {
///    "user": {
///         "username": "ji@ji.in",
///         "first_name": "Ji ji",
///         "last_name": "+911234567891"
///     },
///     "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6ImppQGppLmluIn0.zj40LPKLW6YLsNV5HvRETLtE_mCxksZDb7oDyNr6wo4"
/// }
///
/// You might want to alter this as per the response you get.

class LoginModel {
  User user;
  String token;

  LoginModel({this.user, this.token});

  factory LoginModel.fromJson(Map<String, dynamic> jsonData) {
    return LoginModel(
      user:
          jsonData['user'] != null ? new User.fromJson(jsonData['user']) : null,
      token: jsonData['token'],
    );
  }
}

class User {
  /// email
  String mail;

  /// full name
  String fullName;

  /// mobile number
  String mobileNum;

  User({this.mail, this.fullName, this.mobileNum});

  factory User.fromJson(Map<String, dynamic> jsonData) {
    return User(
      mail: jsonData['username'],
      fullName: jsonData['first_name'],
      mobileNum: jsonData['last_name'],
    );
  }
}
