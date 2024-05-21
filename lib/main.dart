import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import Get package
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/signup_screen.dart';
import 'package:flutter_application_1/screens/splash_screen.dart';
import 'package:flutter_application_1/screens/view_user.dart';
import 'package:flutter_application_1/screens/update_user.dart';
import 'package:flutter_application_1/screens/add_user.dart';
import 'package:flutter_application_1/helpers/db_helper.dart';
import 'package:flutter_application_1/helpers/db_helper3.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper().database;
  await DbHelper3().database; // Ensure database is initialized before running the app

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // Use GetMaterialApp instead of MaterialApp
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: SplashScreen.routeName, 
      getPages: [ // Define routes using GetX GetPages
        GetPage(name: SplashScreen.routeName, page: () => const SplashScreen()),
        GetPage(name: LoginScreen.routeName, page: () => LoginScreen()),
        GetPage(name: SignupScreen.routeName, page: () => SignupScreen()),
        GetPage(name: HomeScreen.routeName, page: () => HomeScreen()),
        GetPage(name: AddUser.routeName, page: () => AddUser()),
        GetPage(name: ViewUser.routeName, page: () {
          final int? userId = Get.arguments as int?;
          return ViewUser(userId: userId ?? 0);
        }),
        GetPage(name: UpdateUser.routeName, page: () {
          final int? userId = Get.arguments as int?;
          return UpdateUser(userId: userId ?? 0);
        }),
      ],
    );
  }
}
