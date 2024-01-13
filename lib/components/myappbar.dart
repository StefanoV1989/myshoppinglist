import 'package:flutter/material.dart';
import 'package:myshoppinglist/globals/theme_globals.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('My Shopping List App'),
      actions: [
        Switch(
          value: themeManager.themeMode == ThemeMode.dark ? true : false,
          onChanged: (value) {
            themeManager.toggleTheme(value);
          },
        )
      ]
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}