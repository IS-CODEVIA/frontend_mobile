import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../responsive/responsive_utils.dart';

class SubjectBottomNav extends StatelessWidget {
  final String subjectName;
  final int courseId;

  const SubjectBottomNav({
    super.key,
    required this.subjectName,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final landscape = isLandscape(context);
    final navHeight = responsiveBottomNavHeight(context);

    final itemStyle = textTheme.labelLarge?.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: landscape ? 11 : 14,
    );

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: landscape ? 8.0 : 16.0, vertical: landscape ? 6.0 : 12.0),
        child: SizedBox(
          height: navHeight,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: landscape
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _LandscapeNavItem(text: 'Avisos', icon: Icons.notifications_outlined, style: itemStyle, onTap: () {
                              context.goNamed(
                                'assignment-notices',
                                pathParameters: {'subjectName': subjectName},
                                extra: {'courseId': courseId},
                              );
                            }),
                            _LandscapeNavItem(text: 'Transcriptor', icon: Icons.record_voice_over_outlined, style: itemStyle, onTap: () {
                              context.goNamed(
                                'transcriptor',
                                pathParameters: {'subjectName': subjectName},
                                extra: {'courseId': courseId},
                              );
                            }),
                            _LandscapeNavItem(text: 'Material', icon: Icons.folder_outlined, style: itemStyle, onTap: () {
                              context.goNamed(
                                'material-students',
                                pathParameters: {'subjectName': subjectName},
                                extra: {'courseId': courseId},
                              );
                            }),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _NavItem(text: 'Avisos', icon: Icons.notifications_outlined, style: itemStyle, onTap: () {
                              context.goNamed(
                                'assignment-notices',
                                pathParameters: {'subjectName': subjectName},
                                extra: {'courseId': courseId},
                              );
                            }),
                            _NavItem(text: 'Transcriptor', icon: Icons.record_voice_over_outlined, style: itemStyle, onTap: () {
                              context.goNamed(
                                'transcriptor',
                                pathParameters: {'subjectName': subjectName},
                                extra: {'courseId': courseId},
                              );
                            }),
                            _NavItem(text: 'Material', icon: Icons.folder_outlined, style: itemStyle, onTap: () {
                              context.goNamed(
                                'material-students',
                                pathParameters: {'subjectName': subjectName},
                                extra: {'courseId': courseId},
                              );
                            }),
                          ],
                        ),
                ),
              ),
              SizedBox(width: landscape ? 6 : 12),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: landscape
                      ? _LandscapeNavItem(
                          text: 'Personas',
                          icon: Icons.people_outline,
                          style: itemStyle,
                          onTap: () {
                            context.goNamed(
                              'people-student',
                              pathParameters: {'subjectName': subjectName},
                              extra: {'courseId': courseId},
                            );
                          },
                        )
                      : _NavItem(
                          text: 'Personas',
                          icon: Icons.people_outline,
                          style: itemStyle,
                          onTap: () {
                            context.goNamed(
                              'people-student',
                              pathParameters: {'subjectName': subjectName},
                              extra: {'courseId': courseId},
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

class _LandscapeNavItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final TextStyle? style;
  final VoidCallback onTap;

  const _LandscapeNavItem({required this.text, required this.icon, required this.style, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: style?.color, size: 16),
            const SizedBox(width: 4),
            Text(text, style: style?.copyWith(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
