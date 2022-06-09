import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:lazaro_app/providers/scan_list_provider.dart';
import 'package:lazaro_app/utils/utils.dart';

class ScanTiles extends StatelessWidget {
  final String tipo;

  const ScanTiles({Key? key, required this.tipo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('tipo: $tipo');
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final scans = scanListProvider.scans;

    return ListView.builder(
      itemCount: scans.length,
      itemBuilder: (_, int index) => Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (DismissDirection direction) {
          Provider.of<ScanListProvider>(context, listen: false)
              .borrarScanPorId(scans[index].id!);
        },
        child: ListTile(
          leading: Icon(
            tipo == 'http'
                ? FontAwesomeIcons.link
                : FontAwesomeIcons.locationDot,
            size: 32,
          ),
          title: Text(
            scans[index].valor,
            style: TextStyle(fontSize: 24),
          ),
          subtitle: Text(
            DateFormat(
              'dd/MM/yyyy – kk:mm',
            ).format(DateTime.parse(scans[index].fecha)).toString(),
            style: const TextStyle(fontSize: 18),
          ),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () => launchURL(context, scans[index]),
        ),
      ),
    );
  }
}
