import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lazaro_app/providers/theme_provider.dart';
import 'package:lazaro_app/shared_preferences/preferences.dart';
import 'package:lazaro_app/widgets/widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pushNamed('home'),
          icon: const Icon(Icons.home),
        ),
        title: const Text(
          'Ajustes',
          style: TextStyle(fontSize: 24),
        ),
      ),
      // drawer: const SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Text(
              //   'Ajustes',
              //   style: TextStyle(fontSize: 45, fontWeight: FontWeight.w300),
              // ),
              const Divider(),
              SwitchListTile.adaptive(
                title: const Text('Modo oscuro'),
                value: Preferences.isDarkmode,
                onChanged: (value) {
                  Preferences.isDarkmode = value;
                  final themeProvider =
                      Provider.of<ThemeProvider>(context, listen: false);
                  value
                      ? themeProvider.setDarkMode()
                      : themeProvider.setLightMode();
                  setState(() {});
                },
              ),
              const Divider(),
              // RadioListTile<int>(
              //   title: const Text('Masculino'),
              //   value: 1,
              //   groupValue: Preferences.gender,
              //   onChanged: (value) {
              //     Preferences.gender = value ?? 1;
              //     setState(() {});
              //   },
              // ),
              // const Divider(),
              // RadioListTile<int>(
              //   title: const Text('Femenino'),
              //   value: 2,
              //   groupValue: Preferences.gender,
              //   onChanged: (value) {
              //     Preferences.gender = value ?? 2;
              //     setState(() {});
              //   },
              // ),
              // const Divider(),
              // TextFormField(
              //   initialValue: Preferences.name,
              //   onChanged: (value) {
              //     Preferences.name = value;
              //     setState(() {});
              //   },
              //   decoration: const InputDecoration(
              //     labelText: 'Nombre',
              //     helperText: 'Nombre del usuario',
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
