import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SingleChildScrollView(
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
    // Check if the email or phone number already exists
    List<Map<String, dynamic>> existingEmail = await DBHelper().getUserByEmail(_emailController.text);
    List<Map<String, dynamic>> existingPhoneNumber = await DBHelper().getUserByPhoneNumber(_phoneNumberController.text);

    bool emailExists = existingEmail.isNotEmpty;
    bool phoneNumberExists = existingPhoneNumber.isNotEmpty;

    if (!emailExists && !phoneNumberExists) {
      // Insert the new user into the database
      int userId = await DBHelper().insertUser({
        'full_name': _fullNameController.text,
        'email': _emailController.text,
        'phone_number': _phoneNumberController.text,
        'gender': _selectedGender,
        'password': _passwordController.text,
      });

    
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Show error message for existing email
      if (emailExists) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sign Up Failed'),
              content: Text('The email is already in use. Please choose a different email.'),
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

      // Show error message for existing phone number
      if (phoneNumberExists) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sign Up Failed'),
              content: Text('The phone number is already in use. Please choose a different phone number.'),
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
}
