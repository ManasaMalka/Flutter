import 'dart:io';
import 'package:flutter/material.dart';
import '../helpers/db_helper3.dart';

class ViewUser extends StatefulWidget {
  static const String routeName = '/viewuser';
  final int userId; // Declare userId as a class variable

  const ViewUser({Key? key, required this.userId}) : super(key: key);

  @override
  _ViewUserState createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  late Future<Map<String, dynamic>> _userDetailsFuture;

  @override
  void initState() {
    super.initState();
    _userDetailsFuture = _getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  if (user['profile_pic_path'] != null)
                    Center(
                      child: ClipOval(
                        child: Image.file(
                          File(user['profile_pic_path']),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  SizedBox(height: 20),
                  Text('Full Name: ${user['full_name']}'),
                  SizedBox(height: 10),
                  Text('Email: ${user['email']}'),
                  SizedBox(height: 10),
                  Text('Phone Number: ${user['phone_number']}'),
                  SizedBox(height: 10),
                  Text('Gender: ${user['gender']}'),
                  SizedBox(height: 10),
                  Text('Role: ${user['role']}'),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _getUserDetails() async {
    try {
      final dbHelper = DbHelper3();
      final user = await dbHelper.getUserById(widget.userId);
      return user;
    } catch (e) {
      throw Exception('Failed to fetch user details: $e');
    }
  }
}
