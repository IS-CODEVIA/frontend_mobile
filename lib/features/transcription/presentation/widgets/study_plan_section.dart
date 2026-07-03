import 'package:flutter/material.dart';
import '../../domain/entities/study_plan_entity.dart';

class StudyPlanSection extends StatelessWidget {
  final FeedbackEntity plan;

  const StudyPlanSection({super.key, required this.plan});

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
                plan.summary,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  height: 1.5,
                ),
              ),
              if (plan.keyTopics.isNotEmpty) ...[
                const SizedBox(height: 16),
                _sectionHeader('Temas clave', Icons.topic_rounded, colorScheme, textTheme),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: plan.keyTopics
                      .map((t) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: colorScheme.tertiaryContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              t,
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onTertiaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
              if (plan.strengths.isNotEmpty) ...[
                const SizedBox(height: 16),
                _sectionHeader('Fortalezas', Icons.check_circle_rounded, colorScheme, textTheme),
                const SizedBox(height: 8),
                ...plan.strengths.map((s) => _bulletPoint(s, colorScheme, textTheme)),
              ],
              if (plan.areasToImprove.isNotEmpty) ...[
                const SizedBox(height: 16),
                _sectionHeader('Áreas a mejorar', Icons.trending_up_rounded, colorScheme, textTheme),
                const SizedBox(height: 8),
                ...plan.areasToImprove.map((a) => _bulletPoint(a, colorScheme, textTheme)),
              ],
              if (plan.recommendations.isNotEmpty) ...[
                const SizedBox(height: 16),
                _sectionHeader('Recomendaciones', Icons.lightbulb_rounded, colorScheme, textTheme),
                const SizedBox(height: 8),
                ...plan.recommendations.map((r) => _bulletPoint(r, colorScheme, textTheme)),
              ],
              if (plan.suggestedReview.isNotEmpty) ...[
                const SizedBox(height: 16),
                _sectionHeader('Revisión sugerida', Icons.replay_rounded, colorScheme, textTheme),
                const SizedBox(height: 8),
                Text(
                  plan.suggestedReview,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.bar_chart_rounded, size: 14, color: colorScheme.tertiary),
                  const SizedBox(width: 4),
                  Text(
                    'Estimación de compromiso: ${(plan.engagementEstimate * 100).toStringAsFixed(0)}%',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.tertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(String title, IconData icon, ColorScheme cs, TextTheme tt) {
    return Row(
      children: [
        Icon(icon, size: 16, color: cs.tertiary),
        const SizedBox(width: 6),
        Text(
          title,
          style: tt.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.tertiary,
          ),
        ),
      ],
    );
  }

  Widget _bulletPoint(String text, ColorScheme cs, TextTheme tt) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: tt.bodySmall?.copyWith(color: cs.tertiary)),
          Expanded(
            child: Text(
              text,
              style: tt.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
