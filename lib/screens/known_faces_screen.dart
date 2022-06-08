import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lazaro_app/widgets/known_face_card.dart';
import 'package:provider/provider.dart';

import 'package:lazaro_app/models/models.dart';
import 'package:lazaro_app/screens/screens.dart';
import 'package:lazaro_app/services/services.dart';
import 'package:lazaro_app/widgets/widgets.dart';

class KnownFacesScreen extends StatelessWidget {
  const KnownFacesScreen({Key? key}) : super(key: key);

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
                'Biblioteca de rostros almacenados por el usuario.\n\nSirven para identificar rostros.',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 36,
              ),
              Icon(
                FontAwesomeIcons.book,
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
    final knownFacesService = Provider.of<KnownFacesService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    if (knownFacesService.isLoading) return const LoadingScreen();

    final localId = [];
    final filteredList = [];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Biblioteca de rostros',
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
      body: FutureBuilder<String?>(
          future: authService.readLocalId(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              localId.clear();
              filteredList.clear();
              localId.add(snapshot.data!);
              // print('localId cargado: ${localId}');
              // print(knownFacesService.knownFaces.length);
              for (var i = 0; i < knownFacesService.knownFaces.length; i++) {
                if (knownFacesService.knownFaces[i].localId == localId[0]) {
                  filteredList.add(knownFacesService.knownFaces[i]);
                  // print(knownFacesService.knownFaces[i].localId);
                }
              }
              // print('filteredList: ${filteredList.length}');
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                cacheExtent: 999,
                //TODO filtrar por localId
                itemCount: filteredList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      knownFacesService.selectedKnownFace =
                          filteredList[index].copy();
                      Navigator.pushNamed(context, 'known_face');
                    },
                    child: KnownFaceCard(knownFace: filteredList[index]),
                  );
                },
              );
            } else {
              return Container();
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          knownFacesService.selectedKnownFace =
              KnownFace(name: '', relation: '', age: '');
          Navigator.pushNamed(context, 'known_face');
        },
      ),
    );
  }
}
