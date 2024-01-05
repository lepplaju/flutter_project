import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: 25,
        backgroundColor: Colors.blue[100],
        leading: Icon(Icons.menu),
        title: Text("Quiz Vault"),
        actions: [
          ElevatedButton(
              onPressed: () => print('button was pressed'),
              child: Text('Statistics'))
        ]);
  }
}
