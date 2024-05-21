import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/add_user/add_user_controller.dart';

class AddUser extends StatelessWidget {
  static const String routeName = '/adduser';

  final AddUserController controller = Get.put(AddUserController());

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
<<<<<<< HEAD
              // Profile Picture Selection
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _getImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: controller.profilePicPath.value.isNotEmpty
                            ? FileImage(File(controller.profilePicPath.value))
                            : AssetImage('assets/default_profile_pic.jpg') as ImageProvider,
                        child: Icon(Icons.camera_alt, size: 40),
                      ),
=======
              
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
>>>>>>> ef0b4eec6deb19cbdca08f79679ffb87e68824f4
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Full Name:',
                style: TextStyle(fontSize: 16),
              ),
              Obx(() =>TextFormField(
                controller: controller.fullNameController,
                decoration: InputDecoration(
                  hintText: 'Enter full name',
                   errorBorder: UnderlineInputBorder(
                        borderSide:BorderSide(color: Theme.of(context).primaryColor), // Customize error border color
                      ),
                       focusedErrorBorder: UnderlineInputBorder(
                        borderSide:BorderSide(color: Theme.of(context).primaryColor), // Customize focused error border color
                      ),
  
  

                  errorText: controller.fullNameError.value,
                ),
              ),),
             SizedBox(height: 10),
              Text(
                'Email:',
                style: TextStyle(fontSize: 16),
              ),
               Obx(() =>  TextFormField(
                controller: controller.emailController,
                decoration: InputDecoration(
                  hintText: 'Enter email',
                               errorBorder: UnderlineInputBorder(
                        borderSide:BorderSide(color: Theme.of(context).primaryColor), // Customize error border color
                      ),
                       focusedErrorBorder: UnderlineInputBorder(
                        borderSide:BorderSide(color: Theme.of(context).primaryColor), // Customize focused error border color
                      ),
                  errorText: controller.emailError.value,
                ),
              ),),
               SizedBox(height: 10),
              Text(
                'Phone Number:',
                style: TextStyle(fontSize: 16),
              ),
              Obx(() =>TextFormField(
                controller: controller.phoneNumberController,
                decoration: InputDecoration(
                  hintText: 'Enter phone number',
                               errorBorder: UnderlineInputBorder(
                        borderSide:BorderSide(color: Theme.of(context).primaryColor), // Customize error border color
                      ),
                       focusedErrorBorder: UnderlineInputBorder(
                        borderSide:BorderSide(color: Theme.of(context).primaryColor), // Customize focused error border color
                      ),
                  errorText: controller.phoneNumberError.value,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
              ),),
              const SizedBox(height: 10),
              Text(
                'Gender:',
                style: TextStyle(fontSize: 16),
              ),
              Obx(() => Row(
                    children: [
                      Radio<String>(
                        value: 'Male',
                        groupValue: controller.gender.value,
                        onChanged: (value) {
                          controller.gender.value = value!;
                        },
                      ),
                      Text('Male'),
                      Radio<String>(
                        value: 'Female',
                        groupValue: controller.gender.value,
                        onChanged: (value) {
                          controller.gender.value = value!;
                        },
                      ),
                      Text('Female'),
                      
                    ],

                  )),
              const SizedBox(height: 10),
              Text(
                'Select Role:',
                style: TextStyle(fontSize: 16),
              ),
              Obx(() => DropdownButton<String>(
                    value: controller.role.value.isEmpty ? null : controller.role.value,
                    hint: Text('Select role'),
                    onChanged: (value) {
                      controller.role.value = value!;
                    },
                    items: controller.roles.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    controller.validateAndAddUser();
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
      controller.setImagePath(pickedFile.path);
    }
  }
<<<<<<< HEAD
=======

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
>>>>>>> ef0b4eec6deb19cbdca08f79679ffb87e68824f4
}


