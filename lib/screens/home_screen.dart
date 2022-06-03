import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lazaro_app/services/services.dart';
import 'package:lazaro_app/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inicio',
          style: TextStyle(fontSize: 24),
        ),
        // leading: IconButton(
        // onPressed: () {
        //   authService.logout();
        //   Navigator.pushReplacementNamed(context, 'login');
        //   print('log out');
        // },
        //   icon: const Icon(Icons.logout),
        // ),
      ),
      drawer: const SideMenu(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            // const SizedBox(height: 40),
            SizedBox(
              height: 200,
              child: Image(image: AssetImage('assets/logo_text.png')),
            ),
            SizedBox(height: 16),
            HomeButton(
              icon: Icons.perm_identity_outlined,
              text: 'User Id',
              goto: 'user_id',
            ),
            SizedBox(height: 8),
            HomeButton(
              icon: Icons.storage_outlined,
              text: 'Storage',
              goto: 'storage',
            ),
            SizedBox(height: 8),
            HomeButton(
              icon: Icons.more_horiz,
              text: 'Plantilla',
              goto: 'plantilla',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final String goto;

  const HomeButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.goto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      icon: Icon(icon, size: 32),
      onPressed: () {
        Navigator.of(context).pushNamed(goto);
      },
      label: Text(
        text,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}
