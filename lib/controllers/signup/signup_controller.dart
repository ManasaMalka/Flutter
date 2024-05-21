import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../helpers/db_helper.dart';

class SignupController extends GetxController {
  var fullNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var passwordController = TextEditingController();

  var fullNameError = RxnString(null);
  var emailError = RxnString(null);
  var phoneNumberError = RxnString(null);
  var genderError = RxnString(null);
  var passwordError = RxnString(null);
  var selectedGender = RxnString(null);

Future<void> validateAndSignUp() async {
  fullNameError.value = _validateFullName(fullNameController.text);
  emailError.value = _validateEmail(emailController.text);
  phoneNumberError.value = _validatePhoneNumber(phoneNumberController.text);
  genderError.value = selectedGender.value == null ? 'Please select a gender' : null;
  passwordError.value = _validatePassword(passwordController.text);

  if (fullNameError.value == null &&
      emailError.value == null &&
      phoneNumberError.value == null &&
      genderError.value == null &&
      passwordError.value == null) {

    List<Map<String, dynamic>> existingEmail = await DBHelper().getUserByEmail(emailController.text);
    List<Map<String, dynamic>> existingPhoneNumber = await DBHelper().getUserByPhoneNumber(phoneNumberController.text);

    bool emailExists = existingEmail.isNotEmpty;
    bool phoneNumberExists = existingPhoneNumber.isNotEmpty;

    if (!emailExists && !phoneNumberExists) {
      // Insert the new user into the database
      int userId = await DBHelper().insertUser({
        'full_name': fullNameController.text,
        'email': emailController.text,
        'phone_number': phoneNumberController.text,
        'gender': selectedGender.value, // Corrected: Add .value to access the actual value
        'password': passwordController.text,
      });

      
      Get.offNamed('/home');
    } else {
      // Show error message for existing email or phone number
      String errorMessage = '';
      if (emailExists) {
        errorMessage += 'The email is already in use. Please choose a different email.';
      }
      if (phoneNumberExists) {
        errorMessage += 'The phone number is already in use. Please choose a different phone number.';
      }
      showSnackbar('Sign Up Failed', errorMessage);
    }
  }
}



  void showSnackbar(String title, String message) {
    if (Get.isSnackbarOpen != null) {
      Get.back(); // Close any existing snackbar
    }
    Get.snackbar(title, message);
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
