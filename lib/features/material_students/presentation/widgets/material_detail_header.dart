import 'package:flutter/material.dart';
import '../../domain/models/material_model.dart';

class MaterialDetailHeader extends StatelessWidget {
  final MaterialItemModel material;

  const MaterialDetailHeader({super.key, required this.material});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isTranscription = material.type == MaterialItemType.transcription;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colorScheme.secondary, width: 1.5),
          ),
          child: Icon(
            isTranscription ? Icons.menu_book_rounded : Icons.insert_drive_file_outlined,
            color: colorScheme.secondary,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                material.title,
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                material.date,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.download_outlined, size: 28),
              color: colorScheme.onSurface,
              onPressed: () {},
            ),
            
            if (isTranscription)
              IconButton(
                icon: const Icon(Icons.account_tree_outlined, size: 28), 
                color: colorScheme.onSurface,
                onPressed: () {},
              ),
          ],
        ),
      ],
    );
  }
}
