import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Text(
              'Food Ordering App',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          ListTile(
            title: const Text('Order Plan'),
            onTap: () => Navigator.pushReplacementNamed(context, '/plan'),
          ),
          ListTile(
            title: const Text('Query Plan'),
            onTap: () => Navigator.pushReplacementNamed(context, '/query'),
          ),
          ListTile(
            title: const Text('Manage Foods'),
            onTap: () => Navigator.pushReplacementNamed(context, '/manage'),
          ),
          ListTile(
            title: const Text('Food List'),
            onTap: () => Navigator.pushReplacementNamed(context, '/foods'),
          ),
        ],
      ),
    );
  }
}
