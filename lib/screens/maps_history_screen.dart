import 'package:flutter/material.dart';

import 'package:lazaro_app/widgets/scan_tiles.dart';

class MapsHistoryScreen extends StatelessWidget {
  const MapsHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ScanTiles(tipo: 'geo');
  }
}
