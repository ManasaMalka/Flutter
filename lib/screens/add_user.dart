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
}


