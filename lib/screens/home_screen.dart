import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this import for SystemNavigator
import 'package:get/get.dart';
import '../controllers/user/user_controller.dart'; // Assuming this is where the controller is defined
import 'view_user.dart';
import 'update_user.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _showExitConfirmationDialog(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: userController.selectAll,
            ),
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    child: Text('View'),
                    value: 'view',
                  ),
                  PopupMenuItem(
                    child: Text('Update'),
                    value: 'update',
                  ),
                  PopupMenuItem(
                    child: Text('Delete'),
                    value: 'delete',
                  ),
                  PopupMenuItem(
                    child: Text('Logout'),
                    value: 'logout',
                  ),
                ];
              },
              onSelected: (value) {
                switch (value) {
                  case 'view':
                    _viewSelectedItems();
                    break;
                  case 'update':
                    _updateSelectedItems();
                    break;
                  case 'delete':
                    _deleteSelectedItems();
                    break;
                  case 'logout':
                    Navigator.pushNamed(context, LoginScreen.routeName);
                    break;
                }
              },
            ),
          ],
        ),
        body: Obx(() {
          if (userController.userData.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: userController.userData.length,
              itemBuilder: (context, index) {
                final user = userController.userData[index];
                ImageProvider<Object>? profileImage;
                if (user['profile_pic_path'] != null && user['profile_pic_path'] is String) {
                  profileImage = FileImage(File(user['profile_pic_path'] as String));
                } else {
                  profileImage = AssetImage('assets/images/no_profile_pic.png');
                }
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: profileImage,
                  ),
                  title: Text(user['full_name'] ?? ''),
                  subtitle: Text('${user['phone_number']} - ${user['role']}'),
                  onTap: () {
                    // Handle tap on each user
                  },
                  onLongPress: () {
                    userController.toggleSelection(user['id']);
                  },
                  trailing: Obx(
  () {
    return userController.selectedItems.containsKey(user['id']) 
      ? Icon(Icons.check_box) 
      : SizedBox(); 
  },
),

                );
              },
            );
          }
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/adduser');
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }

  Future<void> _showExitConfirmationDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App?'),
        content: Text('Are you sure you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              SystemNavigator.pop(); // Close the entire app
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _viewSelectedItems() {
    var userController = Get.find<UserController>();
    if (userController.selectedItems.length == 1) {
      int selectedItemId = userController.selectedItems.keys.first;
      Navigator.pushNamed(Get.context!, ViewUser.routeName, arguments: selectedItemId);
    } else if (userController.selectedItems.isEmpty) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please select an item to view.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('You can only view one item at a time.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _updateSelectedItems() async {
    var userController = Get.find<UserController>();
    if (userController.selectedItems.length == 1) {
      int selectedItemId = userController.selectedItems.keys.first;
      await Navigator.pushNamed(Get.context!, UpdateUser.routeName, arguments: selectedItemId);
      userController.fetchUserData();
    } else if (userController.selectedItems.isEmpty) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please select an item to update.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('You can only update one item at a time.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _deleteSelectedItems() {
    var userController = Get.find<UserController>();
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete selected items?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              userController.deleteUsers();
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
