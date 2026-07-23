import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// En Flutter Web no existe un sistema de archivos accesible con dart:io,
/// así que se dispara la descarga del navegador con un Blob temporal.
Future<String> savePdfBytes(String fileName, List<int> bytes) async {
  final blob = web.Blob(
    [Uint8List.fromList(bytes).toJS].toJS,
    web.BlobPropertyBag(type: 'application/pdf'),
  );
  final url = web.URL.createObjectURL(blob);
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = fileName;
  web.document.body?.appendChild(anchor);
  anchor.click();
  anchor.remove();
  web.URL.revokeObjectURL(url);
  return fileName;
}
