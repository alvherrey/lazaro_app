import 'package:flutter/material.dart';

class OcrScreen extends StatelessWidget {
  const OcrScreen({Key? key}) : super(key: key);

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
                'Haz una foto, o selecciona una imagen de la galería.\n\nAutomaticamente detecta que rostros hay en la foto.',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 36,
              ),
              Icon(
                Icons.document_scanner,
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
          'Lectura de documentos',
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
        child: Text('OcrScreen'),
      ),
    );
  }
}
