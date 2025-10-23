import 'package:flutter/material.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class UserTile extends StatelessWidget {
  final User user;
  final UserProvider provider;

  UserTile({required this.user, required this.provider});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text('${user.email} | ${user.phone}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: Icon(Icons.edit), onPressed: () {
            provider.updateUser(user); // edit handled in dialog
          }),
          IconButton(icon: Icon(Icons.delete), onPressed: () => provider.deleteUser(user.id)),
        ],
      ),
    );
  }
}
