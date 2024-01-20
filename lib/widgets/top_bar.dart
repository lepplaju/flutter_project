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
        centerTitle: true,
        shape: Border(bottom: BorderSide(color: Colors.brown[300]!, width: 2)),
        backgroundColor: Colors.blue[200],
        leading: IconButton(
            icon: const Icon(Icons.home), onPressed: () => context.go('/')),
        title: const Text("Quiz Vault"),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: ElevatedButton(
                  onPressed: () => context.go('/statistics'),
                  child: const Text('Statistics')))
        ]);
  }
}
