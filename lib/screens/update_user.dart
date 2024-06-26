import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/update_user/update_user_controller.dart';

class UpdateUser extends StatefulWidget {
  static const String routeName = '/update_user';
  final int userId;

  const UpdateUser({Key? key, required this.userId}) : super(key: key);

  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  late UpdateUserController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(UpdateUserController());
    controller.getUserDetails(widget.userId); // Fetch user details here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Obx(
            () => Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () => _getImage(controller),
                    child: Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: controller.image.value != null
                            ? FileImage(controller.image.value!)
                            : null,
                        child: controller.image.value == null
                            ? Icon(Icons.camera_alt, size: 40)
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: controller.fullName,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                      errorText: controller.fullNameError.value,
                    
                      errorBorder: UnderlineInputBorder(
                        borderSide:BorderSide(color: Theme.of(context).primaryColor), // Customize error border color
                      ),
                       focusedErrorBorder: UnderlineInputBorder(
                        borderSide:BorderSide(color: Theme.of(context).primaryColor), // Customize focused error border color
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: controller.phoneNumber,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                      errorText: controller.phoneNumberError.value,
                      
                      errorBorder: UnderlineInputBorder(
                         borderSide:BorderSide(color: Theme.of(context).primaryColor), // Customize error border color
                      ), focusedErrorBorder: UnderlineInputBorder(
                        borderSide:BorderSide(color: Theme.of(context).primaryColor), // Customize focused error border color
                      ),

                    ),
                  ),
                  TextFormField(
                    controller: controller.email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                      errorText: controller.emailError.value,
                     
                      errorBorder: UnderlineInputBorder(
                        borderSide:BorderSide(color: Theme.of(context).primaryColor), // Customize error border color
                      ),
                       focusedErrorBorder: UnderlineInputBorder(
                        borderSide:BorderSide(color: Theme.of(context).primaryColor), // Customize focused error border color
                      ),
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    value: controller.selectedGender.value.isNotEmpty
                        ? controller.selectedGender.value
                        : null,
                    items: ['Male', 'Female', 'Other']
                        .map((gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            ))
                        .toList(),
                    onChanged: (value) {
                      controller.selectedGender.value = value!;
                    },
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                      errorText: controller.genderError.value,
                      errorBorder: UnderlineInputBorder(
                       borderSide:BorderSide(color: Theme.of(context).primaryColor), // Customize error border color
                      ),
                       focusedErrorBorder: UnderlineInputBorder(
                        borderSide:BorderSide(color: Theme.of(context).primaryColor), // Customize focused error border color
                      ),
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    value: controller.selectedRole.value.isNotEmpty
                        ? controller.selectedRole.value
                        : null,
                    items: ['Employee', 'Employer']
                        .map((role) => DropdownMenuItem(
                              value: role,
                              child: Text(role),
                            ))
                        .toList(),
                    onChanged: (value) {
                      controller.selectedRole.value = value!;
                    },
                    decoration: InputDecoration(
                      labelText: 'Role',
                      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                      errorText: controller.roleError.value,
                      errorBorder: UnderlineInputBorder(
                         borderSide:BorderSide(color: Theme.of(context).primaryColor),  // Customize error border color
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide:BorderSide(color: Theme.of(context).primaryColor), // Customize focused error border color
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => controller.updateUserDetails(widget.userId),
                    child: Text('Update'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getImage(UpdateUserController controller) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      controller.setImage(imageFile);
    } else {
      print('No image selected.');
    }
  }
}
