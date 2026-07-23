import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/header_students.dart';
import '../../../../shared/widgets/nabvar_students.dart';
import '../../../../shared/widgets/subject_bottom_nav.dart';
import '../../../auth/presentation/riverpod/auth_riverpod.dart';
import '../../../offline_files/data/offline_files_service.dart';
import '../../data/datasources/feedback_remote_datasource.dart';
import '../../domain/entities/study_plan_entity.dart';
import '../../domain/entities/transcription_entity.dart';
import '../widgets/study_plan_section.dart';
import '../widgets/transcription_pdf.dart';

class TranscriptionDetailStudentPage extends ConsumerStatefulWidget {
  final TranscriptionEntity transcription;
  final String subjectName;
  final int courseId;

  const TranscriptionDetailStudentPage({
    super.key,
    required this.transcription,
    required this.subjectName,
    required this.courseId,
  });

  @override
  ConsumerState<TranscriptionDetailStudentPage> createState() =>
      _TranscriptionDetailStudentPageState();
}

class _TranscriptionDetailStudentPageState
    extends ConsumerState<TranscriptionDetailStudentPage> {
  FeedbackEntity? _studyPlan;
  bool _isLoadingFeedback = false;
  String? _feedbackError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadExistingFeedback());
  }

  String get _sessionId => 'live:${widget.courseId}';

  Future<void> _loadExistingFeedback() async {
    final dataSource = FeedbackRemoteDataSource();
    try {
      final plan = await dataSource.getFeedback(
        sessionId: _sessionId,
      );
      if (mounted) {
        setState(() {
          _studyPlan = plan;
        });
      }
    } on Exception catch (e) {
      if (e.toString().contains('FEEDBACK_NOT_FOUND')) return;
      if (mounted) {
        setState(() {
          _feedbackError = e.toString();
        });
      }
    }
  }

  Future<void> _downloadTranscription(BuildContext context) async {
    try {
      final bytes = await buildTranscriptionPdf(
        transcription: widget.transcription,
        subjectName: widget.subjectName,
      );

      final title = widget.transcription.classTopic.isNotEmpty
          ? widget.transcription.classTopic
          : 'Transcripcion';
      final sanitized = title.replaceAll(RegExp(r'[^\w\s]'), '').replaceAll(' ', '_');
      final fileName =
          'transcripcion_${sanitized}_${DateTime.now().millisecondsSinceEpoch}.pdf';

      await ref.read(offlineFilesServiceProvider).saveFile(
            fileName: fileName,
            bytes: bytes,
            source: 'transcription',
          );

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transcripción descargada: $fileName'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al descargar la transcripción'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _generateFeedback() async {
    final user = ref.read(authViewModelProvider).user;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes iniciar sesión para generar feedback'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoadingFeedback = true;
      _feedbackError = null;
    });

    try {
      final dataSource = FeedbackRemoteDataSource();
      final plan = await dataSource.generateFeedback(
        sessionId: _sessionId,
        userId: user.userId,
      );
      setState(() {
        _studyPlan = plan;
        _isLoadingFeedback = false;
      });
    } catch (e) {
      setState(() {
        _feedbackError = e.toString();
        _isLoadingFeedback = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      drawer: const NavbarStudents(),
      bottomNavigationBar: SubjectBottomNav(
        subjectName: widget.subjectName,
        courseId: widget.courseId,
      ),
      body: Column(
        children: [
          const HeaderStudents(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: colorScheme.secondary,
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.transcription.classTopic.isNotEmpty
                            ? widget.transcription.classTopic
                            : 'Transcripción',
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: colorScheme.secondary,
                  thickness: 1.0,
                  height: 16,
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.secondary,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(Icons.menu_book_rounded,
                          color: colorScheme.secondary, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.transcription.classTopic.isNotEmpty
                                ? widget.transcription.classTopic
                                : 'Transcripción',
                            style: textTheme.titleLarge?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.transcription.createdAt,
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
                          icon: const Icon(Icons.download_outlined, size: 24),
                          color: colorScheme.primary,
                          visualDensity: VisualDensity.compact,
                          tooltip: 'Descargar transcripción',
                          onPressed: () => _downloadTranscription(context),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.auto_awesome_rounded, size: 24),
                          color: colorScheme.tertiary,
                          visualDensity: VisualDensity.compact,
                          tooltip: 'Generar feedback',
                          onPressed: _isLoadingFeedback ? null : _generateFeedback,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  widget.transcription.fullText,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (_isLoadingFeedback) ...[
                  const SizedBox(height: 32),
                  Divider(color: colorScheme.outlineVariant),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.tertiary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Generando feedback...',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
                if (_feedbackError != null) ...[
                  const SizedBox(height: 32),
                  Divider(color: colorScheme.outlineVariant),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.error_outline,
                          color: colorScheme.error, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _feedbackError!,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (_studyPlan != null) ...[
                  const SizedBox(height: 32),
                  Divider(color: colorScheme.outlineVariant),
                  const SizedBox(height: 16),
                  StudyPlanSection(plan: _studyPlan!),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
