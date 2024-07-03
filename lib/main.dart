import 'package:flutter/material.dart';
import 'package:flutter_telegram_web_app/flutter_telegram_web_app.dart' as tg;
import 'package:flutter_telegram_web_app/flutter_telegram_web_app.dart';
import 'package:vulpes/screens/main/main_screen.dart';

void main() {
  runApp(const MyApp());
}

// tg

final ValueNotifier<ThemeMode> _notifier =
    ValueNotifier(tg.isDarkMode ? ThemeMode.dark : ThemeMode.light);

void updateThemeMode() {
  _notifier.value = tg.isDarkMode ? ThemeMode.dark : ThemeMode.light;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _notifier,
      builder: (_, mode, __) {
        return MaterialApp(
          title: "AdiKoin Web App",
          debugShowCheckedModeBanner: false,
          theme: TelegramTheme.light,
          darkTheme: TelegramTheme.dark,
          themeMode: mode,
          // home: HomeView(),
          home: const MainScreen(),
        );
      },
    );
  }
}

// not tg

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MainScreen(),
//     );
//   }
// }
