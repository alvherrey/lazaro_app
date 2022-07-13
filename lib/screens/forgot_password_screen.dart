import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:lazaro_app/services/notification_service.dart';
import 'package:lazaro_app/ui/input_decorations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Recuperar Contraseña',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const SizedBox(
              // height: 200,
              child: Text(
                'Introduce tu correo electrónico.\n\nTe enviaremos un correo para restaurar la contraseña',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 4),
            TextFormField(
              // initialValue: 'lazaro@gmail.com',
              controller: emailController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'john.doe@example.com',
                  labelText: 'Correo',
                  prefixIcon: Icons.mail_outline),
              onChanged: (value) => {},
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'Introduce un correo electronico';
              },
            ),
            const SizedBox(height: 20),
            // const SizedBox(height: 8),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.blue,
              height: 50,
              onPressed: resetPassword,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.mail_outline,
                    color: Colors.white,
                    size: 32,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Restaurar contraseña',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future resetPassword() async {
    try {
      print(emailController.text);
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      NotificationService.showSnackBar('Correo de recuperacion enviado');
    } on FirebaseAuthException catch (e) {
      print(e);
      NotificationService.showSnackBar(e.message!);
    }
  }
}
