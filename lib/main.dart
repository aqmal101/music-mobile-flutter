import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:music_app/pages/intro.dart';
import 'package:music_app/provider/auth_provider.dart';
import 'package:music_app/provider/playlist_provider.dart';
import 'package:music_app/provider/music_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthProvider(),
          ),
          ChangeNotifierProvider(create: (_) => MusicProvider()),
          ChangeNotifierProvider(create: (_) => PlaylistProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const IntroScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
