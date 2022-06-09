import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lazaro_app/screens/directions_history_screen.dart';
import 'package:lazaro_app/screens/maps_history_screen.dart';
import 'package:provider/provider.dart';

import 'package:lazaro_app/providers/providers.dart';
import 'package:lazaro_app/widgets/custom_navigation_bar.dart';
import 'package:lazaro_app/widgets/scan_button.dart';

class QrScreen extends StatelessWidget {
  const QrScreen({Key? key}) : super(key: key);

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
                'Escanea codigos QR.\n\nPuede escanear direcciones para abrir con Google Maps.',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 36,
              ),
              Icon(
                Icons.qr_code,
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
          'Escaner QR',
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
        ],
      ),
      body: const _HomeScreenBody(),
      bottomNavigationBar: const CustomNavigationBar(),
      floatingActionButton: const ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _HomeScreenBody extends StatelessWidget {
  const _HomeScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtener UiProvider
    final uiProvider = Provider.of<UiProvider>(context);
    final currentIndex = uiProvider.selectedMenuOption;

    // //TODO: Temporal acciones con la base de datos
    // final tempScan = ScanModel(valor: 'http://google.com');
    // // Añadir un nuevo scan con el ScanModel de tempScan
    // DBProvider.db.nuevoScan(tempScan);
    // // Imprimir un scan por ID
    // DBProvider.db.getScanById(112).then((scan) => print(scan?.valor));
    // // Imprimir todos los Scans
    // DBProvider.db.getTodosLosScans().then(print);
    // // Borrar todos los registros
    // DBProvider.db.deleteAllScans();

    // Usar el ScanListProvider
    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);

    switch (currentIndex) {
      case 0:
        scanListProvider.cargarScansPorTipo('geo');
        return const MapsHistoryScreen();
      case 1:
        scanListProvider.cargarScansPorTipo('http');
        return const DirectionsHistoryScreen();
      default:
        return const DirectionsHistoryScreen();
    }
  }
}
