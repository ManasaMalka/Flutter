import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../models/user.dart';
import '../helpers/database_helper.dart';
import 'signup_screen.dart'; // Import the SignUpScreen if not already imported

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

 void _validateAndLogin() async {
  // Query the database to check if the user exists
 DatabaseHelper databaseHelper = DatabaseHelper.instance; 
    String loginInput = _emailPhoneController.text;
  User? user;

  // Check if it's a valid email
  if (RegExp(r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.[a-zA-Z]{2,}$').hasMatch(loginInput)) {
    user = await databaseHelper.getUserByEmail(loginInput);
  } else {
    user = await databaseHelper.getUserByPhone(loginInput);
  }

  if (user != null) {
    // User found, check password
    if (user.password == _passwordController.text) {
      // Password correct, navigate to home screen
      Navigator.pushNamed(context, HomeScreen.routeName);
    } else {
      // Incorrect password
      _showAlert('Login Error', 'Incorrect password.');
    }
  } else {
    // User not found
    _showAlert('Login Error', 'User not found. Please sign up.');
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
              if (title == 'Login Error' && message == 'Incorrect password.') {
                // Clear the password field if login error is due to incorrect password
                _passwordController.clear();
              }
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

}
