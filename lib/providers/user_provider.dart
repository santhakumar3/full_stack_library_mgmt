import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'package:logger/logger.dart';

class UserProvider with ChangeNotifier {
  List<User> users = [];
  final Logger logger = Logger();

  // Fetch all users
  Future<void> fetchUsers() async {
    try {
      logger.i("Users_Fetching users from API...");
      users = await ApiService.getUsers();
      logger.i("Users_Fetched users successfully. Total: ${users.length}");
      for (var u in users) {
        logger.i("Users_User: ${u.toJson()}");
      }
      notifyListeners();
    } catch (e) {
      logger.e("Users_Error fetching users: $e");
    }
  }

  // Add a user
  Future<void> addUser(User user) async {
    try {
      logger.i("Users_Adding user: ${user.toJson()}");
      await ApiService.addUser(user);
      logger.i("Users_User added successfully, fetching updated list...");
      await fetchUsers();
    } catch (e) {
      logger.e("Users_Error adding user: $e");
    }
  }

  // Update a user
  Future<void> updateUser(User user) async {
    try {
      logger.i("Users_Updating user: ${user.toJson()}");
      await ApiService.updateUser(user);
      logger.i("Users_User updated successfully, fetching updated list...");
      await fetchUsers();
    } catch (e) {
      logger.e("Users_Error updating user: $e");
    }
  }

  // Delete a user
  Future<void> deleteUser(int id) async {
    try {
      logger.i("Users_Deleting user with id: $id");
      await ApiService.deleteUser(id);
      logger.i("Users_User deleted successfully, fetching updated list...");
      await fetchUsers();
    } catch (e) {
      logger.e("Users_Error deleting user: $e");
    }
  }
}
