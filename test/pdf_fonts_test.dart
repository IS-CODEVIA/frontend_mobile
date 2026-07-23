// Verifica que las fuentes usadas por los PDF estén empaquetadas como assets.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Las fuentes Roboto para PDF están declaradas como assets', () async {
    final regular = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final bold = await rootBundle.load('assets/fonts/Roboto-Bold.ttf');

    expect(regular.lengthInBytes, greaterThan(0));
    expect(bold.lengthInBytes, greaterThan(0));
  });
}
