class User {
  int id;
  String fullname;
  String email;
  String phonenumber;
  String gender;
  String password;

  User({
    this.id,
    this.fullname,
    this.email,
    this.phonenumber,
    this.gender,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullname': fullname,
      'email': email,
      'phonenumber': phonenumber,
      'gender': gender,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      fullname: map['fullname'],
      email: map['email'],
      phonenumber: map['phonenumber'],
      gender: map['gender'],
      password: map['password'],
    );
  }
}
