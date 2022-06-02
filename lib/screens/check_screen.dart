import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lazaro_app/screens/screens.dart';
import 'package:lazaro_app/services/services.dart';

class CheckScreen extends StatelessWidget {
  const CheckScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // listen a false, no queremos que se redibuje el widget cuando algo cambie en AuthService
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.readToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) return const Text('');
            if (snapshot.data == '') {
              Future.microtask(
                () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const LoginScreen(),
                      transitionDuration: const Duration(seconds: 0),
                    ),
                  );
                  // Navigator.of(context).pushReplacementNamed('login');
                },
              );
            } else {
              Future.microtask(
                () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const HomeScreen(),
                      transitionDuration: const Duration(seconds: 0),
                    ),
                  );
                  // Navigator.of(context).pushReplacementNamed('login');
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
