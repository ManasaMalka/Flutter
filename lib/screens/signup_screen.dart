import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/signup/signup_controller.dart';

class SignupScreen extends StatelessWidget {
  static const String routeName = '/signup';

  final SignupController controller = Get.put(SignupController());

  SignupScreen({Key? key}) : super(key: key);

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
              Obx(() => TextFormField(
                controller: controller.fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  errorText: controller.fullNameError.value,
                ),
              )),
              const SizedBox(height: 10),
              Obx(() => TextFormField(
                controller: controller.emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: controller.emailError.value,
                ),
              )),
              const SizedBox(height: 10),
              Obx(() => TextFormField(
                controller: controller.phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  errorText: controller.phoneNumberError.value,
                ),
                keyboardType: TextInputType.number,
              )),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text('Gender: '),
                  Obx(() => Radio<String>(
                    value: 'Male',
                    groupValue: controller.selectedGender.value,
                    onChanged: (value) {
                      controller.selectedGender.value = value;
                      controller.genderError.value = null;
                    },
                  )),
                  Text('Male'),
                  Obx(() => Radio<String>(
                    value: 'Female',
                    groupValue: controller.selectedGender.value,
                    onChanged: (value) {
                      controller.selectedGender.value = value;
                      controller.genderError.value = null;
                    },
                  )),
                  Text('Female'),
                ],
              ),
              Obx(() => controller.genderError.value != null
                  ? Text(controller.genderError.value!,
                      style: TextStyle(color: Colors.red))
                  : SizedBox()),
              const SizedBox(height: 10),
              Obx(() => TextFormField(
                controller: controller.passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: controller.passwordError.value,
                ),
                obscureText: true,
              )),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  controller.validateAndSignUp();
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
