import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lazaro_app/services/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lázaro'),
        leading: IconButton(
          onPressed: () {
            authService.logout();
            Navigator.pushReplacementNamed(context, 'auth');
          },
          icon: const Icon(Icons.logout),
        ),
      ),
      body: Center(
        child: FutureBuilder<String?>(
          future: authService.readLocalId(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String data = snapshot.data!;
              return Text(data);
            } else {
              return const Text('waiting');
            }
          },
        ),
      ),
    );
  }
}
