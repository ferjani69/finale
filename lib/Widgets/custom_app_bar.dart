import 'package:flutter/material.dart';

// Assuming this is correctly implemented

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  const CustomAppBar({super.key, this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      leading: IconButton(
        icon: const Icon(Icons.menu),  // Drawer icon
        onPressed: () {
          Scaffold.of(context).openDrawer();  // Open the drawer
        },
      ),
      title: Center(
        child: Image.asset(
          'assets/appbar_logo.png', // Ensure the asset path is correct
          height: 55,  // Adjusted for visibility
        ),
      ),
      elevation: 2.0,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}
