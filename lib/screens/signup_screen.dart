import 'package:flutter/material.dart';
import '../models/user.dart';
import '../helpers/database_helper.dart'; // Import DatabaseHelper

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup';

  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _fullNameError;
  String? _emailError;
  String? _phoneNumberError;
  String? _genderError;
  String? _passwordError;

  String? _selectedGender;

  bool _isDatabaseInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize the database
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    try {
      // await DatabaseHelper.instance.initDatabase();
      setState(() {
        _isDatabaseInitialized = true;
      });
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: !_isDatabaseInitialized
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        errorText: _fullNameError,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        errorText: _emailError,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        errorText: _phoneNumberError,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text('Gender: '),
                        Radio<String>(
                          value: 'Male',
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                              _genderError = null;
                            });
                          },
                        ),
                        Text('Male'),
                        Radio<String>(
                          value: 'Female',
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                              _genderError = null;
                            });
                          },
                        ),
                        Text('Female'),
                      ],
                    ),
                    _genderError != null ? Text(_genderError!, style: TextStyle(color: Colors.red)) : SizedBox(),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        errorText: _passwordError,
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _validateAndSignUp();
                      },
                      child: Text('Sign Up'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _validateAndSignUp() async {
    setState(() {
      _fullNameError = _validateFullName(_fullNameController.text);
      _emailError = _validateEmail(_emailController.text);
      _phoneNumberError = _validatePhoneNumber(_phoneNumberController.text);
      if (_selectedGender == null) {
        _genderError = 'Please select a gender';
      } else {
        _genderError = null;
      }
      _passwordError = _validatePassword(_passwordController.text);
    });

    if (_fullNameError == null &&
        _emailError == null &&
        _phoneNumberError == null &&
        _genderError == null &&
        _passwordError == null) {
      // Query the database to check if the email or phone number already exists
      DatabaseHelper databaseHelper = DatabaseHelper.instance;
      User? existingUserEmail = await databaseHelper.getUserByEmail(_emailController.text);
      User? existingUserPhone = await databaseHelper.getUserByPhone(_phoneNumberController.text);

      if (existingUserEmail != null || existingUserPhone != null) {
        // If user already exists, display an error message
        _showAlert('Sign Up Error', 'Email or phone number already exists. Please use a different email or phone number.');
      } else {
        // Create a User object with the entered data
        User user = User(
          id: 0,
          fullName: _fullNameController.text,
          email: _emailController.text,
          phoneNumber: _phoneNumberController.text,
          gender: _selectedGender!,
          password: _passwordController.text,
        );

        // Insert the user into the database
        await databaseHelper.insertUser(user);

        print('User signed up successfully!');
        // Navigate to the home screen
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  String? _validateFullName(String value) {
    if (value.isEmpty) {
      return 'Please enter your full name';
    } else if (value.length < 4 || value.length > 50) {
      return 'Full Name must be between 4 and 50 characters';
    } else {
      return null;
    }
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    } else {
      return null;
    }
  }

  String? _validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return 'Please enter your phone number';
    } else if (value.length != 10) {
      return 'Phone number must be 10 digits';
    } else {
      return null;
    }
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 8 || value.length > 50) {
      return 'Password must be between 8 and 50 characters';
    } else if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    } else if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    } else if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one digit';
    } else if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    } else {
      return null;
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
