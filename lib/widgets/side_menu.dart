import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lazaro_app/services/services.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const _DrawerHeader(),
          ListTile(
            leading: const Icon(
              Icons.home,
              size: 32,
            ),
            title: const Text(
              'Inicio',
              style: TextStyle(fontSize: 24),
            ),
            onTap: () {
              Navigator.pushNamed(context, 'home');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.people,
              size: 32,
            ),
            title: const Text(
              'Usuario',
              style: TextStyle(fontSize: 24),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'user');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              size: 32,
            ),
            title: const Text(
              'Ajustes',
              style: TextStyle(fontSize: 24),
            ),
            onTap: () {
              // Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'settings');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              size: 32,
            ),
            title: const Text(
              'Cerrar Sesión',
              style: TextStyle(fontSize: 24),
            ),
            onTap: () {
              authService.logout();
              Navigator.pushReplacementNamed(context, 'login');
              print('log out');
            },
          ),
        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/banner_3.png'), fit: BoxFit.cover),
      ),
      child: Container(),
    );
  }
}
