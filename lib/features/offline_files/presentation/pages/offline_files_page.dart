import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/offline_files_service.dart';

class OfflineFilesPage extends ConsumerStatefulWidget {
  const OfflineFilesPage({super.key});

  @override
  ConsumerState<OfflineFilesPage> createState() => _OfflineFilesPageState();
}

class _OfflineFilesPageState extends ConsumerState<OfflineFilesPage> {
  List<OfflineFileInfo>? _files;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    final files = await ref.read(offlineFilesServiceProvider).getFiles();
    if (mounted) setState(() => _files = files);
  }

  Future<void> _deleteFile(String filePath) async {
    await ref.read(offlineFilesServiceProvider).deleteFile(filePath);
    _loadFiles();
  }

  String _sourceLabel(String source) {
    switch (source) {
      case 'study_plan':
        return 'Plan de estudio';
      case 'material':
        return 'Material';
      case 'transcription':
        return 'Transcripción';
      default:
        return source;
    }
  }

  IconData _sourceIcon(String source) {
    switch (source) {
      case 'study_plan':
        return Icons.menu_book_rounded;
      case 'material':
        return Icons.folder_outlined;
      case 'transcription':
        return Icons.transcribe_rounded;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Archivos Offline'),
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
      ),
      body: _files == null
          ? const Center(child: CircularProgressIndicator())
          : _files!.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.download_outlined, size: 64, color: colorScheme.onSurfaceVariant),
                      const SizedBox(height: 16),
                      Text(
                        'No hay archivos descargados',
                        style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Los planes de estudio y materiales que descargues aparecerán aquí.',
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadFiles,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _files!.length,
                    itemBuilder: (context, index) {
                      final file = _files![index];
                      final size = _formatSize(file.filePath);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: colorScheme.secondaryContainer,
                            child: Icon(_sourceIcon(file.source), color: colorScheme.secondary),
                          ),
                          title: Text(
                            file.fileName,
                            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${_sourceLabel(file.source)} • $size',
                            style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                          trailing: IconButton(
                            onPressed: () => _deleteFile(file.filePath),
                            icon: Icon(Icons.delete_outline, color: colorScheme.error),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  String _formatSize(String filePath) {
    try {
      final file = File(filePath);
      if (!file.existsSync()) return 'N/A';
      final bytes = file.lengthSync();
      if (bytes < 1024) return '$bytes B';
      if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } catch (_) {
      return 'N/A';
    }
  }
}
