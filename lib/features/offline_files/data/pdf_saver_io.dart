import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Guarda los bytes en el almacenamiento local del dispositivo
/// (Android, iOS, escritorio) y devuelve la ruta del archivo.
Future<String> savePdfBytes(String fileName, List<int> bytes) async {
  final dir = await getApplicationDocumentsDirectory();
  final offline = Directory('${dir.path}/offline_files');
  if (!await offline.exists()) {
    await offline.create(recursive: true);
  }
  final file = File('${offline.path}/$fileName');
  await file.writeAsBytes(bytes);
  return file.path;
}
