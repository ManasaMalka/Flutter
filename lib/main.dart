import 'package:flutter/material.dart';
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: SplashScreen.routeName, 
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        SignupScreen.routeName: (context) => SignupScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        AddUser.routeName: (context) => AddUser(),
        ViewUser.routeName: (context) {
  final int? userId = ModalRoute.of(context)?.settings.arguments as int?;
  return ViewUser(userId: userId ?? 0); // Assuming 0 is a suitable default value
},


       UpdateUser.routeName: (context) {
  final int? userId = ModalRoute.of(context)?.settings.arguments as int?;
  return UpdateUser(userId: userId ?? 0); // Assuming 0 is a suitable default value
},
      },
    );
  }
}
