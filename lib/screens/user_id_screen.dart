import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lazaro_app/services/services.dart';

class UserIdScreen extends StatelessWidget {
  const UserIdScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Lázaro'),
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
