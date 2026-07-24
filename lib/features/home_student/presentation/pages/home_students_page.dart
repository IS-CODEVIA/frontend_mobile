import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/header_students.dart';
import '../../../../shared/widgets/nabvar_students.dart';

import '../riverpod/home_students_riverpod.dart';
import '../widgets/subject_card.dart';
import '../widgets/join_class_modal.dart';

class HomeStudentsPage extends ConsumerWidget {
  const HomeStudentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final homeAsync = ref.watch(homeStudentProvider);

    return Scaffold(
      drawer: const NavbarStudents(),
      body: Column(
        children: [
          const HeaderStudents(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.menu_book_rounded,
                        color: colorScheme.secondary,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Asignaturas',
                        style: textTheme.headlineMedium?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${homeAsync.asData?.value.subjects.length ?? 0}',
                        style: textTheme.headlineMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: homeAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, _) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.error_outline, size: 48, color: colorScheme.error),
                              const SizedBox(height: 16),
                              Text(
                                'No se pudieron cargar tus asignaturas',
                                textAlign: TextAlign.center,
                                style: textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                error.toString(),
                                textAlign: TextAlign.center,
                                style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
                              ),
                              const SizedBox(height: 16),
                              FilledButton.icon(
                                onPressed: () => ref.invalidate(homeStudentProvider),
                                icon: const Icon(Icons.refresh),
                                label: const Text('Reintentar'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      data: (state) {
                        final subjects = state.subjects;
                        if (subjects.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.school_outlined,
                                  size: 64,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No tienes asignaturas inscritas',
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Usa el bot\u00f3n + para unirte a una clase',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.outline,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.only(top: 8, bottom: 80),
                          itemCount: subjects.length,
                          itemBuilder: (context, index) {
                            return SubjectCard(subject: subjects[index]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => JoinClassModal.show(context),
        backgroundColor: colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.add, color: colorScheme.onSecondary, size: 32),
      ),
    );
  }
}