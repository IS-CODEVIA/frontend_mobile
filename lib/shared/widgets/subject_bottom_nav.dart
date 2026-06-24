import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SubjectBottomNav extends StatelessWidget {
  final String subjectName;

  const SubjectBottomNav({super.key, required this.subjectName});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final itemStyle = textTheme.labelLarge?.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: SizedBox(
          height: 72,
          child: Row(
            children: [
              // Píldora Turquesa (Primary)
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _NavItem(text: 'Avisos', icon: Icons.notifications_outlined, style: itemStyle, onTap: () {
                        context.goNamed(
                          'assignment-notices',
                          pathParameters: {'subjectName': subjectName},
                        );
                      }),
                      _NavItem(text: 'Transcriptor', icon: Icons.record_voice_over_outlined, style: itemStyle, onTap: () {
                        context.goNamed(
                          'transcriptor',
                          pathParameters: {'subjectName': subjectName},
                        );
                      }),
                      _NavItem(text: 'Material', icon: Icons.folder_outlined, style: itemStyle, onTap: () {
                        context.goNamed(
                          'material-students',
                          pathParameters: {'subjectName': subjectName},
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Botón Azul Oscuro (Secondary)
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _NavItem(
                    text: 'Personas',
                    icon: Icons.people_outline,
                    style: itemStyle,
                    onTap: () {
                      context.goNamed(
                        'people-student',
                        pathParameters: {'subjectName': subjectName},
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final TextStyle? style;
  final VoidCallback onTap;

  const _NavItem({required this.text, required this.icon, required this.style, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: style?.color, size: 20),
            const SizedBox(height: 2),
            Text(text, style: style?.copyWith(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}