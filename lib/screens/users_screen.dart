import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late Future<void> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = Provider.of<UserProvider>(context, listen: false).fetchUsers();
    debugPrint("📡 Fetching Users in initState...");
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F4FF),
      body: FutureBuilder(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            debugPrint("❌ Users fetch error: ${snapshot.error}");
            return const Center(
              child: Text(
                'Error fetching users ⚠️',
                style: TextStyle(fontSize: 16, color: Colors.redAccent),
              ),
            );
          }

          if (userProvider.users.isEmpty) {
            debugPrint("⚠️ No users found.");
            return const Center(
              child: Text(
                'No users available 👤',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          debugPrint("✅ Users loaded: ${userProvider.users.length}");

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: userProvider.users.length,
            itemBuilder: (context, index) {
              final user = userProvider.users[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFD9C6FF),
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: Color(0xFF4B0082),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Color(0xFF2D2A4A),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '${user.email} | ${user.phone}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF5F5F6E),
                      ),
                    ),
                  ),
                  trailing: Wrap(
                    spacing: 10,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.indigo),
                        onPressed: () {
                          _showUserDialog(context, userProvider, user: user);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          _confirmDelete(context, userProvider, user.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD9C6FF),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        onPressed: () => _showUserDialog(context, userProvider),
        child: const Icon(Icons.add, color: Color(0xFF4B0082), size: 28),
      ),
    );
  }

  void _confirmDelete(BuildContext context, UserProvider provider, int id) {
    debugPrint("🗑️ Attempting to delete user ID: $id");
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete User'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              provider.deleteUser(id);
              debugPrint("✅ User deleted (ID: $id)");
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showUserDialog(BuildContext context, UserProvider provider, {User? user}) {
    final nameController = TextEditingController(text: user?.name ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');
    final phoneController = TextEditingController(text: user?.phone ?? '');

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFF8F4FF),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user == null ? 'Add New User' : 'Edit User',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B0082),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextField(nameController, 'Name', Icons.person),
                const SizedBox(height: 10),
                _buildTextField(emailController, 'Email', Icons.email),
                const SizedBox(height: 10),
                _buildTextField(phoneController, 'Phone', Icons.phone),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4B0082),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        final newUser = User(
                          id: user?.id ?? 0,
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          phone: phoneController.text.trim(),
                        );

                        if (user == null) {
                          provider.addUser(newUser);
                          debugPrint("🆕 Added new user: ${newUser.name}");
                        } else {
                          provider.updateUser(newUser);
                          debugPrint("✏️ Updated user: ${newUser.name}");
                        }
                        Navigator.pop(context);
                      },
                      child: Text(user == null ? 'Add' : 'Update'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF4B0082)),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
