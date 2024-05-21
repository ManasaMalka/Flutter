class User {
  final int id;
  final String fullname;
  final String email;
  final String phonenumber;
  final String gender;
  final String password;

  User({
    required this.id,
    required this.fullname,
    required this.email,
    required this.phonenumber,
    required this.gender,
    required this.password,
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
