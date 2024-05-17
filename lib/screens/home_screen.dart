import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this import for SystemNavigator
import '../helpers/db_helper3.dart'; // Assuming this is where the helper class is defined
import 'package:flutter_application_1/screens/view_user.dart';
import 'package:flutter_application_1/screens/update_user.dart';
import 'package:flutter_application_1/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> _userDataFuture;
  late List<Map<String, dynamic>> _userData;
  Map<int, bool> _selectedItems = {}; // Map to store selected items by ID

  @override
  void initState() {
    super.initState();
    _userDataFuture = _getUserData();
  }

  Future<List<Map<String, dynamic>>> _getUserData() async {
    return DbHelper3().getUsers(); // Assuming getUsers() method fetches user data
  }

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
            onPressed: () {
              setState(() {
                _selectedItems.clear(); // Clear selected items
              });
            },
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
                  // Handle logout action
                  break;
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            _userData = snapshot.data!;
            return ListView.builder(
              itemCount: _userData.length,
              itemBuilder: (context, index) {
                final user = _userData[index];
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
                    setState(() {
                      if (_selectedItems.containsKey(user['id'])) {
                        _selectedItems.remove(user['id']);
                      } else {
                        _selectedItems[user['id']] = true;
                      }
                    });
                  },
                  trailing: _selectedItems.containsKey(user['id']) ? Icon(Icons.check_box) : null,
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Assuming AddUser route is defined and accessible
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
    if (_selectedItems.length == 1) {
      int selectedItemId = _selectedItems.keys.first;
      Navigator.pushNamed(context, ViewUser.routeName, arguments: selectedItemId);
    } else if (_selectedItems.isEmpty) {
      showDialog(
        context: context,
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
        context: context,
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
    if (_selectedItems.length == 1) {
      int selectedItemId = _selectedItems.keys.first;
      await Navigator.pushNamed(context, UpdateUser.routeName, arguments: selectedItemId);
      // Refresh data when returning from the update screen
      _refreshUserData();
    } else if (_selectedItems.isEmpty) {
      showDialog(
        context: context,
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
        context: context,
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

  void _refreshUserData() {
    setState(() {
      _userDataFuture = _getUserData();
    });
  }
 
  void _deleteSelectedItems() {
    showDialog(
      context: context,
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
              // Implement delete functionality for selected items
              _deleteUsers();
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteUsers() async {
    List<int> selectedIds = _selectedItems.keys.toList();
    for (int id in selectedIds) {
      await DbHelper3().deleteUser(id);
    }
    setState(() {
      _selectedItems.clear(); // Clear selected items
      _userDataFuture = _getUserData(); // Refresh user data
    });
  }

}