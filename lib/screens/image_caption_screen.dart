import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ImageCaptionScreen extends StatelessWidget {
  const ImageCaptionScreen({Key? key}) : super(key: key);

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
                'Haz una foto, o seleccionala desde la galería.\n\nAutomaticamente describe el entorno que te rodea.',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 36,
              ),
              Icon(
                FontAwesomeIcons.landmark,
                size: 70,
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Descripción del entorno',
          style: TextStyle(fontSize: 24),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              displayHelp(context);
            },
            child: Container(
              color: Colors.black.withAlpha(0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
          //     padding: const EdgeInsets.only(left: 10.0, right: 20),
          //     child: GestureDetector(
          //       onTap: () {},
          //       child: Icon(Icons.more_vert),
          //     )),
        ],
      ),
      body: Center(
        child: Text('ImageCaptionScreen'),
      ),
    );
  }
}
