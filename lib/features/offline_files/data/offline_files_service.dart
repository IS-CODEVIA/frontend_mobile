import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pdf_saver_io.dart' if (dart.library.js_interop) 'pdf_saver_web.dart'
    as pdf_saver;

class OfflineFileInfo {
  final String fileName;
  final String filePath;
  final DateTime savedAt;
  final String source; // e.g., "study_plan", "material"

  const OfflineFileInfo({
    required this.fileName,
    required this.filePath,
    required this.savedAt,
    required this.source,
  });
}

class OfflineFilesService {
  static const _manifestKey = 'offline_files_manifest';

  Future<String> saveFile({
    required String fileName,
    required List<int> bytes,
    required String source,
  }) async {
    final filePath = await pdf_saver.savePdfBytes(fileName, bytes);

    // En web el archivo va a la carpeta de descargas del navegador;
    // no hay ruta local que registrar en el manifiesto offline.
    if (!kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final manifest = prefs.getStringList(_manifestKey) ?? [];
      manifest.add(jsonEncode({
        'fileName': fileName,
        'filePath': filePath,
        'savedAt': DateTime.now().toIso8601String(),
        'source': source,
      }));
      await prefs.setStringList(_manifestKey, manifest);
    }

    return filePath;
  }

  Future<List<OfflineFileInfo>> getFiles() async {
    final prefs = await SharedPreferences.getInstance();
    final manifest = prefs.getStringList(_manifestKey) ?? [];
    return manifest.map((entry) {
      final data = jsonDecode(entry) as Map<String, dynamic>;
      return OfflineFileInfo(
        fileName: data['fileName'] as String,
        filePath: data['filePath'] as String,
        savedAt: DateTime.parse(data['savedAt'] as String),
        source: data['source'] as String,
      );
    }).toList()
      ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  Future<void> deleteFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }

    final prefs = await SharedPreferences.getInstance();
    final manifest = prefs.getStringList(_manifestKey) ?? [];
    manifest.removeWhere((entry) {
      final data = jsonDecode(entry) as Map<String, dynamic>;
      return data['filePath'] == filePath;
    });
    await prefs.setStringList(_manifestKey, manifest);
  }
}

final offlineFilesServiceProvider = Provider<OfflineFilesService>((ref) {
  return OfflineFilesService();
});
