import 'package:flutter/material.dart';
import '../../domain/entities/study_plan_entity.dart';

class StudyPlanSection extends StatelessWidget {
  final StudyPlanEntity plan;

  const StudyPlanSection({super.key, required this.plan});

  IconData _typeIcon(String type) {
    switch (type) {
      case 'reading':
        return Icons.menu_book_rounded;
      case 'quiz':
        return Icons.quiz_rounded;
      case 'practice':
        return Icons.code_rounded;
      case 'project':
        return Icons.build_rounded;
      default:
        return Icons.circle_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.auto_awesome_rounded,
                color: colorScheme.tertiary, size: 22),
            const SizedBox(width: 8),
            Text(
              'Feedback',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.tertiary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.tertiaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.tertiary.withValues(alpha: 0.4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plan.topic,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _infoChip(
                    Icons.auto_awesome_rounded,
                    plan.difficulty,
                    colorScheme,
                    textTheme,
                  ),
                  const SizedBox(width: 8),
                  _infoChip(
                    Icons.schedule_rounded,
                    '${plan.durationHours}h',
                    colorScheme,
                    textTheme,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...plan.modules.map((m) => _moduleCard(m, colorScheme, textTheme)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoChip(IconData icon, String label, ColorScheme cs, TextTheme tt) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cs.tertiaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: cs.tertiary),
          const SizedBox(width: 4),
          Text(
            label,
            style: tt.labelSmall?.copyWith(
              color: cs.tertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _moduleCard(ModuleEntity module, ColorScheme cs, TextTheme tt) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            module.title,
            style: tt.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.tertiary,
            ),
          ),
          if (module.concepts.isNotEmpty) ...[
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: module.concepts
                  .map((c) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          c,
                          style: tt.labelSmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
          if (module.sessions.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...module.sessions.map((s) => _sessionTile(s, cs, tt)),
          ],
        ],
      ),
    );
  }

  Widget _sessionTile(SessionEntity session, ColorScheme cs, TextTheme tt) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 6, bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: cs.tertiary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  _typeIcon(session.type),
                  size: 16,
                  color: cs.tertiary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${session.order}. ${session.title}',
                            style: tt.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: cs.onSurface,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${session.durationMin}min',
                            style: tt.labelSmall?.copyWith(
                              color: cs.onSurfaceVariant,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (session.description.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        session.description,
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (session.assessment != null) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: cs.secondaryContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.assignment_rounded,
                                size: 12, color: cs.secondary),
                            const SizedBox(width: 4),
                            Text(
                              session.assessment!.description,
                              style: tt.labelSmall?.copyWith(
                                color: cs.secondary,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
