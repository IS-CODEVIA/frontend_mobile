import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod/transcription_professor_riverpod.dart';

class SaveTranscriptionSheet extends ConsumerStatefulWidget {
  final String subjectName;
  final int courseId;
  final String fullText;

  const SaveTranscriptionSheet({
    super.key,
    required this.subjectName,
    required this.courseId,
    required this.fullText,
  });

  @override
  ConsumerState<SaveTranscriptionSheet> createState() =>
      _SaveTranscriptionSheetState();
}

class _SaveTranscriptionSheetState
    extends ConsumerState<SaveTranscriptionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
    Future.microtask(
      () => ref.read(saveTranscriptionProvider.notifier).reset(),
    );
  }

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _toIsoDateTime() {
    final y = _selectedDate.year;
    final m = _selectedDate.month.toString().padLeft(2, '0');
    final d = _selectedDate.day.toString().padLeft(2, '0');
    final h = _selectedTime.hour.toString().padLeft(2, '0');
    final min = _selectedTime.minute.toString().padLeft(2, '0');
    return '$y-$m-${d}T$h:$min:00Z';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final saveState = ref.watch(saveTranscriptionProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.secondary,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.save_outlined,
                    color: colorScheme.onSecondary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Guardar clase',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.subjectName,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildField(
                      label: 'Tema de la clase',
                      hint: 'Ej. Unidad 1 - Introduccion',
                      controller: _topicController,
                      icon: Icons.book_outlined,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today_rounded,
                                size: 16, color: colorScheme.secondary),
                            const SizedBox(width: 8),
                            Text(
                              'Fecha y hora',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.secondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _pickDate,
                                icon: Icon(Icons.date_range_rounded,
                                    size: 18,
                                    color: colorScheme.secondary),
                                label:                                 Text(
                                  _formatDate(_selectedDate),
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                  side: BorderSide(
                                      color: colorScheme.outlineVariant),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _pickTime,
                                icon: Icon(Icons.access_time_rounded,
                                    size: 18,
                                    color: colorScheme.secondary),
                                label: Text(
                                  _selectedTime.format(context),
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                  side: BorderSide(
                                      color: colorScheme.outlineVariant),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.transcribe_rounded,
                                size: 16, color: colorScheme.secondary),
                            const SizedBox(width: 8),
                            Text(
                              'Transcripcion',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.secondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.fullText.isNotEmpty
                                ? widget.fullText
                                : 'No hay transcripcion disponible',
                            style: textTheme.bodyMedium?.copyWith(
                              color: widget.fullText.isNotEmpty
                                  ? colorScheme.onSurface
                                  : colorScheme.onSurfaceVariant,
                              fontStyle: widget.fullText.isNotEmpty
                                  ? FontStyle.normal
                                  : FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: saveState.isSaving
                        ? null
                        : () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colorScheme.secondary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Cancelar',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed:
                        saveState.isSaving ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.secondary,
                      foregroundColor: colorScheme.onSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: saveState.isSaving
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.onSecondary,
                            ),
                          )
                        : Text(
                            'Guardar clase',
                            style: textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: colorScheme.secondary),
            const SizedBox(width: 8),
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Requerido';
            if (v.trim().length < 5) return 'Mínimo 5 caracteres';
            if (v.trim().length > 200) return 'Máximo 200 caracteres';
            return null;
          },
          style:
              textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: textTheme.bodyMedium
                ?.copyWith(color: colorScheme.outline),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: colorScheme.secondary, width: 2),
            ),
            filled: true,
            fillColor: colorScheme.surface,
          ),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final success = await ref
        .read(saveTranscriptionProvider.notifier)
        .save(
          courseId: widget.courseId,
          dateTime: _toIsoDateTime(),
          topic: _topicController.text.trim(),
          fullText: widget.fullText,
        );

    if (!mounted) return;

    if (success) {
      await _showSuccessDialog(context, _topicController.text.trim());
      if (mounted) Navigator.of(context).pop();
    } else {
      final saveState = ref.read(saveTranscriptionProvider);
      _showErrorDialog(
        context,
        saveState.error ?? 'Error al guardar la clase.',
      );
    }
  }

  Future<void> _showSuccessDialog(BuildContext context, String topic) async {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded,
                color: const Color(0xff00CFBB), size: 64),
            const SizedBox(height: 16),
            Text(
              'Clase guardada con exito',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              topic,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: FilledButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.secondary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 12),
              ),
              child: Text(
                'Listo',
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded,
                color: colorScheme.error, size: 64),
            const SizedBox(height: 16),
            Text(
              'Error al guardar la clase',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: FilledButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.secondary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 12),
              ),
              child: Text(
                'Cerrar',
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
