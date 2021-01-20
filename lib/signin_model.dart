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
  String username; //email
  String firstName; // full name
  String lastName; //mbl

  User({this.username, this.firstName, this.lastName});

  factory User.fromJson(Map<String, dynamic> jsonData) {
    return User(
      username: jsonData['username'],
      firstName: jsonData['first_name'],
      lastName: jsonData['last_name'],
    );
  }
}
