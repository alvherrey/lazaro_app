import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lazaro_app/providers/providers.dart';
import 'package:lazaro_app/services/services.dart';
import 'package:lazaro_app/ui/input_decorations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const SizedBox(
              height: 200,
              child: Image(image: AssetImage('assets/logo_text.png')),
            ),
            const SizedBox(height: 4),
            ChangeNotifierProvider(
              create: (_) => LoginFormProvider(),
              child: const _LoginForm(),
            ),
            // const SizedBox(height: 8),
            TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, 'register'),
              child: const Text(
                'Crear una nueva cuenta',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Form(
      key: loginForm.formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: 'lazaro@gmail.com',
            autovalidateMode: AutovalidateMode.onUserInteraction,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
                hintText: 'john.doe@example.com',
                labelText: 'Correo',
                prefixIcon: Icons.mail_outline),
            onChanged: (value) => loginForm.mail = value,
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = RegExp(pattern);

              return regExp.hasMatch(value ?? '')
                  ? null
                  : 'Introduce un correo electronico';
            },
          ),
          const SizedBox(
            height: 4,
          ),
          TextFormField(
            initialValue: '123456',
            autovalidateMode: AutovalidateMode.onUserInteraction,
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: '******',
              labelText: 'Contraseña',
              prefixIcon: Icons.lock_outline,
            ),
            onChanged: (value) => loginForm.pass = value,
            validator: (value) {
              if (value != null && value.length >= 6) return null;
              return 'Contraseña de minimo 6 caracteres';
            },
          ),
          const SizedBox(height: 20),
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.blue,
            height: 50,
            onPressed: loginForm.isLoading
                ? null
                : () async {
                    final authService =
                        Provider.of<AuthService>(context, listen: false);
                    FocusScope.of(context).unfocus();
                    if (!loginForm.isValidForm()) return;
                    loginForm.isLoading = true;
                    // await Future.delayed(const Duration(seconds: 2));
                    final String? errorMessage =
                        await authService.login(loginForm.mail, loginForm.pass);
                    if (errorMessage == null) {
                      Navigator.pushReplacementNamed(context, 'home');
                    } else {
                      if (errorMessage == 'EMAIL_NOT_FOUND') {
                        NotificationService.showSnackBar('Email no encontrado');
                      } else if (errorMessage == 'INVALID_PASSWORD') {
                        NotificationService.showSnackBar(
                            'Contraseña incorrecta');
                      }
                      loginForm.isLoading = false;
                    }
                  },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock_open,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  loginForm.isLoading ? 'Espere...' : 'Ingresar',
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
