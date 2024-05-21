import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/db_helper3.dart';

class UpdateUserController extends GetxController {
  final fullName = TextEditingController();
  final phoneNumber = TextEditingController();
  final email = TextEditingController();
  final selectedGender = ''.obs;
  final selectedRole = ''.obs;
  final image = Rx<File?>(null);

  final fullNameError = RxString('');
  final phoneNumberError = RxString('');
  final emailError = RxString('');
  final genderError = RxString('');
  final roleError = RxString('');

  @override
  void onInit() {
    super.onInit();
    // validation listeners
    fullName.addListener(() {
      fullNameError.value = _validateFullName(fullName.text);
    });
    phoneNumber.addListener(() {
      phoneNumberError.value = _validatePhoneNumber(phoneNumber.text);
    });
    email.addListener(() {
      emailError.value = _validateEmail(email.text);
    });
    selectedGender.listen((value) {
      genderError.value = _validateGender(value);
    });
    selectedRole.listen((value) {
      roleError.value = _validateRole(value);
    });
  }

  Future<void> getUserDetails(int userId) async {
    try {
      Map<String, dynamic> userDetails = await DbHelper3().getUserById(userId);
      fullName.text = userDetails['full_name'];
      phoneNumber.text = userDetails['phone_number'];
      email.text = userDetails['email'];
      selectedGender.value = userDetails['gender'];
      selectedRole.value = userDetails['role'];
      String? profilePicPath = userDetails['profile_pic_path'];
      if (profilePicPath != null && profilePicPath.isNotEmpty) {
        image.value = File(profilePicPath);
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  Future<void> updateUserDetails(int userId) async {
   
    fullNameError.value = _validateFullName(fullName.text);
    phoneNumberError.value = _validatePhoneNumber(phoneNumber.text);
    emailError.value = _validateEmail(email.text);
    genderError.value = _validateGender(selectedGender.value);
    roleError.value = _validateRole(selectedRole.value);

    // Check if there are any validation errors
    if (fullNameError.value.isEmpty &&
        phoneNumberError.value.isEmpty &&
        emailError.value.isEmpty &&
        genderError.value.isEmpty &&
        roleError.value.isEmpty) {
      try {
        // Update user details in the database
        String profilePicPath = image.value?.path ?? '';
        await DbHelper3().updateUser(
          userId,
          fullName.text.trim(),
          phoneNumber.text.trim(),
          email.text.trim(),
          selectedGender.value,
          selectedRole.value,
          profilePicPath,
        );
        _showSuccessDialog();
      } catch (e) {
        print('Error updating user details: $e');
        _showAlertDialog('Error', 'Failed to update user details. Please try again.');
      }
    }
  }

  void setImage(File? file) {
    image.value = file;
  }

  // Validation methods
  String _validateFullName(String value) {
    if (value.isEmpty) {
      return 'Please enter your full name.';
    } else if (value.length < 4 || value.length > 50) {
      return 'Full name must be between 4 and 50 characters.';
    }
    return '';
  }

  String _validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return 'Please enter your phone number.';
    } else if (value.length != 10) {
      return 'Phone number must be 10 digits.';
    }
    return '';
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter your email address.';
    } else if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email address.';
    }
    return '';
  }

  String _validateGender(String value) {
    if (value.isEmpty) {
      return 'Please select your gender.';
    }
    return '';
  }

  String _validateRole(String value) {
    if (value.isEmpty) {
      return 'Please select your role.';
    }
    return '';
  }

  void _showSuccessDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Success'),
        content: Text('User details updated successfully.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back();
              Get.back(); // Navigate back to Home screen
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAlertDialog(String title, String message) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
