import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/material_model.dart';
import '../riverpod/materials_riverpod.dart';

class AddMaterialSheet extends ConsumerStatefulWidget {
  const AddMaterialSheet({super.key});

  @override
  ConsumerState<AddMaterialSheet> createState() => _AddMaterialSheetState();
}

class _AddMaterialSheetState extends ConsumerState<AddMaterialSheet> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String? _selectedUnit;
  bool _isCreatingUnit = false;
  final _newUnitController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _newUnitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final units = ref.watch(materialsProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Header
              Row(
                children: [
                  Icon(Icons.upload_file_outlined, color: colorScheme.secondary, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Subir material',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Unit selector
              Text(
                'Unidad',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _isCreatingUnit ? null : _selectedUnit,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Seleccionar unidad',
                ),
                items: [
                  ...units.map((u) => DropdownMenuItem(
                    value: u.unitName,
                    child: Text(u.unitName),
                  )),
                  const DropdownMenuItem(
                    value: '__new__',
                    child: Text('+ Crear nueva unidad'),
                  ),
                ],
                onChanged: (val) {
                  setState(() {
                    if (val == '__new__') {
                      _isCreatingUnit = true;
                      _selectedUnit = null;
                    } else {
                      _isCreatingUnit = false;
                      _selectedUnit = val;
                    }
                  });
                },
              ),

              // New unit name field
              if (_isCreatingUnit) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _newUnitController,
                  decoration: InputDecoration(
                    hintText: 'Nombre de la nueva unidad',
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 16),
              // Title
              Text(
                'Título',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Ej: Resumen Kmeans',
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              // Description
              Text(
                'Descripción',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Descripción del material...',
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              // File picker (UI placeholder)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outlineVariant, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload_outlined, color: colorScheme.secondary, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      'Seleccionar archivo',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // Submit button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Subir material'),
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.secondary,
                    foregroundColor: colorScheme.onSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    String? unitName;
    if (_isCreatingUnit) {
      unitName = _newUnitController.text.trim();
      if (unitName.isEmpty) return;
      ref.read(materialsProvider.notifier).createUnit(unitName);
    } else {
      unitName = _selectedUnit;
    }
    if (unitName == null) return;

    ref.read(materialsProvider.notifier).addMaterial(
      unitName,
      MaterialItemModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: _descController.text.trim(),
        date: '${DateTime.now().day} ${_monthName(DateTime.now().month)} ${DateTime.now().year}',
        type: MaterialItemType.document,
      ),
    );
    Navigator.pop(context);
  }

  String _monthName(int month) {
    const months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
    ];
    return months[month - 1];
  }
}
