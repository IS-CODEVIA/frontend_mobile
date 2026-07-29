import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../../core/utils/pdf_fonts.dart';
import '../../../offline_files/data/offline_files_service.dart';
import '../../domain/entities/study_plan_entity.dart';
import '../riverpod/study_plan_riverpod.dart';

const _pdfPrimary = PdfColor.fromInt(0xff008A7B);
const _pdfSecondary = PdfColor.fromInt(0xff1C258F);

pw.Widget _infoRow(String label, String value, pw.Font fontBold, pw.Font fontRegular) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 110,
          child: pw.Text(
            label,
            style: pw.TextStyle(font: fontBold, fontSize: 10, color: PdfColors.grey700),
          ),
        ),
        pw.Expanded(
          child: pw.Text(value, style: pw.TextStyle(font: fontRegular, fontSize: 10)),
        ),
      ],
    ),
  );
}

String _formatPdfDate(DateTime d) {
  return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

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
    final fontRegular = await PdfFonts.regular;
    final fontBold = await PdfFonts.bold;

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(32, 90, 32, 48),
        header: (ctx) => pw.Container(
          padding: const pw.EdgeInsets.only(bottom: 12),
          margin: const pw.EdgeInsets.only(bottom: 16),
          decoration: const pw.BoxDecoration(
            border: pw.Border(bottom: pw.BorderSide(color: _pdfSecondary, width: 2)),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Plan de Estudio',
                    style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: _pdfSecondary),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(widget.courseName, style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700)),
                ],
              ),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: pw.BoxDecoration(color: _pdfPrimary, borderRadius: pw.BorderRadius.circular(12)),
                child: pw.Text(
                  'SOA',
                  style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                ),
              ),
            ],
          ),
        ),
        footer: (ctx) => pw.Container(
          margin: const pw.EdgeInsets.only(top: 8),
          padding: const pw.EdgeInsets.only(top: 8),
          decoration: const pw.BoxDecoration(
            border: pw.Border(top: pw.BorderSide(color: PdfColors.grey400, width: 0.5)),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Generado el ${_formatPdfDate(DateTime.now())}',
                style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
              ),
              pw.Text(
                'Página ${ctx.pageNumber} de ${ctx.pagesCount}',
                style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
              ),
            ],
          ),
        ),
        build: (ctx) => [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(color: PdfColors.grey100, borderRadius: pw.BorderRadius.circular(8)),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _infoRow('Curso', widget.courseName, fontBold, fontRegular),
                _infoRow('Tema', plan.topic, fontBold, fontRegular),
                _infoRow('Dificultad', plan.difficulty, fontBold, fontRegular),
                _infoRow('Duración', '${plan.durationHours} horas', fontBold, fontRegular),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Header(
            level: 1,
            text: 'Introducción',
            textStyle: pw.TextStyle(font: fontBold, fontSize: 14, color: _pdfSecondary),
          ),
          pw.Paragraph(text: plan.introduccion,
              style: pw.TextStyle(font: fontRegular, fontSize: 11, lineSpacing: 3)),
          pw.SizedBox(height: 16),
          pw.Header(
            level: 1,
            text: 'Puntos de Estudio',
            textStyle: pw.TextStyle(font: fontBold, fontSize: 14, color: _pdfSecondary),
          ),
          for (final point in plan.puntosDeEstudio) ...[
            pw.Header(
              level: 2,
              text: point.titulo,
              textStyle: pw.TextStyle(font: fontBold, fontSize: 12),
            ),
            pw.Paragraph(
                text: '¿Por qué es importante?: ${point.porQueImporta}',
                style: pw.TextStyle(font: fontRegular, fontSize: 11, lineSpacing: 3)),
            pw.Paragraph(text: point.explicacion,
                style: pw.TextStyle(font: fontRegular, fontSize: 11, lineSpacing: 3)),
            if (point.antesDeEntenderlo.isNotEmpty) ...[
              pw.Paragraph(
                  text: 'Antes de entenderlo: ${point.antesDeEntenderlo.join(", ")}',
                  style: pw.TextStyle(font: fontRegular, fontSize: 11, lineSpacing: 3)),
            ],
            if (point.comoSeRelaciona.isNotEmpty) ...[
              pw.Paragraph(
                  text: 'Se relaciona con: ${point.comoSeRelaciona.join(", ")}',
                  style: pw.TextStyle(font: fontRegular, fontSize: 11, lineSpacing: 3)),
            ],
            if (point.ejemplo.isNotEmpty) ...[
              pw.Paragraph(text: 'Ejemplo: ${point.ejemplo}',
                  style: pw.TextStyle(font: fontRegular, fontSize: 11, lineSpacing: 3)),
            ],
            pw.SizedBox(height: 12),
          ],
          pw.Header(
            level: 1,
            text: 'Orden de Estudio',
            textStyle: pw.TextStyle(font: fontBold, fontSize: 14, color: _pdfSecondary),
          ),
          for (final order in plan.ordenDeEstudio) ...[
            pw.Paragraph(text: '${order.orden}. ${order.tema} — ${order.razon}',
                style: pw.TextStyle(font: fontRegular, fontSize: 11, lineSpacing: 3)),
          ],
          pw.SizedBox(height: 16),
          pw.Header(
            level: 1,
            text: 'Recomendaciones',
            textStyle: pw.TextStyle(font: fontBold, fontSize: 14, color: _pdfSecondary),
          ),
          if (plan.recomendaciones.repasarAntes.isNotEmpty) ...[
            pw.Paragraph(
                text: 'Repasar antes: ${plan.recomendaciones.repasarAntes.join(", ")}',
                style: pw.TextStyle(font: fontRegular, fontSize: 11, lineSpacing: 3)),
          ],
          if (plan.recomendaciones.conceptosParaPracticar.isNotEmpty) ...[
            pw.Paragraph(
                text: 'Practicar: ${plan.recomendaciones.conceptosParaPracticar.join(", ")}',
                style: pw.TextStyle(font: fontRegular, fontSize: 11, lineSpacing: 3)),
          ],
          if (plan.recomendaciones.comoReforzar.isNotEmpty) ...[
            pw.Paragraph(
                text: 'Reforzar: ${plan.recomendaciones.comoReforzar.join(", ")}',
                style: pw.TextStyle(font: fontRegular, fontSize: 11, lineSpacing: 3)),
          ],
          pw.SizedBox(height: 16),
          pw.Header(
            level: 1,
            text: 'Resumen Final',
            textStyle: pw.TextStyle(font: fontBold, fontSize: 14, color: _pdfSecondary),
          ),
          pw.Paragraph(text: plan.resumenFinal,
              style: pw.TextStyle(font: fontRegular, fontSize: 11, lineSpacing: 3)),
        ],
      ),
    );

    final fileName =
        'plan_estudio_${widget.courseName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final bytes = await pdf.save();

    await ref.read(offlineFilesServiceProvider).saveFile(
      fileName: fileName,
      bytes: bytes,
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
