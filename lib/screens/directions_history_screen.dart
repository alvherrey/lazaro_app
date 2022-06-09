import 'package:flutter/material.dart';

import 'package:lazaro_app/widgets/scan_tiles.dart';

class DirectionsHistoryScreen extends StatelessWidget {
  const DirectionsHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ScanTiles(tipo: 'http');
  }
}
