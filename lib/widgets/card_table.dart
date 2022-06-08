import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardTable extends StatelessWidget {
  const CardTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      children: const [
        TableRow(
          children: [
            _SingleCard(
              text: 'Lectura de documentos',
              icon: Icons.document_scanner,
              color: Colors.white,
              goto: 'ocr',
            ),
            _SingleCard(
              text: 'Descripción del entorno',
              icon: FontAwesomeIcons.landmark,
              color: Colors.white,
              goto: 'image_caption',
            ),
          ],
        ),
        TableRow(
          children: [
            _SingleCard(
              text: 'Escaner QR',
              icon: Icons.qr_code,
              color: Colors.white,
              goto: 'qr',
            ),
            _SingleCard(
              text: 'Contador de monedas',
              icon: FontAwesomeIcons.coins,
              color: Colors.white,
              goto: 'coin',
            ),
          ],
        ),
        TableRow(
          children: [
            _SingleCard(
              text: 'Detección de rostros',
              icon: FontAwesomeIcons.faceSmile,
              color: Colors.white,
              goto: 'face_identify',
            ),
            _SingleCard(
              text: 'Biblioteca de rostros',
              icon: FontAwesomeIcons.book,
              color: Colors.white,
              goto: 'known_faces',
            ),
          ],
        ),
      ],
    );
  }
}

class _SingleCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final String goto;

  const _SingleCard(
      {Key? key,
      required this.icon,
      required this.color,
      required this.text,
      required this.goto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SinlgeCardBackground(
      goto: goto,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: color,
              child: Icon(icon, size: 40, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            Text(text, style: TextStyle(color: color, fontSize: 26)),
          ],
        ),
      ),
    );
  }
}

class _SinlgeCardBackground extends StatelessWidget {
  final Widget child;
  final String goto;

  final boxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    color: Colors.blue.withOpacity(0.7),
  );

  _SinlgeCardBackground({Key? key, required this.child, required this.goto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Material(
            color: const Color.fromRGBO(0, 0, 0, 0),
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed(goto),
              child: Container(
                  height: 200, decoration: boxDecoration, child: child),
            ),
          ),
        ),
      ),
    );
  }
}
