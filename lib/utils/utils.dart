import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:lazaro_app/models/scan_model.dart';

void launchURL(BuildContext context, ScanModel scan) async {
  final url = scan.valor;
  if (scan.tipo == 'http') {
    // Abrir el sitio web
    if (!await launch(url)) throw 'Could not launch $url';
  } else {
    // Abrir el geo location
    Navigator.pushNamed(context, 'map', arguments: scan);
  }
}

Future<String> getDateNow() async {
  return DateTime.now().toString();
}
