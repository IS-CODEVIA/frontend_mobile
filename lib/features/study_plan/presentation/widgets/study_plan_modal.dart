import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../../../offline_files/data/offline_files_service.dart';
import '../../domain/entities/study_plan_entity.dart';
import '../riverpod/study_plan_riverpod.dart';

class StudyPlanModal extends ConsumerStatefulWidget {
  final String courseName;
  final String userId;
  final String sessionId;
  final String topic;

  const StudyPlanModal({
    super.key,
    required this.courseName,
    required this.userId,
    required this.sessionId,
    required this.topic,
  });

  static Future<void> show(
    BuildContext context, {
    required String courseName,
    required String userId,
    required String sessionId,
    required String topic,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => StudyPlanModal(
        courseName: courseName,
        userId: userId,
        sessionId: sessionId,
        topic: topic,
      ),
    );
  }

  @override
  ConsumerState<StudyPlanModal> createState() => _StudyPlanModalState();
}

class _StudyPlanModalState extends ConsumerState<StudyPlanModal> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(studyPlanProvider.notifier).generate(
        userId: widget.userId,
        sessionId: widget.sessionId,
        topic: widget.topic,
      );
    });
  }

  Future<void> _saveAsPdf(StudyPlanEntity plan) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (ctx) => [
          pw.Header(
            level: 0,
            child: pw.Text('Plan de Estudio', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 8),
          pw.Text('Curso: ${widget.courseName}', style: const pw.TextStyle(fontSize: 14)),
          pw.Text('Tema: ${plan.topic}', style: const pw.TextStyle(fontSize: 14)),
          pw.Text('Dificultad: ${plan.difficulty}', style: const pw.TextStyle(fontSize: 14)),
          pw.Text('Duración: ${plan.durationHours} horas', style: const pw.TextStyle(fontSize: 14)),
          pw.SizedBox(height: 16),
          pw.Header(level: 1, text: 'Introducción'),
          pw.Paragraph(text: plan.introduccion),
          pw.SizedBox(height: 16),
          pw.Header(level: 1, text: 'Puntos de Estudio'),
          for (final point in plan.puntosDeEstudio) ...[
            pw.Header(level: 2, text: point.titulo),
            pw.Paragraph(text: '¿Por qué es importante?: ${point.porQueImporta}'),
            pw.Paragraph(text: point.explicacion),
            if (point.antesDeEntenderlo.isNotEmpty) ...[
              pw.Paragraph(text: 'Antes de entenderlo: ${point.antesDeEntenderlo.join(", ")}'),
            ],
            if (point.comoSeRelaciona.isNotEmpty) ...[
              pw.Paragraph(text: 'Se relaciona con: ${point.comoSeRelaciona.join(", ")}'),
            ],
            if (point.ejemplo.isNotEmpty) ...[
              pw.Paragraph(text: 'Ejemplo: ${point.ejemplo}'),
            ],
            pw.SizedBox(height: 12),
          ],
          pw.Header(level: 1, text: 'Orden de Estudio'),
          for (final order in plan.ordenDeEstudio) ...[
            pw.Paragraph(text: '${order.orden}. ${order.tema} — ${order.razon}'),
          ],
          pw.SizedBox(height: 16),
          pw.Header(level: 1, text: 'Recomendaciones'),
          if (plan.recomendaciones.repasarAntes.isNotEmpty) ...[
            pw.Paragraph(text: 'Repasar antes: ${plan.recomendaciones.repasarAntes.join(", ")}'),
          ],
          if (plan.recomendaciones.conceptosParaPracticar.isNotEmpty) ...[
            pw.Paragraph(text: 'Practicar: ${plan.recomendaciones.conceptosParaPracticar.join(", ")}'),
          ],
          if (plan.recomendaciones.comoReforzar.isNotEmpty) ...[
            pw.Paragraph(text: 'Reforzar: ${plan.recomendaciones.comoReforzar.join(", ")}'),
          ],
          pw.SizedBox(height: 16),
          pw.Header(level: 1, text: 'Resumen Final'),
          pw.Paragraph(text: plan.resumenFinal),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final fileName =
        'plan_estudio_${widget.courseName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    await ref.read(offlineFilesServiceProvider).saveFile(
      fileName: fileName,
      bytes: await pdf.save(),
      source: 'study_plan',
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Plan de estudio guardado como $fileName'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final state = ref.watch(studyPlanProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          maxWidth: 600,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.secondary,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  Icon(Icons.menu_book_rounded, color: colorScheme.onSecondary, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Plan de Estudio',
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: colorScheme.onSecondary),
                  ),
                ],
              ),
            ),
            if (state.status == StudyPlanStatus.loading)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Generando plan de estudio...'),
                    ],
                  ),
                ),
              )
            else if (state.status == StudyPlanStatus.error)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: colorScheme.error),
                      const SizedBox(height: 16),
                      Text(
                        state.error ?? 'Error desconocido',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cerrar'),
                      ),
                    ],
                  ),
                ),
              )
            else if (state.plan != null)
              Flexible(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _section(textTheme, colorScheme, 'Introducción', state.plan!.introduccion),
                            const SizedBox(height: 16),
                            Text(
                              'Puntos de Estudio',
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            for (final point in state.plan!.puntosDeEstudio) ...[
                              _pointCard(context, point),
                              const SizedBox(height: 8),
                            ],
                            const SizedBox(height: 16),
                            Text(
                              'Orden de Estudio',
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            for (final order in state.plan!.ordenDeEstudio) ...[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: colorScheme.secondary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${order.orden}',
                                          style: textTheme.labelSmall?.copyWith(
                                            color: colorScheme.onSecondary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(order.tema, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                                          Text(order.razon, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            Text(
                              'Recomendaciones',
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _bulletList(textTheme, 'Repasar antes', state.plan!.recomendaciones.repasarAntes),
                            _bulletList(textTheme, 'Practicar', state.plan!.recomendaciones.conceptosParaPracticar),
                            _bulletList(textTheme, 'Reforzar', state.plan!.recomendaciones.comoReforzar),
                            const SizedBox(height: 16),
                            _section(textTheme, colorScheme, 'Resumen Final', state.plan!.resumenFinal),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                      ),
                      child: FilledButton.icon(
                        onPressed: () => _saveAsPdf(state.plan!),
                        icon: const Icon(Icons.download_rounded),
                        label: const Text('Guardar como PDF'),
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.secondary,
                          foregroundColor: colorScheme.onSecondary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _section(TextTheme textTheme, ColorScheme colorScheme, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(content, style: textTheme.bodyMedium),
      ],
    );
  }

  Widget _pointCard(BuildContext context, StudyPlanPoint point) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(point.titulo, style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(point.porQueImporta, style: textTheme.bodySmall?.copyWith(color: colorScheme.secondary)),
          const SizedBox(height: 8),
          Text(point.explicacion, style: textTheme.bodyMedium),
          if (point.ejemplo.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Ej: ${point.ejemplo}', style: textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _bulletList(TextTheme textTheme, String label, List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• '),
                  Expanded(child: Text(item, style: textTheme.bodySmall)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
