import 'package:application/data/notifiers.dart';
import 'package:application/play_sound.dart';
import 'package:application/views/widget_tree.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //required for async operations

  await loadFavoritesFromStorage();
  await loadDarkModeFromStorage();

  await initSounds();

  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.toString().contains('audioplayers/events') ||
        details.toString().contains('non-platform thread')) {
      return;
    }
    FlutterError.dumpErrorToConsole(details);
  };

  runApp(const MyApp());
}

//stateful" can refresh
//stateless" cant refresh
//setstate to refreshweaeewdwadsd

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: isDarkMode ? Brightness.dark : Brightness.light,
            ),
            // fontFamily: 'PokemonBW',
          ),
          home: WidgetTree(),
        );
      },
    );
  }
}
