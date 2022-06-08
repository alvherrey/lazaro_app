import 'package:flutter/material.dart';
import 'package:lazaro_app/services/services.dart';
import 'package:provider/provider.dart';

import 'package:lazaro_app/providers/theme_provider.dart';
import 'package:lazaro_app/shared_preferences/preferences.dart';
import 'package:lazaro_app/widgets/widgets.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pushNamed('home'),
          icon: const Icon(Icons.home),
        ),
        title: const Text(
          'Usuario',
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

              Container(
                child: FutureBuilder<String?>(
                  future: authService.readLocalId(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      String data = snapshot.data!;
                      return TextFormField(
                        readOnly: true,
                        initialValue: data,
                        // enableInteractiveSelection:
                        //     false, // will disable paste operation
                        // focusNode: AlwaysDisabledFocusNode(),
                        // obscureText: true,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'User Id',
                          hintText: data,
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              const Divider(),
              TextFormField(
                initialValue: Preferences.name,
                onChanged: (value) {
                  Preferences.name = value;
                  setState(() {});
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre',
                  // helperText: 'Nombre del usuario',
                ),
              ),
              const Divider(),
              RadioListTile<int>(
                title: const Text('Masculino'),
                value: 1,
                groupValue: Preferences.gender,
                onChanged: (value) {
                  Preferences.gender = value ?? 1;
                  setState(() {});
                },
              ),
              const Divider(),
              RadioListTile<int>(
                title: const Text('Femenino'),
                value: 2,
                groupValue: Preferences.gender,
                onChanged: (value) {
                  Preferences.gender = value ?? 2;
                  setState(() {});
                },
              ),
              const Divider(),
              TextFormField(
                initialValue: Preferences.age,
                onChanged: (value) {
                  Preferences.age = value;
                  setState(() {});
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Edad',
                  // helperText: 'Nombre del usuario',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
