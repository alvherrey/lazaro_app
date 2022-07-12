import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lazaro_app/providers/providers.dart';
import 'package:lazaro_app/screens/ocr_screen.dart';
import 'package:lazaro_app/screens/screens.dart';
import 'package:lazaro_app/services/services.dart';
import 'package:lazaro_app/shared_preferences/preferences.dart';

// void main() => runApp(const AppState());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(isDarkmode: Preferences.isDarkmode),
        )
      ],
      child: const AppState(),
    ),
  );
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => KnownFacesService()),
        ChangeNotifierProvider(create: (_) => UiProvider()),
        ChangeNotifierProvider(create: (_) => ScanListProvider()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: NotificationService.messengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Lazaro App',
      initialRoute: 'login',
      routes: {
        'login': (_) => const LoginScreen(),
        'forgot_password': (_) => const ForgotPasswordScreen(),
        'home': (_) => const HomeScreen(),
        'home_more': (_) => HomeMoreScreen(),
        'register': (_) => const RegisterScreen(),
        'user_id': (_) => const UserIdScreen(),
        'known_faces': (_) => const KnownFacesScreen(),
        'known_face': (_) => const KnownFaceScreen(),
        'plantilla': (_) => const PlantillaScreen(),
        'settings': (_) => const SettingsScreen(),
        'user': (_) => const UserScreen(),
        'face_identify': (_) => const FaceIdentifyScreen(),
        'ocr': (_) => const OcrScreen(),
        'image_caption': (_) => const ImageCaptionScreen(),
        'qr': (_) => const QrScreen(),
        'coin': (_) => const CoinScreen(),
        'map': (_) => const MapScreen(),
      },
      theme: Provider.of<ThemeProvider>(context).currentTheme,
    );
  }
}
