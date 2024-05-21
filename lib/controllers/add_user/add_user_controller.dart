import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/db_helper3.dart';
import 'package:flutter_application_1/screens/home_screen.dart';

class AddUserController extends GetxController {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final RxString gender = ''.obs;
  final RxString role = ''.obs;

  final RxString profilePicPath = ''.obs;

  RxString fullNameError = ''.obs;
  RxString emailError = ''.obs;
  RxString phoneNumberError = ''.obs;
  RxString genderError = ''.obs;
  RxString roleError = ''.obs;

 
  final List<String> roles = ['Employee', 'Employer'];

  void setImagePath(String path) {
    profilePicPath.value = path;
  }

  Future<void> validateAndAddUser() async {
    fullNameError.value = _validateFullName(fullNameController.text) ?? '';
    emailError.value = _validateEmail(emailController.text) ?? '';
    phoneNumberError.value = _validatePhoneNumber(phoneNumberController.text) ?? '';
    genderError.value = _validateGender(gender.value) ?? '';
    roleError.value = _validateRole(role.value) ?? '';

    if (fullNameError.value.isEmpty &&
        emailError.value.isEmpty &&
        phoneNumberError.value.isEmpty &&
        genderError.value.isEmpty &&
        roleError.value.isEmpty) {
      // All validations passed, add user to database
      try {
        int userId = await DbHelper3().insertUser({
          'full_name': fullNameController.text,
          'email': emailController.text,
          'phone_number': phoneNumberController.text,
          'gender': gender.value,
          'role': role.value,
          'profile_pic_path': profilePicPath.value,
        });
        print('User inserted successfully with ID: $userId');
        Get.offAllNamed(HomeScreen.routeName); // Navigate to the HomeScreen
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

  String? _validateGender(String value) {
    if (value.isEmpty) {
      return 'Please select gender';
    }
    return null;
  }

  String? _validateRole(String value) {
    if (value.isEmpty) {
      return 'Please select role';
    }
    return null;
  }
}
