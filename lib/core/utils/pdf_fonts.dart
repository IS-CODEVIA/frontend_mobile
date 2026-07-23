import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;

class PdfFonts {
  static pw.Font? _regular;
  static pw.Font? _bold;

  static const _regularUrl =
      'https://raw.githubusercontent.com/google/fonts/main/ofl/roboto/Roboto-Regular.ttf';
  static const _boldUrl =
      'https://raw.githubusercontent.com/google/fonts/main/ofl/roboto/Roboto-Bold.ttf';

  static Future<pw.Font> get regular async {
    if (_regular != null) return _regular!;
    _regular = await _loadFromUrl(_regularUrl);
    return _regular!;
  }

  static Future<pw.Font> get bold async {
    if (_bold != null) return _bold!;
    _bold = await _loadFromUrl(_boldUrl);
    return _bold!;
  }

  static Future<pw.Font> _loadFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final bytes = Uint8List.fromList(response.bodyBytes);
      return pw.Font.ttf(bytes.buffer.asByteData());
      }
    } catch (_) {}
    return pw.Font.helvetica();
  }
}
