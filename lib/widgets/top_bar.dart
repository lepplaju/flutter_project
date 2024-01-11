import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// A class to be used as the basic AppBar for most of the pages
class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: 25,
        backgroundColor: Colors.blue[100],
        leading: IconButton(
            icon: const Icon(Icons.home), onPressed: () => context.go('/')),
        title: const Text("Quiz Vault"),
        actions: [
          ElevatedButton(
              onPressed: () => context.go('/statistics'),
              child: const Text('Statistics'))
        ]);
  }
}
