import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lazaro_app/providers/ui_provider.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);

    return BottomNavigationBar(
      onTap: (int i) {
        uiProvider.selectedMenuOption = i;
      },
      currentIndex: uiProvider.selectedMenuOption,
      elevation: 0,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.map, size: 32), label: 'Mapa'),
        BottomNavigationBarItem(
            icon: Icon(Icons.list, size: 32), label: 'Direcciones'),
      ],
    );
  }
}
