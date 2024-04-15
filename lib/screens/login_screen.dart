import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/signup_screen.dart'; 

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailPhoneError;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailPhoneController,
              decoration: InputDecoration(
                labelText: 'Email/Phone Number',
                errorText: _emailPhoneError,
              ),
            ),
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
                _validateAndLogin();
              },
              child: Text('Login'),
            ),
            const SizedBox(height: 10), 
            GestureDetector(
              onTap: () {
                
                Navigator.pushNamed(context, SignupScreen.routeName);
              },
              child: Text(
                "Don't have an Account? Sign Up",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _validateAndLogin() {
    setState(() {
      _emailPhoneError = _validateEmailPhone(_emailPhoneController.text);
      _passwordError = _validatePassword(_passwordController.text);
    });

    if (_emailPhoneError == null && _passwordError == null) {
     
      Navigator.pushReplacementNamed(context, '/home');
    } else {
     
      _showAlert('Validation Error', 'Please fix the validation errors.');
    }
  }

  String? _validateEmailPhone(String value) {
    if (value.isEmpty) {
      return 'Please enter your email/phone number';
    } else {
     
      RegExp emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    
      RegExp phonePattern = RegExp(r'^[0-9]{10}$');

      if (!emailPattern.hasMatch(value) && !phonePattern.hasMatch(value)) {
        return 'Please enter a valid email address or phone number';
      }

      return null;
    }
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters';
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
