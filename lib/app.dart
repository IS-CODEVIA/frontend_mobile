import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/router.dart';
import 'core/di/app_container.dart';
import 'shared/theme/theme.dart';
import 'shared/theme/util.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    ref.read(appContainerProvider.notifier).init();
  }

  @override
  Widget build(BuildContext context) {
    final container = ref.watch(appContainerProvider);

    if (container == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final textTheme = createTextTheme(context, 'Poppins', 'Nunito');
    final materialTheme = MaterialTheme(textTheme);

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
