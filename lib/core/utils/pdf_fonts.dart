import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;

class PdfFonts {
  static pw.Font? _regular;
  static pw.Font? _bold;

  static const _regularAsset = 'assets/fonts/Roboto-Regular.ttf';
  static const _boldAsset = 'assets/fonts/Roboto-Bold.ttf';

  static Future<pw.Font> get regular async {
    if (_regular != null) return _regular!;
    _regular = await _loadFromAsset(_regularAsset);
    return _regular!;
  }

  static Future<pw.Font> get bold async {
    if (_bold != null) return _bold!;
    _bold = await _loadFromAsset(_boldAsset);
    return _bold!;
  }

  static Future<pw.Font> _loadFromAsset(String asset) async {
    try {
      final data = await rootBundle.load(asset);
      return pw.Font.ttf(data);
    } catch (_) {
      return pw.Font.helvetica();
    }
  }
}
