import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../core/utils/pdf_fonts.dart';
import '../../domain/entities/transcription_entity.dart';

const _pdfPrimary = PdfColor.fromInt(0xff008A7B);
const _pdfSecondary = PdfColor.fromInt(0xff1C258F);

/// Builds a professionally formatted PDF for a class transcription.
Future<Uint8List> buildTranscriptionPdf({
  required TranscriptionEntity transcription,
  required String subjectName,
}) async {
  final fontRegular = await PdfFonts.regular;
  final fontBold = await PdfFonts.bold;

  final pdf = pw.Document();
  final title = transcription.classTopic.isNotEmpty
      ? transcription.classTopic
      : 'Transcripción de clase';

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(32, 90, 32, 48),
      header: (ctx) => _pdfHeader(subjectName, fontBold, fontRegular),
      footer: (ctx) => _pdfFooter(ctx, fontRegular),
      build: (ctx) => [
        pw.Text(
          title,
          style: pw.TextStyle(font: fontBold, fontSize: 18),
        ),
        pw.SizedBox(height: 12),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _infoRow('Materia', subjectName, fontBold, fontRegular),
              _infoRow('Tema', title, fontBold, fontRegular),
              _infoRow(
                'Fecha de clase',
                transcription.classDateTime.isNotEmpty
                    ? transcription.classDateTime
                    : transcription.createdAt,
                fontBold,
                fontRegular,
              ),
              _infoRow('Registrado', transcription.createdAt, fontBold, fontRegular),
            ],
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Text(
          'Contenido',
          style: pw.TextStyle(
            font: fontBold,
            fontSize: 13,
            color: _pdfSecondary,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          transcription.fullText.isNotEmpty
              ? transcription.fullText
              : 'Sin contenido disponible.',
          style: pw.TextStyle(font: fontRegular, fontSize: 11, lineSpacing: 3),
          textAlign: pw.TextAlign.justify,
        ),
      ],
    ),
  );

  return pdf.save();
}

pw.Widget _pdfHeader(String subjectName, pw.Font fontBold, pw.Font fontRegular) {
  return pw.Container(
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
              'Transcripción de Clase',
              style: pw.TextStyle(
                font: fontBold,
                fontSize: 20,
                color: _pdfSecondary,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              subjectName,
              style: pw.TextStyle(font: fontRegular, fontSize: 11, color: PdfColors.grey700),
            ),
          ],
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: pw.BoxDecoration(
            color: _pdfPrimary,
            borderRadius: pw.BorderRadius.circular(12),
          ),
          child: pw.Text(
            'SOA',
            style: pw.TextStyle(
              font: fontBold,
              fontSize: 10,
              color: PdfColors.white,
            ),
          ),
        ),
      ],
    ),
  );
}

pw.Widget _pdfFooter(pw.Context ctx, pw.Font fontRegular) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(top: 8),
    padding: const pw.EdgeInsets.only(top: 8),
    decoration: const pw.BoxDecoration(
      border: pw.Border(top: pw.BorderSide(color: PdfColors.grey400, width: 0.5)),
    ),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          'Generado el ${_formatDate(DateTime.now())}',
          style: pw.TextStyle(font: fontRegular, fontSize: 8, color: PdfColors.grey600),
        ),
        pw.Text(
          'Página ${ctx.pageNumber} de ${ctx.pagesCount}',
          style: pw.TextStyle(font: fontRegular, fontSize: 8, color: PdfColors.grey600),
        ),
      ],
    ),
  );
}

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
            style: pw.TextStyle(
              font: fontBold,
              fontSize: 10,
              color: PdfColors.grey700,
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Text(value, style: pw.TextStyle(font: fontRegular, fontSize: 10)),
        ),
      ],
    ),
  );
}

String _formatDate(DateTime d) {
  return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}
