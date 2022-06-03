import 'package:flutter/material.dart';

class PlantillaScreen extends StatelessWidget {
  const PlantillaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Lázaro'),
      ),
      body: const Center(
        child: Text('PlantillaScreen'),
      ),
    );
  }
}