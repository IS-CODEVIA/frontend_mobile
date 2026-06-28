import 'package:flutter/material.dart';
import '../../domain/entities/student_material_entity.dart';
import '../pages/student_material_detail_page.dart';

class StudentMaterialCard extends StatelessWidget {
  final StudentMaterialEntity material;
  final String subjectName;
  final int courseId;

  const StudentMaterialCard({
    super.key,
    required this.material,
    required this.subjectName,
    required this.courseId,
  });

  IconData _fileIcon(String fileType) {
    switch (fileType) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'video':
        return Icons.videocam_rounded;
      case 'document':
        return Icons.description_rounded;
      case 'image':
        return Icons.image_rounded;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  String _fileTypeLabel(String fileType) {
    switch (fileType) {
      case 'pdf':
        return 'PDF';
      case 'video':
        return 'Video';
      case 'document':
        return 'Documento';
      case 'image':
        return 'Imagen';
      default:
        return 'Archivo';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final icon = _fileIcon(material.fileType);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.secondary, width: 1.5),
                ),
                child: Icon(icon, color: colorScheme.secondary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      material.title,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      material.createdAt,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _fileTypeLabel(material.fileType),
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          if (material.description != null &&
              material.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              material.description!,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StudentMaterialDetailPage(
                    material: material,
                    subjectName: subjectName,
                    courseId: courseId,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                Icon(Icons.open_in_new_rounded,
                    size: 16, color: colorScheme.primary),
                const SizedBox(width: 6),
                Text(
                  'Ver más',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
