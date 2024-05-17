class Userdb {
  final int id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String gender;
  final String role;
  final String profilePicPath;

  Userdb({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.role,
    required this.profilePicPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'gender': gender,
      'role': role,
      'profile_pic_path': profilePicPath,
    };
  }

  factory Userdb.fromMap(Map<String, dynamic> map) {
    return Userdb(
      id: map['id'],
      fullName: map['full_name'],
      email: map['email'],
      phoneNumber: map['phone_number'],
      gender: map['gender'],
      role: map['role'],
      profilePicPath: map['profile_pic_path'],
    );
  }
}
