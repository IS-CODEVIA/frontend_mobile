import 'package:flutter/material.dart';
import '../../../../shared/responsive/responsive_utils.dart';
import '../../domain/entities/notice_entity.dart';

class AssignmentNoticeProfessorCard extends StatelessWidget {
  final NoticeEntity notice;

  const AssignmentNoticeProfessorCard({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final landscape = isLandscape(context);

    return Container(
      margin: EdgeInsets.only(bottom: landscape ? 8.0 : 16.0),
      padding: EdgeInsets.all(landscape ? 12.0 : 16.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: colorScheme.secondary,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: landscape ? 16 : 22,
                backgroundColor: colorScheme.surfaceContainerHighest,
                child: Icon(Icons.person, color: colorScheme.outline, size: landscape ? 16 : 24),
              ),
              SizedBox(width: landscape ? 8 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notice.title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurfaceVariant,
                        fontSize: responsiveFontSize(context, landscape ? 13 : 14),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      notice.createdAt,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                        fontSize: responsiveFontSize(context, landscape ? 11 : 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (notice.description != null) ...[
            SizedBox(height: landscape ? 8 : 16),
            Text(
              notice.description!,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.secondary,
                fontWeight: FontWeight.w600,
                fontSize: responsiveFontSize(context, landscape ? 13 : 14),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
