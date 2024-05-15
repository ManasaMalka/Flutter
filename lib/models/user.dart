
class User {
  int id;
  String fullName;
  String email;
  String phoneNumber;
  String gender;
  String password;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'gender': gender,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      fullName: map['full_name'],
      email: map['email'],
      phoneNumber: map['phone_number'],
      gender: map['gender'],
      password: map['password'],
    );
  }
}
