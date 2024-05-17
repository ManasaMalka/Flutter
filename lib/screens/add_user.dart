import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:image_picker/image_picker.dart';
import '../helpers/db_helper3.dart';

class AddUser extends StatefulWidget {
  static const String routeName = '/adduser';
  const AddUser({Key? key}) : super(key: key);

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  String? _gender;
  String? _role;
  String? _fullNameError;
  String? _emailError;
  String? _phoneNumberError;
  String? _genderError;
  String? _roleError;
  String? _profilePicPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _getImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: _profilePicPath != null
                          ? FileImage(File(_profilePicPath!))
                          : AssetImage('assets/default_profile_pic.jpg') as ImageProvider,
                      child: Icon(Icons.camera_alt, size: 40),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Full Name:',
                style: TextStyle(fontSize: 16),
              ),
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  hintText: 'Enter full name',
                  errorText: _fullNameError,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Email:',
                style: TextStyle(fontSize: 16),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Enter email',
                  errorText: _emailError,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Phone Number:',
                style: TextStyle(fontSize: 16),
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  hintText: 'Enter phone number',
                  errorText: _phoneNumberError,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Gender:',
                style: TextStyle(fontSize: 16),
              ),
              Row(
                children: [
                  Radio<String>(
                    value: 'Male',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                  Text('Male'),
                  Radio<String>(
                    value: 'Female',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                  Text('Female'),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Select Role:',
                style: TextStyle(fontSize: 16),
              ),
              DropdownButton<String>(
                value: _role,
                hint: Text('Select role'),
                onChanged: (value) {
                  setState(() {
                    _role = value;
                  });
                },
                items: ['Employee', 'Employer'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _validateAndAddUser();
                  },
                  child: Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profilePicPath = pickedFile.path;
      });
    }
  }

  void _validateAndAddUser() async {
    setState(() {
      _fullNameError = _validateFullName(_fullNameController.text);
      _emailError = _validateEmail(_emailController.text);
      _phoneNumberError = _validatePhoneNumber(_phoneNumberController.text);
      _genderError = _validateGender(_gender);
      _roleError = _validateRole(_role);
    });

    if (_fullNameError == null &&
        _emailError == null &&
        _phoneNumberError == null &&
        _genderError == null &&
        _roleError == null) {
      // All validations passed, add user to database
      try {
        int userId = await DbHelper3().insertUser({
          'full_name': _fullNameController.text,
          'email': _emailController.text,
          'phone_number': _phoneNumberController.text,
          'gender': _gender!,
          'role': _role!,
          'profile_pic_path': _profilePicPath,
        });
        print('User inserted successfully with ID: $userId');
        Navigator.pushNamed(context, HomeScreen.routeName); // Navigate to the HomeScreen
      } catch (e) {
        print('Error inserting user: $e');
      }
    }
  }

  String? _validateFullName(String value) {
    if (value.isEmpty) {
      return 'Please enter full name';
    } else if (value.length < 4 || value.length > 50) {
      return 'Full name must be between 4 and 50 characters';
    }
    return null;
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter email';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return 'Please enter phone number';
    } else if (value.length != 10) {
      return 'Phone number must be 10 digits';
    }
    return null;
  }

  String? _validateGender(String? value) {
    if (value == null) {
      return 'Please select gender';
    }
    return null;
  }

  String? _validateRole(String? value) {
    if (value == null) {
      return 'Please select role';
    }
    return null;
  }
}

