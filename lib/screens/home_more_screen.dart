import 'package:flutter/material.dart';
import 'package:lazaro_app/widgets/widgets.dart';

class HomeMoreScreen extends StatelessWidget {
  HomeMoreScreen({Key? key}) : super(key: key);

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
                'Bienvenido al asistente de visión Lázaro.\n\nSelecciona alguna de sus funciones.',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 36,
              ),
              SizedBox(
                width: 100,
                child: Image(
                  image: AssetImage('assets/logo.png'),
                ),
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

  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      endDrawer: buildProfileDrawer(),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Más funciones',
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
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  color: Colors.black.withAlpha(0),
                  child: GestureDetector(
                    child: const Icon(Icons.question_mark),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 20),
            child: GestureDetector(
              onTap: () {
                _key.currentState!.openEndDrawer();
              },
              child: Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
      // endDrawer: const SideMenu(),
      body: Stack(
        children: const [
          Background(),
          _HomeBody(),
        ],
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        // color: Colors.red,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 8.0, top: 8),
              child: PageTitle(
                text: 'Lázaro',
                fontSize: 42,
                fontWeight: FontWeight.normal,
                fontFamily: 'LibreBaskerville',
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: PageTitle(
                text: 'Asistente para la visión',
                fontSize: 24,
                fontWeight: FontWeight.normal,
                fontFamily: 'normal',
              ),
            ),
            SizedBox(height: 8),
            // Card Table
            CardTable(),
          ],
        ),
      ),
    );
  }
}

//Custom drawer
buildProfileDrawer() {
  return SideMenu();
}
