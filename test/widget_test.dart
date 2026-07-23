// Smoke test: verifica que la app SAUU se construye sin errores.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sauu_mobile/app.dart';

void main() {
  testWidgets('La app se construye y muestra una pantalla inicial',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
