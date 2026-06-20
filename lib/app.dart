import 'package:flutter/material.dart';
import 'shared/theme/theme.dart';
import 'shared/theme/util.dart';
import 'core/config/router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, 'Poppins', 'Nunito');
    MaterialTheme materialTheme = MaterialTheme(textTheme);
    return MaterialApp.router(
      title: 'SAUU',
      debugShowCheckedModeBanner: false,
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}