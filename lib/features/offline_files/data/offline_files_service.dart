import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<Directory> get _storageDir async {
    final dir = await getApplicationDocumentsDirectory();
    final offline = Directory('${dir.path}/offline_files');
    if (!await offline.exists()) {
      await offline.create(recursive: true);
    }
    return offline;
  }

  Future<String> saveFile({
    required String fileName,
    required List<int> bytes,
    required String source,
  }) async {
    final dir = await _storageDir;
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);

    final prefs = await SharedPreferences.getInstance();
    final manifest = prefs.getStringList(_manifestKey) ?? [];
    manifest.add(jsonEncode({
      'fileName': fileName,
      'filePath': file.path,
      'savedAt': DateTime.now().toIso8601String(),
      'source': source,
    }));
    await prefs.setStringList(_manifestKey, manifest);

    return file.path;
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
