import 'package:get/get.dart';
import '../../helpers/db_helper3.dart';

class UserController extends GetxController {
  var userData = <Map<String, dynamic>>[].obs;
  var selectedItems = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  void fetchUserData() async {
    var users = await DbHelper3().getUsers();
    userData.assignAll(users);
  }

  void toggleSelection(int id) {
    if (selectedItems.containsKey(id)) {
      selectedItems.remove(id);
    } else {
      selectedItems[id] = true;
    }
  }

  void selectAll() {
    if (selectedItems.length != userData.length) {
      for (var user in userData) {
        selectedItems[user['id']] = true;
      }
    } else {
      selectedItems.clear();
    }
  }

  void deleteUsers() async {
    List<int> selectedIds = selectedItems.keys.toList();
    for (int id in selectedIds) {
      await DbHelper3().deleteUser(id);
    }
    selectedItems.clear();
    fetchUserData();
  }
}
