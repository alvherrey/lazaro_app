import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:lazaro_app/services/services.dart';
import 'package:lazaro_app/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void displayHelp(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 5,
          title: const Text(
            'Ayuda',
            style: TextStyle(fontSize: 36),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Bienvenido al asistente de visión Lázaro.\n\nSelecciona alguna de sus funciones.',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 36,
              ),
              SizedBox(
                width: 100,
                child: Image(
                  image: AssetImage('assets/logo.png'),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Aceptar',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        );
      },
    );
  }

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
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              displayHelp(context);
            },
            child: Container(
              color: Colors.black.withAlpha(0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  color: Colors.black.withAlpha(0),
                  child: GestureDetector(
                    child: const Icon(Icons.question_mark),
                  ),
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 10.0, right: 20),
          //   child: GestureDetector(
          //     onTap: () {},
          //     child: const Icon(Icons.more_vert),
          //   ),
          // ),
        ],
      ),
      drawer: const SideMenu(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Image(image: AssetImage('assets/logo_text.png')),
            ),
            // SizedBox(height: 16),
            SizedBox(height: 32),
            HomeButton(
              icon: FontAwesomeIcons.faceSmile,
              text: ' Identificar rostros',
              goto: 'face_identify',
            ),
            SizedBox(height: 8),
            HomeButton(
              icon: FontAwesomeIcons.book,
              text: '  Biblioteca de rostros',
              goto: 'known_faces',
            ),
            SizedBox(height: 8),
            HomeButton(
              icon: Icons.more_horiz,
              text: 'Más funciones',
              goto: 'home_more',
            ),
          ],
        ),
      ),
      persistentFooterButtons: <Widget>[
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Lázaro.',
                style: TextStyle(
                  fontFamily: 'LibreBaskerville',
                  fontSize: 24,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Made with'),
                  SizedBox(width: 8),
                  Icon(
                    FontAwesomeIcons.heart,
                    color: Colors.red,
                  ),
                  SizedBox(width: 8),
                  // Text('by Alvaro'),
                ],
              ),
            ],
          ),
        )
      ],
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(FontAwesomeIcons.facebook),
      //       label: "Facebook",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(FontAwesomeIcons.linkedin),
      //       label: "Linkedin",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(FontAwesomeIcons.twitter),
      //       label: "Twitter",
      //     ),
      //   ],
      // ),
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
