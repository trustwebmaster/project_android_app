
//login form 

class Account {
  String id;
  String username;
  String password;
  String name;
  String surname;
  String phoneNumber;

  Account(
      {this.id,
      this.username,
      this.password,
      this.name,
      this.surname,
      this.phoneNumber});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
        id: json['id'] as String,
        username: json['username'] as String,
        password: json['password'] as String,
        name: json['name'] as String,
        surname: json['surname'] as String,
        phoneNumber: json['phonenumber'] as String);
  }
}
