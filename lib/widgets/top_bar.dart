import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: 25,
        backgroundColor: Colors.blue[100],
        leading: IconButton(
            icon: Icon(Icons.home), onPressed: () => context.go('/')),
        title: Text("Quiz Vault"),
        actions: [
          ElevatedButton(
              onPressed: () => context.go('/statistics'),
              child: Text('Statistics'))
        ]);
  }
}
