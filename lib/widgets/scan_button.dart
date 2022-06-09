import 'package:flutter/material.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:lazaro_app/providers/scan_list_provider.dart';
import 'package:lazaro_app/utils/utils.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      child: const Icon(
        Icons.qr_code_scanner,
        size: 32,
      ),
      onPressed: () async {
        //TODO: launch barcode scan or mock the barcodeScanRes
        String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            '#3D8BEF', 'Cancelar', false, ScanMode.QR);
        // const barcodeScanRes = 'https://flutter.dev/';
        // const barcodeScanRes = 'geo:39.875375,-4.030697';

        if (barcodeScanRes == '-1') {
          return;
        }

        // Obtener el Provider ScanListProvider, para despues hacer un nuevoScan
        final scanListProvider =
            Provider.of<ScanListProvider>(context, listen: false);
        await getDateNow().then((value) async {
          final nuevoScan =
              await scanListProvider.nuevoScan(barcodeScanRes, value);
          launchURL(context, nuevoScan);
        });
      },
    );
  }
}
